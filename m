Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E33B1EEE6
	for <mm-commits@vger.kernel.org>; Wed,  4 Jun 2025 01:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749000891; cv=none; b=fPySjdBHygqcK/cE+WAMehJmCNZSTsEuOkq0Jft+YF5R7m5s4x9jl8SgHqMx/A226H3j9XmJ1J580/TRqBPM+mO+Xz8vd32eKh5JqivVDnecfDKPJ4etAOaLk1wrNBVzdwoD3l/PUlVy7dJTMWunu7R5C9bjoAXT+iX8cmrzpiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749000891; c=relaxed/simple;
	bh=SU48g0huoEBrb2LwzTQqpEG3DA/BcfiEiF0arzO7SJA=;
	h=Date:To:From:Subject:Message-Id; b=uj/3py6ZFZ20cZzIRIe1IRzyXWAtQthnTf9eXJXr5VHvqcFaxqBrEgTOkQqnQgccFHlsYQ3k8BOv47F2D6U+xp02lMrkuRHpqLu+glnQRDxYZ02bEzfMVvIrD7Cp0LiSsr455+s1WRQJS/fxIRdTM0iRyQZ7PxMZipez1rxS7Zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y2tS0DuI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y2tS0DuI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B1E9C4CEED;
	Wed,  4 Jun 2025 01:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749000890;
	bh=SU48g0huoEBrb2LwzTQqpEG3DA/BcfiEiF0arzO7SJA=;
	h=Date:To:From:Subject:From;
	b=Y2tS0DuIBcYLgr3bDU9IeXTRa6SqQB1+58fB+qiGVHaRt+1lwrWyCcqBULZ3goyka
	 /BVyre+3EpUnfp//A5taCsosUHI9HCbai315gT84RA4wmveBb9gsYQam1I5aftIKWz
	 2gMvpBSzVsWfjdxE+JFCPLR+Wf4BjC6aTPIx3xks=
Date: Tue, 03 Jun 2025 18:34:49 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tjmercier@google.com,surenb@google.com,rppt@kernel.org,minchan@kernel.org,mhocko@suse.com,masahiroy@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kaleshsingh@google.com,isaacmanjarres@google.com,david@redhat.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rename-config_page_block_order-to-config_page_block_order_ceil.patch added to mm-new branch
Message-Id: <20250604013450.6B1E9C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: rename CONFIG_PAGE_BLOCK_ORDER to CONFIG_PAGE_BLOCK_ORDER_CEIL.
has been added to the -mm mm-new branch.  Its filename is
     mm-rename-config_page_block_order-to-config_page_block_order_ceil.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rename-config_page_block_order-to-config_page_block_order_ceil.patch

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
Subject: mm: rename CONFIG_PAGE_BLOCK_ORDER to CONFIG_PAGE_BLOCK_ORDER_CEIL.
Date: Tue, 3 Jun 2025 11:48:43 -0400

The config is in fact an additional upper limit of pageblock_order, so
rename it to avoid confusion.

Link: https://lkml.kernel.org/r/20250603154843.1565239-1-ziy@nvidia.com
Fixes: e13e7922d034 ("mm: add CONFIG_PAGE_BLOCK_ORDER to select page block order")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
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
 3 files changed, 19 insertions(+), 18 deletions(-)

--- a/include/linux/mmzone.h~mm-rename-config_page_block_order-to-config_page_block_order_ceil
+++ a/include/linux/mmzone.h
@@ -38,19 +38,19 @@
 #define NR_PAGE_ORDERS (MAX_PAGE_ORDER + 1)
 
 /* Defines the order for the number of pages that have a migrate type. */
-#ifndef CONFIG_PAGE_BLOCK_ORDER
-#define PAGE_BLOCK_ORDER MAX_PAGE_ORDER
+#ifndef CONFIG_PAGE_BLOCK_ORDER_CEIL
+#define PAGE_BLOCK_ORDER_CEIL MAX_PAGE_ORDER
 #else
-#define PAGE_BLOCK_ORDER CONFIG_PAGE_BLOCK_ORDER
-#endif /* CONFIG_PAGE_BLOCK_ORDER */
+#define PAGE_BLOCK_ORDER_CEIL CONFIG_PAGE_BLOCK_ORDER_CEIL
+#endif /* CONFIG_PAGE_BLOCK_ORDER_CEIL */
 
 /*
  * The MAX_PAGE_ORDER, which defines the max order of pages to be allocated
- * by the buddy allocator, has to be larger or equal to the PAGE_BLOCK_ORDER,
+ * by the buddy allocator, has to be larger or equal to the PAGE_BLOCK_ORDER_CEIL,
  * which defines the order for the number of pages that can have a migrate type
  */
-#if (PAGE_BLOCK_ORDER > MAX_PAGE_ORDER)
-#error MAX_PAGE_ORDER must be >= PAGE_BLOCK_ORDER
+#if (PAGE_BLOCK_ORDER_CEIL > MAX_PAGE_ORDER)
+#error MAX_PAGE_ORDER must be >= PAGE_BLOCK_ORDER_CEIL
 #endif
 
 /*
--- a/include/linux/pageblock-flags.h~mm-rename-config_page_block_order-to-config_page_block_order_ceil
+++ a/include/linux/pageblock-flags.h
@@ -41,18 +41,18 @@ extern unsigned int pageblock_order;
  * Huge pages are a constant size, but don't exceed the maximum allocation
  * granularity.
  */
-#define pageblock_order		MIN_T(unsigned int, HUGETLB_PAGE_ORDER, PAGE_BLOCK_ORDER)
+#define pageblock_order		MIN_T(unsigned int, HUGETLB_PAGE_ORDER, PAGE_BLOCK_ORDER_CEIL)
 
 #endif /* CONFIG_HUGETLB_PAGE_SIZE_VARIABLE */
 
 #elif defined(CONFIG_TRANSPARENT_HUGEPAGE)
 
-#define pageblock_order		MIN_T(unsigned int, HPAGE_PMD_ORDER, PAGE_BLOCK_ORDER)
+#define pageblock_order		MIN_T(unsigned int, HPAGE_PMD_ORDER, PAGE_BLOCK_ORDER_CEIL)
 
 #else /* CONFIG_TRANSPARENT_HUGEPAGE */
 
-/* If huge pages are not used, group by PAGE_BLOCK_ORDER */
-#define pageblock_order		PAGE_BLOCK_ORDER
+/* If huge pages are not used, group by PAGE_BLOCK_ORDER_CEIL */
+#define pageblock_order		PAGE_BLOCK_ORDER_CEIL
 
 #endif /* CONFIG_HUGETLB_PAGE */
 
--- a/mm/Kconfig~mm-rename-config_page_block_order-to-config_page_block_order_ceil
+++ a/mm/Kconfig
@@ -1005,8 +1005,8 @@ config ARCH_FORCE_MAX_ORDER
 # the default page block order is MAX_PAGE_ORDER (10) as per
 # include/linux/mmzone.h.
 #
-config PAGE_BLOCK_ORDER
-	int "Page Block Order"
+config PAGE_BLOCK_ORDER_CEIL
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
 	  success rate. If your workloads uses THP heavily, please use this
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-rename-config_page_block_order-to-config_page_block_order_ceil.patch

