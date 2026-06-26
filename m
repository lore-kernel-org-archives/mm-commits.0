Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C6318C2C
	for <mm-commits@vger.kernel.org>; Fri, 26 Jun 2026 00:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782433196; cv=none; b=b3HnE1k2y3SRv8N9d5YSJIY8kekpG2bpq6OIh6A2ENk1hYzyJquNoPtX/jVPmf/KVLzJJsrTG8IVdB9mZiAd/X5xKbH/M0p+8exnNIcLldsqL5i3u+mIxj0VMtkia42FpcL+j/DERFNTcXp6mi/kY5x1v/thVo97eEkgS643MvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782433196; c=relaxed/simple;
	bh=mC5DtAxI04wtSfIbfpwT7la6LGU+F2AfAZZ5zjjY5fI=;
	h=Date:To:From:Subject:Message-Id; b=cnd7Or2ZgNzcH+ZBrkeX9ViHRM0rlgR1R7l5w8N7tUylSTn5GtVmvkCFjvY7ZGC7ybpnwRbRK9yRUrgSufyIUtesrQ6bQwKaFV2Gal99AwvamX7mLiTSrLpk9Hizl1gLPMuCprwxzJWiKoB66t1aJZCeqAAHrC9A10tv36V95uI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D13CDKH+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D13CDKH+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B839D1F000E9;
	Fri, 26 Jun 2026 00:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782433194;
	bh=Ds/BMKCBE5Ttd5rcfLnw+14B9pdQmAAl11cRao2I+WM=;
	h=Date:To:From:Subject;
	b=D13CDKH+TbDmW9iF7b4PP+2mf7K4/VaNro/yYpYotUpHqs5xUTA6q/V976xWlku3V
	 9m9TokSoxnszQoNwxn+dynwHtFSGP9ZNCLKaQebNxTkUyAwx+vecF5/0TuDmfQs7Py
	 PPZTbAefIwIxRAWup8p9YVu3NhYgYBr+gpqauo/A=
Date: Thu, 25 Jun 2026 17:19:54 -0700
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,chenyichong@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-mm-page_owner_sort-free-per-record-allocations.patch added to mm-new branch
Message-Id: <20260626001954.B839D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/mm/page_owner_sort: free per-record allocations
has been added to the -mm mm-new branch.  Its filename is
     tools-mm-page_owner_sort-free-per-record-allocations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-mm-page_owner_sort-free-per-record-allocations.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

tools-mm-page_owner_sort-free-per-record-allocations.patch

