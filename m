From: akpm@linux-foundation.org
Subject: + pps-serial-clients-support-avoid-noisy-compilation-on-64bits-architecture.patch added to -mm tree
Date: Tue, 02 Dec 2008 23:51:35 -0800
Message-ID: <200812030751.mB37pZsQ027374@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57461 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751251AbYLCHvj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Dec 2008 02:51:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: giometti@linux.it


The patch titled
     pps ldisc: avoid noisy compilation on 64bits architecture
has been added to the -mm tree.  Its filename is
     pps-serial-clients-support-avoid-noisy-compilation-on-64bits-architecture.patch

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
Subject: pps ldisc: avoid noisy compilation on 64bits architecture
From: Rodolfo Giometti <giometti@linux.it>

Fix things like these:

drivers/pps/clients/pps-ldisc.c: In function 'pps_tty_dcd_change':
drivers/pps/clients/pps-ldisc.c:32: warning: cast from pointer to integer of different size

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/clients/pps-ldisc.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/pps/clients/pps-ldisc.c~pps-serial-clients-support-avoid-noisy-compilation-on-64bits-architecture drivers/pps/clients/pps-ldisc.c
--- a/drivers/pps/clients/pps-ldisc.c~pps-serial-clients-support-avoid-noisy-compilation-on-64bits-architecture
+++ a/drivers/pps/clients/pps-ldisc.c
@@ -29,7 +29,7 @@
 static void pps_tty_dcd_change(struct tty_struct *tty, unsigned int status,
 				struct timespec *ts)
 {
-	int id = (int) tty->disc_data;
+	long id = (long) tty->disc_data;
 	struct timespec __ts;
 	struct pps_ktime pps_ts;
 
@@ -50,7 +50,7 @@ static void pps_tty_dcd_change(struct tt
 			NULL);
 
 	pr_debug("PPS %s at %lu on source #%d\n",
-			status ? "assert" : "clear", jiffies, id);
+			status ? "assert" : "clear", jiffies, (int) id);
 }
 
 static int pps_tty_open(struct tty_struct *tty)
@@ -58,7 +58,7 @@ static int pps_tty_open(struct tty_struc
 	struct pps_source_info info;
 	struct tty_driver *drv = tty->driver;
 	int index = tty->index + drv->name_base;
-	int ret;
+	long ret;
 
 	info.owner = THIS_MODULE;
 	info.dev = NULL;
@@ -79,21 +79,21 @@ static int pps_tty_open(struct tty_struc
 	/* Should open N_TTY ldisc too */
 	ret = n_tty_open(tty);
 	if (ret < 0)
-		pps_unregister_source((int) tty->disc_data);
+		pps_unregister_source((long) tty->disc_data);
 
-	pr_info("PPS source #%d \"%s\" added\n", ret, info.path);
+	pr_info("PPS source #%d \"%s\" added\n", (int) ret, info.path);
 
 	return 0;
 }
 
 static void pps_tty_close(struct tty_struct *tty)
 {
-	int id = (int) tty->disc_data;
+	long id = (long) tty->disc_data;
 
 	pps_unregister_source(id);
 	n_tty_close(tty);
 
-	pr_info("PPS source #%d removed\n", id);
+	pr_info("PPS source #%d removed\n", (int) id);
 }
 
 struct tty_ldisc_ops pps_ldisc_ops = {
_

Patches currently in -mm which might be from giometti@linux.it are

linux-next.patch
linuxpps-core-support.patch
linuxpps-core-support-sysfs-not-needed-variables-removed.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
ldisc-n_tty-export-all-n_tty-ldisc-methods.patch
pps-serial-clients-support.patch
pps-serial-clients-support-avoid-noisy-compilation-on-64bits-architecture.patch
pps-parallel-port-clients-support.patch
pps-low-level-irq-timestamps-recording.patch

