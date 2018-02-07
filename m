From: akpm@linux-foundation.org
Subject: [merged]
 rapidio-improve-a-size-determination-in-five-functions.patch removed from
 -mm tree
Date: Wed, 07 Feb 2018 11:58:27 -0800
Message-ID: <20180207195827.CTU1ebbD6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59994 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754048AbeBGT63 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 14:58:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, elfring@users.sourceforge.net, mm-commits@vger.kernel.org, mporter@kernel.crashing.org


The patch titled
     Subject: rapidio: improve a size determination in five functions
has been removed from the -mm tree.  Its filename was
     rapidio-improve-a-size-determination-in-five-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Markus Elfring <elfring@users.sourceforge.net>
Subject: rapidio: improve a size determination in five functions

Replace the specification of data structures by pointer dereferences as
the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer according to the Linux coding style convention.

This issue was detected by using the Coccinelle software.

Link: http://lkml.kernel.org/r/495f571c-fb4d-b1d5-a6e5-494f2c537a8d@users.sourceforge.net
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Acked-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff -puN drivers/rapidio/rio.c~rapidio-improve-a-size-determination-in-five-functions drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-improve-a-size-determination-in-five-functions
+++ a/drivers/rapidio/rio.c
@@ -110,9 +110,8 @@ EXPORT_SYMBOL(rio_query_mport);
  */
 struct rio_net *rio_alloc_net(struct rio_mport *mport)
 {
-	struct rio_net *net;
+	struct rio_net *net = kzalloc(sizeof(*net), GFP_KERNEL);
 
-	net = kzalloc(sizeof(struct rio_net), GFP_KERNEL);
 	if (net) {
 		INIT_LIST_HEAD(&net->node);
 		INIT_LIST_HEAD(&net->devices);
@@ -246,8 +245,7 @@ int rio_request_inb_mbox(struct rio_mpor
 	if (!mport->ops->open_inb_mbox)
 		goto out;
 
-	res = kzalloc(sizeof(struct resource), GFP_KERNEL);
-
+	res = kzalloc(sizeof(*res), GFP_KERNEL);
 	if (res) {
 		rio_init_mbox_res(res, mbox, mbox);
 
@@ -329,8 +327,7 @@ int rio_request_outb_mbox(struct rio_mpo
 	if (!mport->ops->open_outb_mbox)
 		goto out;
 
-	res = kzalloc(sizeof(struct resource), GFP_KERNEL);
-
+	res = kzalloc(sizeof(*res), GFP_KERNEL);
 	if (res) {
 		rio_init_mbox_res(res, mbox, mbox);
 
@@ -445,8 +442,7 @@ int rio_request_inb_dbell(struct rio_mpo
 					u16 dst, u16 info))
 {
 	int rc = 0;
