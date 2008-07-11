From: akpm@linux-foundation.org
Subject: + hysdn-remove-the-packed-attribute-from-poftimstamp_tag.patch added to -mm tree
Date: Fri, 11 Jul 2008 11:37:56 -0700
Message-ID: <200807111843.m6BIhb7t030804@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38049 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756666AbYGKSoF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 14:44:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, kkeil@suse.de


The patch titled
     hysdn: remove the packed attribute from PofTimStamp_tag
has been added to the -mm tree.  Its filename is
     hysdn-remove-the-packed-attribute-from-poftimstamp_tag.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hysdn: remove the packed attribute from PofTimStamp_tag
From: David Howells <dhowells@redhat.com>

Remove the packed attribute from PofTimStamp_tag in the hysdn driver as the
thing being packed is just an array of chars and so is unpackable.

This deals with a compiler warning:

In file included from drivers/isdn/hysdn/hysdn_boot.c:19:
drivers/isdn/hysdn/hysdn_pof.h:63: warning: 'packed' attribute ignored for field of type 'unsigned char[40]'

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hysdn/hysdn_pof.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/isdn/hysdn/hysdn_pof.h~hysdn-remove-the-packed-attribute-from-poftimstamp_tag drivers/isdn/hysdn/hysdn_pof.h
--- a/drivers/isdn/hysdn/hysdn_pof.h~hysdn-remove-the-packed-attribute-from-poftimstamp_tag
+++ a/drivers/isdn/hysdn/hysdn_pof.h
@@ -60,7 +60,7 @@ typedef struct PofRecHdr_tag {	/* Pof re
 
 typedef struct PofTimeStamp_tag {
 /*00 */ unsigned long UnixTime __attribute__((packed));
-	/*04 */ unsigned char DateTimeText[0x28] __attribute__((packed));
+	/*04 */ unsigned char DateTimeText[0x28];
 	/* =40 */
 /*2C */
 } tPofTimeStamp;
_

Patches currently in -mm which might be from dhowells@redhat.com are

linux-next.patch
acpi-fix-a-cast-of-a-32-bit-int-to-a-pointer.patch
acpi-fix-build-with-config_pm_sleep=n.patch
calgary-fix-a-comparison-warning-the-pci-calgary-64-driver.patch
alsa-fix-a-const-pointer-usage-warning-in-the-digigram-pcxhr-soundcard-driver.patch
alsa-fix-a-const-pointer-usage-warning-in-the-digigram-mixart-soundcard-driver.patch
cifs-fix-range-check.patch
sis-drm-fix-the-memory-allocator-if-the-sis-fb-is-built-as-a-module.patch
sis-drm-fix-a-pointer-cast-warning.patch
ivtv-framebuffer-driver-fix-pointer-cast-warnings.patch
drx397xd-demodulator-driver-fix-a-const-pointer-assignment.patch
mtd-fix-const-assignment-in-the-command-line-partitioning-driver.patch
atm-fix-const-assignment-discard-warnings-in-the-atm-networking-driver.patch
atm-fix-direct-casts-of-pointers-to-u32-in-the-interphase-driver.patch
hysdn-remove-the-packed-attribute-from-poftimstamp_tag.patch
git-unionfs.patch
xfs-fix-disabled-xfs-posix-acl-handling.patch
mn10300-move-sg_dma_addresslen-to-asm-scatterlisth.patch
inflate-refactor-inflate-malloc-code.patch
inflate-refactor-inflate-malloc-code-checkpatch-fixes.patch
pnpacpi-fix-pnpacpi_parse_irq_options-test-against-pnp_irq_nr.patch
include-asm-ptraceh-userspace-headers-cleanup.patch
sdio-fix-break-control-to-now-return-success-or-an-error.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
fix-a-const-assignment-in-moxa_load_fw.patch
frv-use-the-common-ascii-hex-helpers.patch
mn10300-use-the-common-ascii-hex-helpers.patch
mutex-subsystem-synchro-test-module.patch

