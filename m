Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03EF627281D
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758490028; cv=none; b=HnZD5Cu09xE7dYx782jDzPlVGUlCBR+r37UkSFM7C/jFwfZoj1TqqYJA/MVviuOC0sx1Zy77IvUqXDSIQ4AlcR+eLPd+WmNOGJucTjiKNeWFMclsSTFNiw5S2O3rcRUVzGmN2WprvLz0r7Cyfv88QtDIOBW/2sjxeSbgx82+WCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758490028; c=relaxed/simple;
	bh=ts8vdbOwv1w4Tc9s89BM66NRpbE1qQsLQVcPHd9Ybao=;
	h=Date:To:From:Subject:Message-Id; b=fSOo3HFjoYe7yc8KM+XudPQfZs7QLQJjA2BMwXXzv81F/+6ZOOAJETv/cjdfKIM646b/4eJzmHlkwtotPcWPzZbiiJGP/02lbKJtlUU4on1l9P6s8XOCpKeCHDWk4jrfwhjp56WeqVVXNANFNTCKunWkLtMlJggp6mvl9F1g4oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SIIflPII; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SIIflPII"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D03C1C4CEE7;
	Sun, 21 Sep 2025 21:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758490027;
	bh=ts8vdbOwv1w4Tc9s89BM66NRpbE1qQsLQVcPHd9Ybao=;
	h=Date:To:From:Subject:From;
	b=SIIflPIIJg9fE/SSQcGxYNzA5C+xs3a4Vph6NGLBlvZKb0TVslxIwRVIOmxmGJQBh
	 Bb73nqlvIrBp3GVx0uxINuYHe2op+sFDceKT2gDMsfVhzajYKYTgVBwdDXLqyDy+f6
	 RPPoWBscqRXcoIqqxsvU2zMnM+g75wvSuhydAKaE=
Date: Sun, 21 Sep 2025 14:27:07 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] samples-damon-mtier-use-damon_initialized.patch removed from -mm tree
Message-Id: <20250921212707.D03C1C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: samples/damon/mtier: use damon_initialized()
has been removed from the -mm tree.  Its filename was
     samples-damon-mtier-use-damon_initialized.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: samples/damon/mtier: use damon_initialized()
Date: Mon, 15 Sep 2025 20:35:11 -0700

damon_sample_mtier is assuming DAMON is ready to use in module_init time,
and uses its own hack to see if it is the time.  Use damon_initialized(),
which is a way for seeing if DAMON is ready to be used that is more
reliable and better to maintain instead of the hack.

Link: https://lkml.kernel.org/r/20250916033511.116366-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/mtier.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/samples/damon/mtier.c~samples-damon-mtier-use-damon_initialized
+++ a/samples/damon/mtier.c
@@ -193,8 +193,6 @@ static void damon_sample_mtier_stop(void
 	damon_destroy_ctx(ctxs[1]);
 }
 
-static bool init_called;
-
 static int damon_sample_mtier_enable_store(
 		const char *val, const struct kernel_param *kp)
 {
@@ -208,7 +206,7 @@ static int damon_sample_mtier_enable_sto
 	if (enabled == is_enabled)
 		return 0;
 
-	if (!init_called)
+	if (!damon_initialized())
 		return 0;
 
 	if (enabled) {
@@ -225,7 +223,12 @@ static int __init damon_sample_mtier_ini
 {
 	int err = 0;
 
-	init_called = true;
+	if (!damon_initialized()) {
+		if (enabled)
+			enabled = false;
+		return -ENOMEM;
+	}
+
 	if (enabled) {
 		err = damon_sample_mtier_start();
 		if (err)
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-set-damon_ctx-min_sz_region-only-for-paddr-use-case.patch

