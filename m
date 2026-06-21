Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD8C370ACC;
	Sun, 21 Jun 2026 18:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067218; cv=none; b=HvuPAYiJrUB1+V0aRHE7QOKp1sUhU/mIqgf9HNlJ345DFYZ3DDVL8LkNXfswaFUjYr7aG7o8gCXwrmEXNY3KLZyg+Usxgd9jWX7uVY7B7nVjYbgE3PtqgreWVfTMNmVN3sJe2TP1vtrfPW5Xeb5Q9tIQiSPl+PDcZ6xEESWKtF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067218; c=relaxed/simple;
	bh=qpV4P/ya3/CxZOxrkN5YE/ywo6XAL8CGoCitTW3/Kco=;
	h=Date:To:From:Subject:Message-Id; b=r+VaEHZvxHcLM/MZih0zm32gliFPF0xSdSkp2h6E7K/p59dosWgLKxfaiQE1i9Ksmz/6ANhAJMxwF4m+1OzzvMbxXziw/4TuFwG2bhCHW13TnzJdSZdQd2VM2fvWCLYkwtAUTrW+BPkj+fgbaF0DqkKYR30GPToxFQ6IxbNU4v4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CkyA0H83; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CkyA0H83"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4CDA1F000E9;
	Sun, 21 Jun 2026 18:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067217;
	bh=NaYhjMdoJYzf94dyzwLSNV3mai6Hf2uyKbohwQPNSwU=;
	h=Date:To:From:Subject;
	b=CkyA0H83embHRC/C1Mbqf/Mvwy6a4/UcFF89KMVHd+A9cLqKTZ4D4AdK0C1Hqtnk6
	 NIjlmoL9RR2ynu7nN3DaCrusCaWLEfbFqBrwG1WNyGOJtmH3SDvGaSi70JN99ElTT6
	 Y9MXA+5isaVHRyq9uCRBfgRA6zjxOAZgXtV+0n5M=
Date: Sun, 21 Jun 2026 11:40:16 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-always-put-unsuccessfully-committed-target-pids.patch removed from -mm tree
Message-Id: <20260621184016.E4CDA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: always put unsuccessfully committed target pids
has been removed from the -mm tree.  Its filename was
     mm-damon-core-always-put-unsuccessfully-committed-target-pids.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-damon-sysfs-schemes-fix-dir-put-orders-in-access_pattern_add_dirs.patch
mm-damon-sysfs-schemes-put-stats-for-scheme_add_dirs-internal-error.patch

