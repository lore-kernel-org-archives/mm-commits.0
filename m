From: akpm@linux-foundation.org
Subject: - alsa-fix-a-const-pointer-usage-warning-in-the-digigram-pcxhr-soundcard-driver.patch removed from -mm tree
Date: Fri, 11 Jul 2008 16:51:02 -0700
Message-ID: <200807112351.m6BNp25h011009@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35206 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754635AbYGKXvU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 19:51:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     alsa: fix a const pointer usage warning in the Digigram pcxhr soundcard driver
has been removed from the -mm tree.  Its filename was
     alsa-fix-a-const-pointer-usage-warning-in-the-digigram-pcxhr-soundcard-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alsa: fix a const pointer usage warning in the Digigram pcxhr soundcard driver
From: David Howells <dhowells@redhat.com>

Fix a const pointer usage warning in the Digigram pcxhr compatible soundcard
driver.  A const pointer is being passed to copy_from_user() to load the
firmware into.  This is okay in this case because the function has allocated
the firmware struct itself, but the const qualifier is part of the firmware
struct - so the patch casts the const away.

This was introduced by patch 0aa4937648b91e9e6d3879b2cbeaa5f0c9863ac0.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/pci/pcxhr/pcxhr_hwdep.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN sound/pci/pcxhr/pcxhr_hwdep.c~alsa-fix-a-const-pointer-usage-warning-in-the-digigram-pcxhr-soundcard-driver sound/pci/pcxhr/pcxhr_hwdep.c
--- a/sound/pci/pcxhr/pcxhr_hwdep.c~alsa-fix-a-const-pointer-usage-warning-in-the-digigram-pcxhr-soundcard-driver
+++ a/sound/pci/pcxhr/pcxhr_hwdep.c
@@ -394,7 +394,7 @@ static int pcxhr_hwdep_dsp_load(struct s
 			   (unsigned long)fw.size);
 		return -ENOMEM;
 	}
-	if (copy_from_user(fw.data, dsp->image, dsp->length)) {
+	if (copy_from_user((void *)fw.data, dsp->image, dsp->length)) {
 		vfree(fw.data);
 		return -EFAULT;
 	}
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
linux-next.patch
acpi-fix-a-cast-of-a-32-bit-int-to-a-pointer.patch
calgary-fix-a-comparison-warning-the-pci-calgary-64-driver.patch
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
frv-use-the-common-ascii-hex-helpers.patch
mn10300-use-the-common-ascii-hex-helpers.patch
mutex-subsystem-synchro-test-module.patch

