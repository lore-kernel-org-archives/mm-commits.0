From: akpm@linux-foundation.org
Subject: - x86-vsmp-build-fixes.patch removed from -mm tree
Date: Tue, 18 Mar 2008 00:37:16 -0700
Message-ID: <200803180737.m2I7bGZZ020478@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53853 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750763AbYCRHia (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Mar 2008 03:38:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gcosta@redhat.com, kiran@scalemp.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: vsmp build fixes
has been removed from the -mm tree.  Its filename was
     x86-vsmp-build-fixes.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: vsmp build fixes
From: Glauber Costa <gcosta@redhat.com>

VSMP depends on PCI, but the file is now compiled conditionally on PARAVIRT,
no VSMP, so enclose everything in an ifdef CONFIG_PCI.

We have to be careful enough to let is_vsmp_box and vsmp_init defined, since
they are used outside this file

Signed-off-by: Glauber Costa <gcosta@redhat.com>
Cc: Ravikiran Thirumalai <kiran@scalemp.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/vsmp_64.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN arch/x86/kernel/vsmp_64.c~x86-vsmp-build-fixes arch/x86/kernel/vsmp_64.c
--- a/arch/x86/kernel/vsmp_64.c~x86-vsmp-build-fixes
+++ a/arch/x86/kernel/vsmp_64.c
@@ -19,6 +19,7 @@
 #include <asm/io.h>
 #include <asm/paravirt.h>
 
+#ifdef CONFIG_PCI
 /*
  * Interrupt control on vSMPowered systems:
  * ~AC is a shadow of IF.  If IF is 'on' AC should be 'off'
@@ -87,12 +88,18 @@ int is_vsmp_box(void)
 	if (read_pci_config(0, 0x1f, 0, PCI_VENDOR_ID) ==
 	     (PCI_VENDOR_ID_SCALEMP || (PCI_DEVICE_ID_SCALEMP_VSMP_CTL << 16)))
 		vsmp = 1;
-
 	return vsmp;
 }
+#else
+int is_vsmp_box(void)
+{
+	return 0;
+}
+#endif
 
 void __init vsmp_init(void)
 {
+#ifdef CONFIG_PCI
 	void *address;
 	unsigned int cap, ctl, cfg;
 
@@ -125,5 +132,6 @@ void __init vsmp_init(void)
 	}
 
 	early_iounmap(address, 8);
+#endif
 	return;
 }
_

Patches currently in -mm which might be from gcosta@redhat.com are

git-x86.patch
fix-typo-in-tick-broadcastc.patch
git-kvm.patch
x86-vsmp-build-fixes.patch

