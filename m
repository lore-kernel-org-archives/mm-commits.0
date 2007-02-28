From: akpm@linux-foundation.org
Subject: - xen-paravirt_ops-ignore-vgacon-if-hardware-not-present.patch removed from -mm tree
Date: Wed, 28 Feb 2007 15:16:16 -0800
Message-ID: <200702282316.l1SNGGrP030047@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47187 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163AbXB1XQT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:16:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, jeremy@xensource.com, mm-commits@vger.kernel.org


The patch titled
     From: Jeremy Fitzhardinge <jeremy@goop.org>
has been removed from the -mm tree.  Its filename was
     xen-paravirt_ops-ignore-vgacon-if-hardware-not-present.patch

This patch was dropped because an updated version will be merged

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

make-hvc_consolec-compile-on-non-powerpc-remove-no_irq.patch
xen-paravirt_ops-no-need-to-use-traditional-for-processing-asm-in-arch-i386.patch
xen-paravirt_ops-ignore-vgacon-if-hardware-not-present.patch
xen-paravirt_ops-paravirt_ops-hooks-to-set-up-initial-pagetable.patch
xen-paravirt_ops-paravirt_ops-allocate-a-fixmap-slot.patch
xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations.patch
xen-paravirt_ops-some-generic-early-printk-boot-console-fixups.patch
xen-paravirt_ops-use-the-hvc-console-infrastructure-for-xen-console.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
