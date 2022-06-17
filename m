Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF972C43334
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 23:06:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245202AbiFQXGU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Jun 2022 19:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237569AbiFQXGT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Jun 2022 19:06:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FDBF633B5
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 16:06:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CEF336153F
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 23:06:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ABECC3411B;
        Fri, 17 Jun 2022 23:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655507177;
        bh=fyQpKKDp9YfL0fizR9uTRpu2Aj5Y3MPCrPExTlEgo5U=;
        h=Date:To:From:Subject:From;
        b=hcvAaztjdKpAOPm4HG8RGCTv7yudacrYTf7L4t2eTvwTC6mSo+IzNIm+tYnqZcuz/
         6FBCqwpiQdG+NfNBy18Qqe1Ys7j70ZSsFxHEUrcGBqa/Ms6w3mse2vfzUNIqLr+yy1
         I46l1WY0VQ3SLprxqbJrZ2X8GEwOgZtfVQFff3Qw=
Date:   Fri, 17 Jun 2022 16:06:16 -0700
To:     mm-commits@vger.kernel.org, paulmck@kernel.org, osalvador@suse.de,
        mike.kravetz@oracle.com, duanxiongchun@bytedance.com,
        david@redhat.com, corbet@lwn.net, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-enumerate-all-supported-section-flags.patch added to mm-unstable branch
Message-Id: <20220617230617.1ABECC3411B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory_hotplug: enumerate all supported section flags
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory_hotplug-enumerate-all-supported-section-flags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory_hotplug-enumerate-all-supported-section-flags.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memory_hotplug: enumerate all supported section flags
Date: Fri, 17 Jun 2022 21:56:49 +0800

Patch series "make hugetlb_optimize_vmemmap compatible with
memmap_on_memory", v3.

This series makes hugetlb_optimize_vmemmap compatible with
memmap_on_memory.


This patch (of 2):

We are almost running out of section flags, only one bit is available in
the worst case (powerpc with 256k pages).  However, there are still some
free bits (in ->section_mem_map) on other architectures (e.g.  x86_64 has
10 bits available, arm64 has 8 bits available with worst case of 64K
pages).  We have hard coded those numbers in code, it is inconvenient to
use those bits on other architectures except powerpc.  So transfer those
section flags to enumeration to make it easy to add new section flags in
the future.  Also, move SECTION_TAINT_ZONE_DEVICE into the scope of
CONFIG_ZONE_DEVICE to save a bit on non-zone-device case.

Link: https://lkml.kernel.org/r/20220617135650.74901-1-songmuchun@bytedance.com
Link: https://lkml.kernel.org/r/20220617135650.74901-2-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   44 +++++++++++++++++++++++++++++++--------
 mm/memory_hotplug.c    |    6 +++++
 mm/sparse.c            |    2 -
 3 files changed, 42 insertions(+), 10 deletions(-)

