From: akpm@linux-foundation.org
Subject: + 8250-remove-a-few-inlines-of-dubious-value.patch added to -mm tree
Date: Mon, 18 Aug 2008 13:43:25 -0700
Message-ID: <200808182043.m7IKhPTC011740@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49231 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751280AbYHRUne (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 16:43:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: will.newton@gmail.com, alan@lxorguk.ukuu.org.uk


The patch titled
     8250: remove a few inlines of dubious value
has been added to the -mm tree.  Its filename is
     8250-remove-a-few-inlines-of-dubious-value.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: 8250: remove a few inlines of dubious value
From: "Will Newton" <will.newton@gmail.com>

Remove some inlines from various functions that are called once, are too
big to inline, or are called only from slow path code.  This saves around
300 bytes of code for me.

Signed-off-by: Will Newton <will.newton@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN drivers/serial/8250.c~8250-remove-a-few-inlines-of-dubious-value drivers/serial/8250.c
--- a/drivers/serial/8250.c~8250-remove-a-few-inlines-of-dubious-value
+++ a/drivers/serial/8250.c
@@ -540,7 +540,7 @@ static unsigned int serial_icr_read(stru
 /*
  * FIFO support.
  */
-static inline void serial8250_clear_fifos(struct uart_8250_port *p)
+static void serial8250_clear_fifos(struct uart_8250_port *p)
 {
 	if (p->capabilities & UART_CAP_FIFO) {
 		serial_outp(p, UART_FCR, UART_FCR_ENABLE_FIFO);
@@ -555,7 +555,7 @@ static inline void serial8250_clear_fifo
  * capability" bit enabled.  Note that on XR16C850s, we need to
  * reset LCR to write to IER.
  */
-static inline void serial8250_set_sleep(struct uart_8250_port *p, int sleep)
+static void serial8250_set_sleep(struct uart_8250_port *p, int sleep)
 {
 	if (p->capabilities & UART_CAP_SLEEP) {
 		if (p->capabilities & UART_CAP_EFR) {
@@ -1428,8 +1428,7 @@ static unsigned int check_modem_status(s
 /*
  * This handles the interrupt from one port.
  */
-static inline void
-serial8250_handle_port(struct uart_8250_port *up)
+static void serial8250_handle_port(struct uart_8250_port *up)
 {
 	unsigned int status;
 	unsigned long flags;
@@ -1764,7 +1763,7 @@ static void serial8250_break_ctl(struct 
 /*
  *	Wait for transmitter & holding register to empty
  */
-static inline void wait_for_xmitr(struct uart_8250_port *up, int bits)
+static void wait_for_xmitr(struct uart_8250_port *up, int bits)
 {
 	unsigned int status, tmout = 10000;
 
_

Patches currently in -mm which might be from will.newton@gmail.com are

serial-8250-tighten-test-for-using-backup-timer.patch
8250-remove-a-few-inlines-of-dubious-value.patch

