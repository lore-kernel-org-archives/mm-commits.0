Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C053D10F2
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744818; cv=none; b=QhrCkeqsrP0/fxaJBev7mOpSC33WRYP/WHi9vs9xKl15sfRqQpTXGQP7FqLwE1X5lOM2Z9FWwmF/5Fe7RJU2HJFgx+5wknN22glsZM6Zfet1D5u8Ssb080kLNTpzkDZs+RlU6jpw66hzVIG1tZXHfEjrbbdaIdvMsq3d/UFKM/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744818; c=relaxed/simple;
	bh=44PNkKik+XXWEafSettvQ6xbW10z8v/JU0mnkRByj6s=;
	h=Date:To:From:Subject:Message-Id; b=RPIMG2yKRARerCNfwi0YmsEvNKW/3o3XKBO+iTUS7Rnqd6SLqkSndsao5K1Y9hU6U2gyfUmiKVK4QeXZnKmm1JXTZQ5I1dc1JuRyO4413c+De3cJjuz0xYKNVVr2llks9WM3pDnQ8FPdybX3hPRi946sgWqWFxQygQ4PrczWV00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SrOUpUEg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SrOUpUEg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9823CC4CEF7;
	Sun, 29 Mar 2026 00:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744818;
	bh=44PNkKik+XXWEafSettvQ6xbW10z8v/JU0mnkRByj6s=;
	h=Date:To:From:Subject:From;
	b=SrOUpUEgxS88kwjEF6SCFKQTxxPo8Ebjl8xD9+kEIslqMJRCM/rplfTepWsWvReIu
	 Cf1ElVoPiNywo4wdtXb2vRyna4SBrd7vzP/cHSCBKWYrGMkUlV62QtAprgSSWkhG/X
	 0IsaJTuOy5GgMhH0z1NvZvZ0Agk/3WdhZbISZ+0I=
Date: Sat, 28 Mar 2026 17:40:18 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,davidgow@google.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-add-damon_new_region-debug_sanity-check.patch removed from -mm tree
Message-Id: <20260329004018.9823CC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: add damon_new_region() debug_sanity check
has been removed from the -mm tree.  Its filename was
     mm-damon-core-add-damon_new_region-debug_sanity-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: add damon_new_region() debug_sanity check
Date: Fri, 6 Mar 2026 07:29:05 -0800

damon_new_region() is supposed to be called with only valid address range
arguments.  Do the check under DAMON_DEBUG_SANITY.

Link: https://lkml.kernel.org/r/20260306152914.86303-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-add-damon_new_region-debug_sanity-check
+++ a/mm/damon/core.c
@@ -109,6 +109,17 @@ int damon_select_ops(struct damon_ctx *c
 	return err;
 }
 
+#ifdef CONFIG_DAMON_DEBUG_SANITY
+static void damon_verify_new_region(unsigned long start, unsigned long end)
+{
+	WARN_ONCE(start >= end, "start %lu >= end %lu\n", start, end);
+}
+#else
+static void damon_verify_new_region(unsigned long start, unsigned long end)
+{
+}
+#endif
+
 /*
  * Construct a damon_region struct
  *
@@ -118,6 +129,7 @@ struct damon_region *damon_new_region(un
 {
 	struct damon_region *region;
 
+	damon_verify_new_region(start, end);
 	region = kmem_cache_alloc(damon_region_cache, GFP_KERNEL);
 	if (!region)
 		return NULL;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-dealloc-repeat_call_control-if-damon_call-fails.patch

