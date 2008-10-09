From: akpm@linux-foundation.org
Subject: - include-linux-kernelh-userspace-header-cleanup.patch removed from -mm tree
Date: Thu, 09 Oct 2008 15:10:38 -0700
Message-ID: <200810092210.m99MAcxk004903@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34756 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753348AbYJIWLS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2008 18:11:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     include/linux/kernel.h: userspace header cleanup
has been removed from the -mm tree.  Its filename was
     include-linux-kernelh-userspace-header-cleanup.patch

This patch was dropped because I'm tired of Ingo breaking it

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: include/linux/kernel.h: userspace header cleanup
From: Adrian Bunk <bunk@kernel.org>

Nothing from the bottom of this header is part of the kernel<->userspace
ABI.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff -puN include/linux/kernel.h~include-linux-kernelh-userspace-header-cleanup include/linux/kernel.h
--- a/include/linux/kernel.h~include-linux-kernelh-userspace-header-cleanup
+++ a/include/linux/kernel.h
@@ -499,7 +499,19 @@ static inline char *pack_hex_byte(char *
 struct sysinfo;
 extern int do_sysinfo(struct sysinfo *info);
 
-#endif /* __KERNEL__ */
+/* This helps us to avoid #ifdef CONFIG_NUMA */
+#ifdef CONFIG_NUMA
+#define NUMA_BUILD 1
+#else
+#define NUMA_BUILD 0
+#endif
+
+/* Rebuild everything on CONFIG_FTRACE_MCOUNT_RECORD */
+#ifdef CONFIG_FTRACE_MCOUNT_RECORD
+# define REBUILD_DUE_TO_FTRACE_MCOUNT_RECORD
+#endif
+
+#endif		/* __KERNEL__ */
 
 #define SI_LOAD_SHIFT	16
 struct sysinfo {
@@ -519,16 +531,4 @@ struct sysinfo {
 	char _f[20-2*sizeof(long)-sizeof(int)];	/* Padding: libc5 uses this.. */
 };
 
-/* This helps us to avoid #ifdef CONFIG_NUMA */
-#ifdef CONFIG_NUMA
-#define NUMA_BUILD 1
-#else
-#define NUMA_BUILD 0
-#endif
-
-/* Rebuild everything on CONFIG_FTRACE_MCOUNT_RECORD */
-#ifdef CONFIG_FTRACE_MCOUNT_RECORD
-# define REBUILD_DUE_TO_FTRACE_MCOUNT_RECORD
-#endif
-
 #endif
_

Patches currently in -mm which might be from bunk@kernel.org are

git-tip.patch
git-powerpc.patch
git-sparc.patch
git-xtensa.patch
git-v4l-dvb.patch
git-nfs.patch
git-scsi.patch
git-net.patch
git-crypto.patch
git-drm.patch
git-security-testing.patch
the-overdue-eepro100-removal.patch
parisc-lib-make-code-static.patch
drivers-parisc-make-code-static.patch
if-0-ses_match_host.patch
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

