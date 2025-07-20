Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1993914AD2D
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976936; cv=none; b=nS4DpuPNuLACC9PiyVygwXOCKAxOFZzvvWuUKfqMrDocw0s2JYOXpOPRF8BjlcrCx9XJq3sjk9TOoOegPQHjmHH2IbShDc2TIxvIi8uJ2dZnczWAdg6dIGLndiIgBH020jGlT9HKBeMp/HwNj4rK3e0yT8nuCZKQtqhcmzaA/Lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976936; c=relaxed/simple;
	bh=A7I5HrSE8aQLx28K1PtKiPOYhoLmwIqWNU9JK3g9QFg=;
	h=Date:To:From:Subject:Message-Id; b=KOKXKoNiZCA0StC0R7AzTZ64udPQxcYrEYrZM/36S+ous8G2pE+JYFV7sjhuIo4rLjbHqA7lbkjodPkcEEF5tjYEslS5Ap4g0pS4QQywmb8j/2iBPVzllVNRCaDhQ4gBRtr5wE/Xse5CuavRHq5ERHJpsexqjaQUDO6aM/XONBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Wlogdnrh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Wlogdnrh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A70C4CEE3;
	Sun, 20 Jul 2025 02:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976936;
	bh=A7I5HrSE8aQLx28K1PtKiPOYhoLmwIqWNU9JK3g9QFg=;
	h=Date:To:From:Subject:From;
	b=Wlogdnrhphjjbr2hpT5N4VbdDdJQchEhhMnncYgY7K9nrUeNk0kNCV/xvSQjkE5Iz
	 RsjftxuL1RwCNSmnI55eIQ3S4sJdp2zfQZIRGuh/VKt/jI+n7+Eeb9g7FkwZ24IcrH
	 mcymKW3uT8zgqk3W1MUvH4b2fdBfXMxGzhmQ4kdA=
Date: Sat, 19 Jul 2025 19:02:15 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] samples-damon-wsse-use-damon_call-repeat-mode-instead-of-damon_callback.patch removed from -mm tree
Message-Id: <20250720020215.E0A70C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: samples/damon/wsse: use damon_call() repeat mode instead of damon_callback
has been removed from the -mm tree.  Its filename was
     samples-damon-wsse-use-damon_call-repeat-mode-instead-of-damon_callback.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: samples/damon/wsse: use damon_call() repeat mode instead of damon_callback
Date: Sat, 12 Jul 2025 12:50:09 -0700

wsse uses damon_callback for periodically reading DAMON internal data. 
Use its alternative, damon_call() repeat mode.

Link: https://lkml.kernel.org/r/20250712195016.151108-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/wsse.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/samples/damon/wsse.c~samples-damon-wsse-use-damon_call-repeat-mode-instead-of-damon_callback
+++ a/samples/damon/wsse.c
@@ -35,8 +35,9 @@ MODULE_PARM_DESC(enabled, "Enable or dis
 static struct damon_ctx *ctx;
 static struct pid *target_pidp;
 
-static int damon_sample_wsse_after_aggregate(struct damon_ctx *c)
+static int damon_sample_wsse_repeat_call_fn(void *data)
 {
+	struct damon_ctx *c = data;
 	struct damon_target *t;
 
 	damon_for_each_target(t, c) {
@@ -52,9 +53,15 @@ static int damon_sample_wsse_after_aggre
 	return 0;
 }
 
+static struct damon_call_control repeat_call_control = {
+	.fn = damon_sample_wsse_repeat_call_fn,
+	.repeat = true,
+};
+
 static int damon_sample_wsse_start(void)
 {
 	struct damon_target *target;
+	int err;
 
 	pr_info("start\n");
 
@@ -79,8 +86,11 @@ static int damon_sample_wsse_start(void)
 	}
 	target->pid = target_pidp;
 
-	ctx->callback.after_aggregation = damon_sample_wsse_after_aggregate;
-	return damon_start(&ctx, 1, true);
+	err = damon_start(&ctx, 1, true);
+	if (err)
+		return err;
+	repeat_call_control.data = ctx;
+	return damon_call(ctx, &repeat_call_control);
 }
 
 static void damon_sample_wsse_stop(void)
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-commit-damos_quota_goal-nid.patch
mm-damon-sysfs-implement-refresh_ms-file-under-kdamond-directory.patch
mm-damon-sysfs-implement-refresh_ms-file-internal-work.patch
docs-admin-guide-mm-damon-usage-document-refresh_ms-file.patch
docs-abi-damon-update-for-refresh_ms.patch

