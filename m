Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8DA72153D8;
	Fri,  5 Jun 2026 02:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780627845; cv=none; b=uxnc+l3/0QcQjuxeXt3ZgStLAjdKc+NWNcy5O+DBotFrJ2oI0SBZGnAG75fbXDO1iK3N0Lt9Qio1FJhykahHoFn+y5yR5sMRXXunsgQ9xASzBUjtVO8J7id2o6zb6iQSK7+6UgyANezeHCjtnQlisNmVr9B/M4PRd5Ff47NyMxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780627845; c=relaxed/simple;
	bh=k9d5NqJUOwImsa4Tdul6Sc/7Hxuv4Jgt6QR1Ct+g0nU=;
	h=Date:To:From:Subject:Message-Id; b=jN+qznILjQMmnrm9grgEypHDc1K/REVQbnFB6XjHqWe38swFN51jUvEA153F+/atEFs2GoTETFe/S9gNTsR7brwDUYN3CfbSF1lRYzEMMG+q0ieKGhWInde7dvrPcFXRV4pwzaUz51Uho+ls5Yx6G5gLVvnFLibbb2ZiA6hKviM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q2VLEz4g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q2VLEz4g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D341F00893;
	Fri,  5 Jun 2026 02:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780627837;
	bh=jlUS+7pN3Lb/eUXD635yBaPLrwo43+MBqsnq4jaCydQ=;
	h=Date:To:From:Subject;
	b=q2VLEz4gHn76Yn73Kg5cCjhhkBHs2AILFxh9Vo6QTlQ0y0bfGRyk7yRRfjsCEnp8G
	 SRc9KmHrJwqTw42Cs9rJMTGV+SftxdvQlcLrBcKe6MzJO/qMdfTQdGVdmkGtg7H5Bh
	 zjQcfAXLLIgF4Jv2shcWhQ4iF0gaoWFOINLV+8j0=
Date: Thu, 04 Jun 2026 19:50:36 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-always-put-unsuccessfully-committed-target-pids.patch added to mm-new branch
Message-Id: <20260605025037.46D341F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: always put unsuccessfully committed target pids
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-always-put-unsuccessfully-committed-target-pids.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-always-put-unsuccessfully-committed-target-pids.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: always put unsuccessfully committed target pids
Date: Thu, 4 Jun 2026 18:38:48 -0700

damon_commit_target() puts and gets the destination and the source target
pids.  It puts the destination target pid because it will be overwritten
by the source target pid.  It gets the source pid because the caller is
supposed to eventually put the pids.  In more detail, the caller will call
damon_destroy_ctx() after damon_commit_ctx() to destroy the entire source
context.  And in this case, [f]vaddr operation set's cleanup_target()
callback will put the pids.

The commit operation is made at the context level.  The operation can fail
in multiple places including in the middle and after the targets commit
operations.  For any such failures, immediately the error is returned to
the damon_commit_ctx() caller.  If some or all of the source target pids
were committed to the destination during the unsuccessful context commit
attempt, those pids should be put twice.

The source context will do the put operations using the above explained
routine.  However, let's suppose the destination context was not
originally using [f]vaddr operation set and the commit failed before the
ops of the source context is committed.  The destination does not have the
cleanup_target() ops callback, so it cannot put the pids via the
damon_destroy_ctx().

As a result, the pids are leaked.  The issue in the real world would be
not very common.  The commit feature is for changing parameters of running
DAMON context while inheriting internal status like the monitoring
results.  The monitoring results of a physical address range ain't have
things that are beneficial to be inherited to a virtual address ranges
monitoring.  So the problem-causing DAMON control would be not very common
in the real world.  That said, it is a supported feature.  And
damon_commit_target() failure due to memory allocation is relatively
realistic [1] if there are a huge number of target regions.

Fix by putting the pids in the commit operation in case of the failures.

The issue was discovered [2] by Sashiko.

Link: https://lore.kernel.org/20260605013849.83750-1-sj@kernel.org
Link: https://lore.kernel.org/20260603112306.58490-1-akinobu.mita@gmail.com [1]
Link: https://lore.kernel.org/20260320020056.835-1-sj@kernel.org [2]
Fixes: 83dc7bbaecae ("mm/damon/sysfs: use damon_commit_ctx()")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.11.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   55 +++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 47 insertions(+), 8 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-always-put-unsuccessfully-committed-target-pids
+++ a/mm/damon/core.c
@@ -1387,10 +1387,36 @@ static int damon_commit_target(
 	return 0;
 }
 
+/*
+ * damon_revert_target_commits() - revert unsuccessful target commits.
+ * @dst:	Commit destination context
+ * @failed:	Commit failed destination target
+ * @src:	Commit source context
+ *
+ * Revert target states that changed by damon_commit_target(), and cannot be
+ * cleaned up by the destination context's ops.cleanup_target().
+ */
+static void damon_revert_target_commits(struct damon_ctx *dst,
+		struct damon_target *failed, struct damon_ctx *src)
+{
+	struct damon_target *target;
+
+	if (!damon_target_has_pid(src))
+		return;
+	if (dst->ops.cleanup_target)
+		return;
+	damon_for_each_target(target, dst) {
+		if (target == failed)
+			return;
+		put_pid(target->pid);
+	}
+}
+
 static int damon_commit_targets(
 		struct damon_ctx *dst, struct damon_ctx *src)
 {
 	struct damon_target *dst_target, *next, *src_target, *new_target;
+	struct damon_target *failed;
 	int i = 0, j = 0, err;
 
 	damon_for_each_target_safe(dst_target, next, dst) {
@@ -1404,8 +1430,10 @@ static int damon_commit_targets(
 					dst_target, damon_target_has_pid(dst),
 					src_target, damon_target_has_pid(src),
 					src->min_region_sz);
-			if (err)
-				return err;
+			if (err) {
+				failed = dst_target;
+				goto out;
+			}
 		} else {
 			struct damos *s;
 
@@ -1419,25 +1447,34 @@ static int damon_commit_targets(
 		}
 	}
 
+	failed = NULL;
 	damon_for_each_target_safe(src_target, next, src) {
 		if (j++ < i)
 			continue;
 		/* target to remove has no matching dst */
-		if (src_target->obsolete)
-			return -EINVAL;
+		if (src_target->obsolete) {
+			err = -EINVAL;
+			goto out;
+		}
 		new_target = damon_new_target();
-		if (!new_target)
-			return -ENOMEM;
+		if (!new_target) {
+			err = -ENOMEM;
+			goto out;
+		}
 		err = damon_commit_target(new_target, false,
 				src_target, damon_target_has_pid(src),
 				src->min_region_sz);
 		if (err) {
 			damon_destroy_target(new_target, NULL);
-			return err;
+			goto out;
 		}
 		damon_add_target(dst, new_target);
 	}
 	return 0;
+
+out:
+	damon_revert_target_commits(dst, failed, src);
+	return err;
 }
 
 static void damon_commit_filter(struct damon_filter *dst,
@@ -1571,8 +1608,10 @@ int damon_commit_ctx(struct damon_ctx *d
 	 */
 	if (!damon_attrs_equals(&dst->attrs, &src->attrs)) {
 		err = damon_set_attrs(dst, &src->attrs);
-		if (err)
+		if (err) {
+			damon_revert_target_commits(dst, NULL, src);
 			return err;
+		}
 	}
 	dst->pause = src->pause;
 	dst->ops = src->ops;
_

Patches currently in -mm which might be from sj@kernel.org are

maintainers-add-testing-abi-documents-for-mm.patch
mm-damon-core-always-put-unsuccessfully-committed-target-pids.patch

