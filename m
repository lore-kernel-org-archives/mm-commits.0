Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DA8182B4
	for <mm-commits@vger.kernel.org>; Wed, 11 Dec 2024 00:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733877506; cv=none; b=fYnuXeg4lypx51JjUCKfeFQ5fhSGDzWyBryrbWNhcCfw2GrpHR5ip+SgIYF3ULTJ01w+15a+Ef5gQc/Jo1T34LxQxHjsant+b+WKoSc40gb5ZmofatdABcArMTg9+zXRHzFv81hU1qwccIBLWvQDFx6GvOjxNOVy2YaSdiMoZrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733877506; c=relaxed/simple;
	bh=dIYtzmb2Lro/HTrqPmAh7CmZ+E9JtGQUZD258oZ3OXw=;
	h=Date:To:From:Subject:Message-Id; b=uQlL7JngubVWgzRGudYhCkvZka/TQjsUQ6mSseDFRRvqeiaZHquzR8ZblkXw6JIrQ9mdg592QpHFlfbWGlg8tYKSQYU4cPiLj8ZJKN72h6fSCiNm6P06JAaD1iH592SHknh2H8e7HKbUpXRaNOWVEbU4SY8asZMXsRnKzuBBgNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fo4cZFTc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fo4cZFTc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 918EDC4CED6;
	Wed, 11 Dec 2024 00:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733877506;
	bh=dIYtzmb2Lro/HTrqPmAh7CmZ+E9JtGQUZD258oZ3OXw=;
	h=Date:To:From:Subject:From;
	b=fo4cZFTchDVghhuPrCRoroUjxCNW/GHvEP3kXG4Ax/86Flwh9KZPO88ehpdD9dwmS
	 U91eq7v5Qncuir4P8ArYnOJso+8qBqIHoqDzpZKkQqfL+/Zol/8exco7S/JRYoisKp
	 rI8RhXibTqKShgf4K/4+meP+UdNBEXd20SwHDwmo=
Date: Tue, 10 Dec 2024 16:38:25 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + samples-damon-wsse-start-and-stop-damon-as-the-user-requests.patch added to mm-unstable branch
Message-Id: <20241211003826.918EDC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: samples/damon/wsse: start and stop DAMON as the user requests
has been added to the -mm mm-unstable branch.  Its filename is
     samples-damon-wsse-start-and-stop-damon-as-the-user-requests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/samples-damon-wsse-start-and-stop-damon-as-the-user-requests.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: samples/damon/wsse: start and stop DAMON as the user requests
Date: Tue, 10 Dec 2024 13:50:27 -0800

Start running DAMON to monitor accesses of a process that the user
specified via 'target_pid' parameter, when 'y' is passed to 'enable'
parameter.  Stop running DAMON when 'n' is passed to 'enable' parameter. 
Estimating the working set size from DAMON's monitoring results and
reporting it to the user will be implemented by the following commit.

Link: https://lkml.kernel.org/r/20241210215030.85675-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/wsse.c |   35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

--- a/samples/damon/wsse.c~samples-damon-wsse-start-and-stop-damon-as-the-user-requests
+++ a/samples/damon/wsse.c
@@ -27,15 +27,48 @@ static bool enable __read_mostly;
 module_param_cb(enable, &enable_param_ops, &enable, 0600);
 MODULE_PARM_DESC(enable, "Enable or disable DAMON_SAMPLE_WSSE");
 
+static struct damon_ctx *ctx;
+static struct pid *target_pidp;
+
 static int damon_sample_wsse_start(void)
 {
+	struct damon_target *target;
+
 	pr_info("start\n");
-	return 0;
+
+	ctx = damon_new_ctx();
+	if (!ctx)
+		return -ENOMEM;
+	if (damon_select_ops(ctx, DAMON_OPS_VADDR)) {
+		damon_destroy_ctx(ctx);
+		return -EINVAL;
+	}
+
+	target = damon_new_target();
+	if (!target) {
+		damon_destroy_ctx(ctx);
+		return -ENOMEM;
+	}
+	damon_add_target(ctx, target);
+	target_pidp = find_get_pid(target_pid);
+	if (!target_pidp) {
+		damon_destroy_ctx(ctx);
+		return -EINVAL;
+	}
+	target->pid = target_pidp;
+
+	return damon_start(&ctx, 1, true);
 }
 
 static void damon_sample_wsse_stop(void)
 {
 	pr_info("stop\n");
+	if (ctx) {
+		damon_stop(&ctx, 1);
+		damon_destroy_ctx(ctx);
+	}
+	if (target_pidp)
+		put_pid(target_pidp);
 }
 
 static int damon_sample_wsse_enable_store(
_

Patches currently in -mm which might be from sj@kernel.org are

samples-add-a-skeleton-of-a-sample-damon-module-for-working-set-size-estimation.patch
samples-damon-wsse-start-and-stop-damon-as-the-user-requests.patch
samples-damon-wsse-implement-working-set-size-estimation-and-logging.patch
samples-damon-introduce-a-skeleton-of-a-smaple-damon-module-for-proactive-reclamation.patch
samples-damon-prcl-implement-schemes-setup.patch

