From: akpm@osdl.org
Subject: - char-istallion-use-mod_timer.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:10:30 -0800
Message-ID: <200612082010.kB8KAUwq002814@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58823 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946513AbWLHUKf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:10:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: istallion, use mod_timer
has been removed from the -mm tree.  Its filename was
     char-istallion-use-mod_timer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: istallion, use mod_timer
From: Jiri Slaby <jirislaby@gmail.com>

Do not set expires by hand, use kernel helper, which also calls add_timer.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/istallion.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/char/istallion.c~char-istallion-use-mod_timer drivers/char/istallion.c
--- a/drivers/char/istallion.c~char-istallion-use-mod_timer
+++ a/drivers/char/istallion.c
@@ -2545,8 +2545,7 @@ static void stli_poll(unsigned long arg)
 	struct stlibrd *brdp;
 	unsigned int brdnr;
 
-	stli_timerlist.expires = STLI_TIMEOUT;
-	add_timer(&stli_timerlist);
+	mod_timer(&stli_timerlist, STLI_TIMEOUT);
 
 /*
  *	Check each board and do any servicing required.
@@ -3610,8 +3609,7 @@ stli_donestartup:
 
 	if (! stli_timeron) {
 		stli_timeron++;
-		stli_timerlist.expires = STLI_TIMEOUT;
-		add_timer(&stli_timerlist);
+		mod_timer(&stli_timerlist, STLI_TIMEOUT);
 	}
 
 	return rc;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

char-istallion-use-mod_timer.patch
char-cyclades-save-indent-levels.patch
char-cyclades-lindent-the-code.patch
char-cyclades-cleanup.patch
char-cyclades-fix-warnings.patch

