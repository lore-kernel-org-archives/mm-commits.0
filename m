From: akpm@linux-foundation.org
Subject: + rapidio-improve-a-size-determination-in-five-functions.patch
 added to -mm tree
Date: Tue, 19 Dec 2017 16:05:54 -0800
Message-ID: <5a39a962.tcIlcxHfVAS7neqd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40334 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753706AbdLTAFz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Dec 2017 19:05:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elfring@users.sourceforge.net, alexandre.bounine@idt.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: improve a size determination in five functions
has been added to the -mm tree.  Its filename is
     rapidio-improve-a-size-determination-in-five-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-improve-a-size-determination-in-five-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-improve-a-size-determination-in-five-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Markus Elfring <elfring@users.sourceforge.net>
Subject: rapidio: improve a size determination in five functions

Replace the specification of data structures by pointer dereferences as
the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer according to the Linux coding style convention.

This issue was detected by using the Coccinelle software.

Link: http://lkml.kernel.org/r/495f571c-fb4d-b1d5-a6e5-494f2c537a8d@users.sourceforge.net
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Cc: Alexandre Bounine <alexandre.bounine@idt.com>
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
-
-	struct resource *res = kzalloc(sizeof(struct resource), GFP_KERNEL);
+	struct resource *res = kzalloc(sizeof(*res), GFP_KERNEL);
 
 	if (res) {
 		rio_init_dbell_res(res, start, end);
@@ -568,9 +564,8 @@ int rio_add_mport_pw_handler(struct rio_
 			     void *context, union rio_pw_msg *msg, int step))
 {
 	int rc = 0;
-	struct rio_pwrite *pwrite;
+	struct rio_pwrite *pwrite = kzalloc(sizeof(*pwrite), GFP_KERNEL);
 
-	pwrite = kzalloc(sizeof(struct rio_pwrite), GFP_KERNEL);
 	if (!pwrite) {
 		rc = -ENOMEM;
 		goto out;
_

Patches currently in -mm which might be from elfring@users.sourceforge.net are

rapidio-delete-an-error-message-for-a-failed-memory-allocation-in-rio_init_mports.patch
rapidio-adjust-12-checks-for-null-pointers.patch
rapidio-adjust-five-function-calls-together-with-a-variable-assignment.patch
rapidio-improve-a-size-determination-in-five-functions.patch
rapidio-delete-an-unnecessary-variable-initialisation-in-three-functions.patch
rapidio-return-an-error-code-only-as-a-constant-in-two-functions.patch
rapidio-move-12-export_symbol_gpl-calls-to-function-implementations.patch

