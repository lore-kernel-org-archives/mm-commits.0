From: akpm@linux-foundation.org
Subject: +
 mm-memory-hotplug-fix-lowmem-count-overflow-when-offline-pages.patch added
 to -mm tree
Date: Tue, 28 May 2013 16:02:04 -0700
Message-ID: <51a5376c.S2crnLU156c+EHOu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33726 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757389Ab3E1XCG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 May 2013 19:02:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, rientjes@google.com, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, liwanp@linux.vnet.ibm.com

Subject: + mm-memory-hotplug-fix-lowmem-count-overflow-when-offline-pages.patch added to -mm tree
To: liwanp@linux.vnet.ibm.com,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,rientjes@google.com,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 May 2013 16:02:04 -0700


The patch titled
     Subject: mm/memory-hotplug: fix lowmem count overflow when offline pages
has been added to the -mm tree.  Its filename is
     mm-memory-hotplug-fix-lowmem-count-overflow-when-offline-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: mm/memory-hotplug: fix lowmem count overflow when offline pages

Logic memory-remove code fails to correctly account the Total High Memory
when a memory block which contains High Memory is offlined as shown in the
example below.  The following patch fixes it.

Before logic memory remove:

MemTotal:        7603740 kB
MemFree:         6329612 kB
Buffers:           94352 kB
Cached:           872008 kB
SwapCached:            0 kB
Active:           626932 kB
Inactive:         519216 kB
Active(anon):     180776 kB
Inactive(anon):   222944 kB
Active(file):     446156 kB
Inactive(file):   296272 kB
Unevictable:           0 kB
Mlocked:               0 kB
HighTotal:       7294672 kB
HighFree:        5704696 kB
LowTotal:         309068 kB
LowFree:          624916 kB

After logic memory remove:

MemTotal:        7079452 kB
MemFree:         5805976 kB
Buffers:           94372 kB
Cached:           872000 kB
SwapCached:            0 kB
Active:           626936 kB
Inactive:         519236 kB
Active(anon):     180780 kB
Inactive(anon):   222944 kB
Active(file):     446156 kB
Inactive(file):   296292 kB
Unevictable:           0 kB
Mlocked:               0 kB
HighTotal:       7294672 kB
HighFree:        5181024 kB
LowTotal:       4294752076 kB
LowFree:          624952 kB

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: <stable@vger.kernel.org>	[2.6.24+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/page_alloc.c~mm-memory-hotplug-fix-lowmem-count-overflow-when-offline-pages mm/page_alloc.c
--- a/mm/page_alloc.c~mm-memory-hotplug-fix-lowmem-count-overflow-when-offline-pages
+++ a/mm/page_alloc.c
@@ -6196,6 +6196,8 @@ __offline_isolated_pages(unsigned long s
 		list_del(&page->lru);
 		rmv_page_order(page);
 		zone->free_area[order].nr_free--;
+		if (PageHighMem(page))
+			totalhigh_pages -= 1 << order;
 		for (i = 0; i < (1 << order); i++)
 			SetPageReserved((page+i));
 		pfn += (1 << order);
_

Patches currently in -mm which might be from liwanp@linux.vnet.ibm.com are

mm-memory-hotplug-fix-lowmem-count-overflow-when-offline-pages.patch
mm-pageblock-remove-get-set_pageblock_flags.patch
mm-hugetlb-remove-hugetlb_prefault.patch
mm-hugetlb-use-already-exist-interface-huge_page_shift.patch

