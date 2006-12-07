From: akpm@osdl.org
Subject: - arm26-replace-kmallocmemset-with-kzalloc.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:16:49 -0800
Message-ID: <200612072316.kB7NGnxV030880@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53881 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163886AbWLGXRo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:17:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: burman.yan@gmail.com, spyro@f2s.com, mm-commits@vger.kernel.org


The patch titled
     arm26: replace kmalloc+memset with kzalloc
has been removed from the -mm tree.  Its filename was
     arm26-replace-kmallocmemset-with-kzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: arm26: replace kmalloc+memset with kzalloc
From: Yan Burman <burman.yan@gmail.com>

Replace kmalloc+memset with kzalloc

Signed-off-by: Yan Burman <burman.yan@gmail.com>
CC: Ian Molton <spyro@f2s.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/arm26/kernel/ecard.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN arch/arm26/kernel/ecard.c~arm26-replace-kmallocmemset-with-kzalloc arch/arm26/kernel/ecard.c
--- a/arch/arm26/kernel/ecard.c~arm26-replace-kmallocmemset-with-kzalloc
+++ a/arch/arm26/kernel/ecard.c
@@ -620,12 +620,10 @@ ecard_probe(int slot, card_type_t type)
 	struct ex_ecid cid;
 	int i, rc = -ENOMEM;
 
-	ec = kmalloc(sizeof(ecard_t), GFP_KERNEL);
+	ec = kzalloc(sizeof(ecard_t), GFP_KERNEL);
 	if (!ec)
 		goto nomem;
 
-	memset(ec, 0, sizeof(ecard_t));
-
 	ec->slot_no	= slot;
 	ec->type        = type;
 	ec->irq		= NO_IRQ;
_

Patches currently in -mm which might be from burman.yan@gmail.com are

origin.patch
ia64-replace-kmallocmemset-with-kzalloc.patch
jffs2-replace-kmallocmemset-with-kzalloc.patch
nfsd-replace-kmallocmemset-with-kcalloc.patch

