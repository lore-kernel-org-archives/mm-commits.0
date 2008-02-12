From: akpm@linux-foundation.org
Subject: + xc5000-fix-build-error-when-built-as-module.patch added to -mm tree
Date: Mon, 11 Feb 2008 18:54:33 -0800
Message-ID: <200802120255.m1C2tc96014606@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57961 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756156AbYBLC6O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Feb 2008 21:58:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tony@bakeyournoodle.com, mchehab@infradead.org, mkrufky@linuxtv.org


The patch titled
     xc5000: fix build error when built as module
has been added to the -mm tree.  Its filename is
     xc5000-fix-build-error-when-built-as-module.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xc5000: fix build error when built as module
From: Tony Breeds <tony@bakeyournoodle.com>

drivers/built-in.o: In function `set_type':
tuner-core.c:(.text+0x8879d): undefined reference to `xc5000_attach'

Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
Reviewed-by: Michael Krufky <mkrufky@linuxtv.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/frontends/xc5000.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/media/dvb/frontends/xc5000.h~xc5000-fix-build-error-when-built-as-module drivers/media/dvb/frontends/xc5000.h
--- a/drivers/media/dvb/frontends/xc5000.h~xc5000-fix-build-error-when-built-as-module
+++ a/drivers/media/dvb/frontends/xc5000.h
@@ -45,7 +45,8 @@ struct xc5000_config {
 /* xc5000 callback command */
 #define XC5000_TUNER_RESET		0
 
-#if defined(CONFIG_DVB_TUNER_XC5000) || defined(CONFIG_DVB_TUNER_XC5000_MODULE)
+#if defined(CONFIG_DVB_TUNER_XC5000) || \
+    (defined(CONFIG_DVB_TUNER_XC5000_MODULE) && defined(MODULE))
 extern struct dvb_frontend* xc5000_attach(struct dvb_frontend *fe,
 					  struct i2c_adapter *i2c,
 					  struct xc5000_config *cfg);
_

Patches currently in -mm which might be from tony@bakeyournoodle.com are

origin.patch
xc5000-fix-build-error-when-built-as-module.patch
