From: akpm@linux-foundation.org
Subject: - memcgroup-check-and-initialize-page-cgroup-in-memmap_init_zone.patch removed from -mm tree
Date: Thu, 17 Apr 2008 20:18:23 -0700
Message-ID: <200804180318.m3I3INUk008631@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43502 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753806AbYDRDTm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Apr 2008 23:19:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shiwh@cn.fujitsu.com, balbir@in.ibm.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, stable@kernel.org, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     memcgroup: check and initialize page->cgroup in memmap_init_zone
has been removed from the -mm tree.  Its filename was
     memcgroup-check-and-initialize-page-cgroup-in-memmap_init_zone.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcgroup: check and initialize page->cgroup in memmap_init_zone
From: Shi Weihua <shiwh@cn.fujitsu.com>

When we test memory controller in Fujitsu PrimeQuest(arch: ia64),
the compiled kernel boots failed, the following message occured on
the telnet terminal.

-------------------------------------
..........
ELILO boot: Uncompressing Linux... done
Loading file initrd-2.6.25-rc9-00067-gb87e81e.img...done
_ (system freezed)
-------------------------------------

We found commit 9442ec9df40d952b0de185ae5638a74970388e01
causes this boot failure by git-bisect.

And, we found the following change caused the boot failure.

-------------------------------------
                set_page_links(page, zone, nid, pfn);
                init_page_count(page);
                reset_page_mapcount(page);
-               page_assign_page_cgroup(page, NULL);
                SetPageReserved(page);

                /*
-------------------------------------

In this patch, the Author Hugh Dickins said "...memmap_init_zone doesn't need
it either, ...  Linux assumes pointers in zeroed structures are NULL
pointers." But it seems it's not always the case, so we should check and
initialize page->cgroup anyways.

Signed-off-by: Shi Weihua <shiwh@cn.fujitsu.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/page_alloc.c~memcgroup-check-and-initialize-page-cgroup-in-memmap_init_zone mm/page_alloc.c
--- a/mm/page_alloc.c~memcgroup-check-and-initialize-page-cgroup-in-memmap_init_zone
+++ a/mm/page_alloc.c
@@ -2518,6 +2518,7 @@ void __meminit memmap_init_zone(unsigned
 	struct page *page;
 	unsigned long end_pfn = start_pfn + size;
 	unsigned long pfn;
+	void *pc;
 
 	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
 		/*
@@ -2535,6 +2536,9 @@ void __meminit memmap_init_zone(unsigned
 		set_page_links(page, zone, nid, pfn);
 		init_page_count(page);
 		reset_page_mapcount(page);
+		pc = page_get_page_cgroup(page);
+		if (pc)
+			page_reset_bad_cgroup(page);
 		SetPageReserved(page);
 
 		/*
_

Patches currently in -mm which might be from shiwh@cn.fujitsu.com are

memcgroup-check-and-initialize-page-cgroup-in-memmap_init_zone.patch

