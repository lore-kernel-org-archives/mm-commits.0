From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?rapidio-delete-an-unnecessary-variable-initialisation-in-t?=
 =?US-ASCII?Q?hree-functions.patch?= removed from -mm tree
Date: Wed, 07 Feb 2018 11:58:30 -0800
Message-ID: <20180207195830.KrY2LTmFY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60002 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754494AbeBGT6b (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 14:58:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, elfring@users.sourceforge.net, mm-commits@vger.kernel.org, mporter@kernel.crashing.org


The patch titled
     Subject: rapidio: delete an unnecessary variable initialisation in three functions
has been removed from the -mm tree.  Its filename was
     rapidio-delete-an-unnecessary-variable-initialisation-in-three-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from elfring@users.sourceforge.net are


