Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E3428467B
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126215; cv=none; b=UMMI2UHL0jFIYhcrFN9IobwoebfsYqLYD1cnuThBSydVyq6C8hHpzeFhUkCnlwVSsWto42gS9XlgjTsmDax2exMBliuCxckJlejDcG9ZRFRi06jpCtcMZLJ2Wz4uIePtsFK3b1YSZubMyGW8Ad3oK8UgiB0j37ex17Ib6C2Y+fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126215; c=relaxed/simple;
	bh=7PbD9ePO1z9BRLDj+2L43ATyY3xDxd7IRtcksmGwnOE=;
	h=Date:To:From:Subject:Message-Id; b=IpK91iE4gSjqR5d2CiP8+TtAPv5Z5nTzciFcjh/De5YtB1MNLiYIhHb2vnMvsoDoNd9GF/rkVoCJvp2MbPaTXPFuuShV7cszcT1Lg9rgA3zp3l4bFDkTNZElpsYdSGK3L9A82kezBW51mLJQumTwBzRmYicutDiWpdmrMSBYlz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u4fmF8Qt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u4fmF8Qt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B26DC4CEE3;
	Thu, 10 Jul 2025 05:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126215;
	bh=7PbD9ePO1z9BRLDj+2L43ATyY3xDxd7IRtcksmGwnOE=;
	h=Date:To:From:Subject:From;
	b=u4fmF8Qt9fLEGMPZZtGeMmA2P8oRzaLEaojg7tE2bHelC6MivI/phKlL85bXB/KyG
	 l5klPAembpYuj3FK59uxuuT0rReI4b//gFXtF3G6l+DbTfv+hj8V6I/+MOCSvupQAA
	 qiLHozmPDMUeAXmY3r4dJKHP00JabgkPvbyR5cOM=
Date: Wed, 09 Jul 2025 22:43:34 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tjmercier@google.com,surenb@google.com,rppt@kernel.org,osalvador@suse.de,minchan@kernel.org,mhocko@suse.com,masahiroy@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kaleshsingh@google.com,jyescas@google.com,isaacmanjarres@google.com,david@redhat.com,anshuman.khandual@arm.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rename-config_page_block_order-to-config_page_block_max_order.patch removed from -mm tree
Message-Id: <20250710054335.3B26DC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: rename CONFIG_PAGE_BLOCK_ORDER to CONFIG_PAGE_BLOCK_MAX_ORDER
has been removed from the -mm tree.  Its filename was
     mm-rename-config_page_block_order-to-config_page_block_max_order.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm: rename CONFIG_PAGE_BLOCK_ORDER to CONFIG_PAGE_BLOCK_MAX_ORDER
Date: Wed, 4 Jun 2025 17:14:27 -0400

The config is in fact an additional upper limit of pageblock_order, so
rename it to avoid confusion.

Link: https://lkml.kernel.org/r/20250604211427.1590859-1-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Juan Yescas <jyescas@google.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: "Isaac J. Manjarres" <isaacmanjarres@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: T.J. Mercier <tjmercier@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h          |   14 +++++++-------
 include/linux/pageblock-flags.h |    8 ++++----
 mm/Kconfig                      |   15 ++++++++-------
 mm/mm_init.c                    |    2 +-
 4 files changed, 20 insertions(+), 19 deletions(-)

--- a/include/linux/mmzone.h~mm-rename-config_page_block_order-to-config_page_block_max_order
+++ a/include/linux/mmzone.h
@@ -38,19 +38,19 @@
 #define NR_PAGE_ORDERS (MAX_PAGE_ORDER + 1)
 
 /* Defines the order for the number of pages that have a migrate type. */
-#ifndef CONFIG_PAGE_BLOCK_ORDER
-#define PAGE_BLOCK_ORDER MAX_PAGE_ORDER
+#ifndef CONFIG_PAGE_BLOCK_MAX_ORDER
+#define PAGE_BLOCK_MAX_ORDER MAX_PAGE_ORDER
 #else
-#define PAGE_BLOCK_ORDER CONFIG_PAGE_BLOCK_ORDER
-#endif /* CONFIG_PAGE_BLOCK_ORDER */
+#define PAGE_BLOCK_MAX_ORDER CONFIG_PAGE_BLOCK_MAX_ORDER
+#endif /* CONFIG_PAGE_BLOCK_MAX_ORDER */
 
 /*
  * The MAX_PAGE_ORDER, which defines the max order of pages to be allocated
- * by the buddy allocator, has to be larger or equal to the PAGE_BLOCK_ORDER,
+ * by the buddy allocator, has to be larger or equal to the PAGE_BLOCK_MAX_ORDER,
  * which defines the order for the number of pages that can have a migrate type
  */
