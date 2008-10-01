From: akpm@linux-foundation.org
Subject: - m32r-export-__ndelay.patch removed from -mm tree
Date: Wed, 01 Oct 2008 14:50:34 -0700
Message-ID: <200810012150.m91LoYu3005852@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53613 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753717AbYJAVu4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2008 17:50:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, takata@linux-m32r.org, mm-commits@vger.kernel.org


The patch titled
     m32r: export __ndelay
has been removed from the -mm tree.  Its filename was
     m32r-export-__ndelay.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-powerpc.patch
git-sparc.patch
git-x86.patch
git-xtensa.patch
git-v4l-dvb.patch
git-net.patch
git-crypto.patch
git-drm.patch
git-security-testing.patch
the-overdue-eepro100-removal.patch
parisc-lib-make-code-static.patch
drivers-parisc-make-code-static.patch
if-0-ses_match_host.patch
scsi-remove-the-unused-scsi_qlogic_fc_firmware-option.patch
drivers-scsi-a2091c-make-2-functions-static.patch
drivers-scsi-a3000c-make-2-functions-static.patch
fs_mbcache-dont-needlessly-make-it-built-in.patch
misdn-dsp_cmxc-fix-size-checks.patch
asm-h8300-mdh-remove-cvs-keyword.patch
alpha-miata-remove-dead-url.patch
uml-remove-the-dead-tty_log-code.patch
include-linux-kernelh-userspace-header-cleanup.patch
maintainers-remove-hga-framebuffer-driver-entry.patch
include-linux-mounth-remove-cvs-keyword.patch
kernel-dmac-remove-a-cvs-keyword.patch
binfmt_somc-add-module_license.patch
make-probe_serial_gsc-static.patch
pnp-remove-printk-with-outdated-version.patch
telephony-remove-cvs-keywords.patch
reiserfs-procfsc-remove-cvs-keywords.patch
quota-remove-cvs-keywords.patch
make-ptrace_untrace-static.patch
fs-partitions-acornc-remove-dead-code.patch
parport-remove-cvs-keywords.patch
make-mm-rmapc-anon_vma_cachep-static.patch
ipc-semc-make-free_un-static.patch
make-fs-proc-proc_sysctlc-grab_header-static.patch
make-hp_wmi_notify-static.patch
make-kprobesc-kretprobe_table_lock-static.patch
acpi-use-bcd2bin-bin2bcd.patch
alpha-use-bcd2bin-bin2bcd.patch
cris-use-bcd2bin-bin2bcd.patch
drivers-rtc-use-bcd2bin-bin2bcd.patch
rtc-use-bcd2bin-bin2bcd.patch
mips-use-bcd2bin-bin2bcd.patch
mn10300-use-bcd2bin-bin2bcd.patch
i2c-use-bcd2bin-bin2bcd.patch
drivers-scsi-sr_vendorc-use-bcd2bin.patch
remove-the-obsolete-bcdbin-binbcd-macros.patch
include-linux-bcdh-remove-comments.patch
reiser4.patch

