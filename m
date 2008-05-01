From: akpm@linux-foundation.org
Subject: - s390-tty-prepare-for-put_char-to-return-success-fail.patch removed from -mm tree
Date: Thu, 01 May 2008 02:30:06 -0700
Message-ID: <200805010930.m419U6J5030739@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42697 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757657AbYEAJag (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:30:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, borntraeger@de.ibm.com, heiko.carstens@de.ibm.com, peter.oberparleiter@de.ibm.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     s390 tty: Prepare for put_char to return success/fail
has been removed from the -mm tree.  Its filename was
     s390-tty-prepare-for-put_char-to-return-success-fail.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: s390 tty: Prepare for put_char to return success/fail
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Put the changes into the drivers first.  This will still compile/work but
produce a warning if bisected so can still be debugged

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/s390/char/con3215.c    |    5 +++--
 drivers/s390/char/sclp_tty.c   |    4 ++--
 drivers/s390/char/sclp_vt220.c |    6 +++++-
 drivers/s390/char/tty3270.c    |    3 ++-
 4 files changed, 12 insertions(+), 6 deletions(-)

diff -puN drivers/s390/char/con3215.c~s390-tty-prepare-for-put_char-to-return-success-fail drivers/s390/char/con3215.c
--- a/drivers/s390/char/con3215.c~s390-tty-prepare-for-put_char-to-return-success-fail
+++ a/drivers/s390/char/con3215.c
@@ -982,15 +982,16 @@ tty3215_write(struct tty_struct * tty,
 /*
  * Put character routine for 3215 ttys
  */
-static void
+static int
 tty3215_put_char(struct tty_struct *tty, unsigned char ch)
 {
 	struct raw3215_info *raw;
 
 	if (!tty)
-		return;
+		return 0;
 	raw = (struct raw3215_info *) tty->driver_data;
 	raw3215_putchar(raw, ch);
+	return 1;
 }
 
 static void
diff -puN drivers/s390/char/sclp_tty.c~s390-tty-prepare-for-put_char-to-return-success-fail drivers/s390/char/sclp_tty.c
--- a/drivers/s390/char/sclp_tty.c~s390-tty-prepare-for-put_char-to-return-success-fail
+++ a/drivers/s390/char/sclp_tty.c
@@ -412,14 +412,14 @@ sclp_tty_write(struct tty_struct *tty, c
  * - including previous characters from sclp_tty_put_char() and strings from
  * sclp_write() without final '\n' - will be written.
  */
-static void
+static int
 sclp_tty_put_char(struct tty_struct *tty, unsigned char ch)
 {
 	sclp_tty_chars[sclp_tty_chars_count++] = ch;
 	if (ch == '\n' || sclp_tty_chars_count >= SCLP_TTY_BUF_SIZE) {
 		sclp_tty_write_string(sclp_tty_chars, sclp_tty_chars_count);
 		sclp_tty_chars_count = 0;
-	}
+	} return 1;
 }
 
 /*
diff -puN drivers/s390/char/sclp_vt220.c~s390-tty-prepare-for-put_char-to-return-success-fail drivers/s390/char/sclp_vt220.c
--- a/drivers/s390/char/sclp_vt220.c~s390-tty-prepare-for-put_char-to-return-success-fail
+++ a/drivers/s390/char/sclp_vt220.c
@@ -524,11 +524,15 @@ sclp_vt220_close(struct tty_struct *tty,
  * NOTE: include/linux/tty_driver.h specifies that a character should be
  * ignored if there is no room in the queue. This driver implements a different
  * semantic in that it will block when there is no more room left.
+ *
+ * FIXME: putchar can currently be called from BH and other non blocking
+ * handlers so  this semantic isn't a good idea.
  */
-static void
+static int
 sclp_vt220_put_char(struct tty_struct *tty, unsigned char ch)
 {
 	__sclp_vt220_write(&ch, 1, 0, 0, 1);
+	return 1;
 }
 
 /*
diff -puN drivers/s390/char/tty3270.c~s390-tty-prepare-for-put_char-to-return-success-fail drivers/s390/char/tty3270.c
--- a/drivers/s390/char/tty3270.c~s390-tty-prepare-for-put_char-to-return-success-fail
+++ a/drivers/s390/char/tty3270.c
@@ -965,7 +965,7 @@ tty3270_write_room(struct tty_struct *tt
  * Insert character into the screen at the current position with the
  * current color and highlight. This function does NOT do cursor movement.
  */
-static void
+static int
 tty3270_put_character(struct tty3270 *tp, char ch)
 {
 	struct tty3270_line *line;
@@ -986,6 +986,7 @@ tty3270_put_character(struct tty3270 *tp
 	cell->character = tp->view.ascebc[(unsigned int) ch];
 	cell->highlight = tp->highlight;
 	cell->f_color = tp->f_color;
+	return 1;
 }
 
 /*
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
pata_atiixp-simplex-clear.patch
pata_atiixp-dont-disable.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
parisc-new-termios-definitions.patch
generic-irq-let-setup_irq-reenable-a-shared-irq.patch
8250-switch-8250-drivers-to-use-_nocache-ioremaps.patch
sxc-fix-printk-warnings-on-sparc32.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

