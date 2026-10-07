Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450D731AABC
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334286; cv=none; b=QN8vt7gTcWuxek0gnlhoyrxDgnzZEaPdUhUNqjHxGbFYFjiH/zARiFL98vAUz0xJvB9Gk7cFEMW2q59Ayvziq5BQxr5gAuLH2ThFAh5r4sZA1OWZ64Hnkdtp+mP09Y6noXs+ouPY4O1+3F41OraknJuomJvwuJuFuV6OMjB9mYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334286; c=relaxed/simple;
	bh=19nx5WJWl01lEzWliI23AlSgSknIJn7hUpLOdP2w6A8=;
	h=Date:To:From:Subject:Message-Id; b=a1p4lClY02AvBm1r0dNtXeVVbqVkqXYtP2bG6j1IofZ3aeSYqQPzuKmv/OoIjDv86nhrriyH7fCG98t6RNpNPvQ94BsKHsn0z8+VQft5y48jIR+qDnXXV/elXf+oY1Pi5WuPF3e5jOLXTUigsBpfcrXQP9d0X6sqMIThdhjgKSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NuHgjDKu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NuHgjDKu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C4001F0089B;
	Wed,  7 Oct 2026 00:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334285;
	bh=BafpuDyWRcrwAkh7yyv+TJ5RnQ7A2XyMYxuIWSNvP24=;
	h=Date:To:From:Subject;
	b=NuHgjDKui9Kv2o7gT5LfCd81awp7rqGkIf+F7Sn2vPzX89Rxs7YVIPc0X3ckiq4Wt
	 7bdQ+HLs2u2vPQiKt7WNYy3b/4fzyMkt2dqRZjGJXyvaK6dvQw/4yr9meF9Mt0sJqH
	 S9CrBFmUE2Onbfz1jJy5rMncsgVnAQAstNUt273c=
Date: Tue, 06 Oct 2026 17:51:24 -0700
To: mm-commits@vger.kernel.org,zhaozhengzhuo@uniontech.com,zenghui.yu@linux.dev,sj@kernel.org,shuah@kernel.org,liyouhong@kylinos.cn,jaeyeon.lee.dev@gmail.com,harimishal1@gmail.com,gregkh@linuxfoundation.org,lienze@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-introduce-damon_set_target_pid.patch removed from -mm tree
Message-Id: <20261007005125.1C4001F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: introduce damon_set_target_pid()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-introduce-damon_set_target_pid.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Enze Li <lienze@kylinos.cn>
Subject: mm/damon/core: introduce damon_set_target_pid()
Date: Mon, 31 Aug 2026 07:26:04 -0700

The logic that finds the struct pid for a given pid number and assigns it
to a damon_target is duplicated in multiple places.  Including
damon_sysfs_add_target() of mm/damon/sysfs.c and the start functions of
the two sample modules, samples/damon/wsse.c and samples/damon/prcl.c. 
Add a function that does the work, and replace the duplicated code in the
places with calls to the function.

Link: https://lore.kernel.org/20260831142611.77572-3-sj@kernel.org
Signed-off-by: Enze Li <lienze@kylinos.cn>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hari Mishal <harimishal1@gmail.com>
Cc: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Cc: Li Youhong <liyouhong@kylinos.cn>
Cc: Shuah Khan <shuah@kernel.org>
Cc: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Cc: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
---

 include/linux/damon.h |    1 +
 mm/damon/core.c       |   12 ++++++++++++
 mm/damon/sysfs.c      |    6 ++----
 samples/damon/prcl.c  |    5 +----
 samples/damon/wsse.c  |    5 +----
 5 files changed, 17 insertions(+), 12 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-introduce-damon_set_target_pid
