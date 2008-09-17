From: akpm@linux-foundation.org
Subject: + serial-driver-handle-multiple-consecutive-sysrq-from-the-serial.patch added to -mm tree
Date: Wed, 17 Sep 2008 16:46:27 -0700
Message-ID: <200809172346.m8HNkRPS004328@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60131 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752125AbYIQXqq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Sep 2008 19:46:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: liberty@extricom.com, alan@lxorguk.ukuu.org.uk, liberty@extricom.org, rmk@arm.linux.org.uk


The patch titled
     serial driver: handle multiple consecutive sysrq characters
has been added to the -mm tree.  Its filename is
     serial-driver-handle-multiple-consecutive-sysrq-from-the-serial.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial driver: handle multiple consecutive sysrq characters
From: Eran Liberty <liberty@extricom.com>

Let me start of by saying my particular hardware must be buggy in some
way.  When I issue a sysrq (Ctrl A+ F from minicom) I get a lot of sysrq
triggers.

I have worked around the problem and I think this workaround is a viable
patch even for platforms which do not exhibit this peculiar behavior.

upon getting numerous interrupts which request sysrq the function
uart_handle_break in include/linux/serial_core.h is hit multiple times.
The current code which looks like this:

static inline int uart_handle_break(struct uart_port *port)
 {
        struct uart_info *info = port->info;
 #ifdef SUPPORT_SYSRQ
        if (port->cons && port->cons->index == port->line) {
               if (!port->sysrq) {
                       port->sysrq = jiffies + HZ*5;
                       return 1;
               }
               port->sysrq = 0;
        }
 #endif
        if (port->flags & UPF_SAK)
                do_SAK(info->tty);
       return 0;
}

Will basicly toggle port->sysrq between a timeout value and zero.  If you
are lucky this penguin rullet will stop on timeout and the next character
hit will trigger the sysrq in the function "uart_handle_sysrq_char".  But
if you are not so lucky the last sysrq interupt will toggle port->sysrq to
zero and the next char hit will be ignored (not trigger sysrq).

The suggested patch will do the next few things:

1. "port->sysrq" is now the time when the last sysrq was triggered and
not the timeout for the the next char
2. Stamped "port->sysrq" every time there is a sysrq rather then toggled
it up and down.
3. Always continue to consider UPF_SAK.
4. "port->sysrq" is toggled back to zero only in uart_handle_break() and
only if the a char has been accepted after the sysrq timeout (5 sec)
5. uart_handle_break() will ignore extra chars received in super human
speed after the last sysrq (0.01 sec)

Signed-off-by: Eran Liberty <liberty@extricom.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/serial_core.h |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff -puN include/linux/serial_core.h~serial-driver-handle-multiple-consecutive-sysrq-from-the-serial include/linux/serial_core.h
--- a/include/linux/serial_core.h~serial-driver-handle-multiple-consecutive-sysrq-from-the-serial
+++ a/include/linux/serial_core.h
@@ -444,8 +444,9 @@ static inline int
 uart_handle_sysrq_char(struct uart_port *port, unsigned int ch)
 {
 #ifdef SUPPORT_SYSRQ
-	if (port->sysrq) {
-		if (ch && time_before(jiffies, port->sysrq)) {
+	if (port->sysrq && time_after(jiffies, port->sysrq +
+					(unsigned long)(HZ*0.01))) {
+		if (ch && time_before(jiffies, port->sysrq + HZ*5)) {
 			handle_sysrq(ch, port->info ? port->info->port.tty : NULL);
 			port->sysrq = 0;
 			return 1;
@@ -464,19 +465,17 @@ uart_handle_sysrq_char(struct uart_port 
  */
 static inline int uart_handle_break(struct uart_port *port)
 {
+	int ret = 0;
 	struct uart_info *info = port->info;
 #ifdef SUPPORT_SYSRQ
 	if (port->cons && port->cons->index == port->line) {
-		if (!port->sysrq) {
-			port->sysrq = jiffies + HZ*5;
-			return 1;
-		}
-		port->sysrq = 0;
+		port->sysrq = jiffies;
+		ret = 1;
 	}
 #endif
 	if (port->flags & UPF_SAK)
 		do_SAK(info->port.tty);
-	return 0;
+	return ret;
 }
 
 /**
_

Patches currently in -mm which might be from liberty@extricom.com are

serial-driver-handle-multiple-consecutive-sysrq-from-the-serial.patch
serial-driver-handle-multiple-consecutive-sysrq-from-the-serial-fix.patch

