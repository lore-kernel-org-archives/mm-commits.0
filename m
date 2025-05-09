Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA72A24339D
	for <mm-commits@vger.kernel.org>; Fri,  9 May 2025 20:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746822561; cv=none; b=mLqOul8yvtPb9u/w7sWhMiYf7jGq+CM3izspdLUgRzhnetwJ9K/pISOZTokat4s0o3UN5xSEGndSQvdZOe4ORZBLl0IGEEdefNgKHoUXiTJpWysQ6FMMoD+nLoY6DvEc6g3guqC7WUgW2OGtSsibf7tzM0F7+TevjpAFAmqxFE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746822561; c=relaxed/simple;
	bh=ucJu+7ebP5ZUHywEu8rl9T3agrFXisnQWI2dpftupDA=;
	h=Date:To:From:Subject:Message-Id; b=Cc8kSOrm7xg8O4gvq+xfhKICqzWq0CMCS/praVFKvqjvaPTIHx+zu5iQfUjnsHppVck8GGRAVzP7RtaP7HnJmUsszu3YPWcmXzE32vPUV1UMA4Uv2JthG+ZugLtc8RcOOaz5wNaMzc2EVV2lpwO3YhS/wXmNsy5FueMYVoLBvEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FdBoSiLU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FdBoSiLU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32A26C4CEE4;
	Fri,  9 May 2025 20:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746822561;
	bh=ucJu+7ebP5ZUHywEu8rl9T3agrFXisnQWI2dpftupDA=;
	h=Date:To:From:Subject:From;
	b=FdBoSiLUIPWhXfznXxff3cYrOGRHZMx7rvwbWRLbtZl+8Lk5Yi8hIUaK4tu8ibw+X
	 ULEAOg1Bzc6jIOWbKyWWn3JT1DjWJFR5Bo687hoft4+Ms09jS51r2e35Q/869Y6B4i
	 SNpM2ipxhR1PQrRkUWeCPa50whbz5pGCKaRXlORg=
Date: Fri, 09 May 2025 13:29:20 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,minchan@kernel.org,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,david@redhat.com,jyescas@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-add-config_page_block_order-to-select-page-block-order.patch removed from -mm tree
Message-Id: <20250509202921.32A26C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add CONFIG_PAGE_BLOCK_ORDER to select page block order
has been removed from the -mm tree.  Its filename was
     mm-add-config_page_block_order-to-select-page-block-order.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Juan Yescas <jyescas@google.com>
Subject: mm: add CONFIG_PAGE_BLOCK_ORDER to select page block order
Date: Mon, 5 May 2025 17:22:58 -0700

Problem: On large page size configurations (16KiB, 64KiB), the CMA
alignment requirement (CMA_MIN_ALIGNMENT_BYTES) increases considerably,
and this causes the CMA reservations to be larger than necessary.  This
means that system will have less available MIGRATE_UNMOVABLE and
MIGRATE_RECLAIMABLE page blocks since MIGRATE_CMA can't fallback to them.

The CMA_MIN_ALIGNMENT_BYTES increases because it depends on MAX_PAGE_ORDER
which depends on ARCH_FORCE_MAX_ORDER.  The value of ARCH_FORCE_MAX_ORDER
increases on 16k and 64k kernels.

For example, in ARM, the CMA alignment requirement when:

- CONFIG_ARCH_FORCE_MAX_ORDER default value is used
- CONFIG_TRANSPARENT_HUGEPAGE is set:

PAGE_SIZE | MAX_PAGE_ORDER | pageblock_order | CMA_MIN_ALIGNMENT_BYTES
-----------------------------------------------------------------------
   4KiB   |      10        |      10         |  4KiB * (2 ^ 10)  =  4MiB
  16Kib   |      11        |      11         | 16KiB * (2 ^ 11) =  32MiB
  64KiB   |      13        |      13         | 64KiB * (2 ^ 13) = 512MiB

There are some extreme cases for the CMA alignment requirement when:

- CONFIG_ARCH_FORCE_MAX_ORDER maximum value is set
- CONFIG_TRANSPARENT_HUGEPAGE is NOT set:
- CONFIG_HUGETLB_PAGE is NOT set

