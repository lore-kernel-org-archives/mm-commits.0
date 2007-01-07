From: akpm@osdl.org
Subject: - kvm-mmu-if-an-empty-shadow-page-is-not-empty-report-more-info.patch removed from -mm tree
Date: Sat, 06 Jan 2007 23:59:46 -0800
Message-ID: <200701070759.l077xkvd013089@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40922 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932434AbXAGH7w (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 7 Jan 2007 02:59:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     KVM: MMU: If an empty shadow page is not empty, report more info
has been removed from the -mm tree.  Its filename was
     kvm-mmu-if-an-empty-shadow-page-is-not-empty-report-more-info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: MMU: If an empty shadow page is not empty, report more info
From: Avi Kivity <avi@qumranet.com>

Signed-off-by: Avi Kivity <avi@qumranet.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/mmu.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN drivers/kvm/mmu.c~kvm-mmu-if-an-empty-shadow-page-is-not-empty-report-more-info drivers/kvm/mmu.c
--- a/drivers/kvm/mmu.c~kvm-mmu-if-an-empty-shadow-page-is-not-empty-report-more-info
+++ a/drivers/kvm/mmu.c
@@ -305,12 +305,16 @@ static void rmap_write_protect(struct kv
 
 static int is_empty_shadow_page(hpa_t page_hpa)
 {
-	u32 *pos;
-	u32 *end;
-	for (pos = __va(page_hpa), end = pos + PAGE_SIZE / sizeof(u32);
+	u64 *pos;
+	u64 *end;
+
+	for (pos = __va(page_hpa), end = pos + PAGE_SIZE / sizeof(u64);
 		      pos != end; pos++)
-		if (*pos != 0)
+		if (*pos != 0) {
+			printk(KERN_ERR "%s: %p %llx\n", __FUNCTION__,
+			       pos, *pos);
 			return 0;
+		}
 	return 1;
 }
 
_

Patches currently in -mm which might be from avi@qumranet.com are
