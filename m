Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A9433A033
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465840; cv=none; b=I42gHjRfLYaIoLCpa97E1fbnb1m5xxwzTXlCBRBsimFNFcE4QLMh1RIryHwyhPvrEuFZU0TD8EQV2Nh9Hr5egqZ1UbkRKhwZD4d5iVcJKohdwHzI746s3oL7usKYaW2GV5hMLLmCwpTlIXOwgGUMBkAUJCH6MJGqnaWC3iffZJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465840; c=relaxed/simple;
	bh=JUZnhPEluaEY5tyRIzRj6ARZ53aML6C9AwwT3xOw24Y=;
	h=Date:To:From:Subject:Message-Id; b=B8ij2QTXSvlYrCtaxjJn82jBTALnXuySl6qqBcef2NknoXOkYAeROZ4E6tX7ZNjCf4pCu5BXksz1YYp4Keu7dEZm44xtq2iUzA49TzfSsfqnHwruQy31+T9jfQillU4F7MgnO2J3DjbsRDRuui+veApQSNrq+YDO56cuxy5SV7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HcPpHqFV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HcPpHqFV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E95A1F00A3A;
	Fri, 31 Jul 2026 02:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465838;
	bh=UJbyWmhmTY35ejhZMZ4O5EoAcu4LX0+qdHRhV9icB0Y=;
	h=Date:To:From:Subject;
	b=HcPpHqFVi5M7AlFmcaGdWFcAA2FWCVceVIvC93oINt8oT3PrkASKZiclV1lrGv2P1
	 qRC+5cXWjjm4Faqn6secUI64s6mPM8UKDGB1Lca3qhmuDNq0d38lmHdaI9g3eXm7qZ
	 wAV5u02Nyp9n0zMX7vwcRxv9tGAqFqPrIakEhFNs=
Date: Thu, 30 Jul 2026 19:43:58 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhen.ni@easystack.cn,ye.liu@linux.dev,vishal.moola@gmail.com,chenyichong@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-mm-page_owner_sort-return-explicit-filter-results.patch removed from -mm tree
Message-Id: <20260731024358.9E95A1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/mm/page_owner_sort: return explicit filter results
has been removed from the -mm tree.  Its filename was
     tools-mm-page_owner_sort-return-explicit-filter-results.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yichong Chen <chenyichong@uniontech.com>
Subject: tools/mm/page_owner_sort: return explicit filter results
Date: Mon, 29 Jun 2026 09:43:14 +0800

Patch series "tools/mm/page_owner_sort: fix filtering and cleanup issues",
v5.

Patch 1 renames is_need() to filter_record() and makes the filter path
return explicit results.  Patch 2 fixes the per-record allocation leaks. 
Patch 3 bounds search_pattern() output copies, addressing the pre-existing
issue reported by Sashiko/AI review.


This patch (of 3):

Rename is_need() to filter_record() and make the filter path return
explicit error, skip, and match results.  This lets callers distinguish
allocation failures from records that simply do not match active filters.

Link: https://lore.kernel.org/20260629014316.130307-1-chenyichong@uniontech.com
Link: https://lore.kernel.org/20260629014316.130307-2-chenyichong@uniontech.com
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Reviewed-by: Vishal Moola <vishal.moola@gmail.com>
Cc: Ye Liu <ye.liu@linux.dev>
Cc: Zhen Ni <zhen.ni@easystack.cn>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/mm/page_owner_sort.c |   42 ++++++++++++++++++++++++++---------
 1 file changed, 32 insertions(+), 10 deletions(-)

--- a/tools/mm/page_owner_sort.c~tools-mm-page_owner_sort-return-explicit-filter-results
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
@@ -450,32 +460,44 @@ static bool match_str_list(const char *s
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
 	list[list_size].pid = get_pid(buf);
 	list[list_size].tgid = get_tgid(buf);
_

Patches currently in -mm which might be from chenyichong@uniontech.com are

hugetlbfs-release-subpool-on-fill_super-failure.patch
hugetlb-make-hugepage_put_subpool-tolerate-null.patch
hugetlb-evaluate-subpool-free-state-while-locked.patch
fat-release-buffer-head-after-rebuilding-parent.patch

