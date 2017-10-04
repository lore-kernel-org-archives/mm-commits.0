From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?mm-memory=5Fhotplug-change-pfn=5Fto=5Fsection=5Fnr-sect?=
 =?US-ASCII?Q?ion=5Fnr=5Fto=5Fpfn-macro-to-inline-function.patch?= removed
 from -mm tree
Date: Wed, 04 Oct 2017 12:41:58 -0700
Message-ID: <20171004194158.BG6Y3bSXM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33730 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751132AbdJDTl7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2017 15:41:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arbab@linux.vnet.ibm.com, isimatu.yasuaki@jp.fujitsu.com, mhocko@suse.com, mm-commits@vger.kernel.org, qiuxishi@huawei.com, vbabka@suse.cz, yasu.isimatu@gmail.com


The patch titled
     Subject: mm/memory_hotplug: change pfn_to_section_nr/section_nr_to_pfn macro to inline function
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-change-pfn_to_section_nr-section_nr_to_pfn-macro-to-inline-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: YASUAKI ISHIMATSU <yasu.isimatu@gmail.com>
Subject: mm/memory_hotplug: change pfn_to_section_nr/section_nr_to_pfn macro to inline function

pfn_to_section_nr() and section_nr_to_pfn() are defined as macro. 
pfn_to_section_nr() has no issue even if it is defined as macro.  But
section_nr_to_pfn() has overflow issue if sec is defined as int.

section_nr_to_pfn() just shifts sec by PFN_SECTION_SHIFT.  If sec is
defined as unsigned long, section_nr_to_pfn() returns pfn as 64 bit value.
But if sec is defined as int, section_nr_to_pfn() returns pfn as 32 bit
value.

__remove_section() calculates start_pfn using section_nr_to_pfn() and
scn_nr defined as int.  So if hot-removed memory address is over 16TB,
overflow issue occurs and section_nr_to_pfn() does not calculate correct
pfn.

To make callers use proper arg, the patch changes the macros to inline
functions.

Fixes: 815121d2b5cd ("memory_hotplug: clear zone when removing the memory")
Link: http://lkml.kernel.org/r/e643a387-e573-6bbf-d418-c60c8ee3d15e@gmail.com
Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Reza Arbab <arbab@linux.vnet.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   10 ++++++++--
 mm/memory_hotplug.c    |    2 +-
 2 files changed, 9 insertions(+), 3 deletions(-)

diff -puN include/linux/mmzone.h~mm-memory_hotplug-change-pfn_to_section_nr-section_nr_to_pfn-macro-to-inline-function include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-memory_hotplug-change-pfn_to_section_nr-section_nr_to_pfn-macro-to-inline-function
+++ a/include/linux/mmzone.h
@@ -1094,8 +1094,14 @@ static inline unsigned long early_pfn_to
 #error Allocator MAX_ORDER exceeds SECTION_SIZE
 #endif
 
-#define pfn_to_section_nr(pfn) ((pfn) >> PFN_SECTION_SHIFT)
-#define section_nr_to_pfn(sec) ((sec) << PFN_SECTION_SHIFT)
+static inline unsigned long pfn_to_section_nr(unsigned long pfn)
+{
+	return pfn >> PFN_SECTION_SHIFT;
+}
+static inline unsigned long section_nr_to_pfn(unsigned long sec)
+{
+	return sec << PFN_SECTION_SHIFT;
+}
 
 #define SECTION_ALIGN_UP(pfn)	(((pfn) + PAGES_PER_SECTION - 1) & PAGE_SECTION_MASK)
 #define SECTION_ALIGN_DOWN(pfn)	((pfn) & PAGE_SECTION_MASK)
diff -puN mm/memory_hotplug.c~mm-memory_hotplug-change-pfn_to_section_nr-section_nr_to_pfn-macro-to-inline-function mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplug-change-pfn_to_section_nr-section_nr_to_pfn-macro-to-inline-function
+++ a/mm/memory_hotplug.c
@@ -551,7 +551,7 @@ static int __remove_section(struct zone
 		return ret;
 
 	scn_nr = __section_nr(ms);
-	start_pfn = section_nr_to_pfn(scn_nr);
+	start_pfn = section_nr_to_pfn((unsigned long)scn_nr);
 	__remove_zone(zone, start_pfn);
 
 	sparse_remove_one_section(zone, ms, map_offset);
_

Patches currently in -mm which might be from yasu.isimatu@gmail.com are


