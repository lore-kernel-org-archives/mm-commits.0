From: akpm@osdl.org
Subject: - kvm-virtualization-infrastructure-fix-asm-constraints-for-segment-loads.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:52:16 -0800
Message-ID: <200612100752.kBA7qGQr017637@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59504 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760378AbWLJHwT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:52:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bero@arklinux.org, avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: Fix asm constraints for segment loads
has been removed from the -mm tree.  Its filename was
     kvm-virtualization-infrastructure-fix-asm-constraints-for-segment-loads.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: Fix asm constraints for segment loads
From: Bernhard Rosenkraenzer <bero@arklinux.org>

"g" is an invalid constraint for a segment register load, since it includes
immediate operands, which are illegal for segment moves.

Fix by specifying register or memory operands.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm_main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/kvm/kvm_main.c~kvm-virtualization-infrastructure-fix-asm-constraints-for-segment-loads drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-virtualization-infrastructure-fix-asm-constraints-for-segment-loads
+++ a/drivers/kvm/kvm_main.c
@@ -152,12 +152,12 @@ static u16 read_ldt(void)
 
 static void load_fs(u16 sel)
 {
-	asm ("mov %0, %%fs" : : "g"(sel));
+	asm ("mov %0, %%fs" : : "rm"(sel));
 }
 
 static void load_gs(u16 sel)
 {
-	asm ("mov %0, %%gs" : : "g"(sel));
+	asm ("mov %0, %%gs" : : "rm"(sel));
 }
 
 #ifndef load_ldt
_

Patches currently in -mm which might be from bero@arklinux.org are

kvm-userspace-interface.patch
kvm-virtualization-infrastructure-fix-asm-constraints-for-segment-loads.patch

