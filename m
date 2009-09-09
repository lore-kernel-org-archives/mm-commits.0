From: akpm@linux-foundation.org
Subject: + char-riscom8-fix-tty-refcnt.patch added to -mm tree
Date: Tue, 08 Sep 2009 23:19:26 -0700
Message-ID: <200909090619.n896JQSD032544@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58893 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751514AbZIIGTe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2009 02:19:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com


The patch titled
     Char: riscom8, fix tty refcnt
has been added to the -mm tree.  Its filename is
     char-riscom8-fix-tty-refcnt.patch

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
Subject: Char: riscom8, fix tty refcnt
From: Jiri Slaby <jirislaby@gmail.com>

Stanse found a tty refcnt leak on one fail path in rc_transmit.  Fix that
by jumping to the 'out' label.

http://stanse.fi.muni.cz/

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/riscom8.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/riscom8.c~char-riscom8-fix-tty-refcnt drivers/char/riscom8.c
--- a/drivers/char/riscom8.c~char-riscom8-fix-tty-refcnt
+++ a/drivers/char/riscom8.c
@@ -467,7 +467,7 @@ static void rc_transmit(struct riscom_bo
 			rc_out(bp, CD180_CCR, CCR_CORCHG2);
 			port->break_length = 0;
 		}
-		return;
+		goto out;
 	}
 
 	count = CD180_NFIFO;
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
usb-serial-mct_u232-fix-tty-refcnt.patch

