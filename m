Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB92F27281D
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758490025; cv=none; b=oknkuDCRGjzSefAJQv/Jchs+IAhy5oEM9pnKZKFyZpN6FsrP6FKcbQtmLWHd79HhkoGErjsfa7Obyfh6ejOxW2o05jAquEIl35yDw7yJH/j86f68KHfb+p2rEMA6U5GcSIeyQuw+w3L6Pde2+S+QZSYLCCjjbIMTHaoV27OvrAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758490025; c=relaxed/simple;
	bh=3OZS21XpbvxNHEkEdnc2OFhXuR2nWuOFLgGRQIxkyM0=;
	h=Date:To:From:Subject:Message-Id; b=m3r1OdKu6Wml+q6n8PoYbT3IsdKS+eKogcSjGDEsaLgLn+kVz7oaueUgCB18d4ahYiNPLXryTsPlmRe4rU3B/OI/nw6zM7FUbk+M6lEAyIFj9QeF31j4j9+sII1n6icNhcua5Y7vJFaQa7nR+I8ebLofHS35uelUi+9j9mnw3Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2vs5hHG+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2vs5hHG+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8BF4C4CEE7;
	Sun, 21 Sep 2025 21:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758490025;
	bh=3OZS21XpbvxNHEkEdnc2OFhXuR2nWuOFLgGRQIxkyM0=;
	h=Date:To:From:Subject:From;
	b=2vs5hHG+fLJIoVnyiW6f9pk5AzLmzcwk56TTr/daq5X+bDiblkejbKMxAZnakdJQE
	 HjxCLAAbnbOVrSgMj3nIM8/QMj/C2w8RcnwpH32T/7ghSUdWdmd/46CDskr22UYMhE
	 7UaTpTkgZdzupzCUXV6HAgrj5V7qw+ajx+EzWv4M=
Date: Sun, 21 Sep 2025 14:27:05 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] samples-damon-wsse-use-damon_initialized.patch removed from -mm tree
Message-Id: <20250921212705.A8BF4C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: samples/damon/wsse: use damon_initialized()
has been removed from the -mm tree.  Its filename was
     samples-damon-wsse-use-damon_initialized.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: samples/damon/wsse: use damon_initialized()
Date: Mon, 15 Sep 2025 20:35:09 -0700

damon_sample_wsse is assuming DAMON is ready to use in module_init time,
and uses its own hack to see if it is the time.  Use damon_initialized(),
which is a way for seeing if DAMON is ready to be used that is more
reliable and better to maintain instead of the hack.

Link: https://lkml.kernel.org/r/20250916033511.116366-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/wsse.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/samples/damon/wsse.c~samples-damon-wsse-use-damon_initialized
+++ a/samples/damon/wsse.c
@@ -102,8 +102,6 @@ static void damon_sample_wsse_stop(void)
 	}
 }
 
-static bool init_called;
-
 static int damon_sample_wsse_enable_store(
 		const char *val, const struct kernel_param *kp)
 {
@@ -117,10 +115,10 @@ static int damon_sample_wsse_enable_stor
 	if (enabled == is_enabled)
 		return 0;
 
-	if (enabled) {
-		if (!init_called)
-			return 0;
+	if (!damon_initialized())
+		return 0;
 
+	if (enabled) {
 		err = damon_sample_wsse_start();
 		if (err)
 			enabled = false;
@@ -134,7 +132,12 @@ static int __init damon_sample_wsse_init
 {
 	int err = 0;
 
-	init_called = true;
+	if (!damon_initialized()) {
+		err = -ENOMEM;
+		if (enabled)
+			enabled = false;
+	}
+
 	if (enabled) {
 		err = damon_sample_wsse_start();
 		if (err)
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-set-damon_ctx-min_sz_region-only-for-paddr-use-case.patch

