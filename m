From: akpm@linux-foundation.org
Subject: - xen-paravirt-ignore-vgacon-if-hardware-not-present.patch removed from -mm tree
Date: Wed, 21 Feb 2007 18:35:54 -0800
Message-ID: <200702220235.l1M2Zsuo001964@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34236 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410AbXBVCg7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 21:36:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, ak@suse.de, chrisw@sous-sol.org, jeremy@xensource.com, rusty@rustcorp.com.au, zach@vmware.com, mm-commits@vger.kernel.org


The patch titled
     Xen-paravirt: ignore vgacon if hardware not present
has been removed from the -mm tree.  Its filename was
     xen-paravirt-ignore-vgacon-if-hardware-not-present.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Xen-paravirt: ignore vgacon if hardware not present
From: Jeremy Fitzhardinge <jeremy@goop.org>

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Zachary Amsden <zach@vmware.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/vgacon.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/video/console/vgacon.c~xen-paravirt-ignore-vgacon-if-hardware-not-present drivers/video/console/vgacon.c
--- a/drivers/video/console/vgacon.c~xen-paravirt-ignore-vgacon-if-hardware-not-present
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

xen-paravirt-ignore-vgacon-if-hardware-not-present.patch
xen-paravirt-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries.patch
xen-paravirt-paravirt_ops-hooks-to-set-up-initial-pagetable.patch
xen-paravirt-paravirt_ops-allocate-a-fixmap-slot.patch
xen-paravirt-remove-ctor-for-pgd-cache.patch
xen-paravirt-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch
xen-paravirt-allow-paravirt-backend-to-select-pgd-allocation-alignment.patch
xen-paravirt-add-hooks-to-intercept-mm-creation-and-destruction.patch
xen-paravirt-add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
xen-paravirt-allocate-and-free-vmalloc-areas.patch
xen-paravirt-add-nosegneg-capability-to-the-vsyscall-page-notes.patch
xen-paravirt-add-xen-config-options-and-disable-unsupported-config-options.patch
xen-paravirt-add-xen-interface-header-files.patch
xen-paravirt-core-xen-implementation.patch
xen-paravirt-core-xen-implementation-fix.patch
xen-paravirt-add-the-xen-virtual-console-driver.patch
xen-paravirt-add-xen-grant-table-support.patch
xen-paravirt-add-the-xenbus-sysfs-and-virtual-device-hotplug-driver.patch
xen-paravirt-add-xen-virtual-block-device-driver.patch
xen-paravirt-add-the-xen-virtual-network-device-driver.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
