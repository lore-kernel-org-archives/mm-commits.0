Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53B51DB951
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274600; cv=none; b=QItnoI2vdBWYZ08TwZHXsLyARe9mp/vlFSRm5ku96xi2965KgThv2DbXBq7tkJx/25yzx0F1qug7OZSIrjRn1R6CduTnImdoYpLBBHEJk0BEC8FRQOVMKebyfTRUKMFj5tTrxK39LhmjSWCfFSfpcgoQCCCvQjk70r9t8xglKOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274600; c=relaxed/simple;
	bh=u/A1uP/whGvX5UYLNtwhYm4FQM0XIi/pk8CubVhVitw=;
	h=Date:To:From:Subject:Message-Id; b=uyETIzHmj0xK0Uc0Tku5j9Vp/4MWpB6dt+SH+BfyaeU+M1o1qZUXixVcn40zrX+nqBRu8/om+FEbwLT+TR8P4Vj7rwSGEyAt4zCAocQU1zuXDpSUBeklct/7DtZnsn2O9Bf/ALPQkOG2//URpywVRMBRyFyLnUF5jKQS20R7WYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e3maigp8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e3maigp8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87B19C4CEDD;
	Tue, 18 Mar 2025 05:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274600;
	bh=u/A1uP/whGvX5UYLNtwhYm4FQM0XIi/pk8CubVhVitw=;
	h=Date:To:From:Subject:From;
	b=e3maigp8eYuY7eWCL/RMZ7vQ6pY+a6L40j3uF61WAA8HCJydRZxtQC8tK0pBVut5q
	 VRuib/GQG2h7t4VXl8Wine1vxQAh3CJo9Umn8FMB1HUR1tlDq6Z8sh9qh2lKkPMaFl
	 bsmeXPlrqxE5CNvjfoeUPBoll0kyydh4/gNvJ3Bc=
Date: Mon, 17 Mar 2025 22:10:00 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-remove-damon_sysfs_cmd_request-and-its-readers.patch removed from -mm tree
Message-Id: <20250318051000.87B19C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: remove damon_sysfs_cmd_request and its readers
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-remove-damon_sysfs_cmd_request-and-its-readers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: remove damon_sysfs_cmd_request and its readers
Date: Thu, 6 Mar 2025 09:59:02 -0800

damon_sysfs_cmd_request is DAMON sysfs interface's own synchronization
mechanism for accessing DAMON internal data via damon_callback hooks.  All
the users are now migrated to damon_call() and damos_walk(), so nobody
really uses it.  No one writes to the data structure but reading code is
still remained.  Remove the reading code and the entire data structure.

Link: https://lkml.kernel.org/r/20250306175908.66300-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   24 +-----------------------
 1 file changed, 1 insertion(+), 23 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-remove-damon_sysfs_cmd_request-and-its-readers
+++ a/mm/damon/sysfs.c
@@ -1238,25 +1238,6 @@ static const char * const damon_sysfs_cm
 	"update_tuned_intervals",
 };
 
-/*
- * struct damon_sysfs_cmd_request - A request to the DAMON callback.
- * @cmd:	The command that needs to be handled by the callback.
- * @kdamond:	The kobject wrapper that associated to the kdamond thread.
- *
- * This structure represents a sysfs command request that need to access some
- * DAMON context-internal data.  Because DAMON context-internal data can be
- * safely accessed from DAMON callbacks without additional synchronization, the
- * request will be handled by the DAMON callback.  None-``NULL`` @kdamond means
- * the request is valid.
- */
-struct damon_sysfs_cmd_request {
-	enum damon_sysfs_cmd cmd;
-	struct damon_sysfs_kdamond *kdamond;
-};
-
-/* Current DAMON callback request.  Protected by damon_sysfs_lock. */
-static struct damon_sysfs_cmd_request damon_sysfs_cmd_request;
-
 static ssize_t state_show(struct kobject *kobj, struct kobj_attribute *attr,
 		char *buf)
 {
@@ -1555,8 +1536,6 @@ static int damon_sysfs_turn_damon_on(str
 
 	if (damon_sysfs_kdamond_running(kdamond))
 		return -EBUSY;
-	if (damon_sysfs_cmd_request.kdamond == kdamond)
-		return -EBUSY;
 	/* TODO: support multiple contexts per kdamond */
 	if (kdamond->contexts->nr != 1)
 		return -EINVAL;
@@ -1796,8 +1775,7 @@ static bool damon_sysfs_kdamonds_busy(st
 	int i;
 
 	for (i = 0; i < nr_kdamonds; i++) {
-		if (damon_sysfs_kdamond_running(kdamonds[i]) ||
-		    damon_sysfs_cmd_request.kdamond == kdamonds[i])
+		if (damon_sysfs_kdamond_running(kdamonds[i]))
 			return true;
 	}
 
_

Patches currently in -mm which might be from sj@kernel.org are


