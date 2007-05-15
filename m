From: akpm@linux-foundation.org
Subject: - update-dvb-use-of-symbol_getput.patch removed from -mm tree
Date: Tue, 15 May 2007 01:49:26 -0700
Message-ID: <200705150849.l4F8nPGp005532@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37776 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757902AbXEOItk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 04:49:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xyzzy@speakeasy.org, dwmw2@infradead.org, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Update dvb use of symbol_(get|put)
has been removed from the -mm tree.  Its filename was
     update-dvb-use-of-symbol_getput.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: Update dvb use of symbol_(get|put)
From: Trent Piepho <xyzzy@speakeasy.org>

Make the dvb sub-system use the ability of symbol_(put|get) to keep track of
what module did the putting or getting.  In the dvb sub-system, symbol_put is
called through the macro dvb_attach().  A driver for a bridge or card will
attach frontends, tuners, or other helper drivers, and this card driver will
be listed as the user of the helper drivers.

When the card driver unloads, a single function in dvb-core,
dvb_frontend_detach(), will release all the helper drivers.  Since the get()
happened in the card driver, but the put() is happening in dvb-core, it is
necessary to use __symbol_put_addr() so that a user other than THIS_MODULE
(which would be dvb-core, while we want the card driver) can be specified.

Signed-off-by: Trent Piepho <xyzzy@speakeasy.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/bt8xx/dst.c             |    2 +-
 drivers/media/dvb/dvb-core/dvb_frontend.c |    9 +++++----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff -puN drivers/media/dvb/bt8xx/dst.c~update-dvb-use-of-symbol_getput drivers/media/dvb/bt8xx/dst.c
--- a/drivers/media/dvb/bt8xx/dst.c~update-dvb-use-of-symbol_getput
+++ a/drivers/media/dvb/bt8xx/dst.c
@@ -1718,7 +1718,7 @@ static void dst_release(struct dvb_front
 	if (state->dst_ca) {
 		dvb_unregister_device(state->dst_ca);
 #ifdef CONFIG_DVB_CORE_ATTACH
-		symbol_put(dst_ca_attach);
+		symbol_put_user(dst_ca_attach, fe->dvb->module);
 #endif
 	}
 	kfree(state);
diff -puN drivers/media/dvb/dvb-core/dvb_frontend.c~update-dvb-use-of-symbol_getput drivers/media/dvb/dvb-core/dvb_frontend.c
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c~update-dvb-use-of-symbol_getput
+++ a/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1122,19 +1122,20 @@ EXPORT_SYMBOL(dvb_unregister_frontend);
 void dvb_frontend_detach(struct dvb_frontend* fe)
 {
 	void *ptr;
+	struct module *mod = fe->dvb->module;
 
 	if (fe->ops.release_sec) {
 		fe->ops.release_sec(fe);
-		symbol_put_addr(fe->ops.release_sec);
+		__symbol_put_addr(fe->ops.release_sec, mod);
 	}
 	if (fe->ops.tuner_ops.release) {
 		fe->ops.tuner_ops.release(fe);
-		symbol_put_addr(fe->ops.tuner_ops.release);
+		__symbol_put_addr(fe->ops.tuner_ops.release, mod);
 	}
 	ptr = (void*)fe->ops.release;
 	if (ptr) {
-		fe->ops.release(fe);
-		symbol_put_addr(ptr);
+		fe->ops.release(fe); /* This call will de-allocate fe! */
+		__symbol_put_addr(ptr, mod);
 	}
 }
 #else
_

Patches currently in -mm which might be from xyzzy@speakeasy.org are

git-dvb.patch
update-dvb-use-of-symbol_getput.patch
