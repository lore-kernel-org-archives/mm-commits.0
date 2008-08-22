From: akpm@linux-foundation.org
Subject: + make-kprobesc-kretprobe_table_lock-static.patch added to -mm tree
Date: Fri, 22 Aug 2008 11:37:27 -0700
Message-ID: <200808221837.m7MIbRV1010296@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42177 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752249AbYHVSho (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Aug 2008 14:37:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, ananth@in.ibm.com


The patch titled
     make kprobes.c:kretprobe_table_lock() static
has been added to the -mm tree.  Its filename is
     make-kprobesc-kretprobe_table_lock-static.patch

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
Subject: make kprobes.c:kretprobe_table_lock() static
From: Adrian Bunk <bunk@kernel.org>

Make the needlessly global kretprobe_table_lock() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kprobes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/kprobes.c~make-kprobesc-kretprobe_table_lock-static kernel/kprobes.c
--- a/kernel/kprobes.c~make-kprobesc-kretprobe_table_lock-static
+++ a/kernel/kprobes.c
@@ -404,7 +404,7 @@ void kretprobe_hash_lock(struct task_str
 	spin_lock_irqsave(hlist_lock, *flags);
 }
 
-void kretprobe_table_lock(unsigned long hash, unsigned long *flags)
+static void kretprobe_table_lock(unsigned long hash, unsigned long *flags)
 {
 	spinlock_t *hlist_lock = kretprobe_table_lock_ptr(hash);
 	spin_lock_irqsave(hlist_lock, *flags);
_

Patches currently in -mm which might be from bunk@kernel.org are

ntfs-update-homepage.patch
linux-next.patch
m32r-remove-the-unused-nohighmem-option.patch
m32r-dont-offer-config_isa.patch
m32r-export-empty_zero_page.patch
m32r-export-__ndelay.patch
m32r-kernel-cleanups.patch
the-overdue-eepro100-removal.patch
parisc-lib-make-code-static.patch
drivers-parisc-make-code-static.patch
if-0-ses_match_host.patch
scsi-remove-the-unused-scsi_qlogic_fc_firmware-option.patch
drivers-scsi-a2091c-make-2-functions-static.patch
drivers-scsi-a3000c-make-2-functions-static.patch
fs_mbcache-dont-needlessly-make-it-built-in.patch
git-xtensa.patch
mpc8xxx_wdt-fix-modular-build.patch
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
mm-hugetlbc-make-resv_map_allocrelease-static.patch
make-mm-hugetlbc-unmap_ref_private-static.patch
make-kprobesc-kretprobe_table_lock-static.patch
acpi-use-bcd2bin-bin2bcd.patch
alpha-use-bcd2bin-bin2bcd.patch
arm-use-bcd2bin-bin2bcd.patch
cris-use-bcd2bin-bin2bcd.patch
drivers-rtc-use-bcd2bin-bin2bcd.patch
rtc-use-bcd2bin-bin2bcd.patch
mips-use-bcd2bin-bin2bcd.patch
mn10300-use-bcd2bin-bin2bcd.patch
i2c-use-bcd2bin-bin2bcd.patch
drivers-scsi-sr_vendorc-use-bcd2bin.patch
sparc64-use-bcd2bin-bin2bcd.patch
remove-the-obsolete-bcdbin-binbcd-macros.patch
include-linux-bcdh-remove-comments.patch
remove-unused-include-linux-versionhs.patch
reiser4.patch

