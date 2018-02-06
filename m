From: akpm@linux-foundation.org
Subject: [patch 067/114] rapidio: delete an unnecessary variable
 initialisation in three functions
Date: Tue, 06 Feb 2018 15:39:55 -0800
Message-ID: <20180206233955.zB3MtjtZ-%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55276 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932090AbeBFXj4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:39:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alexandre.bounine@idt.com, elfring@users.sourceforge.net, mm-commits@vger.kernel.org, mporter@kernel.crashing.org, torvalds@linux-foundation.org

From: Markus Elfring <elfring@users.sourceforge.net>
Subject: rapidio: delete an unnecessary variable initialisation in three functions

The local variable "rc" will be set to an appropriate value a bit later. 
Thus omit the explicit initialisation at the beginning.

Link: http://lkml.kernel.org/r/ed729e8c-815c-8b56-a48f-1be579d0cc2b@users.sourceforge.net
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Acked-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/rapidio/rio.c~rapidio-delete-an-unnecessary-variable-initialisation-in-three-functions drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-delete-an-unnecessary-variable-initialisation-in-three-functions
+++ a/drivers/rapidio/rio.c
@@ -441,7 +441,7 @@ int rio_request_inb_dbell(struct rio_mpo
 			  void (*dinb) (struct rio_mport * mport, void *dev_id, u16 src,
 					u16 dst, u16 info))
 {
-	int rc = 0;
+	int rc;
 	struct resource *res = kzalloc(sizeof(*res), GFP_KERNEL);
 
 	if (res) {
@@ -693,7 +693,7 @@ EXPORT_SYMBOL_GPL(rio_pw_enable);
 int rio_map_inb_region(struct rio_mport *mport, dma_addr_t local,
 			u64 rbase, u32 size, u32 rflags)
 {
-	int rc = 0;
+	int rc;
 	unsigned long flags;
 
 	if (!mport->ops->map_inb)
@@ -737,7 +737,7 @@ EXPORT_SYMBOL_GPL(rio_unmap_inb_region);
 int rio_map_outb_region(struct rio_mport *mport, u16 destid, u64 rbase,
 			u32 size, u32 rflags, dma_addr_t *local)
 {
-	int rc = 0;
+	int rc;
 	unsigned long flags;
 
 	if (!mport->ops->map_outb)
_
