From: akpm@linux-foundation.org
Subject: +
 vmalloc-fix-__gfp_highmem-usage-for-vmalloc_32-on-32b-systems-checkpatch-fixes.patch added to -mm tree
Date: Mon, 12 Feb 2018 16:29:21 -0800
Message-ID: <5a823161.vWgLXb0ixRX8gW2+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56456 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932769AbeBMA3X (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Feb 2018 19:29:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: vmalloc-fix-__gfp_highmem-usage-for-vmalloc_32-on-32b-systems-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     vmalloc-fix-__gfp_highmem-usage-for-vmalloc_32-on-32b-systems-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vmalloc-fix-__gfp_highmem-usage-for-vmalloc_32-on-32b-systems-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vmalloc-fix-__gfp_highmem-usage-for-vmalloc_32-on-32b-systems-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: vmalloc-fix-__gfp_highmem-usage-for-vmalloc_32-on-32b-systems-checkpatch-fixes

ERROR: Please use git commit description style 'commit <12+ chars of sha1> ("<title line>")' - ie: 'commit 0123456789ab ("commit description")'
#5: 
drivers/media/common/saa7146/saa7146_core.c since 19809c2da28a ("mm,

ERROR: Macros with complex values should be enclosed in parentheses
#45: FILE: mm/vmalloc.c:1954:
+#define GFP_VMALLOC32 GFP_DMA32 | GFP_KERNEL

total: 2 errors, 0 warnings, 12 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/vmalloc-fix-__gfp_highmem-usage-for-vmalloc_32-on-32b-systems.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/vmalloc.c~vmalloc-fix-__gfp_highmem-usage-for-vmalloc_32-on-32b-systems-checkpatch-fixes mm/vmalloc.c
--- a/mm/vmalloc.c~vmalloc-fix-__gfp_highmem-usage-for-vmalloc_32-on-32b-systems-checkpatch-fixes
+++ a/mm/vmalloc.c
@@ -1943,9 +1943,9 @@ void *vmalloc_exec(unsigned long size)
 }
 
 #if defined(CONFIG_64BIT) && defined(CONFIG_ZONE_DMA32)
-#define GFP_VMALLOC32 GFP_DMA32 | GFP_KERNEL
+#define GFP_VMALLOC32 (GFP_DMA32 | GFP_KERNEL)
 #elif defined(CONFIG_64BIT) && defined(CONFIG_ZONE_DMA)
-#define GFP_VMALLOC32 GFP_DMA | GFP_KERNEL
+#define GFP_VMALLOC32 (GFP_DMA | GFP_KERNEL)
 #else
 /*
  * 64b systems should always have either DMA or DMA32 zones. For others
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
include-linux-sched-mmh-re-inline-mmdrop.patch
mm-zpool-zpool_evictable-fix-mismatch-in-parameter-name-and-kernel-doc-fix.patch
vmalloc-fix-__gfp_highmem-usage-for-vmalloc_32-on-32b-systems-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
inotify-extend-ioctl-to-allow-to-request-id-of-new-watch-descriptor-fix.patch
mm.patch
mm-initialize-pages-on-demand-during-boot-fix.patch
list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch
mm-oom-cgroup-aware-oom-killer-fix.patch
mm-oom-docs-describe-the-cgroup-aware-oom-killer-fix-2-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

