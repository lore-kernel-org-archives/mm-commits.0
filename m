From: akpm@linux-foundation.org
Subject: + mm-drop-page_initialized-check-from-get_nid_for_pfn.patch added to -mm tree
Date: Mon, 15 May 2017 14:26:44 -0700
Message-ID: <591a1d14.E30poIwCSbJS1w0F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48314 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758735AbdEOV0q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 15 May 2017 17:26:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, aarcange@redhat.com, ak@linux.intel.com, arbab@linux.vnet.ibm.com, bsingharora@gmail.com, dan.j.williams@intel.com, daniel.kiper@oracle.com, heiko.carstens@de.ibm.com, imammedo@redhat.com, isimatu.yasuaki@jp.fujitsu.com, jglisse@redhat.com, js1304@gmail.com, mgorman@suse.de, qiuxishi@huawei.com, rientjes@google.com, schwidefsky@de.ibm.com, tobias.regnery@gmail.com, toshi.kani@hpe.com, vbabka@suse.cz, vkuznets@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: drop page_initialized check from get_nid_for_pfn
has been added to the -mm tree.  Its filename is
     mm-drop-page_initialized-check-from-get_nid_for_pfn.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-drop-page_initialized-check-from-get_nid_for_pfn.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-drop-page_initialized-check-from-get_nid_for_pfn.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm: drop page_initialized check from get_nid_for_pfn

c04fc586c1a4 ("mm: show node to memory section relationship with symlinks
in sysfs") has added means to export memblock<->node association into the
sysfs.  It has also introduced get_nid_for_pfn which is a rather confusing
counterpart of pfn_to_nid which checks also whether the pfn page is
already initialized (page_initialized).  This is done by checking
page::lru != NULL which doesn't make any sense at all.  Nothing in this
path really relies on the lru list being used or initialized.  Just remove
it because this will become a problem with later patches.

Thanks to Reza Arbab for testing which revealed this to be a problem
(http://lkml.kernel.org/r/20170403202337.GA12482@dhcp22.suse.cz)

Link: http://lkml.kernel.org/r/20170515085827.16474-4-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Reza Arbab <arbab@linux.vnet.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Daniel Kiper <daniel.kiper@oracle.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Igor Mammedov <imammedo@redhat.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Tobias Regnery <tobias.regnery@gmail.com>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c |    7 -------
 1 file changed, 7 deletions(-)

diff -puN drivers/base/node.c~mm-drop-page_initialized-check-from-get_nid_for_pfn drivers/base/node.c
--- a/drivers/base/node.c~mm-drop-page_initialized-check-from-get_nid_for_pfn
+++ a/drivers/base/node.c
@@ -368,21 +368,14 @@ int unregister_cpu_under_node(unsigned i
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG_SPARSE
-#define page_initialized(page)  (page->lru.next)
-
 static int __ref get_nid_for_pfn(unsigned long pfn)
 {
-	struct page *page;
-
 	if (!pfn_valid_within(pfn))
 		return -1;
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 	if (system_state == SYSTEM_BOOTING)
 		return early_pfn_to_nid(pfn);
 #endif
-	page = pfn_to_page(pfn);
-	if (!page_initialized(page))
-		return -1;
 	return pfn_to_nid(pfn);
 }
 
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-remove-return-value-from-init_currently_empty_zone.patch
mm-memory_hotplug-use-node-instead-of-zone-in-can_online_high_movable.patch
mm-drop-page_initialized-check-from-get_nid_for_pfn.patch
mm-memory_hotplug-get-rid-of-is_zone_device_section.patch
mm-memory_hotplug-split-up-register_one_node.patch
mm-memory_hotplug-consider-offline-memblocks-removable.patch
mm-consider-zone-which-is-not-fully-populated-to-have-holes.patch
mm-compaction-skip-over-holes-in-__reset_isolation_suitable.patch
mm-__first_valid_page-skip-over-offline-pages.patch
mm-vmstat-skip-reporting-offline-pages-in-pagetypeinfo.patch
mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online.patch
mm-memory_hotplug-replace-for_device-by-want_memblock-in-arch_add_memory.patch
mm-memory_hotplug-fix-the-section-mismatch-warning.patch
mm-memory_hotplug-remove-unused-cruft-after-memory-hotplug-rework.patch

