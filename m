From: akpm@linux-foundation.org
Subject: +
 mm-vmstat-skip-reporting-offline-pages-in-pagetypeinfo-fix.patch added to
 -mm tree
Date: Mon, 22 May 2017 13:13:56 -0700
Message-ID: <59234684.NV/A4WEZVWsqKWp8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40488 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757407AbdEVUN5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 May 2017 16:13:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, fengguang.wu@intel.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmstat-skip-reporting-offline-pages-in-pagetypeinfo-fix
has been added to the -mm tree.  Its filename is
     mm-vmstat-skip-reporting-offline-pages-in-pagetypeinfo-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmstat-skip-reporting-offline-pages-in-pagetypeinfo-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmstat-skip-reporting-offline-pages-in-pagetypeinfo-fix.patch

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
Subject: mm-vmstat-skip-reporting-offline-pages-in-pagetypeinfo-fix

0-day has reported
   In file included from arch/x86/include/asm/page.h:75:0,
                    from arch/x86/include/asm/thread_info.h:11,
                    from include/linux/thread_info.h:37,
                    from arch/x86/include/asm/preempt.h:6,
                    from include/linux/preempt.h:80,
                    from include/linux/spinlock.h:50,
                    from include/linux/wait.h:8,
                    from include/linux/fs.h:5,
                    from mm/vmstat.c:12:
   mm/vmstat.c: In function 'pagetypeinfo_showblockcount_print':
>> include/asm-generic/memory_model.h:54:52: warning: 'page' is used uninitialized in this function [-Wuninitialized]
    #define __page_to_pfn(page) (unsigned long)((page) - vmemmap)
                                                       ^
   mm/vmstat.c:1224:16: note: 'page' was declared here
      struct page *page;
                   ^~~~

Link: http://lkml.kernel.org/r/20170519072225.GA13041@dhcp22.suse.cz
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/vmstat.c~mm-vmstat-skip-reporting-offline-pages-in-pagetypeinfo-fix mm/vmstat.c
--- a/mm/vmstat.c~mm-vmstat-skip-reporting-offline-pages-in-pagetypeinfo-fix
+++ a/mm/vmstat.c
@@ -1223,7 +1223,8 @@ static void pagetypeinfo_showblockcount_
 	for (pfn = start_pfn; pfn < end_pfn; pfn += pageblock_nr_pages) {
 		struct page *page;
 
-		if (!pfn_to_online_page(pfn))
+		page = pfn_to_online_page(pfn);
+		if (!page)
 			continue;
 
 		/* Watch for unexpected holes punched in the memmap */
_

Patches currently in -mm which might be from mhocko@suse.com are

include-linux-gfph-fix-___gfp_nolockdep-value.patch
mm-clarify-why-we-want-kmalloc-before-falling-backto-vmallock.patch
mm-remove-return-value-from-init_currently_empty_zone.patch
mm-memory_hotplug-use-node-instead-of-zone-in-can_online_high_movable.patch
mm-drop-page_initialized-check-from-get_nid_for_pfn.patch
mm-memory_hotplug-get-rid-of-is_zone_device_section.patch
mm-memory_hotplug-split-up-register_one_node.patch
mm-memory_hotplug-consider-offline-memblocks-removable.patch
mm-consider-zone-which-is-not-fully-populated-to-have-holes.patch
mm-consider-zone-which-is-not-fully-populated-to-have-holes-fix.patch
mm-compaction-skip-over-holes-in-__reset_isolation_suitable.patch
mm-__first_valid_page-skip-over-offline-pages.patch
mm-vmstat-skip-reporting-offline-pages-in-pagetypeinfo.patch
mm-vmstat-skip-reporting-offline-pages-in-pagetypeinfo-fix.patch
mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online.patch
mm-memory_hotplug-replace-for_device-by-want_memblock-in-arch_add_memory.patch
mm-memory_hotplug-fix-the-section-mismatch-warning.patch
mm-memory_hotplug-remove-unused-cruft-after-memory-hotplug-rework.patch
mm-adaptive-hash-table-scaling-fix.patch

