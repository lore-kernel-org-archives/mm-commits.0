From: akpm@linux-foundation.org
Subject: - voyager-use-struct-instead-of-param.patch removed from -mm tree
Date: Mon, 12 Nov 2007 20:07:39 -0800
Message-ID: <200711130407.lAD47cbY025240@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56456 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755937AbXKMEIO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 23:08:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, James.Bottomley@steeleye.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     voyager: use struct instead of PARAM
has been removed from the -mm tree.  Its filename was
     voyager-use-struct-instead-of-param.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: voyager: use struct instead of PARAM
From: Randy Dunlap <randy.dunlap@oracle.com>

Use struct boot_params instead of PARAM + 0xoffsets.
Fixes one of many Voyager build problems.

arch/x86/kernel/setup_32.c:543: error: 'PARAM' undeclared (first use in this function)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86/mach-voyager/setup_arch.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN include/asm-x86/mach-voyager/setup_arch.h~voyager-use-struct-instead-of-param include/asm-x86/mach-voyager/setup_arch.h
--- a/include/asm-x86/mach-voyager/setup_arch.h~voyager-use-struct-instead-of-param
+++ a/include/asm-x86/mach-voyager/setup_arch.h
@@ -1,5 +1,7 @@
 #include <asm/voyager.h>
-#define VOYAGER_BIOS_INFO ((struct voyager_bios_info *)(PARAM+0x40))
+#include <asm/setup_32.h>
+#define VOYAGER_BIOS_INFO ((struct voyager_bios_info *) \
+			(&boot_params.apm_bios_info))
 
 /* Hook to call BIOS initialisation function */
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
chipsfb-uses-depends-on-pci.patch
git-dvb.patch
git-kbuild.patch
advansys-fix-section-mismatch-warning.patch
aic94-fix-section-mismatches.patch
sym2-fix-section-mismatch-warning.patch
git-unionfs.patch
git-ipwireless_cs.patch
x86-bitops_32h-style-cleanups.patch
sysctl-fix-token-ring-procname.patch
gbefb-fix-section-mismatch-warnings.patch
vmstat-fix-section-mismatch-warning.patch
register_cpu-__devinit-or-__cpuinit.patch
cciss-use-upper_32_bits-macro-to-eliminate-warnings.patch
move-kprobes-examples-to-samples-resend.patch
move-kprobes-examples-to-samples-resend-checkpatch-fixes.patch
fs-menu-small-reorg.patch
profile-likely-unlikely-macros.patch
