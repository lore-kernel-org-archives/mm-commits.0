From: akpm@linux-foundation.org
Subject: + eeepc-laptop-enable-bluetooth-for-asus-eee-901.patch added to -mm tree
Date: Tue, 30 Dec 2008 15:40:50 -0800
Message-ID: <200812302340.mBUNeol8010351@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37392 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752273AbYL3XlP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Dec 2008 18:41:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: santiago@crfreenet.org, corentincj@iksaif.net, lenb@kernel.org, mjg59@srcf.ucam.org


The patch titled
     eeepc-laptop: enable Bluetooth for Asus EEE 901
has been added to the -mm tree.  Its filename is
     eeepc-laptop-enable-bluetooth-for-asus-eee-901.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: eeepc-laptop: enable Bluetooth for Asus EEE 901
From: Ondrej Zajicek <santiago@crfreenet.org>

eeepc-laptop driver has interface for enabling/disabling Bluetooth, but it
does not work.  This patch fixes it.

Signed-off-by: Ondrej Zajicek <santiago@crfreenet.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Corentin Chary <corentincj@iksaif.net>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/eeepc-laptop.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/platform/x86/eeepc-laptop.c~eeepc-laptop-enable-bluetooth-for-asus-eee-901 drivers/platform/x86/eeepc-laptop.c
--- a/drivers/platform/x86/eeepc-laptop.c~eeepc-laptop-enable-bluetooth-for-asus-eee-901
+++ a/drivers/platform/x86/eeepc-laptop.c
@@ -90,7 +90,7 @@ enum {
 };
 
 static const char *cm_getv[] = {
-	"WLDG", NULL, NULL, NULL,
+	"WLDG", "BTHG", NULL, NULL,
 	"CAMG", NULL, NULL, NULL,
 	NULL, "PBLG", NULL, NULL,
 	"CFVG", NULL, NULL, NULL,
@@ -99,7 +99,7 @@ static const char *cm_getv[] = {
 };
 
 static const char *cm_setv[] = {
-	"WLDS", NULL, NULL, NULL,
+	"WLDS", "BTHS", NULL, NULL,
 	"CAMS", NULL, NULL, NULL,
 	"SDSP", "PBLS", "HDPS", NULL,
 	"CFVS", NULL, NULL, NULL,
_

Patches currently in -mm which might be from santiago@crfreenet.org are

eeepc-laptop-enable-bluetooth-for-asus-eee-901.patch

