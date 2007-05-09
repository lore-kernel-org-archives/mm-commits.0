From: akpm@linux-foundation.org
Subject: - char-cyclades-remove-useless-casts.patch removed from -mm tree
Date: Tue, 08 May 2007 19:56:37 -0700
Message-ID: <200705090256.l492ubmm010077@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47874 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032578AbXEIC4l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:56:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: cyclades, remove useless casts
has been removed from the -mm tree.  Its filename was
     char-cyclades-remove-useless-casts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: cyclades, remove useless casts
From: Jiri Slaby <jirislaby@gmail.com>

cyclades, remove useless casts

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |   38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-remove-useless-casts drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-remove-useless-casts
+++ a/drivers/char/cyclades.c
@@ -2636,7 +2636,7 @@ static int cy_open(struct tty_struct *tt
  */
 static void cy_wait_until_sent(struct tty_struct *tty, int timeout)
 {
-	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+	struct cyclades_port *info = tty->driver_data;
 	void __iomem *base_addr;
 	int card, chip, channel, index;
 	unsigned long orig_jiffies;
@@ -2713,7 +2713,7 @@ static void cy_wait_until_sent(struct tt
  */
 static void cy_close(struct tty_struct *tty, struct file *filp)
 {
-	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+	struct cyclades_port *info = tty->driver_data;
 	unsigned long flags;
 
 #ifdef CY_DEBUG_OTHER
@@ -2858,7 +2858,7 @@ static void cy_close(struct tty_struct *
  */
 static int cy_write(struct tty_struct *tty, const unsigned char *buf, int count)
 {
-	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+	struct cyclades_port *info = tty->driver_data;
 	unsigned long flags;
 	int c, ret = 0;
 
@@ -2909,7 +2909,7 @@ static int cy_write(struct tty_struct *t
  */
 static void cy_put_char(struct tty_struct *tty, unsigned char ch)
 {
-	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+	struct cyclades_port *info = tty->driver_data;
 	unsigned long flags;
 
 #ifdef CY_DEBUG_IO
@@ -2942,7 +2942,7 @@ static void cy_put_char(struct tty_struc
  */
 static void cy_flush_chars(struct tty_struct *tty)
 {
-	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+	struct cyclades_port *info = tty->driver_data;
 
 #ifdef CY_DEBUG_IO
 	printk("cyc:cy_flush_chars ttyC%d\n", info->line);	/* */
@@ -2966,7 +2966,7 @@ static void cy_flush_chars(struct tty_st
  */
 static int cy_write_room(struct tty_struct *tty)
 {
-	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+	struct cyclades_port *info = tty->driver_data;
 	int ret;
 
 #ifdef CY_DEBUG_IO
@@ -2983,7 +2983,7 @@ static int cy_write_room(struct tty_stru
 
 static int cy_chars_in_buffer(struct tty_struct *tty)
 {
-	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+	struct cyclades_port *info = tty->driver_data;
 	int card, channel;
 
 	if (serial_paranoia_check(info, tty->name, "cy_chars_in_buffer"))
@@ -3572,7 +3572,7 @@ static int get_lsr_info(struct cyclades_
 
 static int cy_tiocmget(struct tty_struct *tty, struct file *file)
 {
-	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+	struct cyclades_port *info = tty->driver_data;
 	int card, chip, channel, index;
 	void __iomem *base_addr;
 	unsigned long flags;
@@ -3646,7 +3646,7 @@ static int
 cy_tiocmset(struct tty_struct *tty, struct file *file,
 		unsigned int set, unsigned int clear)
 {
-	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+	struct cyclades_port *info = tty->driver_data;
 	int card, chip, channel, index;
 	void __iomem *base_addr;
 	unsigned long flags;
@@ -3797,7 +3797,7 @@ cy_tiocmset(struct tty_struct *tty, stru
  */
 static void cy_break(struct tty_struct *tty, int break_state)
 {
-	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+	struct cyclades_port *info = tty->driver_data;
 	unsigned long flags;
 
 	if (serial_paranoia_check(info, tty->name, "cy_break"))
@@ -3997,7 +3997,7 @@ static int
 cy_ioctl(struct tty_struct *tty, struct file *file,
 	 unsigned int cmd, unsigned long arg)
 {
-	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+	struct cyclades_port *info = tty->driver_data;
 	struct cyclades_icount cprev, cnow;	/* kernel counter temps */
 	struct serial_icounter_struct __user *p_cuser;	/* user space */
 	int ret_val = 0;
@@ -4190,7 +4190,7 @@ cy_ioctl(struct tty_struct *tty, struct 
  */
 static void cy_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 {
-	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+	struct cyclades_port *info = tty->driver_data;
 
 #ifdef CY_DEBUG_OTHER
 	printk("cyc:cy_set_termios ttyC%d\n", info->line);
@@ -4225,7 +4225,7 @@ static void cy_set_termios(struct tty_st
 */
 static void cy_send_xchar(struct tty_struct *tty, char ch)
 {
-	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+	struct cyclades_port *info = tty->driver_data;
 	int card, channel;
 
 	if (serial_paranoia_check(info, tty->name, "cy_send_xchar"))
@@ -4255,7 +4255,7 @@ static void cy_send_xchar(struct tty_str
  */
 static void cy_throttle(struct tty_struct *tty)
 {
-	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+	struct cyclades_port *info = tty->driver_data;
 	unsigned long flags;
 	void __iomem *base_addr;
 	int card, chip, channel, index;
@@ -4313,7 +4313,7 @@ static void cy_throttle(struct tty_struc
  */
 static void cy_unthrottle(struct tty_struct *tty)
 {
-	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+	struct cyclades_port *info = tty->driver_data;
 	unsigned long flags;
 	void __iomem *base_addr;
 	int card, chip, channel, index;
@@ -4369,7 +4369,7 @@ static void cy_unthrottle(struct tty_str
 static void cy_stop(struct tty_struct *tty)
 {
 	struct cyclades_card *cinfo;
-	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+	struct cyclades_port *info = tty->driver_data;
 	void __iomem *base_addr;
 	int chip, channel, index;
 	unsigned long flags;
@@ -4404,7 +4404,7 @@ static void cy_stop(struct tty_struct *t
 static void cy_start(struct tty_struct *tty)
 {
 	struct cyclades_card *cinfo;
-	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+	struct cyclades_port *info = tty->driver_data;
 	void __iomem *base_addr;
 	int chip, channel, index;
 	unsigned long flags;
@@ -4437,7 +4437,7 @@ static void cy_start(struct tty_struct *
 
 static void cy_flush_buffer(struct tty_struct *tty)
 {
-	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+	struct cyclades_port *info = tty->driver_data;
 	int card, channel, retval;
 	unsigned long flags;
 
@@ -4474,7 +4474,7 @@ static void cy_flush_buffer(struct tty_s
  */
 static void cy_hangup(struct tty_struct *tty)
 {
-	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+	struct cyclades_port *info = tty->driver_data;
 
 #ifdef CY_DEBUG_OTHER
 	printk("cyc:cy_hangup ttyC%d\n", info->line);	/* */
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-dvb.patch
cinergyt2-fix-file-release-handler.patch
auerswald-fix-file-release-handler.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
vmstat-use-our-own-timer-events-fix.patch
shrink_slab-handle-bad-shrinkers.patch
