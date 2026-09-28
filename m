Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9280534EEFD
	for <mm-commits@vger.kernel.org>; Mon, 28 Sep 2026 01:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790558741; cv=none; b=FN8Sw65lnKFoDsQXr1Pnu5L1NVxqTTpw6VaYWWz4QvySvSQRM4pCUgeBRRzet3jFMGyNHdWmSEgR95wN3yO7J0CJJ5iM/wri5O3kKbKO21fN4MAbzEdxX9ywB0IBBO3IGIYBY+kRSeKDb7t+L8yw97wzTR+ErN68TuoSmyN/WSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790558741; c=relaxed/simple;
	bh=Fr4sx0Bt3caOHfKAlRTpTVpg7VfdIGAayPs1gp/olB0=;
	h=Date:To:From:Subject:Message-Id; b=f/ZF/BbfUF8N4iqUnhaJN/MMfUVm/C2JC/uA57ICcJvQZN6pVGe4ysnfwZmN+yTDw1ADE5SQrUogKHrfYvLc0aGGz4K+5+ja4l614kMMBqx1A6Q0x1F0ZFpqkUwH10mzq1LhXyqCk3V+6KnNHN3I3CppVwvW2B40wDvyygHWcIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J9hnRrGE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J9hnRrGE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F32321F00898;
	Mon, 28 Sep 2026 01:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790558740;
	bh=epXeStYSqKVSf/zoSMY22GVQCzuCLj6NV/0+xikWXYk=;
	h=Date:To:From:Subject;
	b=J9hnRrGEN4sv1qPlTmhrXcKgdcDQWYlGV+2ctvv63Px9mDbsXado4LCgd0pk/DC6G
	 Jb69tL7T1jZXCx+c2UtLgF89mhFmcuXgDQwyTvBGuNIBy0k0o6Gs7FaaB9XkP1/XF3
	 ANGqd827MnTTXnF4a8ApLZV/sO3mdLX4YHclF1LI=
Date: Sun, 27 Sep 2026 18:25:39 -0700
To: mm-commits@vger.kernel.org,raemoar63@gmail.com,huang.ying.caritas@gmail.com,geert@linux-m68k.org,david@davidgow.net,brendan.higgins@linux.dev,brads@mainlining.org,andriy.shevchenko@linux.intel.com,kmehltretter@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + resource-kunit-stop-selecting-get_free_region.patch added to mm-nonmm-unstable branch
Message-Id: <20260928012539.F32321F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: resource, kunit: stop selecting GET_FREE_REGION
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     resource-kunit-stop-selecting-get_free_region.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/resource-kunit-stop-selecting-get_free_region.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Karl Mehltretter <kmehltretter@gmail.com>
Subject: resource, kunit: stop selecting GET_FREE_REGION
Date: Sat, 26 Sep 2026 02:26:51 +0200

RESOURCE_KUNIT_TEST selects GET_FREE_REGION even when no other option
needs it. Remove the selection to follow the dependency rule in
Documentation/dev-tools/kunit/style.rst.

Skip resource_test_region_intersects() when GET_FREE_REGION is disabled.
GET_FREE_REGION has no prompt, so configurations without a production
consumer cannot enable it. Most configurations will therefore skip this
case; this is intentional. The union and intersection tests remain
available.

Since kunit_skip() does not return, the compiler drops the reference to
the unavailable alloc_free_mem_region(), as in the CONFIG_OF_ADDRESS
check in drivers/of/of_test.c.

Link: https://lore.kernel.org/20260926002651.87267-1-kmehltretter@gmail.com
Fixes: 99185c10d5d9 ("resource, kunit: add test case for region_intersects()")
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Tested-by: Bradley Morgan <brads@mainlining.org> # Power10
Assisted-by: LLM
Cc: Ying Huang <huang.ying.caritas@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <david@davidgow.net>
Cc: Rae Moar <raemoar63@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

---

 kernel/resource_kunit.c |    3 +++
 lib/Kconfig.debug       |    1 -
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/resource_kunit.c~resource-kunit-stop-selecting-get_free_region
+++ a/kernel/resource_kunit.c
@@ -225,6 +225,9 @@ static void resource_test_region_interse
 	struct resource *parent;
 	resource_size_t start;
 
+	if (!IS_ENABLED(CONFIG_GET_FREE_REGION))
+		kunit_skip(test, "CONFIG_GET_FREE_REGION is disabled");
+
 	/* Find an iomem_resource hole to hold test resources */
 	parent = alloc_free_mem_region(&iomem_resource, RES_TEST_TOTAL_SIZE, SZ_1M,
 				       "test resources");
--- a/lib/Kconfig.debug~resource-kunit-stop-selecting-get_free_region
+++ a/lib/Kconfig.debug
@@ -2776,7 +2776,6 @@ config RESOURCE_KUNIT_TEST
 	tristate "KUnit test for resource API" if !KUNIT_ALL_TESTS
 	depends on KUNIT
 	default KUNIT_ALL_TESTS
-	select GET_FREE_REGION
 	help
 	  This builds the resource API unit test.
 	  Tests the logic of API provided by resource.c and ioport.h.
_

Patches currently in -mm which might be from kmehltretter@gmail.com are

mm-damon-core-handle-uninitialized-damos_quota_goal-last_psi_total-fix.patch
docs-mm-ksm-use-the-renamed-ksm-structure-names.patch
mm-secretmem-fix-the-enable-parameter-description.patch
klist-avoid-accesses-after-waking-klist_remove.patch
squashfs-fix-fragment-index-table-sizing-overflow-on-32-bit.patch
squashfs-make-the-fragment-index-table-bounds-check-overflow-safe.patch
fork-honor-task_structs-declared-alignment.patch
ocfs2-cluster-hold-a-reference-on-the-heartbeat-thread.patch
resource-kunit-stop-selecting-get_free_region.patch

