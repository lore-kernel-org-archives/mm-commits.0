From: akpm@linux-foundation.org
Subject: + connector-bugfix-for-cn_call_callback.patch added to -mm tree
Date: Wed, 07 Mar 2007 13:39:32 -0800
Message-ID: <200703072139.l27LdWh3009851@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60160 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965676AbXCGVmp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Mar 2007 16:42:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: philipp.reisner@linbit.com, johnpol@2ka.mipt.ru, lars.ellenberg@linbit.com, stable@kernel.org


The patch titled
     connector: bugfix for cn_call_callback()
has been added to the -mm tree.  Its filename is
     connector-bugfix-for-cn_call_callback.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: connector: bugfix for cn_call_callback()
From: Philipp Reisner <philipp.reisner@linbit.com>

When one stresses the connector code, with sending many messages from
userspace to kernel, one could get in the "unlikely()" part in
cn_call_callback().

There a new __cbq gets allocated, and a NULL pointer got assigned to the
callback by dereferencing __cbq.  This is the bug.  The right thing is the
dereference the original __cbq.  Therefore the bugfix is to use a new
variable for the newly allocated __cbq.

This is tested, and it fixes the issue.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
Acked-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/connector/connector.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/connector/connector.c~connector-bugfix-for-cn_call_callback drivers/connector/connector.c
--- a/drivers/connector/connector.c~connector-bugfix-for-cn_call_callback
+++ a/drivers/connector/connector.c
@@ -128,7 +128,7 @@ EXPORT_SYMBOL_GPL(cn_netlink_send);
  */
 static int cn_call_callback(struct cn_msg *msg, void (*destruct_data)(void *), void *data)
 {
-	struct cn_callback_entry *__cbq;
+	struct cn_callback_entry *__cbq, *__new_cbq;
 	struct cn_dev *dev = &cdev;
 	int err = -ENODEV;
 
@@ -148,23 +148,23 @@ static int cn_call_callback(struct cn_ms
 			} else {
 				struct cn_callback_data *d;
 				
-				__cbq = kzalloc(sizeof(*__cbq), GFP_ATOMIC);
-				if (__cbq) {
-					d = &__cbq->data;
+				__new_cbq = kzalloc(sizeof(*__new_cbq), GFP_ATOMIC);
+				if (__new_cbq) {
+					d = &__new_cbq->data;
 					d->callback_priv = msg;
 					d->callback = __cbq->data.callback;
 					d->ddata = data;
 					d->destruct_data = destruct_data;
-					d->free = __cbq;
+					d->free = __new_cbq;
 
-					INIT_WORK(&__cbq->work,
+					INIT_WORK(&__new_cbq->work,
 							&cn_queue_wrapper);
 					
 					if (queue_work(dev->cbdev->cn_queue,
-						    &__cbq->work))
+							&__new_cbq->work))
 						err = 0;
 					else {
-						kfree(__cbq);
+						kfree(__new_cbq);
 						err = -EINVAL;
 					}
 				} else
_

Patches currently in -mm which might be from philipp.reisner@linbit.com are

connector-bugfix-for-cn_call_callback.patch
