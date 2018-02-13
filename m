From: akpm@linux-foundation.org
Subject: +
 vmalloc-fix-__gfp_highmem-usage-for-vmalloc_32-on-32b-systems.patch added
 to -mm tree
Date: Mon, 12 Feb 2018 16:27:53 -0800
Message-ID: <5a823109.5o/gVc3ZlOB759yX%akpm__25249.9026865282$1518481587$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56130 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932769AbeBMA1z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Feb 2018 19:27:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, kai.heng.feng@canonical.com, labbott@redhat.com, stable@vger.kernel.org, willy@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: vmalloc: fix __GFP_HIGHMEM usage for vmalloc_32 on 32b systems
has been added to the -mm tree.  Its filename is
     vmalloc-fix-__gfp_highmem-usage-for-vmalloc_32-on-32b-systems.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vmalloc-fix-__gfp_highmem-usage-for-vmalloc_32-on-32b-systems.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vmalloc-fix-__gfp_highmem-usage-for-vmalloc_32-on-32b-systems.patch

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
Subject: vmalloc: fix __GFP_HIGHMEM usage for vmalloc_32 on 32b systems

Kai Heng Feng has noticed that BUG_ON(PageHighMem(pg)) triggers in
drivers/media/common/saa7146/saa7146_core.c since 19809c2da28a ("mm,
vmalloc: use __GFP_HIGHMEM implicitly").  saa7146_vmalloc_build_pgtable
uses vmalloc_32 and it is reasonable to expect that the resulting page is
not in highmem.  The above commit aimed to add __GFP_HIGHMEM only for
those requests which do not specify any zone modifier gfp flag. 
vmalloc_32 relies on GFP_VMALLOC32 which should do the right thing. 
Except it has been missed that GFP_VMALLOC32 is an alias for GFP_KERNEL on
32b architectures.  Thanks to Matthew to notice this.

Fix the problem by unconditionally setting GFP_DMA32 in GFP_VMALLOC32 for
!64b arches (as a bailout).  This should do the right thing and use
ZONE_NORMAL which should be always below 4G on 32b systems.

Debugged by Matthew Wilcox.

Link: http://lkml.kernel.org/r/20180212095019.GX21609@dhcp22.suse.cz
Fixes: 19809c2da28a ("mm, vmalloc: use __GFP_HIGHMEM implicitly”)
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Kai Heng Feng <kai.heng.feng@canonical.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Laura Abbott <labbott@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN mm/vmalloc.c~vmalloc-fix-__gfp_highmem-usage-for-vmalloc_32-on-32b-systems mm/vmalloc.c
--- a/mm/vmalloc.c~vmalloc-fix-__gfp_highmem-usage-for-vmalloc_32-on-32b-systems
+++ a/mm/vmalloc.c
@@ -1947,7 +1947,11 @@ void *vmalloc_exec(unsigned long size)
 #elif defined(CONFIG_64BIT) && defined(CONFIG_ZONE_DMA)
 #define GFP_VMALLOC32 GFP_DMA | GFP_KERNEL
 #else
-#define GFP_VMALLOC32 GFP_KERNEL
+/*
+ * 64b systems should always have either DMA or DMA32 zones. For others
+ * GFP_DMA32 should do the right thing and use the normal zone.
+ */
+#define GFP_VMALLOC32 GFP_DMA32 | GFP_KERNEL
 #endif
 
 /**
_

Patches currently in -mm which might be from mhocko@suse.com are

vmalloc-fix-__gfp_highmem-usage-for-vmalloc_32-on-32b-systems.patch
mm-oom-docs-describe-the-cgroup-aware-oom-killer-fix-2.patch
mm-introduce-map_fixed_safe.patch
fs-elf-drop-map_fixed-usage-from-elf_map.patch
mm-numa-rework-do_pages_move.patch
mm-migrate-remove-reason-argument-from-new_page_t.patch
mm-unclutter-thp-migration.patch

