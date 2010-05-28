From: akpm@linux-foundation.org
Subject: + serial-fix-missing-bit-coverage-of-async_flags.patch added to -mm tree
Date: Fri, 28 May 2010 15:03:29 -0700
Message-ID: <201005282203.o4SM3TYk017040@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38121 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750705Ab0E1WET (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 May 2010 18:04:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jvillalo@redhat.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com, john.l.villalovos@intel.com


The patch titled
     serial: fix missing bit coverage of ASYNC_FLAGS
has been added to the -mm tree.  Its filename is
     serial-fix-missing-bit-coverage-of-async_flags.patch

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
Subject: serial: fix missing bit coverage of ASYNC_FLAGS
From: John Villalovos <jvillalo@redhat.com>

It seems that currently ASYNC_FLAGS is one bit short of covering all the
bits of the ASYNC user flags.  In particular it does not cover the
ASYNC_AUTOPROBE bit.

ASYNCB_LAST_USER and ASYNCB_AUTOPROBE are both equal to 15.

Therefore:
ASYNC_AUTOPROBE = 1000 0000 0000 0000
ASYNC_FLAGS     = 0111 1111 1111 1111

So ASYNC_FLAGS is not covering the ASYNC_AUTOPROBE bit.

This patch fixes the issue and with the patch the values will be:
ASYNC_AUTOPROBE = 1000 0000 0000 0000
ASYNC_FLAGS     = 1111 1111 1111 1111

As a side note, doing a "git grep" I didn't find any use of
ASYNC_AUTOPROBE or ASYNCB_AUTOPROBE in the kernel, besides this include
file.

Signed-off-by: John Villalovos <john.l.villalovos@intel.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/serial.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/serial.h~serial-fix-missing-bit-coverage-of-async_flags include/linux/serial.h
--- a/include/linux/serial.h~serial-fix-missing-bit-coverage-of-async_flags
+++ a/include/linux/serial.h
@@ -151,7 +151,7 @@ struct serial_uart_config {
 #define ASYNC_BUGGY_UART	(1U << ASYNCB_BUGGY_UART)
 #define ASYNC_AUTOPROBE		(1U << ASYNCB_AUTOPROBE)
 
-#define ASYNC_FLAGS		((1U << ASYNCB_LAST_USER) - 1)
+#define ASYNC_FLAGS		((1U << (ASYNCB_LAST_USER + 1)) - 1)
 #define ASYNC_USR_MASK		(ASYNC_SPD_HI|ASYNC_SPD_VHI| \
 		ASYNC_CALLOUT_NOHUP|ASYNC_SPD_SHI|ASYNC_LOW_LATENCY)
 #define ASYNC_SPD_CUST		(ASYNC_SPD_HI|ASYNC_SPD_VHI)
_

Patches currently in -mm which might be from jvillalo@redhat.com are

serial-fix-missing-bit-coverage-of-async_flags.patch

