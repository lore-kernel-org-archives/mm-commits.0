From: akpm@linux-foundation.org
Subject: [merged]
 rapidio-return-an-error-code-only-as-a-constant-in-two-functions.patch
 removed from -mm tree
Date: Wed, 07 Feb 2018 11:58:33 -0800
Message-ID: <20180207195833.2yXzpN_n8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60010 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754494AbeBGT6e (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 14:58:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, elfring@users.sourceforge.net, mm-commits@vger.kernel.org, mporter@kernel.crashing.org


The patch titled
     Subject: rapidio: return an error code only as a constant in two functions
has been removed from the -mm tree.  Its filename was
     rapidio-return-an-error-code-only-as-a-constant-in-two-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Markus Elfring <elfring@users.sourceforge.net>
Subject: rapidio: return an error code only as a constant in two functions

* Return an error code without storing it in an intermediate variable.

* Delete the label "out" and local variable "rc" which became unnecessary
  with this refactoring.

Link: http://lkml.kernel.org/r/8db441e1-c227-64e7-4747-095da63d7a2e@users.sourceforge.net
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Acked-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio.c |   21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff -puN drivers/rapidio/rio.c~rapidio-return-an-error-code-only-as-a-constant-in-two-functions drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-return-an-error-code-only-as-a-constant-in-two-functions
+++ a/drivers/rapidio/rio.c
@@ -402,13 +402,10 @@ rio_setup_inb_dbell(struct rio_mport *mp
 		    void (*dinb) (struct rio_mport * mport, void *dev_id, u16 src, u16 dst,
 				  u16 info))
 {
-	int rc = 0;
 	struct rio_dbell *dbell = kmalloc(sizeof(*dbell), GFP_KERNEL);
 
-	if (!dbell) {
-		rc = -ENOMEM;
-		goto out;
-	}
+	if (!dbell)
+		return -ENOMEM;
 
 	dbell->res = res;
 	dbell->dinb = dinb;
@@ -417,9 +414,7 @@ rio_setup_inb_dbell(struct rio_mport *mp
 	mutex_lock(&mport->lock);
 	list_add_tail(&dbell->node, &mport->dbells);
 	mutex_unlock(&mport->lock);
-
-      out:
-	return rc;
+	return 0;
 }
 
 /**
@@ -563,21 +558,17 @@ int rio_add_mport_pw_handler(struct rio_
 			     int (*pwcback)(struct rio_mport *mport,
 			     void *context, union rio_pw_msg *msg, int step))
 {
-	int rc = 0;
 	struct rio_pwrite *pwrite = kzalloc(sizeof(*pwrite), GFP_KERNEL);
 
-	if (!pwrite) {
-		rc = -ENOMEM;
-		goto out;
-	}
+	if (!pwrite)
+		return -ENOMEM;
 
 	pwrite->pwcback = pwcback;
 	pwrite->context = context;
 	mutex_lock(&mport->lock);
 	list_add_tail(&pwrite->node, &mport->pwrites);
 	mutex_unlock(&mport->lock);
-out:
-	return rc;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(rio_add_mport_pw_handler);
 
_

Patches currently in -mm which might be from elfring@users.sourceforge.net are


