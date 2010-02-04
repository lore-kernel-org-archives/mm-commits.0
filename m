From: akpm@linux-foundation.org
Subject: [merged] resources-introduce-generic-page_is_ram-fix-2.patch removed from -mm tree
Date: Thu, 04 Feb 2010 09:49:35 -0800
Message-ID: <201002041749.o14HnZPf012058@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39817 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755599Ab0BDRtw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Feb 2010 12:49:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     resources-introduce-generic-page_is_ram-fix-2
has been removed from the -mm tree.  Its filename was
     resources-introduce-generic-page_is_ram-fix-2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: resources-introduce-generic-page_is_ram-fix-2
From: Wu Fengguang <fengguang.wu@intel.com>



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ioport.h |    2 --
 include/linux/mm.h     |    2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/ioport.h~resources-introduce-generic-page_is_ram-fix-2 include/linux/ioport.h
--- a/include/linux/ioport.h~resources-introduce-generic-page_is_ram-fix-2
+++ a/include/linux/ioport.h
@@ -191,7 +191,5 @@ extern int
 walk_system_ram_range(unsigned long start_pfn, unsigned long nr_pages,
 		void *arg, int (*func)(unsigned long, unsigned long, void *));
 
-extern int page_is_ram(unsigned long pfn);
-
 #endif /* __ASSEMBLY__ */
 #endif	/* _LINUX_IOPORT_H */
diff -puN include/linux/mm.h~resources-introduce-generic-page_is_ram-fix-2 include/linux/mm.h
--- a/include/linux/mm.h~resources-introduce-generic-page_is_ram-fix-2
+++ a/include/linux/mm.h
@@ -265,6 +265,8 @@ static inline int get_page_unless_zero(s
 	return atomic_inc_not_zero(&page->_count);
 }
 
+extern int page_is_ram(unsigned long pfn);
+
 /* Support for virtually mapped pages */
 struct page *vmalloc_to_page(const void *addr);
 unsigned long vmalloc_to_pfn(const void *addr);
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
linux-next.patch
fanotify-fix-fmode_nonotify-bit-number.patch
vfs-improve-writeback_inodes_wb.patch
mm-introduce-dump_page-and-print-symbolic-flag-names.patch
vmscan-check-high-watermark-after-shrink-zone.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix-2.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory-fix.patch
vfs-take-f_lock-on-modifying-f_mode-after-open-time.patch
readahead-introduce-fmode_random-for-posix_fadv_random.patch
readahead-introduce-fmode_random-for-posix_fadv_random-fix.patch
include-linux-fsh-convert-fmode_-constants-to-hex.patch
vfs-add-super-operation-writeback_inodes.patch

