Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF8934570C3
	for <mm-commits@vger.kernel.org>; Sun, 11 Oct 2026 22:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791757208; cv=none; b=VbN0FAQ7RHnRMrQo4n4Xmux6RNOBKq4bFVh/1G7/C2EW2KkbaIdI1OZKdDv1hQY09I4XqaKWkELF6YAAtcqJrHFwkCGicQ1crE+u7QMg4yKiJ5pl2VqD5sgitxmyy/FH7ui1aosOiVSgKGmj1NFMYE9zm3wEX9xifRwXRliYHYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791757208; c=relaxed/simple;
	bh=JtZFifFr61gfRNjyJdEmiBBCO3cLiWHi6luSuOnaS8A=;
	h=Date:To:From:Subject:Message-Id; b=BYhzl1ScIxvgEDhHFYRynAFh3VRzuRCmugfzky2inPCByTuvfxPbK52YQ6yl/zc8bbrYT4tldEcXXmMh4llkD755D9qSq7lxzcu82Y9xg98Vb67kIqSXLv9VKFn+szE1P64Uu11PNunW3j38XKPmlwmzupeXgxRQQWbFJUqo9FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cCAEXD5O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cCAEXD5O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 847FB1F0089C;
	Sun, 11 Oct 2026 22:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791757205;
	bh=lrnmFOs/8dVN66huxcbwi9owQzNIV2VUv2H8CMrCuHM=;
	h=Date:To:From:Subject;
	b=cCAEXD5OeNy+rc6/JSy6SF5yR6hUlkP7uqRhmQCNNNzsgfS/JXn7/sO1+dX+GwSCB
	 3CzPdGNPUqu6zCd4BaxxIGgX+gTR/Jmt3g4iploIDXyLNCXU6hB6lt3BAVQHY0G0Oj
	 bV49SNDZVodjJVUWWy3JZNX74RfYGMhTW7Jb1FP4=
Date: Sun, 11 Oct 2026 15:20:05 -0700
To: mm-commits@vger.kernel.org,raemoar63@gmail.com,huang.ying.caritas@gmail.com,geert@linux-m68k.org,david@davidgow.net,brendan.higgins@linux.dev,brads@mainlining.org,andriy.shevchenko@linux.intel.com,kmehltretter@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] resource-kunit-stop-selecting-get_free_region.patch removed from -mm tree
Message-Id: <20261011222005.847FB1F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: resource, kunit: stop selecting GET_FREE_REGION
has been removed from the -mm tree.  Its filename was
     resource-kunit-stop-selecting-get_free_region.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-secretmem-fix-the-enable-parameter-description.patch
mm-damon-core-preserve-the-quota-passed-to-damon_new_scheme.patch
mm-damon-tests-core-kunit-test-preservation-of-quota-state.patch
mm-damon-tests-core-kunit-test-psi-goal-values-with-explicit-samples.patch
squashfs-fix-fragment-index-table-sizing-overflow-on-32-bit.patch
squashfs-make-the-fragment-index-table-bounds-check-overflow-safe.patch

