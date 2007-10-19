From: akpm@linux-foundation.org
Subject: - tty_ioctl-fix-the-baud_table-check-in-encode_baud_rate.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:40:31 -0700
Message-ID: <200710190340.l9J3eVIV012715@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44451 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966526AbXJSD4G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:56:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: macro@linux-mips.org, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     tty_ioctl: fix the baud_table check in encode_baud_rate
has been removed from the -mm tree.  Its filename was
     tty_ioctl-fix-the-baud_table-check-in-encode_baud_rate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: tty_ioctl: fix the baud_table check in encode_baud_rate
From: "Maciej W. Rozycki" <macro@linux-mips.org>

The tty_termios_encode_baud_rate() function as defined by tty_ioctl.c has a
problem with the baud_table within.  The comparison operators are reversed
and as a result this table's entries never match and BOTHER is always used.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_ioctl.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN drivers/char/tty_ioctl.c~tty_ioctl-fix-the-baud_table-check-in-encode_baud_rate drivers/char/tty_ioctl.c
--- a/drivers/char/tty_ioctl.c~tty_ioctl-fix-the-baud_table-check-in-encode_baud_rate
+++ a/drivers/char/tty_ioctl.c
@@ -228,7 +228,8 @@ EXPORT_SYMBOL(tty_termios_input_baud_rat
  *	and will all go away once this is done.
  */
 
-void tty_termios_encode_baud_rate(struct ktermios *termios, speed_t ibaud, speed_t obaud)
+void tty_termios_encode_baud_rate(struct ktermios *termios,
+				  speed_t ibaud, speed_t obaud)
 {
 	int i = 0;
 	int ifound = -1, ofound = -1;
@@ -263,11 +264,15 @@ void tty_termios_encode_baud_rate(struct
 	 */
 
 	do {
-		if (obaud - oclose >= baud_table[i] && obaud + oclose <= baud_table[i]) {
+		if (obaud - oclose <= baud_table[i] &&
+		    obaud + oclose >= baud_table[i]) {
 			termios->c_cflag |= baud_bits[i];
 			ofound = i;
 		}
-		if (ibaud - iclose >= baud_table[i] && ibaud + iclose <= baud_table[i]) {
+		if (ibaud - iclose <= baud_table[i] &&
+		    ibaud + iclose >= baud_table[i]) {
+			/* For the case input == output don't set IBAUD bits
+			   if the user didn't do so */
 			if (ofound == i && !ibinput)
 				ifound  = i;
 #ifdef IBSHIFT
_

Patches currently in -mm which might be from macro@linux-mips.org are

origin.patch
kernel-printkc-concerns-about-the-console-handover.patch
