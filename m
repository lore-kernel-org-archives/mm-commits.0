From: akpm@linux-foundation.org
Subject: + mm-make-maddr-__iomem.patch added to -mm tree
Date: Tue, 25 Nov 2008 15:56:02 -0800
Message-ID: <200811252356.mAPNu2vE026696@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39106 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751528AbYKYX4H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Nov 2008 18:56:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com


The patch titled
     mm: make maddr __iomem
has been added to the -mm tree.  Its filename is
     mm-make-maddr-__iomem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: make maddr __iomem
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

sparse output following warnings.

mm/memory.c:2936:8: warning: incorrect type in assignment (different address spaces)
mm/memory.c:2936:8:    expected void *maddr
mm/memory.c:2936:8:    got void [noderef] <asn:2>

cleanup here.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory.c~mm-make-maddr-__iomem mm/memory.c
--- a/mm/memory.c~mm-make-maddr-__iomem
+++ a/mm/memory.c
@@ -2935,7 +2935,7 @@ int generic_access_phys(struct vm_area_s
 {
 	resource_size_t phys_addr;
 	unsigned long prot = 0;
-	void *maddr;
+	void __iomem *maddr;
 	int offset = addr & (PAGE_SIZE-1);
 
 	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

linux-next.patch
vmscan-evict-streaming-io-first.patch
mm-report-the-pagesize-backing-a-vma-in-proc-pid-smaps.patch
mm-report-the-mmu-pagesize-in-proc-pid-smaps.patch
oom-fix-zone_scan_mutex-name.patch
mm-get-rid-of-pagevec_release_nonlru.patch
cleanup-get-rid-of-ifdef-config_migration.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
mm-make-page_lock_anon_vma-static.patch
memcg-reclaim-shouldnt-change-zone-recent_rotated-statistics.patch
mm-make-init_section_page_cgroup-static.patch
mm-make-maddr-__iomem.patch
mm-make-mem_cgroup_resize_limit-static.patch
mm-make-scan_all_zones_unevictable_pages-static.patch
mm-make-scan_zone_unevictable_pages-static.patch
mm-make-setup_per_zone_inactive_ratio-static.patch
mm-make-vread-and-vwrite-declaration.patch