--- a/include/linux/mmzone.h~mm-memory_hotplug-enumerate-all-supported-section-flags
+++ a/include/linux/mmzone.h
@@ -1422,16 +1422,35 @@ extern size_t mem_section_usage_size(voi
  *      (equal SECTION_SIZE_BITS - PAGE_SHIFT), and the
  *      worst combination is powerpc with 256k pages,
  *      which results in PFN_SECTION_SHIFT equal 6.
- * To sum it up, at least 6 bits are available.
+ * To sum it up, at least 6 bits are available on all architectures.
+ * However, we can exceed 6 bits on some other architectures except
+ * powerpc (e.g. 15 bits are available on x86_64, 13 bits are available
+ * with the worst case of 64K pages on arm64) if we make sure the
+ * exceeded bit is not applicable to powerpc.
  */
-#define SECTION_MARKED_PRESENT		(1UL<<0)
-#define SECTION_HAS_MEM_MAP		(1UL<<1)
-#define SECTION_IS_ONLINE		(1UL<<2)
-#define SECTION_IS_EARLY		(1UL<<3)
-#define SECTION_TAINT_ZONE_DEVICE	(1UL<<4)
-#define SECTION_MAP_LAST_BIT		(1UL<<5)
-#define SECTION_MAP_MASK		(~(SECTION_MAP_LAST_BIT-1))
-#define SECTION_NID_SHIFT		6
+enum {
+	SECTION_MARKED_PRESENT_BIT,
+	SECTION_HAS_MEM_MAP_BIT,
+	SECTION_IS_ONLINE_BIT,
+	SECTION_IS_EARLY_BIT,
+#ifdef CONFIG_ZONE_DEVICE
+	SECTION_TAINT_ZONE_DEVICE_BIT,
+#endif
+	SECTION_MAP_LAST_BIT,
+};
+
+enum {
+	SECTION_MARKED_PRESENT		= BIT(SECTION_MARKED_PRESENT_BIT),
+	SECTION_HAS_MEM_MAP		= BIT(SECTION_HAS_MEM_MAP_BIT),
+	SECTION_IS_ONLINE		= BIT(SECTION_IS_ONLINE_BIT),
+	SECTION_IS_EARLY		= BIT(SECTION_IS_EARLY_BIT),
+#ifdef CONFIG_ZONE_DEVICE
+	SECTION_TAINT_ZONE_DEVICE	= BIT(SECTION_TAINT_ZONE_DEVICE_BIT),
+#endif
+};
+
+#define SECTION_MAP_MASK		(~(BIT(SECTION_MAP_LAST_BIT) - 1))
+#define SECTION_NID_SHIFT		SECTION_MAP_LAST_BIT
 
 static inline struct page *__section_mem_map_addr(struct mem_section *section)
 {
@@ -1470,12 +1489,19 @@ static inline int online_section(struct
 	return (section && (section->section_mem_map & SECTION_IS_ONLINE));
 }
 
+#ifdef CONFIG_ZONE_DEVICE
 static inline int online_device_section(struct mem_section *section)
 {
 	unsigned long flags = SECTION_IS_ONLINE | SECTION_TAINT_ZONE_DEVICE;
 
 	return section && ((section->section_mem_map & flags) == flags);
 }
+#else
+static inline int online_device_section(struct mem_section *section)
+{
+	return 0;
+}
+#endif
 
 static inline int online_section_nr(unsigned long nr)
 {
--- a/mm/memory_hotplug.c~mm-memory_hotplug-enumerate-all-supported-section-flags
+++ a/mm/memory_hotplug.c
@@ -670,12 +670,18 @@ static void __meminit resize_pgdat_range
 
 }
 
+#ifdef CONFIG_ZONE_DEVICE
 static void section_taint_zone_device(unsigned long pfn)
 {
 	struct mem_section *ms = __pfn_to_section(pfn);
 
 	ms->section_mem_map |= SECTION_TAINT_ZONE_DEVICE;
 }
+#else
+static inline void section_taint_zone_device(unsigned long pfn)
+{
+}
+#endif
 
 /*
  * Associate the pfn range with the given zone, initializing the memmaps
--- a/mm/sparse.c~mm-memory_hotplug-enumerate-all-supported-section-flags
+++ a/mm/sparse.c
@@ -281,7 +281,7 @@ static unsigned long sparse_encode_mem_m
 {
 	unsigned long coded_mem_map =
 		(unsigned long)(mem_map - (section_nr_to_pfn(pnum)));
-	BUILD_BUG_ON(SECTION_MAP_LAST_BIT > (1UL<<PFN_SECTION_SHIFT));
+	BUILD_BUG_ON(SECTION_MAP_LAST_BIT > PFN_SECTION_SHIFT);
 	BUG_ON(coded_mem_map & ~SECTION_MAP_MASK);
 	return coded_mem_map;
 }
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memory_hotplug-enumerate-all-supported-section-flags.patch
mm-memory_hotplug-make-hugetlb_optimize_vmemmap-compatible-with-memmap_on_memory.patch

