From: akpm@linux-foundation.org
Subject: + char-mxser-use-thre-for-aspp_oqueue-ioctl.patch added to -mm tree
Date: Fri, 11 Sep 2009 14:34:53 -0700
Message-ID: <200909112134.n8BLYr4O020827@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35307 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755381AbZIKVf1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Sep 2009 17:35:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk


The patch titled
     Char: mxser, use THRE for ASPP_OQUEUE ioctl
has been added to the -mm tree.  Its filename is
     char-mxser-use-thre-for-aspp_oqueue-ioctl.patch

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
Subject: Char: mxser, use THRE for ASPP_OQUEUE ioctl
From: Jiri Slaby <jirislaby@gmail.com>

In moxa specific ASPP_OQUEUE ioctl command, they apparently want only know
whether there is space in transmitter hold register.

So switch UART_LSR_TEMT to UART_LSR_THRE in that specific case according
to the change in 1.14 moxa drivers.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mxser.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/mxser.c~char-mxser-use-thre-for-aspp_oqueue-ioctl drivers/char/mxser.c
--- a/drivers/char/mxser.c~char-mxser-use-thre-for-aspp_oqueue-ioctl
+++ a/drivers/char/mxser.c
@@ -1806,7 +1806,7 @@ static int mxser_ioctl(struct tty_struct
 
 		lock_kernel();
 		len = mxser_chars_in_buffer(tty);
-		lsr = inb(info->ioaddr + UART_LSR) & UART_LSR_TEMT;
+		lsr = inb(info->ioaddr + UART_LSR) & UART_LSR_THRE;
 		len += (lsr ? 0 : 1);
 		unlock_kernel();
 
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
char-mxser-add-support-for-cp112ul.patch
char-mxser-use-thre-for-aspp_oqueue-ioctl.patch
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