-#if (PAGE_BLOCK_ORDER > MAX_PAGE_ORDER)
-#error MAX_PAGE_ORDER must be >= PAGE_BLOCK_ORDER
+#if (PAGE_BLOCK_MAX_ORDER > MAX_PAGE_ORDER)
+#error MAX_PAGE_ORDER must be >= PAGE_BLOCK_MAX_ORDER
 #endif
 
 /*
--- a/include/linux/pageblock-flags.h~mm-rename-config_page_block_order-to-config_page_block_max_order
+++ a/include/linux/pageblock-flags.h
@@ -41,18 +41,18 @@ extern unsigned int pageblock_order;
  * Huge pages are a constant size, but don't exceed the maximum allocation
  * granularity.
  */
-#define pageblock_order		MIN_T(unsigned int, HUGETLB_PAGE_ORDER, PAGE_BLOCK_ORDER)
+#define pageblock_order		MIN_T(unsigned int, HUGETLB_PAGE_ORDER, PAGE_BLOCK_MAX_ORDER)
 
 #endif /* CONFIG_HUGETLB_PAGE_SIZE_VARIABLE */
 
 #elif defined(CONFIG_TRANSPARENT_HUGEPAGE)
 
-#define pageblock_order		MIN_T(unsigned int, HPAGE_PMD_ORDER, PAGE_BLOCK_ORDER)
+#define pageblock_order		MIN_T(unsigned int, HPAGE_PMD_ORDER, PAGE_BLOCK_MAX_ORDER)
 
 #else /* CONFIG_TRANSPARENT_HUGEPAGE */
 
-/* If huge pages are not used, group by PAGE_BLOCK_ORDER */
-#define pageblock_order		PAGE_BLOCK_ORDER
+/* If huge pages are not used, group by PAGE_BLOCK_MAX_ORDER */
+#define pageblock_order		PAGE_BLOCK_MAX_ORDER
 
 #endif /* CONFIG_HUGETLB_PAGE */
 
--- a/mm/Kconfig~mm-rename-config_page_block_order-to-config_page_block_max_order
+++ a/mm/Kconfig
@@ -1005,8 +1005,8 @@ config ARCH_FORCE_MAX_ORDER
 # the default page block order is MAX_PAGE_ORDER (10) as per
 # include/linux/mmzone.h.
 #
-config PAGE_BLOCK_ORDER
-	int "Page Block Order"
+config PAGE_BLOCK_MAX_ORDER
+	int "Page Block Order Upper Limit"
 	range 1 10 if ARCH_FORCE_MAX_ORDER = 0
 	default 10 if ARCH_FORCE_MAX_ORDER = 0
 	range 1 ARCH_FORCE_MAX_ORDER if ARCH_FORCE_MAX_ORDER != 0
@@ -1014,12 +1014,13 @@ config PAGE_BLOCK_ORDER
 	help
 	  The page block order refers to the power of two number of pages that
 	  are physically contiguous and can have a migrate type associated to
-	  them. The maximum size of the page block order is limited by
-	  ARCH_FORCE_MAX_ORDER.
+	  them. The maximum size of the page block order is at least limited by
+	  ARCH_FORCE_MAX_ORDER/MAX_PAGE_ORDER.
 
-	  This config allows overriding the default page block order when the
-	  page block order is required to be smaller than ARCH_FORCE_MAX_ORDER
-	  or MAX_PAGE_ORDER.
+	  This config adds a new upper limit of default page block
+	  order when the page block order is required to be smaller than
+	  ARCH_FORCE_MAX_ORDER/MAX_PAGE_ORDER or other limits
+	  (see include/linux/pageblock-flags.h for details).
 
 	  Reducing pageblock order can negatively impact THP generation
 	  success rate. If your workloads use THP heavily, please use this
--- a/mm/mm_init.c~mm-rename-config_page_block_order-to-config_page_block_max_order
+++ a/mm/mm_init.c
@@ -1509,7 +1509,7 @@ static inline void setup_usemap(struct z
 /* Initialise the number of pages represented by NR_PAGEBLOCK_BITS */
 void __init set_pageblock_order(void)
 {
-	unsigned int order = PAGE_BLOCK_ORDER;
+	unsigned int order = PAGE_BLOCK_MAX_ORDER;
 
 	/* Check that pageblock_nr_pages has not already been setup */
 	if (pageblock_order)
_

Patches currently in -mm which might be from ziy@nvidia.com are

selftests-mm-fix-split_huge_page_test-for-folio_split-tests.patch
mm-page_alloc-pageblock-flags-functions-clean-up.patch
mm-page_isolation-make-page-isolation-a-standalone-bit.patch
mm-page_alloc-add-support-for-initializing-pageblock-as-isolated.patch
mm-page_isolation-remove-migratetype-from-move_freepages_block_isolate.patch
mm-page_isolation-remove-migratetype-from-undo_isolate_page_range.patch
mm-page_isolation-remove-migratetype-parameter-from-more-functions.patch

