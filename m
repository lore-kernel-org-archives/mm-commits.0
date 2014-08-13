From: akpm@linux-foundation.org
Subject: + lib-genallocc-add-power-aligned-algorithm.patch added to -mm
 tree
Date: Wed, 13 Aug 2014 15:19:56 -0700
Message-ID: <53ebe48c.DNc83BnFAt4wc5Wd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:37068 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbaHMWT6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Aug 2014 18:19:58 -0400
Received: by mail-qa0-f73.google.com with SMTP id s7so54401qap.2
        for <mm-commits@vger.kernel.org>; Wed, 13 Aug 2014 15:19:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lauraa@codeaurora.org, arnd@arndb.de, catalin.marinas@arm.com, davidriley@chromium.org, linux@arm.linux.org.uk, olof@lixom.net, ritesh.harjani@gmail.com, thierry.reding@gmail.com, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/genalloc.c: add power aligned algorithm
has been added to the -mm tree.  Its filename is
     lib-genallocc-add-power-aligned-algorithm.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-genallocc-add-power-aligned-algorithm.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-genallocc-add-power-aligned-algorithm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Laura Abbott <lauraa@codeaurora.org>
Subject: lib/genalloc.c: add power aligned algorithm

One of the more common algorithms used for allocation is to align the
start address of the allocation to the order of size requested.  Add this
as an algorithm option for genalloc.

Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
Acked-by: Will Deacon <will.deacon@arm.com>
Acked-by: Olof Johansson <olof@lixom.net>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David Riley <davidriley@chromium.org>
Cc: Ritesh Harjain <ritesh.harjani@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/genalloc.h |    4 ++++
 lib/genalloc.c           |   20 ++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff -puN include/linux/genalloc.h~lib-genallocc-add-power-aligned-algorithm include/linux/genalloc.h
--- a/include/linux/genalloc.h~lib-genallocc-add-power-aligned-algorithm
+++ a/include/linux/genalloc.h
@@ -110,6 +110,10 @@ extern void gen_pool_set_algo(struct gen
 extern unsigned long gen_pool_first_fit(unsigned long *map, unsigned long size,
 		unsigned long start, unsigned int nr, void *data);
 
+extern unsigned long gen_pool_first_fit_order_align(unsigned long *map,
+		unsigned long size, unsigned long start, unsigned int nr,
+		void *data);
+
 extern unsigned long gen_pool_best_fit(unsigned long *map, unsigned long size,
 		unsigned long start, unsigned int nr, void *data);
 
diff -puN lib/genalloc.c~lib-genallocc-add-power-aligned-algorithm lib/genalloc.c
--- a/lib/genalloc.c~lib-genallocc-add-power-aligned-algorithm
+++ a/lib/genalloc.c
@@ -481,6 +481,26 @@ unsigned long gen_pool_first_fit(unsigne
 EXPORT_SYMBOL(gen_pool_first_fit);
 
 /**
+ * gen_pool_first_fit_order_align - find the first available region
+ * of memory matching the size requirement. The region will be aligned
+ * to the order of the size specified.
+ * @map: The address to base the search on
+ * @size: The bitmap size in bits
+ * @start: The bitnumber to start searching at
+ * @nr: The number of zeroed bits we're looking for
+ * @data: additional data - unused
+ */
+unsigned long gen_pool_first_fit_order_align(unsigned long *map,
+		unsigned long size, unsigned long start,
+		unsigned int nr, void *data)
+{
+	unsigned long align_mask = roundup_pow_of_two(nr) - 1;
+
+	return bitmap_find_next_zero_area(map, size, start, nr, align_mask);
+}
+EXPORT_SYMBOL(gen_pool_first_fit_order_align);
+
+/**
  * gen_pool_best_fit - find the best fitting region of memory
  * macthing the size requirement (no alignment constraint)
  * @map: The address to base the search on
_

Patches currently in -mm which might be from lauraa@codeaurora.org are

origin.patch
lib-genallocc-add-power-aligned-algorithm.patch
lib-genallocc-add-genpool-range-check-function.patch
common-dma-mapping-introduce-common-remapping-functions.patch
arm-use-genalloc-for-the-atomic-pool.patch
arm64-add-atomic-pool-for-non-coherent-and-cma-allocations.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

