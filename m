From: akpm@linux-foundation.org
Subject: - fix-buid-error-of-autodetect_raid.patch removed from -mm tree
Date: Thu, 09 Oct 2008 11:17:19 -0700
Message-ID: <200810091817.m99IHJrc022401@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41197 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753511AbYJISSE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2008 14:18:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, arjan@linux.intel.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     fix buid error of autodetect_raid()
has been removed from the -mm tree.  Its filename was
     fix-buid-error-of-autodetect_raid.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix buid error of autodetect_raid()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Patch against: mmotm 02 Oct
Applied after: git-fastboot.patch

fix following build error

>  CC      init/do_mounts_md.o
>init/do_mounts_md.c: In function 'autodetect_raid':
>init/do_mounts_md.c:278: error: implicit declaration of function 'msleep'
>make[1]: *** [init/do_mounts_md.o] Error 1
>make: *** [init] Error 2

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts_md.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN init/do_mounts_md.c~fix-buid-error-of-autodetect_raid init/do_mounts_md.c
--- a/init/do_mounts_md.c~fix-buid-error-of-autodetect_raid
+++ a/init/do_mounts_md.c
@@ -1,5 +1,6 @@
 
 #include <linux/raid/md.h>
+#include <linux/delay.h>
 
 #include "do_mounts.h"
 
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

fix-buid-error-of-autodetect_raid.patch
fix-buid-error-of-md-raid.patch
usb-usb-remove-warn-macro-from-usbh-vs-git-hid.patch
usb-usb-remove-warn-macro-from-usbh-vs-git-hid-fix.patch
mm-do_generic_file_read-never-gets-a-null-filp-argument.patch
vmscan-use-an-indexed-array-for-lru-variables.patch
swap-use-an-array-for-the-lru-pagevecs.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
vmscan-second-chance-replacement-for-anonymous-pages.patch
unevictable-lru-infrastructure.patch
unevictable-lru-infrastructure-nommu-fix.patch
unevictable-lru-infrastructure-remember-pages-active-state.patch
unevictable-lru-infrastructure-defer-vm-event-counting.patch
unevictable-infrastructure-lru-add-event-counting-with-statistics.patch
unevictable-lru-page-statistics.patch
shm_locked-pages-are-unevictable.patch
shm_locked-pages-are-unevictable-add-event-counts-to-list-scan.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
doc-unevictable-lru-and-mlocked-pages-documentation-update-2.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-fix-__mlock_vma_pages_range-comment-block.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-backout-locked_vm-adjustment-during-mmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch-fix.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-fix-return-value-for-munmap-mlock-vma-race.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-update-locked_vm-on-munmap-of-mlocked-region.patch
vmstat-mlocked-pages-statistics.patch
vmstat-mlocked-pages-statistics-mlocked-pages-add-event-counting-with-statistics.patch
swap-cull-unevictable-pages-in-fault-path.patch
vmscan-unevictable-lru-scan-sysctl.patch
vmscam-kill-unused-lru-functions.patch
mlock-revert-mainline-handling-of-mlock-error-return.patch
mlock-make-mlock-error-return-posixly-correct.patch
mlock-make-mlock-error-return-posixly-correct-fix.patch
mm-unlockless-reclaim.patch
coredump_filter-add-hugepage-dumping-v4.patch
hugepage-support-zero_page.patch
add-config_core_dump_default_elf_headers.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
make-mm-rmapc-anon_vma_cachep-static.patch