PAGE_SIZE | MAX_PAGE_ORDER | pageblock_order |  CMA_MIN_ALIGNMENT_BYTES
------------------------------------------------------------------------
   4KiB   |      15        |      15         |  4KiB * (2 ^ 15) = 128MiB
  16Kib   |      13        |      13         | 16KiB * (2 ^ 13) = 128MiB
  64KiB   |      13        |      13         | 64KiB * (2 ^ 13) = 512MiB

This affects the CMA reservations for the drivers. If a driver in a
4KiB kernel needs 4MiB of CMA memory, in a 16KiB kernel, the minimal
reservation has to be 32MiB due to the alignment requirements:

reserved-memory {
    ...
    cma_test_reserve: cma_test_reserve {
        compatible = "shared-dma-pool";
        size = <0x0 0x400000>; /* 4 MiB */
        ...
    };
};

reserved-memory {
    ...
    cma_test_reserve: cma_test_reserve {
        compatible = "shared-dma-pool";
        size = <0x0 0x2000000>; /* 32 MiB */
        ...
    };
};

Solution: Add a new config CONFIG_PAGE_BLOCK_ORDER that allows to set the
page block order in all the architectures.  The maximum page block order
will be given by ARCH_FORCE_MAX_ORDER.

By default, CONFIG_PAGE_BLOCK_ORDER will have the same value that
ARCH_FORCE_MAX_ORDER.  This will make sure that current kernel
configurations won't be affected by this change.  It is a opt-in change.

This patch will allow to have the same CMA alignment requirements for
large page sizes (16KiB, 64KiB) as that in 4kb kernels by setting a lower
pageblock_order.

Tests:

- Verified that HugeTLB pages work when pageblock_order is 1, 7, 10
on 4k and 16k kernels.

- Verified that Transparent Huge Pages work when pageblock_order
is 1, 7, 10 on 4k and 16k kernels.

- Verified that dma-buf heaps allocations work when pageblock_order
is 1, 7, 10 on 4k and 16k kernels.

Benchmarks:

The benchmarks compare 16kb kernels with pageblock_order 10 and 7.  The
reason for the pageblock_order 7 is because this value makes the min CMA
alignment requirement the same as that in 4kb kernels (2MB).

