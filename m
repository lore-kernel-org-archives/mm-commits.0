Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4D2367B70
	for <mm-commits@vger.kernel.org>; Mon, 31 Aug 2026 23:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788219110; cv=none; b=ddx2i2gIJodwqeTUKbLe0YlH6RyamPkuHhxZqQwVlSgEQFD182jsOubRQ+9eIrSdM2L6HNQR7B5u42GdadhVBTYqE+WFynPBgLopvDYJgGPqpbJ9cT12ouk9RwP4Uc1N/+V2s9YkI1/1JPHgiorHluzcVcsMkAFWP6IUsxQkn9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788219110; c=relaxed/simple;
	bh=HIZtd+XSG01lFjE1+AVO1i2ASa9q485rpBkG5hYxcvk=;
	h=Date:To:From:Subject:Message-Id; b=FNNm18g59Cq2O6SLhOkuueHPzOWoVKOPX4fgb7DmsrNOTXGEgkQNGS1xlKUYTCuVgz62n4QWK2epunK3QcibwdTaLecF3OTCQvikfcqJGfxR2bpOMF2sPDTkmn0HsjVhA4WQcql/MF35So4drcoPKQPN20ua2xLIMCFWbZsTysg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yXJAoMTZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yXJAoMTZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D4E41F000E9;
	Mon, 31 Aug 2026 23:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788219108;
	bh=5UlLPDwscEaf81njslL7bfHZZL8WK1zCX6+a0ZShwk0=;
	h=Date:To:From:Subject;
	b=yXJAoMTZE8prEEXeXOO1Y473bHKTpnAOFW+MUH3U1Zi1VOP0j28pzsqhKD2wr3lby
	 gipBO/Ka6LPojQ9ruFqIMAgoUgNaW+eSACEPTYQNtLQo4V0pNCKPmhMtJX4iBYM2VB
	 ixKxT0CeIrlLvF72lpJ9iGLRHZp1WvXXH/zBYOm4=
Date: Mon, 31 Aug 2026 16:31:47 -0700
To: mm-commits@vger.kernel.org,zhaozhengzhuo@uniontech.com,zenghui.yu@linux.dev,sj@kernel.org,shuah@kernel.org,liyouhong@kylinos.cn,jaeyeon.lee.dev@gmail.com,harimishal1@gmail.com,gregkh@linuxfoundation.org,lienze@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-introduce-damon_set_target_pid.patch added to mm-new branch
Message-Id: <20260831233148.0D4E41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: introduce damon_set_target_pid()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-introduce-damon_set_target_pid.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-introduce-damon_set_target_pid.patch

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
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hari Mishal <harimishal1@gmail.com>
Cc: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Cc: Li Youhong <liyouhong@kylinos.cn>
Cc: Shuah Khan <shuah@kernel.org>
Cc: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Cc: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

mm-damon-core-introduce-damon_set_target_pid.patch
samples-damon-mtier-add-comment-for-struct-region_range.patch

