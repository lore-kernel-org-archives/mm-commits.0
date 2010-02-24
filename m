From: akpm@linux-foundation.org
Subject: + pps-serial-clients-support-fix-2.patch added to -mm tree
Date: Wed, 24 Feb 2010 12:30:01 -0800
Message-ID: <201002242030.o1OKU1m9018737@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35814 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757675Ab0BXUaU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Feb 2010 15:30:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: giometti@enneenne.com


The patch titled
     pps-serial-clients-support-fix-2
has been added to the -mm tree.  Its filename is
     pps-serial-clients-support-fix-2.patch

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
Subject: pps-serial-clients-support-fix-2
From: Rodolfo Giometti <giometti@enneenne.com>



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/clients/pps-ldisc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/pps/clients/pps-ldisc.c~pps-serial-clients-support-fix-2 drivers/pps/clients/pps-ldisc.c
--- a/drivers/pps/clients/pps-ldisc.c~pps-serial-clients-support-fix-2
+++ a/drivers/pps/clients/pps-ldisc.c
@@ -53,7 +53,7 @@ static void pps_tty_dcd_change(struct tt
 			status ? "assert" : "clear", jiffies, id);
 }
 
-static int (*n_tty_open)(struct tty_struct *tty);
+static int (*alias_n_tty_open)(struct tty_struct *tty);
 
 static int pps_tty_open(struct tty_struct *tty)
 {
@@ -79,7 +79,7 @@ static int pps_tty_open(struct tty_struc
 	tty->disc_data = (void *) ret;
 
 	/* Should open N_TTY ldisc too */
-	ret = n_tty_open(tty);
+	ret = alias_n_tty_open(tty);
 	if (ret < 0)
 		pps_unregister_source((int) tty->disc_data);
 
@@ -88,14 +88,14 @@ static int pps_tty_open(struct tty_struc
 	return 0;
 }
 
-static void (*n_tty_close)(struct tty_struct *tty);
+static void (*alias_n_tty_close)(struct tty_struct *tty);
 
 static void pps_tty_close(struct tty_struct *tty)
 {
 	int id = (int) tty->disc_data;
 
 	pps_unregister_source(id);
-	n_tty_close(tty);
+	alias_n_tty_close(tty);
 
 	pr_info("PPS source #%d removed\n", id);
 }
_

Patches currently in -mm which might be from giometti@enneenne.com are

pps-serial-clients-support-fix-2.patch

