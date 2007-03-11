From: akpm@linux-foundation.org
Subject: + update-dvb-use-of-symbol_getput.patch added to -mm tree
Date: Sun, 11 Mar 2007 00:10:01 -0800
Message-ID: <200703110810.l2B8A1I4007547@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39481 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735AbXCKIKN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Mar 2007 04:10:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xyzzy@speakeasy.org, dwmw2@infradead.org, rusty@rustcorp.com.au


The patch titled
     Update dvb use of symbol_(get|put)
has been added to the -mm tree.  Its filename is
     update-dvb-use-of-symbol_getput.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

 drivers/media/dvb/bt8xx/dst.c             |    5 +----
 drivers/media/dvb/dvb-core/dvb_frontend.c |    9 +++++----
 2 files changed, 6 insertions(+), 8 deletions(-)

diff -puN drivers/media/dvb/bt8xx/dst.c~update-dvb-use-of-symbol_getput drivers/media/dvb/bt8xx/dst.c
--- a/drivers/media/dvb/bt8xx/dst.c~update-dvb-use-of-symbol_getput
+++ a/drivers/media/dvb/bt8xx/dst.c
@@ -1718,12 +1718,9 @@ static void dst_release(struct dvb_front
 	if (state->dst_ca) {
 		dvb_unregister_device(state->dst_ca);
 #ifdef CONFIG_DVB_CORE_ATTACH
-		symbol_put(dst_ca_attach);
+		symbol_put_user(dst_ca_attach, fe->dvb->module);
 #endif
 	}
-#ifdef CONFIG_DVB_CORE_ATTACH
-	symbol_put(dst_attach);
-#endif
 	kfree(state);
 }
 
diff -puN drivers/media/dvb/dvb-core/dvb_frontend.c~update-dvb-use-of-symbol_getput drivers/media/dvb/dvb-core/dvb_frontend.c
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c~update-dvb-use-of-symbol_getput
+++ a/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1106,19 +1106,20 @@ EXPORT_SYMBOL(dvb_unregister_frontend);
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
fix-constant-folding-and-poor-optimization-in-byte-swapping.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
add-ability-to-keep-track-of-callers-of-symbol_getput-tidy.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
