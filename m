From: akpm@osdl.org
Subject: - kvm-mmu-add-missing-dirty-bit.patch removed from -mm tree
Date: Sun, 07 Jan 2007 00:00:21 -0800
Message-ID: <200701070800.l0780LFb013181@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41019 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932486AbXAGIAX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 7 Jan 2007 03:00:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: MMU: Add missing dirty bit
has been removed from the -mm tree.  Its filename was
     kvm-mmu-add-missing-dirty-bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: MMU: Add missing dirty bit
From: Avi Kivity <avi@qumranet.com>

If we emulate a write, we fail to set the dirty bit on the guest pte, leading
the guest to believe the page is clean, and thus lose data.  Bad.

Fix by setting the guest pte dirty bit under such conditions.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/paging_tmpl.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/kvm/paging_tmpl.h~kvm-mmu-add-missing-dirty-bit drivers/kvm/paging_tmpl.h
--- a/drivers/kvm/paging_tmpl.h~kvm-mmu-add-missing-dirty-bit
+++ a/drivers/kvm/paging_tmpl.h
@@ -317,6 +317,7 @@ static int FNAME(fix_write_pf)(struct kv
 	} else if (kvm_mmu_lookup_page(vcpu, gfn)) {
 		pgprintk("%s: found shadow page for %lx, marking ro\n",
 			 __FUNCTION__, gfn);
+		*guest_ent |= PT_DIRTY_MASK;
 		*write_pt = 1;
 		return 0;
 	}
_

Patches currently in -mm which might be from avi@qumranet.com are
