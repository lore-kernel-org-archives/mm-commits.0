Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87EC633689E
	for <mm-commits@vger.kernel.org>; Mon, 29 Jun 2026 04:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782708105; cv=none; b=ukkugyatwvmIwM+GSnpuRJeUrZQNyBTjEBqBKBKQWNHox3SscyfFfOuFjwPifCC0tmSXRoRYEbHv/BqCMQYSF7KX1w78kyk6jjNtwrzcHMViOl9c52mKbK9usprS1tOwnBtsuZUl51qg8ZnNsGxNtOj7WhhpjTBwsGHn7ThfUb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782708105; c=relaxed/simple;
	bh=uH2I7JDvYSS3Tm66dd9e2MJTK/zFf/QXMbqKak0pN0Y=;
	h=Date:To:From:Subject:Message-Id; b=atL16EsjT8niBYsRn4U/JBbORCX4hLKn0c/3WLx1A9/0ddbURP+Iw5Tj+eo+29lVt5DKPczjKLXUZkN0pnKFbUOkub0m+zeGp7xjZUipb1G9ra/ZmGPUScFgrmUIU/dFdbZ/s065tmz13ziSWoigEU7OdFasLff/Tsx7DMpB0+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZWA3zCwx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZWA3zCwx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C3D11F000E9;
	Mon, 29 Jun 2026 04:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782708104;
	bh=vcgdCOO6/Dcc0gpEEvAHk0cLu8TPMmt0M8rEUsRil38=;
	h=Date:To:From:Subject;
	b=ZWA3zCwxQ521lireSZn545pd0976Dp1ZxCRx6XicL9RF7FFIeV0dmMRPyaS/KBEdf
	 B6TvoCP9rV3YMD/e8Poys3WiISAwmL/6jVYQZ6Ok8jc+Qa6yhoV6C34cQ3nJ7PD6t7
	 ZVFG16Mov8ytgDUu3sUkdo4vWRJRZj8zPnvPj2ao=
Date: Sun, 28 Jun 2026 21:41:43 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhen.ni@easystack.cn,ye.liu@linux.dev,vishal.moola@gmail.com,chenyichong@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-mm-page_owner_sort-return-explicit-filter-results.patch added to mm-new branch
Message-Id: <20260629044144.1C3D11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/mm/page_owner_sort: return explicit filter results
has been added to the -mm mm-new branch.  Its filename is
     tools-mm-page_owner_sort-return-explicit-filter-results.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-mm-page_owner_sort-return-explicit-filter-results.patch

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

tools-mm-page_owner_sort-return-explicit-filter-results.patch
tools-mm-page_owner_sort-free-per-record-allocations.patch
tools-mm-page_owner_sort-bound-pattern-output-copies.patch

