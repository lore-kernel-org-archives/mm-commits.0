From: akpm@linux-foundation.org
Subject: +
 mm-memory_hotplug-change-pfn_to_section_nr-section_nr_to_pfn-macro-to-inline-function.patch added to -mm tree
Date: Wed, 27 Sep 2017 16:02:34 -0700
Message-ID: <59cc2e0a.kjDHaeRJQqlMI++A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58210 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751671AbdI0XCf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Sep 2017 19:02:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yasu.isimatu@gmail.com, arbab@linux.vnet.ibm.com, isimatu.yasuaki@jp.fujitsu.com, mhocko@suse.com, qiuxishi@huawei.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: change pfn_to_section_nr/section_nr_to_pfn macro to inline function
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-change-pfn_to_section_nr-section_nr_to_pfn-macro-to-inline-function.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-change-pfn_to_section_nr-section_nr_to_pfn-macro-to-inline-function.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-change-pfn_to_section_nr-section_nr_to_pfn-macro-to-inline-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-memory_hotplug-change-pfn_to_section_nr-section_nr_to_pfn-macro-to-inline-function.patch
mm-memory_hotplug-define-find_smallestbiggest_section_pfn-as-unsigned-long.patch

