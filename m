From: akpm@osdl.org
Subject: - kvm-fix-oops-on-oom.patch removed from -mm tree
Date: Mon, 01 Jan 2007 23:25:22 -0800
Message-ID: <200701020725.l027PMvC013037@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37450 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932908AbXABHZZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 02:25:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: Fix oops on oom
has been removed from the -mm tree.  Its filename was
     kvm-fix-oops-on-oom.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: Fix oops on oom
From: Avi Kivity <avi@qumranet.com>

__free_page() doesn't like a NULL argument, so check before calling it.  A
NULL can only happen if memory is exhausted during allocation of a memory
slot.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm_main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/kvm/kvm_main.c~kvm-fix-oops-on-oom drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-fix-oops-on-oom
+++ a/drivers/kvm/kvm_main.c
@@ -245,7 +245,8 @@ static void kvm_free_physmem_slot(struct
 	if (!dont || free->phys_mem != dont->phys_mem)
 		if (free->phys_mem) {
 			for (i = 0; i < free->npages; ++i)
-				__free_page(free->phys_mem[i]);
+				if (free->phys_mem[i])
+					__free_page(free->phys_mem[i]);
 			vfree(free->phys_mem);
 		}
 
_

Patches currently in -mm which might be from avi@qumranet.com are
