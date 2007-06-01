From: akpm@linux-foundation.org
Subject: - kvm-fix-section-mismatch-warning-in-kvm-intelo.patch removed from -mm tree
Date: Fri, 01 Jun 2007 10:48:32 -0700
Message-ID: <200706011748.l51HmVkc015214@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:34068 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761617AbXFARsf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2007 13:48:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sam@ravnborg.org, avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     kvm: fix section mismatch warning in kvm-intel.o
has been removed from the -mm tree.  Its filename was
     kvm-fix-section-mismatch-warning-in-kvm-intelo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kvm: fix section mismatch warning in kvm-intel.o
From: Sam Ravnborg <sam@ravnborg.org>

Fix following section mismatch warning in kvm-intel.o:
WARNING: o-i386/drivers/kvm/kvm-intel.o(.init.text+0xbd): Section mismatch: reference to .exit.text: (between 'hardware_setup' and 'vmx_disabled_by_bios')

The function free_kvm_area is used in the function alloc_kvm_area which
is marked __init.
The __exit area is discarded by some archs during link-time if a
module is built-in resulting in an oops.

Note: This warning is only seen by my local copy of modpost
      but the change will soon hit upstream.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/kvm/vmx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/kvm/vmx.c~kvm-fix-section-mismatch-warning-in-kvm-intelo drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-fix-section-mismatch-warning-in-kvm-intelo
+++ a/drivers/kvm/vmx.c
@@ -639,7 +639,7 @@ static void free_vmcs(struct vmcs *vmcs)
 	free_pages((unsigned long)vmcs, vmcs_descriptor.order);
 }
 
-static __exit void free_kvm_area(void)
+static void free_kvm_area(void)
 {
 	int cpu;
 
_

Patches currently in -mm which might be from sam@ravnborg.org are

origin.patch
git-kbuild.patch
use-posix-bre-in-headers-install-target.patch
fix-x86_64-mm-xen-core-xen-implementation.patch
x86-fix-section-mismatch-warnings-in-mtrr.patch
git-newsetup.patch
