From: akpm@osdl.org
Subject: - kvm-mmu-flush-guest-tlb-when-reducing-permissions-on-a-pte.patch removed from -mm tree
Date: Sun, 07 Jan 2007 00:00:02 -0800
Message-ID: <200701070800.l07802kX013151@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40980 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932479AbXAGIAL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 7 Jan 2007 03:00:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     KVM: MMU: Flush guest tlb when reducing permissions on a pte
has been removed from the -mm tree.  Its filename was
     kvm-mmu-flush-guest-tlb-when-reducing-permissions-on-a-pte.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: MMU: Flush guest tlb when reducing permissions on a pte
From: Avi Kivity <avi@qumranet.com>

If we reduce permissions on a pte, we must flush the cached copy of the pte
from the guest's tlb.

This is implemented at the moment by flushing the entire guest tlb, and can be
improved by flushing just the relevant virtual address, if it is known.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/mmu.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN drivers/kvm/mmu.c~kvm-mmu-flush-guest-tlb-when-reducing-permissions-on-a-pte drivers/kvm/mmu.c
--- a/drivers/kvm/mmu.c~kvm-mmu-flush-guest-tlb-when-reducing-permissions-on-a-pte
+++ a/drivers/kvm/mmu.c
@@ -383,6 +383,7 @@ static void rmap_write_protect(struct kv
 		BUG_ON(!(*spte & PT_WRITABLE_MASK));
 		rmap_printk("rmap_write_protect: spte %p %llx\n", spte, *spte);
 		rmap_remove(vcpu, spte);
+		kvm_arch_ops->tlb_flush(vcpu);
 		*spte &= ~(u64)PT_WRITABLE_MASK;
 	}
 }
@@ -594,6 +595,7 @@ static void kvm_mmu_page_unlink_children
 				rmap_remove(vcpu, &pt[i]);
 			pt[i] = 0;
 		}
+		kvm_arch_ops->tlb_flush(vcpu);
 		return;
 	}
 
@@ -927,7 +929,10 @@ static inline void set_pte_common(struct
 			pgprintk("%s: found shadow page for %lx, marking ro\n",
 				 __FUNCTION__, gfn);
 			access_bits &= ~PT_WRITABLE_MASK;
-			*shadow_pte &= ~PT_WRITABLE_MASK;
+			if (is_writeble_pte(*shadow_pte)) {
+				    *shadow_pte &= ~PT_WRITABLE_MASK;
+				    kvm_arch_ops->tlb_flush(vcpu);
+			}
 		}
 	}
 
_

Patches currently in -mm which might be from avi@qumranet.com are
