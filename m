From: akpm@linux-foundation.org
Subject: + parisc-lib-make-code-static.patch added to -mm tree
Date: Wed, 06 Aug 2008 15:52:57 -0700
Message-ID: <200808062252.m76MqvQm019802@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54896 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755041AbYHFWxy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2008 18:53:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, grundler@parisc-linux.org, kyle@mcmartin.ca, matthew@wil.cx


The patch titled
     parisc/lib/: make code static
has been added to the -mm tree.  Its filename is
     parisc-lib-make-code-static.patch

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
Subject: parisc/lib/: make code static
From: Adrian Bunk <bunk@kernel.org>

Make the following needlessly global code static:

- iomap.c: struct iomap_ops[]
- memcpy.c: pa_memcpy()

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Grant Grundler <grundler@parisc-linux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/lib/iomap.c  |    2 +-
 arch/parisc/lib/memcpy.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/parisc/lib/iomap.c~parisc-lib-make-code-static arch/parisc/lib/iomap.c
--- a/arch/parisc/lib/iomap.c~parisc-lib-make-code-static
+++ a/arch/parisc/lib/iomap.c
@@ -261,7 +261,7 @@ static const struct iomap_ops iomem_ops 
 	iomem_write32r,
 };
 
-const struct iomap_ops *iomap_ops[8] = {
+static const struct iomap_ops *iomap_ops[8] = {
 	[0] = &ioport_ops,
 	[7] = &iomem_ops
 };
diff -puN arch/parisc/lib/memcpy.c~parisc-lib-make-code-static arch/parisc/lib/memcpy.c
--- a/arch/parisc/lib/memcpy.c~parisc-lib-make-code-static
+++ a/arch/parisc/lib/memcpy.c
@@ -275,7 +275,7 @@ handle_store_error:
 
 
 /* Returns 0 for success, otherwise, returns number of bytes not transferred. */
-unsigned long pa_memcpy(void *dstp, const void *srcp, unsigned long len)
+static unsigned long pa_memcpy(void *dstp, const void *srcp, unsigned long len)
 {
 	register unsigned long src, dst, t1, t2, t3;
 	register unsigned char *pcs, *pcd;
_

Patches currently in -mm which might be from bunk@kernel.org are

feature-removal-scheduletxt-remove-the-ncr53c9x-entry.patch
linux-next.patch
m32r-remove-the-unused-nohighmem-option.patch
m32r-dont-offer-config_isa.patch
if-0-ses_match_host.patch
scsi-remove-the-unused-scsi_qlogic_fc_firmware-option.patch
git-block.patch
fs_mbcache-dont-needlessly-make-it-built-in.patch
git-xtensa.patch
uml-remove-the-dead-tty_log-code.patch
include-linux-kernelh-userspace-header-cleanup.patch
make-mm-rmapc-anon_vma_cachep-static.patch
drivers-firmware-iscsi_ibftc-make-3-functions-static.patch
reiser4.patch
fs-partitions-acornc-remove-dead-code.patch
the-overdue-eepro100-removal.patch
pnp-remove-printk-with-outdated-version.patch
telephony-remove-cvs-keywords.patch
reiserfs-procfsc-remove-cvs-keywords.patch
parport-remove-cvs-keywords.patch
quota-remove-cvs-keywords.patch
include-linux-mounth-remove-cvs-keyword.patch
kernel-dmac-remove-a-cvs-keyword.patch
asm-h8300-mdh-remove-cvs-keyword.patch
alpha-miata-remove-dead-url.patch
maintainers-remove-zf-machz-watchdog-entry.patch
maintainers-remove-hga-framebuffer-driver-entry.patch
ntfs-update-homepage.patch
drivers-scsi-a2091c-make-2-functions-static.patch
drivers-scsi-a3000c-make-2-functions-static.patch
m32r-export-empty_zero_page.patch
m32r-export-__ndelay.patch
m32r-kernel-cleanups.patch
binfmt_somc-add-module_license.patch
parisc-lib-make-code-static.patch
drivers-parisc-make-code-static.patch
make-probe_serial_gsc-static.patch
make-ptrace_untrace-static.patch
the-scheduled-serial_coldfire-removal.patch

