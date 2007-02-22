From: akpm@linux-foundation.org
Subject: + xen-paravirt_ops-ignore-vgacon-if-hardware-not-present.patch added to -mm tree
Date: Wed, 21 Feb 2007 18:53:15 -0800
Message-ID: <200702220253.l1M2rFL4002443@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34551 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923AbXBVCxS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 21:53:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, jeremy@xensource.com


The patch titled
     From: Jeremy Fitzhardinge <jeremy@goop.org>
has been added to the -mm tree.  Its filename is
     xen-paravirt_ops-ignore-vgacon-if-hardware-not-present.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: From: Jeremy Fitzhardinge <jeremy@goop.org>


Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

===================================================================
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/vgacon.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/video/console/vgacon.c~xen-paravirt_ops-ignore-vgacon-if-hardware-not-present drivers/video/console/vgacon.c
--- a/drivers/video/console/vgacon.c~xen-paravirt_ops-ignore-vgacon-if-hardware-not-present
+++ a/drivers/video/console/vgacon.c
@@ -371,7 +371,8 @@ static const char *vgacon_startup(void)
 	}
 
 	/* VGA16 modes are not handled by VGACON */
-	if ((ORIG_VIDEO_MODE == 0x0D) ||	/* 320x200/4 */
+	if ((ORIG_VIDEO_MODE == 0x00) ||	/* SCREEN_INFO not initialized */
+	    (ORIG_VIDEO_MODE == 0x0D) ||	/* 320x200/4 */
 	    (ORIG_VIDEO_MODE == 0x0E) ||	/* 640x200/4 */
 	    (ORIG_VIDEO_MODE == 0x10) ||	/* 640x350/4 */
 	    (ORIG_VIDEO_MODE == 0x12) ||	/* 640x480/4 */
_

Patches currently in -mm which might be from jeremy@goop.org are

xen-paravirt_ops-no-need-to-use-traditional-for-processing-asm-in-arch-i386.patch
xen-paravirt_ops-clean-up-elf-note-generation.patch
xen-paravirt_ops-fix-typo-in-sync_constant_test_bits-name.patch
xen-paravirt_ops-ignore-vgacon-if-hardware-not-present.patch
xen-paravirt_ops-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries.patch
xen-paravirt_ops-paravirt_ops-hooks-to-set-up-initial-pagetable.patch
xen-paravirt_ops-paravirt_ops-allocate-a-fixmap-slot.patch
xen-paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch
xen-paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction.patch
xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations.patch
xen-paravirt_ops-add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
xen-paravirt_ops-allocate-and-free-vmalloc-areas.patch
xen-paravirt_ops-add-nosegneg-capability-to-the-vsyscall-page-notes.patch
xen-paravirt_ops-add-xen-config-options.patch
xen-paravirt_ops-add-xen-interface-header-files.patch
xen-paravirt_ops-core-xen-implementation.patch
xen-paravirt_ops-some-generic-early-printk-boot-console-fixups.patch
xen-paravirt_ops-use-the-hvc-console-infrastructure-for-xen-console.patch
xen-paravirt_ops-add-early-printk-support-via-hvc-console.patch
xen-paravirt_ops-add-xen-grant-table-support.patch
xen-paravirt_ops-add-the-xenbus-sysfs-and-virtual-device-hotplug-driver.patch
xen-paravirt_ops-add-xen-virtual-block-device-driver.patch
xen-paravirt_ops-add-the-xen-virtual-network-device-driver.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
