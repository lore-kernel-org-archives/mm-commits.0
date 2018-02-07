From: akpm@linux-foundation.org
Subject: [merged]
 rapidio-move-12-export_symbol_gpl-calls-to-function-implementations.patch
 removed from -mm tree
Date: Wed, 07 Feb 2018 11:58:36 -0800
Message-ID: <20180207195836.yvwQCct3H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60018 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754494AbeBGT6h (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 14:58:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, elfring@users.sourceforge.net, mm-commits@vger.kernel.org, mporter@kernel.crashing.org


The patch titled
     Subject: rapidio: move 12 EXPORT_SYMBOL_GPL() calls to function implementations
has been removed from the -mm tree.  Its filename was
     rapidio-move-12-export_symbol_gpl-calls-to-function-implementations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Markus Elfring <elfring@users.sourceforge.net>
Subject: rapidio: move 12 EXPORT_SYMBOL_GPL() calls to function implementations

checkpatch pointed information out like the following.

WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable

Thus fix the affected source code places.

Link: http://lkml.kernel.org/r/5f51f606-ece8-7bff-bb86-81d182c49b98@users.sourceforge.net
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Acked-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff -puN drivers/rapidio/rio.c~rapidio-move-12-export_symbol_gpl-calls-to-function-implementations drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-move-12-export_symbol_gpl-calls-to-function-implementations
+++ a/drivers/rapidio/rio.c
@@ -81,6 +81,7 @@ u16 rio_local_get_device_id(struct rio_m
 
 	return (RIO_GET_DID(port->sys_size, result));
 }
+EXPORT_SYMBOL_GPL(rio_local_get_device_id);
 
 /**
  * rio_query_mport - Query mport device attributes
@@ -275,6 +276,7 @@ int rio_request_inb_mbox(struct rio_mpor
       out:
 	return rc;
 }
+EXPORT_SYMBOL_GPL(rio_request_inb_mbox);
 
 /**
  * rio_release_inb_mbox - release inbound mailbox message service
@@ -303,6 +305,7 @@ int rio_release_inb_mbox(struct rio_mpor
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(rio_release_inb_mbox);
 
 /**
  * rio_request_outb_mbox - request outbound mailbox service
@@ -357,6 +360,7 @@ int rio_request_outb_mbox(struct rio_mpo
       out:
 	return rc;
 }
+EXPORT_SYMBOL_GPL(rio_request_outb_mbox);
 
 /**
  * rio_release_outb_mbox - release outbound mailbox message service
@@ -385,6 +389,7 @@ int rio_release_outb_mbox(struct rio_mpo
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(rio_release_outb_mbox);
 
 /**
  * rio_setup_inb_dbell - bind inbound doorbell callback
@@ -458,6 +463,7 @@ int rio_request_inb_dbell(struct rio_mpo
       out:
 	return rc;
 }
+EXPORT_SYMBOL_GPL(rio_request_inb_dbell);
 
 /**
  * rio_release_inb_dbell - release inbound doorbell message service
@@ -499,6 +505,7 @@ int rio_release_inb_dbell(struct rio_mpo
       out:
 	return rc;
 }
+EXPORT_SYMBOL_GPL(rio_release_inb_dbell);
 
 /**
  * rio_request_outb_dbell - request outbound doorbell message range
@@ -527,6 +534,7 @@ struct resource *rio_request_outb_dbell(
 
 	return res;
 }
+EXPORT_SYMBOL_GPL(rio_request_outb_dbell);
 
 /**
  * rio_release_outb_dbell - release outbound doorbell message range
@@ -544,6 +552,7 @@ int rio_release_outb_dbell(struct rio_de
 
 	return rc;
 }
+EXPORT_SYMBOL_GPL(rio_release_outb_dbell);
 
 /**
  * rio_add_mport_pw_handler - add port-write message handler into the list
@@ -1450,6 +1459,7 @@ struct rio_dev *rio_get_asm(u16 vid, u16
 	spin_unlock(&rio_global_list_lock);
 	return rdev;
 }
+EXPORT_SYMBOL_GPL(rio_get_asm);
 
 /**
  * rio_get_device - Begin or continue searching for a RIO device by vid/did
@@ -1469,6 +1479,7 @@ struct rio_dev *rio_get_device(u16 vid,
 {
 	return rio_get_asm(vid, did, RIO_ANY_ID, RIO_ANY_ID, from);
 }
+EXPORT_SYMBOL_GPL(rio_get_device);
 
 /**
  * rio_std_route_add_entry - Add switch route table entry using standard
@@ -2203,6 +2214,7 @@ no_disc:
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(rio_init_mports);
 
 static int rio_get_hdid(int index)
 {
@@ -2317,16 +2329,3 @@ int rio_unregister_mport(struct rio_mpor
 	return 0;
 }
 EXPORT_SYMBOL_GPL(rio_unregister_mport);
