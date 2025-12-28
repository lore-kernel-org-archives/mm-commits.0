Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0E824397A;
	Sun, 28 Dec 2025 19:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766949133; cv=none; b=hzp5tifdD9LOXOXI09AD4gKh3S7emW5+6dxS3CdsjMprM7scLPhiDPMyX9HmMe+KKUYVVo955+lLei9FnxdmE983NzM1D9nrngYFE5AIV7kdLLy7VqawGvsuLdTDvzd03mEaPwjR9VeczDk9JLpCQe8c954Jp8EPKA88r1d2aTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766949133; c=relaxed/simple;
	bh=QPnuzWVIONyZHJ0YYj1VECJvPDnVAC6Ci2j24eATdKs=;
	h=Date:To:From:Subject:Message-Id; b=VhCf3PH5EO3zQeRRD5baEnr5J023fUwz1i8DMuilCBoqREXvCZMpLCXol1rVegf18O0OCmBRS42hG09c/nkyHwX8RCS0Y9WHN+OIkSc5g/OZf6sLMLM0C/jsFo+ImiLr2Ssqit65pZL5CynWNGy7c5V19ydZydGs1dcfTJ3rsEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A3PS/k3B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A3PS/k3B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B082FC4CEFB;
	Sun, 28 Dec 2025 19:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766949132;
	bh=QPnuzWVIONyZHJ0YYj1VECJvPDnVAC6Ci2j24eATdKs=;
	h=Date:To:From:Subject:From;
	b=A3PS/k3BnMra5mvy6oFOi5UAtviyCYWmzdYEwraR/EXWMtK6Nd+7D9ex3bFXUd1Wu
	 h90byruJQwj/OkicNx8RZSr1khfRABz4r1H5KRi8IRhWPU66+lvCtsuby7a7s+xSxD
	 i+AumkXfnUbXp8qPFFZku1PCxrzdc8gvSt5dOeoA=
Date: Sun, 28 Dec 2025 11:12:12 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,rgbi3307@gmail.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-remove-call_control-in-inactive-contexts.patch added to mm-hotfixes-unstable branch
Message-Id: <20251228191212.B082FC4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: remove call_control in inactive contexts
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-core-remove-call_control-in-inactive-contexts.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-remove-call_control-in-inactive-contexts.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: mm/damon/core: remove call_control in inactive contexts
Date: Sun, 28 Dec 2025 10:31:01 -0800

If damon_call() is executed against a DAMON context that is not running,
the function returns error while keeping the damon_call_control object
linked to the context's call_controls list.  Let's suppose the object is
deallocated after the damon_call(), and yet another damon_call() is
executed against the same context.  The function tries to add the new
damon_call_control object to the call_controls list, which still has the
pointer to the previous damon_call_control object, which is deallocated. 
As a result, use-after-free happens.

This can actually be triggered using the DAMON sysfs interface.  It is not
easily exploitable since it requires the sysfs write permission and making
a definitely weird file writes, though.  Please refer to the report for
more details about the issue reproduction steps.

Fix the issue by making damon_call() to cleanup the damon_call_control
object before returning the error.

Link: https://lkml.kernel.org/r/20251228183105.289441-1-sj@kernel.org
Fixes: 42b7491af14c ("mm/damon/core: introduce damon_call()")
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: JaeJoon Jung <rgbi3307@gmail.com>
Closes: https://lore.kernel.org/20251224094401.20384-1-rgbi3307@gmail.com
Cc: <stable@vger.kernel.org>	[6.14+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-core-remove-call_control-in-inactive-contexts
+++ a/mm/damon/core.c
@@ -1431,6 +1431,35 @@ bool damon_is_running(struct damon_ctx *
 	return running;
 }
 
+/*
+ * damon_call_handle_inactive_ctx() - handle DAMON call request that added to
+ *				      an inactive context.
+ * @ctx:	The inactive DAMON context.
+ * @control:	Control variable of the call request.
+ *
+ * This function is called in a case that @control is added to @ctx but @ctx is
+ * not running (inactive).  See if @ctx handled @control or not, and cleanup
+ * @control if it was not handled.
+ *
+ * Returns 0 if @control was handled by @ctx, negative error code otherwise.
+ */
+static int damon_call_handle_inactive_ctx(
+		struct damon_ctx *ctx, struct damon_call_control *control)
+{
+	struct damon_call_control *c;
+
+	mutex_lock(&ctx->call_controls_lock);
+	list_for_each_entry(c, &ctx->call_controls, list) {
+		if (c == control) {
+			list_del(&control->list);
+			mutex_unlock(&ctx->call_controls_lock);
+			return -EINVAL;
+		}
+	}
+	mutex_unlock(&ctx->call_controls_lock);
+	return 0;
+}
+
 /**
  * damon_call() - Invoke a given function on DAMON worker thread (kdamond).
  * @ctx:	DAMON context to call the function for.
@@ -1461,7 +1490,7 @@ int damon_call(struct damon_ctx *ctx, st
 	list_add_tail(&control->list, &ctx->call_controls);
 	mutex_unlock(&ctx->call_controls_lock);
 	if (!damon_is_running(ctx))
-		return -EINVAL;
+		return damon_call_handle_inactive_ctx(ctx, control);
 	if (control->repeat)
 		return 0;
 	wait_for_completion(&control->completion);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-remove-call_control-in-inactive-contexts.patch
mm-damon-core-introduce-nr_snapshots-damos-stat.patch
mm-damon-sysfs-schemes-introduce-nr_snapshots-damos-stat-file.patch
docs-mm-damon-design-update-for-nr_snapshots-damos-stat.patch
docs-admin-guide-mm-damon-usage-update-for-nr_snapshots-damos-stat.patch
docs-abi-damon-update-for-nr_snapshots-damos-stat.patch
mm-damon-update-damos-kerneldoc-for-stat-field.patch
mm-damon-core-implement-max_nr_snapshots.patch
mm-damon-sysfs-schemes-implement-max_nr_snapshots-file.patch
docs-mm-damon-design-update-for-max_nr_snapshots.patch
docs-admin-guide-mm-damon-usage-update-for-max_nr_snapshots.patch
docs-abi-damon-update-for-max_nr_snapshots.patch
mm-damon-core-add-trace-point-for-damos-stat-per-apply-interval.patch

