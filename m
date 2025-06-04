Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6872DBA42
	for <mm-commits@vger.kernel.org>; Wed,  4 Jun 2025 21:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749072536; cv=none; b=Q3iMSd6xR/z3ODuGkbgVJc7q7vXH3hp8uCdJ6XzRpNYAPtqiL95nbSflRyqm6Dw+yp+npvU6IceJ2IanNV0Q9YuX0kzlTX3h61rp7RaSQPWgyFYbuP2QRk1hYFvQNb/KnLZJIihcj/AcdWcX2src0NYpDCOyRzL1UuxCPwdbFt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749072536; c=relaxed/simple;
	bh=okcWM9CUNwEciHHja3Y+CcHht+YuIM48VV5M/6Ee2A4=;
	h=Date:To:From:Subject:Message-Id; b=PZOsiSRh5akEHtbqgGwU+pcP1w/d/7VocptAC9Cpzc+t0eSPRFSTpYOZh8jFCS6T7xAdkf83Q5IP64Xs3CzSAKUk1lj3lpmURDKNx8FeTH7MIxxyzeNexQef63dgKZ0MMMDQePfR3LlytnvyVXNEAYOJfKtcQQC2lD1owOu/FI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zZKVAgBB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zZKVAgBB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C28D1C4CEE4;
	Wed,  4 Jun 2025 21:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749072534;
	bh=okcWM9CUNwEciHHja3Y+CcHht+YuIM48VV5M/6Ee2A4=;
	h=Date:To:From:Subject:From;
	b=zZKVAgBB0toF75b5CgN2Y6mIq6pj4s27SL3ZM70gUFxmQUvyHd4zm2Cky5nHQ3b0J
	 8ZnoPYRkn6eGp3Fgyh35RDrbajkpmVcns5qz2weitySFvA2Ksay3ZWzDOkieMB3jtu
	 Bp4dnlqDq5NzC4gbOojxDM+L1hMLrJSYxFzAMefQ=
Date: Wed, 04 Jun 2025 14:28:54 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tjmercier@google.com,surenb@google.com,rppt@kernel.org,osalvador@suse.de,minchan@kernel.org,mhocko@suse.com,masahiroy@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kaleshsingh@google.com,jyescas@google.com,isaacmanjarres@google.com,david@redhat.com,anshuman.khandual@arm.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rename-config_page_block_order-to-config_page_block_max_order.patch added to mm-new branch
Message-Id: <20250604212854.C28D1C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: rename CONFIG_PAGE_BLOCK_ORDER to CONFIG_PAGE_BLOCK_MAX_ORDER.
has been added to the -mm mm-new branch.  Its filename is
     mm-rename-config_page_block_order-to-config_page_block_max_order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rename-config_page_block_order-to-config_page_block_max_order.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Zi Yan <ziy@nvidia.com>
Subject: mm: rename CONFIG_PAGE_BLOCK_ORDER to CONFIG_PAGE_BLOCK_MAX_ORDER.
Date: Wed, 4 Jun 2025 17:14:27 -0400

The config is in fact an additional upper limit of pageblock_order, so
rename it to avoid confusion.

Link: https://lkml.kernel.org/r/20250604211427.1590859-1-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Juan Yescas <jyescas@google.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
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
Cc: Vlastimil Babka <vbabka@suse.cz>
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

mm-rename-config_page_block_order-to-config_page_block_max_order.patch

