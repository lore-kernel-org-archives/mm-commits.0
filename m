From: akpm@osdl.org
Subject: - kvm-mmu-ensure-freed-shadow-pages-are-clean.patch removed from -mm tree
Date: Sat, 06 Jan 2007 23:59:44 -0800
Message-ID: <200701070759.l077xikG013086@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40914 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932466AbXAGH7s (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 7 Jan 2007 02:59:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     KVM: MMU: Ensure freed shadow pages are clean
has been removed from the -mm tree.  Its filename was
     kvm-mmu-ensure-freed-shadow-pages-are-clean.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: MMU: Ensure freed shadow pages are clean
From: Avi Kivity <avi@qumranet.com>

Signed-off-by: Avi Kivity <avi@qumranet.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/mmu.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/kvm/mmu.c~kvm-mmu-ensure-freed-shadow-pages-are-clean drivers/kvm/mmu.c
--- a/drivers/kvm/mmu.c~kvm-mmu-ensure-freed-shadow-pages-are-clean
+++ a/drivers/kvm/mmu.c
@@ -318,6 +318,7 @@ static void kvm_mmu_free_page(struct kvm
 {
 	struct kvm_mmu_page *page_head = page_header(page_hpa);
 
+	ASSERT(is_empty_shadow_page(page_hpa));
 	list_del(&page_head->link);
 	page_head->page_hpa = page_hpa;
 	list_add(&page_head->link, &vcpu->free_pages);
_

Patches currently in -mm which might be from avi@qumranet.com are
