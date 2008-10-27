From: akpm@linux-foundation.org
Subject: + vt-incomplete-initialization-of-vc_tab_stop.patch added to -mm tree
Date: Sun, 26 Oct 2008 21:15:13 -0700
Message-ID: <200810270415.m9R4FDYP009808@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50730 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751119AbYJ0EPl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Oct 2008 00:15:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wolfgang@kroworsch.de, alan@lxorguk.ukuu.org.uk, hch@lst.de


The patch titled
     vt: incomplete initialization of vc_tab_stop
has been added to the -mm tree.  Its filename is
     vt-incomplete-initialization-of-vc_tab_stop.patch

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
Subject: vt: incomplete initialization of vc_tab_stop
From: Wolfgang Kroworsch <wolfgang@kroworsch.de>

Problem 1 (see patch below):
  vc_tab_stop is declared as an array of 8 unsigned ints in struct
  vc_data in include/linux/console_struct.h .
  In drivers/char/vt.c only 5 of these 8 unsigned ints get initialized
  leading to unintended tabulator placement on displays with more than
  160 columns text.

Problem 2 (open):
  Upcoming displays will have more than 256 columns of text leading to
  invalid memory access in drivers/char/vt.c during tabulator
  calculations:
    if (vc->vc_tab_stop[vc->vc_x >> 5] & (1 << (vc->vc_x & 31)))
	break;

Signed-off-by: Wolfgang Kroworsch <wolfgang@kroworsch.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN drivers/char/vt.c~vt-incomplete-initialization-of-vc_tab_stop drivers/char/vt.c
--- a/drivers/char/vt.c~vt-incomplete-initialization-of-vc_tab_stop
+++ a/drivers/char/vt.c
@@ -1642,7 +1642,10 @@ static void reset_terminal(struct vc_dat
 	vc->vc_tab_stop[1]	=
 	vc->vc_tab_stop[2]	=
 	vc->vc_tab_stop[3]	=
-	vc->vc_tab_stop[4]	= 0x01010101;
+	vc->vc_tab_stop[4]	=
+	vc->vc_tab_stop[5]	=
+	vc->vc_tab_stop[6]	=
+	vc->vc_tab_stop[7]	= 0x01010101;
 
 	vc->vc_bell_pitch = DEFAULT_BELL_PITCH;
 	vc->vc_bell_duration = DEFAULT_BELL_DURATION;
@@ -1933,7 +1936,10 @@ static void do_con_trol(struct tty_struc
 					vc->vc_tab_stop[1] =
 					vc->vc_tab_stop[2] =
 					vc->vc_tab_stop[3] =
-					vc->vc_tab_stop[4] = 0;
+					vc->vc_tab_stop[4] =
+					vc->vc_tab_stop[5] =
+					vc->vc_tab_stop[6] =
+					vc->vc_tab_stop[7] = 0;
 			}
 			return;
 		case 'm':
_

Patches currently in -mm which might be from wolfgang@kroworsch.de are

vt-incomplete-initialization-of-vc_tab_stop.patch
vt-incomplete-initialization-of-vc_tab_stop-fix.patch

