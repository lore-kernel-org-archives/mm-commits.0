From: akpm@linux-foundation.org
Subject: + fix-buid-error-of-md-raid.patch added to -mm tree
Date: Thu, 09 Oct 2008 00:08:07 -0700
Message-ID: <200810090708.m99787DN012175@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59612 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755432AbYJIHJT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2008 03:09:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, maan@systemlinux.org, neilb@suse.de


The patch titled
     fix buid error of md raid
has been added to the -mm tree.  Its filename is
     fix-buid-error-of-md-raid.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix buid error of md raid
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Patch against: mmotm 02 Oct
Applied after: git-md.patch

fix following build error

--------------------
  CC      drivers/md/raid1.o
drivers/md/raid1.c: In function 'sync_request':
drivers/md/raid1.c:1759: error: implicit declaration of function 'msleep_interruptible'
make[2]: *** [drivers/md/raid1.o] Error 1
make[1]: *** [drivers/md] Error 2
make: *** [drivers] Error 2

  CC      drivers/md/raid10.o
drivers/md/raid10.c: In function 'sync_request':
drivers/md/raid10.c:1749: error: implicit declaration of function 'msleep_interruptible'
make[2]: *** [drivers/md/raid10.o] Error 1

  CC      drivers/md/md.o
drivers/md/md.c: In function 'md_do_sync':
drivers/md/md.c:5914: error: implicit declaration of function 'msleep'
drivers/md/md.c: In function 'md_notify_reboot':
drivers/md/md.c:6265: error: implicit declaration of function 'mdelay'
make[2]: *** [drivers/md/md.o] Error 1
make[1]: *** [drivers/md] Error 2
make: *** [drivers] Error 2
----------------------

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Andre Noll <maan@systemlinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c     |    1 +
 drivers/md/raid1.c  |    1 +
 drivers/md/raid10.c |    1 +
 3 files changed, 3 insertions(+)

diff -puN drivers/md/md.c~fix-buid-error-of-md-raid drivers/md/md.c
--- a/drivers/md/md.c~fix-buid-error-of-md-raid
+++ a/drivers/md/md.c
@@ -44,6 +44,7 @@
 #include <linux/random.h>
 #include <linux/reboot.h>
 #include <linux/file.h>
+#include <linux/delay.h>
 
 #define MAJOR_NR MD_MAJOR
 
diff -puN drivers/md/raid1.c~fix-buid-error-of-md-raid drivers/md/raid1.c
--- a/drivers/md/raid1.c~fix-buid-error-of-md-raid
+++ a/drivers/md/raid1.c
@@ -34,6 +34,7 @@
 #include "dm-bio-list.h"
 #include <linux/raid/raid1.h>
 #include <linux/raid/bitmap.h>
+#include <linux/delay.h>
 
 #define DEBUG 0
 #if DEBUG
diff -puN drivers/md/raid10.c~fix-buid-error-of-md-raid drivers/md/raid10.c
--- a/drivers/md/raid10.c~fix-buid-error-of-md-raid
+++ a/drivers/md/raid10.c
@@ -21,6 +21,7 @@
 #include "dm-bio-list.h"
 #include <linux/raid/raid10.h>
 #include <linux/raid/bitmap.h>
+#include <linux/delay.h>
 
 /*
  * RAID10 provides a combination of RAID0 and RAID1 functionality.
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

fix-buid-error-of-autodetect_raid.patch
fix-buid-error-of-md-raid.patch
usb-usb-remove-warn-macro-from-usbh-vs-git-hid.patch
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

