Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 728E2C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 31 May 2022 20:57:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241929AbiEaU5V (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 May 2022 16:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344824AbiEaU5U (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 May 2022 16:57:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 884D417E2F
        for <mm-commits@vger.kernel.org>; Tue, 31 May 2022 13:57:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2508D60F2A
        for <mm-commits@vger.kernel.org>; Tue, 31 May 2022 20:57:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 717F5C385A9;
        Tue, 31 May 2022 20:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654030635;
        bh=ZXCc7imV+SrGtoygYFbi9bZrIpJ7eaOc/ksrItRU/0c=;
        h=Date:To:From:Subject:From;
        b=xgz5e2aQtFO08K3SJQ/P9EEIbsiaEW2KGclHS6lXzRnp2GIbbUMUPokWqhhMSlBZN
         1fOHcmWw+iGZ0VZZ2Rr3ebtYaDQkhMKFZUF0i/GUIpOrCzTo2fc9gQVwzYx67dNWN8
         m2WmkHrXcX2sYqf9aIx2mQ5r+/Uetl5aDzu2SMZU=
Date:   Tue, 31 May 2022 13:57:14 -0700
To:     mm-commits@vger.kernel.org, paulmck@kernel.org, osalvador@suse.de,
        mike.kravetz@oracle.com, duanxiongchun@bytedance.com,
        david@redhat.com, corbet@lwn.net, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-enumerate-all-supported-section-flags.patch added to mm-unstable branch
Message-Id: <20220531205715.717F5C385A9@smtp.kernel.org>
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
Date: Fri, 20 May 2022 10:55:37 +0800

Patch series "make hugetlb_optimize_vmemmap compatible with memmap_on_memory", v2.

This series makes hugetlb_optimize_vmemmap compatible with
memmap_on_memory.


This patch (of 2):

We are almost running out of section flags, only one bit is available in
the worst case (powerpc with 256k pages).  However, there are still some
free bits (in ->section_mem_map) on other architectures (e.g.  x86_64 has
10 bits available, arm64 has 8 bits available with worst case of 64K
pages).  We have hard coded those numbers in code, it is inconvenient to
use those bits on other architectures except powerpc.

So transfer those section flags to enumeration to make it easy to add new
section flags in the future.  Also, move SECTION_TAINT_ZONE_DEVICE into
the scope of CONFIG_ZONE_DEVICE to save a bit on non-zone-device case.

Link: https://lkml.kernel.org/r/20220520025538.21144-1-songmuchun@bytedance.com
Link: https://lkml.kernel.org/r/20220520025538.21144-2-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kconfig.h |    1 
 include/linux/mmzone.h  |   54 ++++++++++++++++++++++++++++++++------
 mm/memory_hotplug.c     |    6 ++++
 3 files changed, 53 insertions(+), 8 deletions(-)

--- a/include/linux/kconfig.h~mm-memory_hotplug-enumerate-all-supported-section-flags
+++ a/include/linux/kconfig.h
@@ -10,6 +10,7 @@
 #define __LITTLE_ENDIAN 1234
 #endif
 
+#define __ARG_PLACEHOLDER_ 0,
 #define __ARG_PLACEHOLDER_1 0,
 #define __take_second_arg(__ignored, val, ...) val
 
--- a/include/linux/mmzone.h~mm-memory_hotplug-enumerate-all-supported-section-flags
+++ a/include/linux/mmzone.h
@@ -1422,16 +1422,47 @@ extern size_t mem_section_usage_size(voi
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
+#define ENUM_SECTION_FLAG(MAPPER)						\
+	MAPPER(MARKED_PRESENT)							\
+	MAPPER(HAS_MEM_MAP)							\
+	MAPPER(IS_ONLINE)							\
+	MAPPER(IS_EARLY)							\
+	MAPPER(TAINT_ZONE_DEVICE, CONFIG_ZONE_DEVICE)				\
+	MAPPER(MAP_LAST_BIT)
+
+#define __SECTION_SHIFT_FLAG_MAPPER_0(x)
+#define __SECTION_SHIFT_FLAG_MAPPER_1(x)	SECTION_##x##_SHIFT,
+#define __SECTION_SHIFT_FLAG_MAPPER(x, ...)	\
+	__PASTE(__SECTION_SHIFT_FLAG_MAPPER_, IS_ENABLED(__VA_ARGS__))(x)
+
+#define __SECTION_FLAG_MAPPER_0(x)
+#define __SECTION_FLAG_MAPPER_1(x)		SECTION_##x = BIT(SECTION_##x##_SHIFT),
+#define __SECTION_FLAG_MAPPER(x, ...)		\
+	__PASTE(__SECTION_FLAG_MAPPER_, IS_ENABLED(__VA_ARGS__))(x)
+
+enum {
+	/*
+	 * Generate a series of enumeration flags like SECTION_$name_SHIFT.
+	 * Each entry in ENUM_SECTION_FLAG() macro will be generated to one
+	 * enumeration iff the 2nd parameter of MAPPER() is defined or absent.
+	 * The $name comes from the 1st parameter of MAPPER() macro.
+	 */
+	ENUM_SECTION_FLAG(__SECTION_SHIFT_FLAG_MAPPER)
+	/*
+	 * Generate a series of enumeration flags like:
+	 *   SECTION_$name = BIT(SECTION_$name_SHIFT)
+	 */
+	ENUM_SECTION_FLAG(__SECTION_FLAG_MAPPER)
+};
+
 #define SECTION_MAP_MASK		(~(SECTION_MAP_LAST_BIT-1))
-#define SECTION_NID_SHIFT		6
+#define SECTION_NID_SHIFT		SECTION_MAP_LAST_BIT_SHIFT
 
 static inline struct page *__section_mem_map_addr(struct mem_section *section)
 {
@@ -1470,12 +1501,19 @@ static inline int online_section(struct
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
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-hugetlb_vmemmap-fix-config_hugetlb_page_free_vmemmap_default_on.patch
mm-memory_hotplug-enumerate-all-supported-section-flags.patch
mm-memory_hotplug-introduce-section_cannot_optimize_vmemmap.patch

