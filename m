From: akpm@linux-foundation.org
Subject: [folded] pps-serial-clients-support-fix-2.patch removed from -mm tree
Date: Wed, 24 Feb 2010 14:41:06 -0800
Message-ID: <201002242241.o1OMf602024701@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55008 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757453Ab0BXWlh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Feb 2010 17:41:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: giometti@enneenne.com, mm-commits@vger.kernel.org


The patch titled
     pps-serial-clients-support-fix-2
has been removed from the -mm tree.  Its filename was
     pps-serial-clients-support-fix-2.patch

This patch was dropped because it was folded into pps-serial-clients-support.patch

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

pps-serial-clients-support.patch
pps-serial-clients-support-fix-2.patch

