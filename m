From: akpm@linux-foundation.org
Subject: + pps-timestamp-is-always-passed-to-dcd_change.patch added to -mm tree
Date: Fri, 17 Dec 2010 16:20:08 -0800
Message-ID: <201012180020.oBI0K8mv004919@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45980 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756601Ab0LRAUY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Dec 2010 19:20:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lasaine@lvk.cs.msu.su, giometti@linux.it


The patch titled
     pps: timestamp is always passed to dcd_change()
has been added to the -mm tree.  Its filename is
     pps-timestamp-is-always-passed-to-dcd_change.patch

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
Subject: pps: timestamp is always passed to dcd_change()
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>

Remove the code that gatheres timestamp in pps_tty_dcd_change() in case
passed ts parameter is NULL because it never happens in the current code. 
Fix comments as well.

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Acked-by: Rodolfo Giometti <giometti@linux.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/serial/tty.txt    |    2 +-
 drivers/pps/clients/pps-ldisc.c |    8 --------
 include/linux/tty_ldisc.h       |    2 +-
 3 files changed, 2 insertions(+), 10 deletions(-)

diff -puN Documentation/serial/tty.txt~pps-timestamp-is-always-passed-to-dcd_change Documentation/serial/tty.txt
--- a/Documentation/serial/tty.txt~pps-timestamp-is-always-passed-to-dcd_change
+++ a/Documentation/serial/tty.txt
@@ -107,7 +107,7 @@ write_wakeup()	-	May be called at any po
 
 dcd_change()	-	Report to the tty line the current DCD pin status
 			changes and the relative timestamp. The timestamp
-			can be NULL.
+			cannot be NULL.
 
 
 Driver Access
diff -puN drivers/pps/clients/pps-ldisc.c~pps-timestamp-is-always-passed-to-dcd_change drivers/pps/clients/pps-ldisc.c
--- a/drivers/pps/clients/pps-ldisc.c~pps-timestamp-is-always-passed-to-dcd_change
+++ a/drivers/pps/clients/pps-ldisc.c
@@ -32,14 +32,6 @@ static void pps_tty_dcd_change(struct tt
 				struct pps_event_time *ts)
 {
 	struct pps_device *pps = (struct pps_device *)tty->disc_data;
-	struct pps_event_time __ts;
-
-	/* First of all we get the time stamp... */
-	pps_get_ts(&__ts);
-
-	/* Does caller give us a timestamp? */
-	if (!ts)	/* No. Do it ourself! */
-		ts = &__ts;
 
 	BUG_ON(pps == NULL);
 
diff -puN include/linux/tty_ldisc.h~pps-timestamp-is-always-passed-to-dcd_change include/linux/tty_ldisc.h
--- a/include/linux/tty_ldisc.h~pps-timestamp-is-always-passed-to-dcd_change
+++ a/include/linux/tty_ldisc.h
@@ -104,7 +104,7 @@
  *			struct pps_event_time *ts)
  *
  *	Tells the discipline that the DCD pin has changed its status and
- *	the relative timestamp. Pointer ts can be NULL.
+ *	the relative timestamp. Pointer ts cannot be NULL.
  */
 
 #include <linux/fs.h>
_

Patches currently in -mm which might be from lasaine@lvk.cs.msu.su are

pps-trivial-fixes.patch
pps-declare-variables-where-they-are-used-in-switch.patch
pps-fix-race-in-pps_fetch-handler.patch
pps-unify-timestamp-gathering.patch
pps-access-pps-device-by-direct-pointer.patch
pps-convert-printk-pr_-to-dev_.patch
pps-move-idr-stuff-to-ppsc.patch
pps-do-not-disable-interrupts-for-idr-operations.patch
pps-use-bug_on-for-kernel-api-safety-checks.patch
pps-simplify-conditions-a-bit.patch
pps-timestamp-is-always-passed-to-dcd_change.patch
ntp-add-hardpps-implementation.patch
pps-capture-monotonic_raw-timestamps-as-well.patch
pps-add-kernel-consumer-support.patch
pps-add-parallel-port-pps-client.patch
pps-add-parallel-port-pps-signal-generator.patch

