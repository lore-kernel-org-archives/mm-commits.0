From: akpm@linux-foundation.org
Subject: - kvm-vmx-reload-ds-and-es-even-in-64-bit-mode.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:48:53 -0800
Message-ID: <200702122248.l1CMmrXv014063@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45574 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030366AbXBLWs4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:48:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     kvm: VMX: Reload ds and es even in 64-bit mode
has been removed from the -mm tree.  Its filename was
     kvm-vmx-reload-ds-and-es-even-in-64-bit-mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kvm: VMX: Reload ds and es even in 64-bit mode
From: Avi Kivity <avi@qumranet.com>

Or 32-bit userspace will get confused.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/kvm/vmx.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/kvm/vmx.c~kvm-vmx-reload-ds-and-es-even-in-64-bit-mode drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-vmx-reload-ds-and-es-even-in-64-bit-mode
+++ a/drivers/kvm/vmx.c
@@ -1865,9 +1865,7 @@ again:
 	fx_restore(vcpu->host_fx_image);
 	vcpu->interrupt_window_open = (vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) & 3) == 0;
 
-#ifndef CONFIG_X86_64
 	asm ("mov %0, %%ds; mov %0, %%es" : : "r"(__USER_DS));
-#endif
 
 	/*
 	 * Profile KVM exit RIPs:
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
