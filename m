From: akpm@linux-foundation.org
Subject: - utrace-i386-build-fix.patch removed from -mm tree
Date: Thu, 08 Feb 2007 16:22:51 -0800
Message-ID: <200702090024.l190O0xe031914@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46832 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423042AbXBIAYK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Feb 2007 19:24:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     utrace-i386-build-fix
has been removed from the -mm tree.  Its filename was
     utrace-i386-build-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
acpi-bay-driver-warning-fix.patch
fix-warning-in-device_add_attrs.patch
git-dvb.patch
kthread-api-conversion-for-dvb_frontend-and-av7110-fix.patch
git-libata-all.patch
sis-warning-fixes.patch
git-libata-all-lib-iomapc-fix-for-config_pci=n.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
git-net.patch
git-sh.patch
git-scsi-misc.patch
git-scsi-misc-fixup.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block.patch
x86_64-survive-having-no-irq-mapping-for-a-vector-fix.patch
git-cryptodev-fixup.patch
mm-vm_insert_pfn-tidy.patch
swiotlb-uninlinings.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses-tidy.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path-tidy.patch
revert-x86_64-mm-putreg-check.patch
fix-utrace-utrace-ptrace-compat.patch
utrace-i386-build-fix.patch
deprecate-sa_interrupt-and-friends.patch
