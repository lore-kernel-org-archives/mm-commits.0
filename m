From: akpm@linux-foundation.org
Subject: - xc5000-fix-build-error-when-built-as-module.patch removed from -mm tree
Date: Thu, 14 Feb 2008 14:23:38 -0500
Message-ID: <200802150226.m1F2QvHN015270@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54506 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760658AbYBOC3G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 21:29:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tony@bakeyournoodle.com, mchehab@infradead.org, mkrufky@linuxtv.org, mm-commits@vger.kernel.org


The patch titled
     xc5000: fix build error when built as module
has been removed from the -mm tree.  Its filename was
     xc5000-fix-build-error-when-built-as-module.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

fix-compile-of-swim3-as-module.patch
git-dvb.patch
