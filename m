From: akpm@linux-foundation.org
Subject: + fix-a-const-assignment-in-moxa_load_fw.patch added to -mm tree
Date: Fri, 11 Jul 2008 11:43:35 -0700
Message-ID: <200807111849.m6BInG1L031209@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50828 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755975AbYGKSth (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 14:49:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, jirislaby@gmail.com


The patch titled
     moxa: fix a const assignment in moxa_load_fw()
has been added to the -mm tree.  Its filename is
     fix-a-const-assignment-in-moxa_load_fw.patch

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
Subject: moxa: fix a const assignment in moxa_load_fw()
From: David Howells <dhowells@redhat.com>

Fix an assignment of a const pointer to a non-const pointer in moxa_load_fw().

This was introduced by patch 037182346f0991683cc7320a257c3f6089432cee.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/moxa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/moxa.c~fix-a-const-assignment-in-moxa_load_fw drivers/char/moxa.c
--- a/drivers/char/moxa.c~fix-a-const-assignment-in-moxa_load_fw
+++ a/drivers/char/moxa.c
@@ -731,7 +731,7 @@ static int moxa_load_fw(struct moxa_boar
 		u8 model;	/* C218T=1, C320T=2, CP204=3 */
 		u8 reserved2[8];
 		__le16 len[5];
-	} *hdr = ptr;
+	} const *hdr = ptr;
 
 	BUILD_BUG_ON(ARRAY_SIZE(hdr->len) != ARRAY_SIZE(lens));
 
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

