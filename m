Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D011B86C7
	for <mm-commits@vger.kernel.org>; Mon, 29 Jun 2026 04:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782707735; cv=none; b=VA9hztFmBg/M5pOvrQBy1435Qr1/7JcPRbtI5pV2z33ZC8RqGRAy+eA13Gdf65Sx4Ry9++K8t+vMhIRk9GsUEeffykIZR1m/6oTQFHmL+elUjnJCdvei6B+YdyuP6QpSAriYMk26LJd7RC7XRdeFzDJa2zhfSGS0jZbG9wiw3yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782707735; c=relaxed/simple;
	bh=ntNrf/JUkYMYo6tgAcqBpxaTprX0RSkx7ddEzSAtgUk=;
	h=Date:To:From:Subject:Message-Id; b=RloW72fq7nCjd8uefqpyDsd4C45cEP0nPc/cC8WNzHD/QDoKi8b5T9cD7V4iNtW1o90YFsq1mLqB6C+JuvH+bpNeh1tU/wmmen4oCvUVIQdeCl/j1Unvq7hbjcUopJ/gLpCf89cSKmc1AiWPJrtcgOX4Qc2dUXiPXYCRYtfRw5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AB111F000E9;
	Mon, 29 Jun 2026 04:35:34 +0000 (UTC)
Date: Sun, 28 Jun 2026 21:35:29 -0700
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,chenyichong@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] tools-mm-page_owner_sort-free-per-record-allocations.patch removed from -mm tree
Message-Id: <20260629043534.2AB111F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/mm/page_owner_sort: free per-record allocations
has been removed from the -mm tree.  Its filename was
     tools-mm-page_owner_sort-free-per-record-allocations.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Yichong Chen <chenyichong@uniontech.com>
Subject: tools/mm/page_owner_sort: free per-record allocations
Date: Fri, 12 Jun 2026 13:50:17 +0800

add_list() allocates comm and txt for each page owner record, but the
cleanup path only frees the outer list array.  This leaks both buffers for
every retained record.

Free partial allocations in add_list(), discarded records during culling,
and retained records on exit.  Return explicit error, skip, and match
results from filter_record() to handle get_comm() failures.

Link: https://lore.kernel.org/610C3A89A09303F8+20260612055017.632263-1-chenyichong@uniontech.com
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Reviewed-by: Vishal Moola <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/mm/page_owner_sort.c |   63 ++++++++++++++++++++++++++++-------
 1 file changed, 51 insertions(+), 12 deletions(-)

--- a/tools/mm/page_owner_sort.c~tools-mm-page_owner_sort-free-per-record-allocations
+++ a/tools/mm/page_owner_sort.c
@@ -43,6 +43,13 @@ enum FILTER_BIT {
 	FILTER_TGID = 1<<2,
 	FILTER_COMM = 1<<3
 };
+
+enum FILTER_RESULT {
+	FILTER_ERROR,
+	FILTER_SKIP,
+	FILTER_MATCH
+};
+
 enum CULL_BIT {
 	CULL_PID = 1<<1,
 	CULL_TGID = 1<<2,
@@ -372,6 +379,9 @@ static char *get_comm(char *buf)
 {
 	char *comm_str = malloc(TASK_COMM_LEN);
 
+	if (!comm_str)
+		return NULL;
+
 	memset(comm_str, 0, TASK_COMM_LEN);
 
 	search_pattern(&comm_pattern, comm_str, buf);
@@ -386,6 +396,12 @@ static char *get_comm(char *buf)
 	return comm_str;
 }
 
+static void free_block_list(struct block_list *block)
+{
+	free(block->comm);
+	free(block->txt);
+}
+
 static int get_arg_type(const char *arg)
 {
 	if (!strcmp(arg, "pid") || !strcmp(arg, "p"))
@@ -450,39 +466,57 @@ static bool match_str_list(const char *s
 	return false;
 }
 
-static bool is_need(char *buf)
+static enum FILTER_RESULT filter_record(char *buf)
 {
+	char *comm;
+
 	if ((filter & FILTER_PID) && !match_num_list(get_pid(buf), fc.pids, fc.pids_size))
-		return false;
+		return FILTER_SKIP;
 	if ((filter & FILTER_TGID) &&
 		!match_num_list(get_tgid(buf), fc.tgids, fc.tgids_size))
-		return false;
-
-	char *comm = get_comm(buf);
+		return FILTER_SKIP;
+	if (!(filter & FILTER_COMM))
+		return FILTER_MATCH;
+
+	comm = get_comm(buf);
+	if (!comm)
+		return FILTER_ERROR;
 
-	if ((filter & FILTER_COMM) &&
-	!match_str_list(comm, fc.comms, fc.comms_size)) {
+	if (!match_str_list(comm, fc.comms, fc.comms_size)) {
 		free(comm);
-		return false;
+		return FILTER_SKIP;
 	}
 	free(comm);
-	return true;
+	return FILTER_MATCH;
 }
 
 static bool add_list(char *buf, int len, char *ext_buf)
 {
+	enum FILTER_RESULT filter_result;
+
 	if (list_size == max_size) {
 		fprintf(stderr, "max_size too small??\n");
 		return false;
 	}
-	if (!is_need(buf))
+	filter_result = filter_record(buf);
+	if (filter_result == FILTER_ERROR) {
+		fprintf(stderr, "Out of memory\n");
+		return false;
+	}
+	if (filter_result == FILTER_SKIP)
 		return true;
+
 	list[list_size].pid = get_pid(buf);
 	list[list_size].tgid = get_tgid(buf);
 	list[list_size].comm = get_comm(buf);
-	list[list_size].txt = malloc(len+1);
+	if (!list[list_size].comm) {
+		fprintf(stderr, "Out of memory\n");
+		return false;
+	}
+	list[list_size].txt = malloc(len + 1);
 	if (!list[list_size].txt) {
 		fprintf(stderr, "Out of memory\n");
+		free(list[list_size].comm);
 		return false;
 	}
 	memcpy(list[list_size].txt, buf, len);
@@ -841,8 +875,10 @@ int main(int argc, char **argv)
 		} else {
 			list[count-1].num += list[i].num;
 			list[count-1].page_num += list[i].page_num;
+			free_block_list(&list[i]);
 		}
 	}
+	list_size = count;
 
 	qsort(list, count, sizeof(list[0]), compare_sort_condition);
 
@@ -876,8 +912,11 @@ out_free:
 		free(ext_buf);
 	if (buf)
 		free(buf);
-	if (list)
+	if (list) {
+		for (i = 0; i < list_size; i++)
+			free_block_list(&list[i]);
 		free(list);
+	}
 out_ts:
 	regfree(&ts_nsec_pattern);
 out_comm:
_

Patches currently in -mm which might be from chenyichong@uniontech.com are