+++ a/include/linux/damon.h
@@ -1057,6 +1057,7 @@ int damos_commit_quota_goals(struct damo
 
 struct damon_target *damon_new_target(void);
 void damon_add_target(struct damon_ctx *ctx, struct damon_target *t);
+int damon_set_target_pid(struct damon_target *t, int pid);
 void damon_free_target(struct damon_target *t);
 void damon_destroy_target(struct damon_target *t, struct damon_ctx *ctx);
 unsigned int damon_nr_regions(struct damon_target *t);
--- a/mm/damon/core.c~mm-damon-core-introduce-damon_set_target_pid
+++ a/mm/damon/core.c
@@ -10,6 +10,7 @@
 #include <linux/kthread.h>
 #include <linux/memcontrol.h>
 #include <linux/mm.h>
+#include <linux/pid.h>
 #include <linux/psi.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
@@ -795,6 +796,17 @@ void damon_add_target(struct damon_ctx *
 	list_add_tail(&t->list, &ctx->adaptive_targets);
 }
 
+/*
+ * Assign the struct pid of the given pid number to the given target.
+ */
+int damon_set_target_pid(struct damon_target *t, int pid)
+{
+	t->pid = find_get_pid(pid);
+	if (!t->pid)
+		return -EINVAL;
+	return 0;
+}
+
 static void damon_del_target(struct damon_target *t)
 {
 	list_del(&t->list);
--- a/mm/damon/sysfs.c~mm-damon-core-introduce-damon_set_target_pid
+++ a/mm/damon/sysfs.c
@@ -3,7 +3,6 @@
  * DAMON sysfs Interface
  */
 
-#include <linux/pid.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 
@@ -2035,9 +2034,8 @@ static int damon_sysfs_add_target(struct
 		return -ENOMEM;
 	damon_add_target(ctx, t);
 	if (damon_target_has_pid(ctx)) {
-		t->pid = find_get_pid(sys_target->pid);
-		if (!t->pid)
-			/* caller will destroy targets */
+		/* caller will destroy targets */
+		if (damon_set_target_pid(t, sys_target->pid))
 			return -EINVAL;
 	}
 	t->obsolete = sys_target->obsolete;
--- a/samples/damon/prcl.c~mm-damon-core-introduce-damon_set_target_pid
+++ a/samples/damon/prcl.c
@@ -32,7 +32,6 @@ module_param_cb(enabled, &enabled_param_
 MODULE_PARM_DESC(enabled, "Enable or disable DAMON_SAMPLE_PRCL");
 
 static struct damon_ctx *ctx;
-static struct pid *target_pidp;
 
 static int damon_sample_prcl_repeat_call_fn(void *data)
 {
@@ -79,12 +78,10 @@ static int damon_sample_prcl_start(void)
 		return -ENOMEM;
 	}
 	damon_add_target(ctx, target);
-	target_pidp = find_get_pid(target_pid);
-	if (!target_pidp) {
+	if (damon_set_target_pid(target, target_pid)) {
 		damon_destroy_ctx(ctx);
 		return -EINVAL;
 	}
-	target->pid = target_pidp;
 
 	scheme = damon_new_scheme(
 			&(struct damos_access_pattern) {
--- a/samples/damon/wsse.c~mm-damon-core-introduce-damon_set_target_pid
+++ a/samples/damon/wsse.c
@@ -33,7 +33,6 @@ module_param_cb(enabled, &enabled_param_
 MODULE_PARM_DESC(enabled, "Enable or disable DAMON_SAMPLE_WSSE");
 
 static struct damon_ctx *ctx;
-static struct pid *target_pidp;
 
 static int damon_sample_wsse_repeat_call_fn(void *data)
 {
@@ -79,12 +78,10 @@ static int damon_sample_wsse_start(void)
 		return -ENOMEM;
 	}
 	damon_add_target(ctx, target);
-	target_pidp = find_get_pid(target_pid);
-	if (!target_pidp) {
+	if (damon_set_target_pid(target, target_pid)) {
 		damon_destroy_ctx(ctx);
 		return -EINVAL;
 	}
-	target->pid = target_pidp;
 
 	err = damon_start(&ctx, 1, true);
 	if (err) {
_

Patches currently in -mm which might be from lienze@kylinos.cn are

maintainers-cover-all-hugetlb-headers-under-hugetlb-subsystem.patch
mm-hugetlb_cgroup-add-trailing-endif-comment-for-include-guard.patch
docs-hugetlbpagerst-fix-typo-in-per-node-attribute-description.patch

