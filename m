From: akpm@linux-foundation.org
Subject: + mm-__first_valid_page-skip-over-offline-pages.patch added to
 -mm tree
Date: Mon, 15 May 2017 14:27:03 -0700
Message-ID: <591a1d27.5Gj9N3ATw7/M2mJb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48498 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758883AbdEOV1E (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 15 May 2017 17:27:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, aarcange@redhat.com, ak@linux.intel.com, arbab@linux.vnet.ibm.com, bsingharora@gmail.com, dan.j.williams@intel.com, daniel.kiper@oracle.com, heiko.carstens@de.ibm.com, imammedo@redhat.com, isimatu.yasuaki@jp.fujitsu.com, jglisse@redhat.com, js1304@gmail.com, mgorman@suse.de, qiuxishi@huawei.com, rientjes@google.com, schwidefsky@de.ibm.com, tobias.regnery@gmail.com, toshi.kani@hpe.com, vbabka@suse.cz, vkuznets@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: __first_valid_page skip over offline pages
has been added to the -mm tree.  Its filename is
     mm-__first_valid_page-skip-over-offline-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-__first_valid_page-skip-over-offline-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-__first_valid_page-skip-over-offline-pages.patch

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
Subject: mm: __first_valid_page skip over offline pages

__first_valid_page skips over invalid pfns in the range but it might still
stumble over offline pages.  At least start_isolate_page_range will mark
those set_migratetype_isolate.  This doesn't represent any immediate
AFAICS because alloc_contig_range will fail to isolate those pages but it
relies on not fully initialized page which will become a problem later
when we stop associating offline pages to zones.  Use pfn_to_online_page
to handle this.

This is more a preparatory patch than a fix.

Link: http://lkml.kernel.org/r/20170515085827.16474-10-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
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
Cc: Reza Arbab <arbab@linux.vnet.ibm.com>
Cc: Tobias Regnery <tobias.regnery@gmail.com>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |   26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff -puN mm/page_isolation.c~mm-__first_valid_page-skip-over-offline-pages mm/page_isolation.c
--- a/mm/page_isolation.c~mm-__first_valid_page-skip-over-offline-pages
+++ a/mm/page_isolation.c
@@ -138,12 +138,18 @@ static inline struct page *
 __first_valid_page(unsigned long pfn, unsigned long nr_pages)
 {
 	int i;
-	for (i = 0; i < nr_pages; i++)
-		if (pfn_valid_within(pfn + i))
-			break;
-	if (unlikely(i == nr_pages))
-		return NULL;
-	return pfn_to_page(pfn + i);
+
+	for (i = 0; i < nr_pages; i++) {
+		struct page *page;
+
+		if (!pfn_valid_within(pfn + i))
+			continue;
+		page = pfn_to_online_page(pfn + i);
+		if (!page)
+			continue;
+		return page;
+	}
+	return NULL;
 }
 
 /*
@@ -184,8 +190,12 @@ int start_isolate_page_range(unsigned lo
 undo:
 	for (pfn = start_pfn;
 	     pfn < undo_pfn;
-	     pfn += pageblock_nr_pages)
-		unset_migratetype_isolate(pfn_to_page(pfn), migratetype);
+	     pfn += pageblock_nr_pages) {
+		struct page *page = pfn_to_online_page(pfn);
+		if (!page)
+			continue;
+		unset_migratetype_isolate(page, migratetype);
+	}
 
 	return -EBUSY;
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

