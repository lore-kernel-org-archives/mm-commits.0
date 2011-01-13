From: akpm@linux-foundation.org
Subject: [merged] pps-timestamp-is-always-passed-to-dcd_change.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:09:28 -0800
Message-ID: <201101132012.p0DKC9or030260@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53686 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933765Ab1AMUUs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:20:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lasaine@lvk.cs.msu.su, giometti@linux.it, mm-commits@vger.kernel.org


The patch titled
     pps: timestamp is always passed to dcd_change()
has been removed from the -mm tree.  Its filename was
     pps-timestamp-is-always-passed-to-dcd_change.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
