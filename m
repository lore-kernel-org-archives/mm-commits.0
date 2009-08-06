From: akpm@linux-foundation.org
Subject: + n_tty-honor-opost-flag-for-echoes.patch added to -mm tree
Date: Wed, 05 Aug 2009 17:16:03 -0700
Message-ID: <200908060016.n760G3lm002840@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43048 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751806AbZHFAQJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Aug 2009 20:16:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@skyrush.com, greg@kroah.com


The patch titled
     n_tty: honor opost flag for echoes
has been added to the -mm tree.  Its filename is
     n_tty-honor-opost-flag-for-echoes.patch

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
Subject: n_tty: honor opost flag for echoes
From: Joe Peterson <joe@skyrush.com>

Fixes the following bug:

      http://bugs.linuxbase.org/show_bug.cgi?id=2692

Causes processing of echoed characters (output from the echo buffer) to
honor the O_OPOST flag.  This re-establishes this behavior.

Note that this and the next patch ("n_tty: move echoctl check and clean up
logic") were verified together by the bug reporters, and all tty tests now
pass.

The tty tests are from the "Linux Standard Base" test suite:

	http://www.linuxfoundation.org/collaborate/workgroups/lsb
	
Signed-off-by: Joe Peterson <joe@skyrush.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/n_tty.c |  100 +++++++++++++++++++++--------------------
 1 file changed, 53 insertions(+), 47 deletions(-)

diff -puN drivers/char/n_tty.c~n_tty-honor-opost-flag-for-echoes drivers/char/n_tty.c
--- a/drivers/char/n_tty.c~n_tty-honor-opost-flag-for-echoes
+++ a/drivers/char/n_tty.c
@@ -292,54 +292,56 @@ static int do_output_char(unsigned char 
 	if (!space)
 		return -1;
 
-	switch (c) {
-	case '\n':
-		if (O_ONLRET(tty))
-			tty->column = 0;
-		if (O_ONLCR(tty)) {
-			if (space < 2)
-				return -1;
-			tty->canon_column = tty->column = 0;
-			tty_put_char(tty, '\r');
-			tty_put_char(tty, c);
-			return 2;
-		}
-		tty->canon_column = tty->column;
-		break;
-	case '\r':
-		if (O_ONOCR(tty) && tty->column == 0)
-			return 0;
-		if (O_OCRNL(tty)) {
-			c = '\n';
+	if (O_OPOST(tty)) {
+		switch (c) {
+		case '\n':
 			if (O_ONLRET(tty))
+				tty->column = 0;
+			if (O_ONLCR(tty)) {
+				if (space < 2)
+					return -1;
 				tty->canon_column = tty->column = 0;
+				tty_put_char(tty, '\r');
+				tty_put_char(tty, c);
+				return 2;
+			}
+			tty->canon_column = tty->column;
 			break;
-		}
-		tty->canon_column = tty->column = 0;
-		break;
-	case '\t':
-		spaces = 8 - (tty->column & 7);
-		if (O_TABDLY(tty) == XTABS) {
-			if (space < spaces)
-				return -1;
+		case '\r':
+			if (O_ONOCR(tty) && tty->column == 0)
+				return 0;
+			if (O_OCRNL(tty)) {
+				c = '\n';
+				if (O_ONLRET(tty))
+					tty->canon_column = tty->column = 0;
+				break;
+			}
+			tty->canon_column = tty->column = 0;
+			break;
+		case '\t':
+			spaces = 8 - (tty->column & 7);
+			if (O_TABDLY(tty) == XTABS) {
+				if (space < spaces)
+					return -1;
+				tty->column += spaces;
+				tty->ops->write(tty, "        ", spaces);
+				return spaces;
+			}
 			tty->column += spaces;
-			tty->ops->write(tty, "        ", spaces);
-			return spaces;
-		}
-		tty->column += spaces;
-		break;
-	case '\b':
-		if (tty->column > 0)
-			tty->column--;
-		break;
-	default:
-		if (!iscntrl(c)) {
-			if (O_OLCUC(tty))
-				c = toupper(c);
-			if (!is_continuation(c, tty))
-				tty->column++;
+			break;
+		case '\b':
+			if (tty->column > 0)
+				tty->column--;
+			break;
+		default:
+			if (!iscntrl(c)) {
+				if (O_OLCUC(tty))
+					c = toupper(c);
+				if (!is_continuation(c, tty))
+					tty->column++;
+			}
+			break;
 		}
-		break;
 	}
 
 	tty_put_char(tty, c);
@@ -351,8 +353,9 @@ static int do_output_char(unsigned char 
  *	@c: character (or partial unicode symbol)
  *	@tty: terminal device
  *
- *	Perform OPOST processing.  Returns -1 when the output device is
- *	full and the character must be retried.
+ *	Output a character (with OPOST processing if enabled).
+ *	Returns -1 if the output device is full and the character
+ *	must be retried.
  *
  *	Locking: output_lock to protect column state and space left
  *		 (also, this is called from n_tty_write under the
@@ -378,8 +381,11 @@ static int process_output(unsigned char 
 /**
  *	process_output_block		-	block post processor
  *	@tty: terminal device
- *	@inbuf: user buffer
- *	@nr: number of bytes
+ *	@buf: character buffer
+ *	@nr: number of bytes to output
+ *
+ *	Output a block of characters (with OPOST processing - assumed enabled).
+ *	Returns the number of characters output.
  *
  *	This path is used to speed up block console writes, among other
  *	things when processing blocks of output data. It handles only
_

Patches currently in -mm which might be from joe@skyrush.com are

n_tty-honor-opost-flag-for-echoes.patch
n_tty-move-echoctl-check-and-clean-up-logic.patch

