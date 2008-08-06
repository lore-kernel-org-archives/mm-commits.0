From: akpm@linux-foundation.org
Subject: + m32r-export-__ndelay.patch added to -mm tree
Date: Wed, 06 Aug 2008 15:52:51 -0700
Message-ID: <200808062252.m76MqpI1019793@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57119 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754779AbYHFWxL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2008 18:53:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, takata@linux-m32r.org


The patch titled
     m32r: export __ndelay
has been added to the -mm tree.  Its filename is
     m32r-export-__ndelay.patch

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
Subject: m32r: export __ndelay
From: Adrian Bunk <bunk@kernel.org>

ERROR: "__ndelay" [drivers/spi/spi_bitbang.ko] undefined!

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/lib/delay.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/m32r/lib/delay.c~m32r-export-__ndelay arch/m32r/lib/delay.c
--- a/arch/m32r/lib/delay.c~m32r-export-__ndelay
+++ a/arch/m32r/lib/delay.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/param.h>
+#include <linux/module.h>
 #ifdef CONFIG_SMP
 #include <linux/sched.h>
 #include <asm/current.h>
@@ -121,3 +122,4 @@ void __ndelay(unsigned long nsecs)
 {
 	__const_udelay(nsecs * 0x00005);  /* 2**32 / 1000000000 (rounded up) */
 }
+EXPORT_SYMBOL(__ndelay);
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

