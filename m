From: akpm@linux-foundation.org
Subject: [merged] n_tty-move-echoctl-check-and-clean-up-logic.patch removed from -mm tree
Date: Mon, 10 Aug 2009 12:28:51 -0700
Message-ID: <200908101928.n7AJSpfL028398@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46725 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752539AbZHJT2x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Aug 2009 15:28:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@skyrush.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     n_tty: move echoctl check and clean up logic
has been removed from the -mm tree.  Its filename was
     n_tty-move-echoctl-check-and-clean-up-logic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: n_tty: move echoctl check and clean up logic
From: Joe Peterson <joe@skyrush.com>

Check L_ECHOCTL before insertting a character in the echo buffer (rather
than as the buffer is processed), to be more consistent with when all
other L_ flags are checked.  Also cleaned up the related logic.

Note that this and the previous patch ("n_tty: honor opost flag for
echoes") were verified together by the reporters of the bug that patch
addresses (http://bugs.linuxbase.org/show_bug.cgi?id=2692), and all tty
tests now pass.

Signed-off-by: Joe Peterson <joe@skyrush.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/n_tty.c |   46 ++++++++++++++++-------------------------
 1 file changed, 18 insertions(+), 28 deletions(-)

diff -puN drivers/char/n_tty.c~n_tty-move-echoctl-check-and-clean-up-logic drivers/char/n_tty.c
--- a/drivers/char/n_tty.c~n_tty-move-echoctl-check-and-clean-up-logic
+++ a/drivers/char/n_tty.c
@@ -578,33 +578,23 @@ static void process_echoes(struct tty_st
 				break;
 
 			default:
-				if (iscntrl(op)) {
-					if (L_ECHOCTL(tty)) {
-						/*
-						 * Ensure there is enough space
-						 * for the whole ctrl pair.
-						 */
-						if (space < 2) {
-							no_space_left = 1;
-							break;
-						}
-						tty_put_char(tty, '^');
-						tty_put_char(tty, op ^ 0100);
-						tty->column += 2;
-						space -= 2;
-					} else {
-						if (!space) {
-							no_space_left = 1;
-							break;
-						}
-						tty_put_char(tty, op);
-						space--;
-					}
-				}
 				/*
-				 * If above falls through, this was an
-				 * undefined op.
+				 * If the op is not a special byte code,
+				 * it is a ctrl char tagged to be echoed
+				 * as "^X" (where X is the letter
+				 * representing the control char).
+				 * Note that we must ensure there is
+				 * enough space for the whole ctrl pair.
+				 *
 				 */
+				if (space < 2) {
+					no_space_left = 1;
+					break;
+				}
+				tty_put_char(tty, '^');
+				tty_put_char(tty, op ^ 0100);
+				tty->column += 2;
+				space -= 2;
 				cp += 2;
 				nr -= 2;
 			}
@@ -805,8 +795,8 @@ static void echo_char_raw(unsigned char 
  *	Echo user input back onto the screen. This must be called only when
  *	L_ECHO(tty) is true. Called from the driver receive_buf path.
  *
- *	This variant tags control characters to be possibly echoed as
- *	as "^X" (where X is the letter representing the control char).
+ *	This variant tags control characters to be echoed as "^X"
+ *	(where X is the letter representing the control char).
  *
  *	Locking: echo_lock to protect the echo buffer
  */
@@ -819,7 +809,7 @@ static void echo_char(unsigned char c, s
 		add_echo_byte(ECHO_OP_START, tty);
 		add_echo_byte(ECHO_OP_START, tty);
 	} else {
-		if (iscntrl(c) && c != '\t')
+		if (L_ECHOCTL(tty) && iscntrl(c) && c != '\t')
 			add_echo_byte(ECHO_OP_START, tty);
 		add_echo_byte(c, tty);
 	}
_

Patches currently in -mm which might be from joe@skyrush.com are

linux-next.patch

