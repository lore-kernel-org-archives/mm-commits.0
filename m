Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C3B23D3EE
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837060; cv=none; b=nxLfyGj74Ca4wvuu5pMMjWXyAAEqxY8LiK3TutdUUy9SYdqePzvlpzy7gljKpQX9bAY6JBdxOANNxWjwGLB60dIUauHaw5rlSSm4VKifcVt0S69THmT96yBgdEHBdferBKyk1QZy55Chq/XPiqqzSoWb5Aquoq0H3PuJxLvxO5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837060; c=relaxed/simple;
	bh=WXYQB+o83c1rVeI4kZzoTbTsvoTXRT13XwswcLq7Obg=;
	h=Date:To:From:Subject:Message-Id; b=WDjKc2D1un16obcyXSn81fXwht35xhM0d13WbsoJjv2mPuRygbrMfda6HvOGBckaNZrzPv0HLXUVV7h2yBJOmoXNNqnPDkwDJn9tF4wWUCP87htZay1Hq7UvOWsF2L2Dj5ePxyVN1C1pfq5W7DGZH6xfqqjcFmeApt2fPH0sL9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1WVxWBvj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1WVxWBvj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9632C4CEDD;
	Tue, 14 Jan 2025 06:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837059;
	bh=WXYQB+o83c1rVeI4kZzoTbTsvoTXRT13XwswcLq7Obg=;
	h=Date:To:From:Subject:From;
	b=1WVxWBvjnmgaeh4PJd7FsDiaf8Ad9v7KCEZsIsZIeOKBbjPJlqNPZBLTH3NTvikME
	 obagSo+LOkDKDT34zs2712nkTjM01SB+7R3ePUjms1jTH3emWsG2M11lR7F91x5JqX
	 caHsDO2od8BhLqGU+WI4Zy2hi0qEl+CYjEK1xSrA=
Date: Mon, 13 Jan 2025 22:44:19 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] samples-damon-wsse-start-and-stop-damon-as-the-user-requests.patch removed from -mm tree
Message-Id: <20250114064419.B9632C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: samples/damon/wsse: start and stop DAMON as the user requests
has been removed from the -mm tree.  Its filename was
     samples-damon-wsse-start-and-stop-damon-as-the-user-requests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

docs-mm-damon-design-add-monitoring-parameters-tuning-guide.patch
docs-mm-damon-add-an-example-monitoring-intervals-tuning.patch
docs-admin-guide-mm-damon-usage-fix-and-add-missing-damos-filter-sysfs-files-on-files-hierarchy.patch
docs-admin-guide-mm-damon-start-update-snapshot-example.patch
mm-damon-explain-effective-quota-on-kernel-doc-comment.patch

