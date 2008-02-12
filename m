From: akpm@linux-foundation.org
Subject: + x86-visws-fix-printk-format-warnings.patch added to -mm tree
Date: Mon, 11 Feb 2008 23:53:50 -0800
Message-ID: <200802120754.m1C7swcd024706@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51923 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756984AbYBLHz4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Feb 2008 02:55:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86/visws: fix printk format warnings
has been added to the -mm tree.  Its filename is
     x86-visws-fix-printk-format-warnings.patch

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
Subject: x86/visws: fix printk format warnings
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix visws printk format warnings:

/local/linsrc/linux-2.6.24-git15/arch/x86/mach-visws/traps.c:50: warning: format '%#lx' expects type 'long unsigned int', but argument 2 has type 'u32'
/local/linsrc/linux-2.6.24-git15/arch/x86/mach-visws/traps.c:50: warning: format '%#lx' expects type 'long unsigned int', but argument 3 has type 'u32'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mach-visws/traps.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN arch/x86/mach-visws/traps.c~x86-visws-fix-printk-format-warnings arch/x86/mach-visws/traps.c
--- a/arch/x86/mach-visws/traps.c~x86-visws-fix-printk-format-warnings
+++ a/arch/x86/mach-visws/traps.c
@@ -46,8 +46,9 @@ static __init void cobalt_init(void)
 	 */
 	set_fixmap(FIX_APIC_BASE, APIC_DEFAULT_PHYS_BASE);
 	setup_local_APIC();
-	printk(KERN_INFO "Local APIC Version %#lx, ID %#lx\n",
-		apic_read(APIC_LVR), apic_read(APIC_ID));
+	printk(KERN_INFO "Local APIC Version %#x, ID %#x\n",
+		(unsigned int)apic_read(APIC_LVR),
+		(unsigned int)apic_read(APIC_ID));
 
 	set_fixmap(FIX_CO_CPU, CO_CPU_PHYS);
 	set_fixmap(FIX_CO_APIC, CO_APIC_PHYS);
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
kernel-doc-fix-fs-pipec-notation.patch
docbook-move-pipe-and-splice-to-filesystems-docbook.patch
docbook-sunrpc-filenames-and-notation-fixes.patch
docbook-make-a-networking-book-and-fix-a-few-errors.patch
apanel-fix-kconfig-dependencies.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-unionfs.patch
x86-visws-fix-printk-format-warnings.patch
profile-likely-unlikely-macros.patch
