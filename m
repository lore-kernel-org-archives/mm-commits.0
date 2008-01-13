From: akpm@linux-foundation.org
Subject: - x86-discover_ebda-section-mismatch.patch removed from -mm tree
Date: Sun, 13 Jan 2008 03:34:10 -0800
Message-ID: <200801131133.m0DBXoHK009876@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44506 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751420AbYAMLjZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Jan 2008 06:39:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mingo@elte.hu, sam@ravnborg.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: discover_ebda section mismatch
has been removed from the -mm tree.  Its filename was
     x86-discover_ebda-section-mismatch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: discover_ebda section mismatch
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix section mismatches.  discover_ebda() can be __init.

WARNING: vmlinux.o(.text+0x738a): Section mismatch: reference to .init.data:ebda_addr (between 'discover_ebda' and 'get_model_name')
WARNING: vmlinux.o(.text+0x73c4): Section mismatch: reference to .init.data:ebda_size (between 'discover_ebda' and 'get_model_name')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/setup_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/kernel/setup_64.c~x86-discover_ebda-section-mismatch arch/x86/kernel/setup_64.c
--- a/arch/x86/kernel/setup_64.c~x86-discover_ebda-section-mismatch
+++ a/arch/x86/kernel/setup_64.c
@@ -257,7 +257,7 @@ static inline void __init reserve_crashk
 unsigned __initdata ebda_addr;
 unsigned __initdata ebda_size;
 
-static void discover_ebda(void)
+static void __init discover_ebda(void)
 {
 	/*
 	 * there is a real-mode segmented pointer pointing to the
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
scsi-qla2xxx-qla_osc-section-fix.patch
cciss-section-mismatch.patch
advansys-fix-section-mismatch-warning.patch
uvesafb-fix-section-mismatch-warnings.patch
driver-core-build-with-sysfs=n.patch
sysfs-make-sysfs_deprecated-depend-on-sysfs.patch
git-dvb.patch
git-kbuild.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
pcmcia-include-bad-cis-filename-in-error-message.patch
git-scsi-misc.patch
megaraid-fix-section-mismatch.patch
git-unionfs.patch
hostap-section-mismatch-warning.patch
git-ipwireless_cs.patch
git-x86.patch
register_cpu-__devinit-or-__cpuinit.patch
cciss-use-upper_32_bits-macro-to-eliminate-warnings.patch
dio-fix-kernel-doc-notation.patch
tpm-infineon-section-mismatch.patch
tdfxfb-fix-section-mismatch-warnings.patch
uvesafb-small-cleanups.patch
documentation-move-dnotifytxt-to-filesystems.patch
documentation-move-sharedsubtreestxt-to-filesystems.patch
documentation-create-new-scheduler-subdirectory.patch
reporting-bugs-cc-the-mailing-list-too.patch
fs-menu-small-reorg.patch
profile-likely-unlikely-macros.patch