- Perform 100K dma-buf heaps (/dev/dma_heap/system) allocations of
  SZ_8M, SZ_4M, SZ_2M, SZ_1M, SZ_64, SZ_8, SZ_4.  Use simpleperf
  (https://developer.android.com/ndk/guides/simpleperf) to measure the #
  of instructions and page-faults on 16k kernels.  The benchmark was
  executed 10 times.  The averages are below:

           # instructions         |     #page-faults
    order 10     |  order 7       | order 10 | order 7
--------------------------------------------------------
 13,891,765,770	 | 11,425,777,314 |    220   |   217
 14,456,293,487	 | 12,660,819,302 |    224   |   219
 13,924,261,018	 | 13,243,970,736 |    217   |   221
 13,910,886,504	 | 13,845,519,630 |    217   |   221
 14,388,071,190	 | 13,498,583,098 |    223   |   224
 13,656,442,167	 | 12,915,831,681 |    216   |   218
 13,300,268,343	 | 12,930,484,776 |    222   |   218
 13,625,470,223	 | 14,234,092,777 |    219   |   218
 13,508,964,965	 | 13,432,689,094 |    225   |   219
 13,368,950,667	 | 13,683,587,37  |    219   |   225
-------------------------------------------------------------------
 13,803,137,433  | 13,131,974,268 |    220   |   220    Averages

There were 4.85% #instructions when order was 7, in comparison with order
10.

     13,803,137,433 - 13,131,974,268 = -671,163,166 (-4.86%)

The number of page faults in order 7 and 10 were the same.

These results didn't show any significant regression when the
pageblock_order is set to 7 on 16kb kernels.

- Run speedometer 3.1 (https://browserbench.org/Speedometer3.1/) 5 times
  on the 16k kernels with pageblock_order 7 and 10.

order 10 | order 7  | order 7 - order 10 | (order 7 - order 10) %
-------------------------------------------------------------------
  15.8	 |  16.4    |         0.6        |     3.80%
  16.4	 |  16.2    |        -0.2        |    -1.22%
  16.6	 |  16.3    |        -0.3        |    -1.81%
  16.8	 |  16.3    |        -0.5        |    -2.98%
  16.6	 |  16.8    |         0.2        |     1.20%
-------------------------------------------------------------------
  16.44     16.4            -0.04	          -0.24%   Averages

The results didn't show any significant regression when the
pageblock_order is set to 7 on 16kb kernels.

[akpm@linux-foundation.org: tweak Kconfig text]
Link: https://lkml.kernel.org/r/20250506002319.513795-1-jyescas@google.com
Signed-off-by: Juan Yescas <jyescas@google.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pageblock-flags.h |   14 +++++++++----
 mm/Kconfig                      |   31 ++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+), 4 deletions(-)

--- a/include/linux/pageblock-flags.h~mm-add-config_page_block_order-to-select-page-block-order
+++ a/include/linux/pageblock-flags.h
@@ -28,6 +28,12 @@ enum pageblock_bits {
 	NR_PAGEBLOCK_BITS
 };
 
+#if defined(CONFIG_PAGE_BLOCK_ORDER)
+#define PAGE_BLOCK_ORDER CONFIG_PAGE_BLOCK_ORDER
+#else
+#define PAGE_BLOCK_ORDER MAX_PAGE_ORDER
+#endif /* CONFIG_PAGE_BLOCK_ORDER */
+
 #if defined(CONFIG_HUGETLB_PAGE)
 
 #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE
@@ -41,18 +47,18 @@ extern unsigned int pageblock_order;
  * Huge pages are a constant size, but don't exceed the maximum allocation
  * granularity.
  */
-#define pageblock_order		MIN_T(unsigned int, HUGETLB_PAGE_ORDER, MAX_PAGE_ORDER)
+#define pageblock_order		MIN_T(unsigned int, HUGETLB_PAGE_ORDER, PAGE_BLOCK_ORDER)
 
 #endif /* CONFIG_HUGETLB_PAGE_SIZE_VARIABLE */
 
 #elif defined(CONFIG_TRANSPARENT_HUGEPAGE)
 
-#define pageblock_order		MIN_T(unsigned int, HPAGE_PMD_ORDER, MAX_PAGE_ORDER)
+#define pageblock_order		MIN_T(unsigned int, HPAGE_PMD_ORDER, PAGE_BLOCK_ORDER)
 
 #else /* CONFIG_TRANSPARENT_HUGEPAGE */
 
-/* If huge pages are not used, group by MAX_ORDER_NR_PAGES */
-#define pageblock_order		MAX_PAGE_ORDER
+/* If huge pages are not used, group by PAGE_BLOCK_ORDER */
+#define pageblock_order		PAGE_BLOCK_ORDER
 
 #endif /* CONFIG_HUGETLB_PAGE */
 
--- a/mm/Kconfig~mm-add-config_page_block_order-to-select-page-block-order
+++ a/mm/Kconfig
@@ -993,6 +993,37 @@ config CMA_AREAS
 
 	  If unsure, leave the default value "8" in UMA and "20" in NUMA.
 
+#
+# Select this config option from the architecture Kconfig, if available, to set
+# the max page order for physically contiguous allocations.
+#
+config ARCH_FORCE_MAX_ORDER
+	int
+
+# When ARCH_FORCE_MAX_ORDER is not defined, the default page block order is 10,
+# as per include/linux/mmzone.h.
+config PAGE_BLOCK_ORDER
+	int "Page Block Order"
+	range 1 10 if !ARCH_FORCE_MAX_ORDER
+	default 10 if !ARCH_FORCE_MAX_ORDER
+	range 1 ARCH_FORCE_MAX_ORDER if ARCH_FORCE_MAX_ORDER
+	default ARCH_FORCE_MAX_ORDER if ARCH_FORCE_MAX_ORDER
+
+	help
+	  The page block order refers to the power of two number of pages that
+	  are physically contiguous and can have a migrate type associated to
+	  them. The maximum size of the page block order is limited by
+	  ARCH_FORCE_MAX_ORDER.
+
+	  This option allows overriding the default setting when the page
+	  block order is required to be smaller than ARCH_FORCE_MAX_ORDER.
+
+	  Reducing pageblock order can negatively impact THP generation
+	  success rate. If your workloads uses THP heavily, please use this
+	  option with caution.
+
+	  Don't change if unsure.
+
 config MEM_SOFT_DIRTY
 	bool "Track memory changes"
 	depends on CHECKPOINT_RESTORE && HAVE_ARCH_SOFT_DIRTY && PROC_FS
_

Patches currently in -mm which might be from jyescas@google.com are


