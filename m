From: akpm@linux-foundation.org
Subject: + utrace-i386-build-fix.patch added to -mm tree
Date: Wed, 07 Feb 2007 18:11:51 -0800
Message-ID: <200702080212.l182Cu1r002609@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50552 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161358AbXBHCNJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 21:13:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, roland@redhat.com


The patch titled
     utrace-i386-build-fix
has been added to the -mm tree.  Its filename is
     utrace-i386-build-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: utrace-i386-build-fix
From: Andrew Morton <akpm@linux-foundation.org>

Make it seem to work...

Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/math-emu/fpu_entry.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/i386/math-emu/fpu_entry.c~utrace-i386-build-fix arch/i386/math-emu/fpu_entry.c
--- a/arch/i386/math-emu/fpu_entry.c~utrace-i386-build-fix
+++ a/arch/i386/math-emu/fpu_entry.c
@@ -212,8 +212,8 @@ asmlinkage void math_emulate(long arg)
     }
 
   FPU_lookahead = 1;
-  if (current->ptrace & PT_PTRACED)
-    FPU_lookahead = 0;
+//  if (current->ptrace & PT_PTRACED)
+//  FPU_lookahead = 0;
 
   if ( !valid_prefix(&byte1, (u_char __user **)&FPU_EIP,
 		     &addr_modes.override) )
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
md-fix-various-bugs-with-aligned-reads-in-raid5-fix.patch
acpi-bay-driver-warning-fix.patch
fix-warning-in-device_add_attrs.patch
git-dvb.patch
kthread-api-conversion-for-dvb_frontend-and-av7110-fix.patch
git-libata-all.patch
sis-warning-fixes.patch
git-libata-all-lib-iomapc-fix-for-config_pci=n.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
git-sh.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block.patch
x86_64-survive-having-no-irq-mapping-for-a-vector-fix.patch
git-cryptodev-fixup.patch
mm-vm_insert_pfn-tidy.patch
swiotlb-uninlinings.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses-tidy.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path-tidy.patch
fix-utrace-utrace-ptrace-compat.patch
utrace-i386-build-fix.patch
