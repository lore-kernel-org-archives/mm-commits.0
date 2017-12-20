From: akpm@linux-foundation.org
Subject: +
 rapidio-return-an-error-code-only-as-a-constant-in-two-functions.patch
 added to -mm tree
Date: Tue, 19 Dec 2017 16:05:59 -0800
Message-ID: <5a39a967.W8TVWxzfWuAFqsFd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40362 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753724AbdLTAGA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Dec 2017 19:06:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elfring@users.sourceforge.net, alexandre.bounine@idt.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: return an error code only as a constant in two functions
has been added to the -mm tree.  Its filename is
     rapidio-return-an-error-code-only-as-a-constant-in-two-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-return-an-error-code-only-as-a-constant-in-two-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-return-an-error-code-only-as-a-constant-in-two-functions.patch

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
Subject: rapidio: return an error code only as a constant in two functions

* Return an error code without storing it in an intermediate variable.

* Delete the label "out" and local variable "rc" which became unnecessary
  with this refactoring.

Link: http://lkml.kernel.org/r/8db441e1-c227-64e7-4747-095da63d7a2e@users.sourceforge.net
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Cc: Alexandre Bounine <alexandre.bounine@idt.com>
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

rapidio-delete-an-error-message-for-a-failed-memory-allocation-in-rio_init_mports.patch
rapidio-adjust-12-checks-for-null-pointers.patch
rapidio-adjust-five-function-calls-together-with-a-variable-assignment.patch
rapidio-improve-a-size-determination-in-five-functions.patch
rapidio-delete-an-unnecessary-variable-initialisation-in-three-functions.patch
rapidio-return-an-error-code-only-as-a-constant-in-two-functions.patch
rapidio-move-12-export_symbol_gpl-calls-to-function-implementations.patch

