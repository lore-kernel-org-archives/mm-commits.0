From: akpm@linux-foundation.org
Subject: + x86-discover_ebda-section-mismatch.patch added to -mm tree
Date: Thu, 10 Jan 2008 16:04:44 -0800
Message-ID: <200801110004.m0B04jiH016475@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48875 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754829AbYAKAFX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jan 2008 19:05:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: discover_ebda section mismatch
has been added to the -mm tree.  Its filename is
     x86-discover_ebda-section-mismatch.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-dvb.patch
git-kbuild.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
pcmcia-include-bad-cis-filename-in-error-message.patch
git-scsi-misc.patch
git-unionfs.patch
git-ipwireless_cs.patch
git-x86.patch
scsi-qla2xxx-qla_osc-section-fix.patch
register_cpu-__devinit-or-__cpuinit.patch
cciss-use-upper_32_bits-macro-to-eliminate-warnings.patch
dio-fix-kernel-doc-notation.patch
fs-menu-small-reorg.patch
profile-likely-unlikely-macros.patch
megaraid-fix-section-mismatch.patch
cciss-section-mismatch.patch
x86-discover_ebda-section-mismatch.patch
tpm-infineon-section-mismatch.patch
dvb-av7110-fix-section-mismatch.patch
hostap-section-mismatch-warning.patch
