From: akpm@linux-foundation.org
Subject: + usb-serial-mct_u232-fix-tty-refcnt.patch added to -mm tree
Date: Tue, 08 Sep 2009 23:19:58 -0700
Message-ID: <200909090619.n896JwUA001099@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48781 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751514AbZIIGUH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2009 02:20:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com


The patch titled
     usb: serial/mct_u232, fix tty refcnt
has been added to the -mm tree.  Its filename is
     usb-serial-mct_u232-fix-tty-refcnt.patch

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
Subject: usb: serial/mct_u232, fix tty refcnt
From: Jiri Slaby <jirislaby@gmail.com>

Stanse found a tty refcnt leak in read_int_callback.  In fact it's handled
wrong altogether.  tty_port_tty_get can return NULL and it's not checked
in that manner.

Fix that by checking the tty_port_tty_get retval and put tty kref
properly.

http://stanse.fi.muni.cz/

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/mct_u232.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN drivers/usb/serial/mct_u232.c~usb-serial-mct_u232-fix-tty-refcnt drivers/usb/serial/mct_u232.c
--- a/drivers/usb/serial/mct_u232.c~usb-serial-mct_u232-fix-tty-refcnt
+++ a/drivers/usb/serial/mct_u232.c
@@ -566,10 +566,13 @@ static void mct_u232_read_int_callback(s
 	 * Work-a-round: handle the 'usual' bulk-in pipe here
 	 */
 	if (urb->transfer_buffer_length > 2) {
-		tty = tty_port_tty_get(&port->port);
 		if (urb->actual_length) {
-			tty_insert_flip_string(tty, data, urb->actual_length);
-			tty_flip_buffer_push(tty);
+			tty = tty_port_tty_get(&port->port);
+			if (tty) {
+				tty_insert_flip_string(tty, data,
+						urb->actual_length);
+				tty_flip_buffer_push(tty);
+			}
 			tty_kref_put(tty);
 		}
 		goto exit;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

linux-next.patch
md-dm-log-fix-cn_ulog_callback-declaration.patch
mtd-sst25l-fix-lock-imbalance.patch
isdn-hisax-fix-lock-imbalance.patch
isdn-eicon-use-offsetof.patch
isdn-eicon-return-on-error.patch
icom-converting-space-to-tabs.patch
cyclades-read-buffer-overflow.patch
serial167-fix-read-buffer-overflow.patch
usb-serial-mct_u232-fix-tty-refcnt.patch
kcore-use-registerd-physmem-information.patch
kcore-register-vmemmap-range.patch
kcore-register-vmemmap-range-fix.patch
kcore-register-module-area-in-generic-way.patch
video-console-use-div_round_up.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
cyclades-allow-overriding-isa-defaults-also-when-the-driver-is-built-in.patch
drivers-char-rio-rioctrlc-off-by-one-error-in-rioctrlc.patch
char-riscom8-fix-tty-refcnt.patch
memstick-move-dev_dbg.patch
reiser4.patch
fs-reiser4-add-parenths-around-x-y.patch

