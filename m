From: akpm@linux-foundation.org
Subject: - usb-usb-remove-warn-macro-from-usbh-vs-git-hid.patch removed from -mm tree
Date: Thu, 09 Oct 2008 17:16:49 -0700
Message-ID: <200810100031.m9A0VFOH013820@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45620 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757560AbYJJAbc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2008 20:31:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, greg@kroah.com, jikos@jikos.cz, mm-commits@vger.kernel.org


The patch titled
     usb-usb-remove-warn-macro-from-usbh vs git-hid
has been removed from the -mm tree.  Its filename was
     usb-usb-remove-warn-macro-from-usbh-vs-git-hid.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb-usb-remove-warn-macro-from-usbh vs git-hid
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

fix following buiild error

-------------------------
  CC [M]  drivers/hid/usbhid/hid-core.o
drivers/hid/usbhid/hid-core.c: In function 'usbhid_submit_report':
drivers/hid/usbhid/hid-core.c:417: error: incompatible type for argument 1 of 'dev_driver_string'
drivers/hid/usbhid/hid-core.c:417: error: incompatible type for argument 1 of 'dev_name'
drivers/hid/usbhid/hid-core.c:436: error: incompatible type for argument 1 of 'dev_driver_string'
drivers/hid/usbhid/hid-core.c:436: error: incompatible type for argument 1 of 'dev_name'
drivers/hid/usbhid/hid-core.c: In function 'usbhid_init_reports':
drivers/hid/usbhid/hid-core.c:568: error: incompatible type for argument 1 of 'dev_driver_string'
drivers/hid/usbhid/hid-core.c:568: error: incompatible type for argument 1 of 'dev_name'
make[3]: *** [drivers/hid/usbhid/hid-core.o] Error 1
make[2]: *** [drivers/hid/usbhid] Error 2
make[1]: *** [drivers/hid] Error 2
make: *** [drivers] Error 2
-------------------

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Jiri Kosina <jikos@jikos.cz>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hid/usbhid/hid-core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/hid/usbhid/hid-core.c~usb-usb-remove-warn-macro-from-usbh-vs-git-hid drivers/hid/usbhid/hid-core.c
--- a/drivers/hid/usbhid/hid-core.c~usb-usb-remove-warn-macro-from-usbh-vs-git-hid
+++ a/drivers/hid/usbhid/hid-core.c
@@ -421,7 +421,7 @@ void usbhid_submit_report(struct hid_dev
 
 		if ((head = (usbhid->outhead + 1) & (HID_OUTPUT_FIFO_SIZE - 1)) == usbhid->outtail) {
 			spin_unlock_irqrestore(&usbhid->outlock, flags);
-			dev_warn(hid->dev, "output queue full\n");
+			dev_warn(&hid->dev, "output queue full\n");
 			return;
 		}
 
@@ -447,7 +447,7 @@ void usbhid_submit_report(struct hid_dev
 
 	if ((head = (usbhid->ctrlhead + 1) & (HID_CONTROL_FIFO_SIZE - 1)) == usbhid->ctrltail) {
 		spin_unlock_irqrestore(&usbhid->ctrllock, flags);
-		dev_warn(hid->dev, "control queue full\n");
+		dev_warn(&hid->dev, "control queue full\n");
 		return;
 	}
 
@@ -588,7 +588,7 @@ void usbhid_init_reports(struct hid_devi
 	}
 
 	if (err)
-		dev_warn(hid->dev, "timeout initializing reports\n");
+		dev_warn(&hid->dev, "timeout initializing reports\n");
 }
 
 /*
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

git-tip.patch
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

