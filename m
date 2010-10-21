From: akpm@linux-foundation.org
Subject: + drivers-char-mwave-makefile-clean-up.patch added to -mm tree
Date: Thu, 21 Oct 2010 15:25:50 -0700
Message-ID: <201010212225.o9LMPofu007268@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46104 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758859Ab0JUW00 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Oct 2010 18:26:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tdent48227@gmail.com, jirislaby@gmail.com, mmarek@suse.cz


The patch titled
     drivers/char/mwave/Makefile: clean up
has been added to the -mm tree.  Its filename is
     drivers-char-mwave-makefile-clean-up.patch

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
Subject: drivers/char/mwave/Makefile: clean up
From: Tracey Dent <tdent48227@gmail.com>

Changed <module>-objs to <module>-y in Makefile and use
ccflags-y option.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mwave/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/char/mwave/Makefile~drivers-char-mwave-makefile-clean-up drivers/char/mwave/Makefile
--- a/drivers/char/mwave/Makefile~drivers-char-mwave-makefile-clean-up
+++ a/drivers/char/mwave/Makefile
@@ -6,10 +6,10 @@
 
 obj-$(CONFIG_MWAVE) += mwave.o
 
-mwave-objs := mwavedd.o smapi.o tp3780i.o 3780i.o
+mwave-y := mwavedd.o smapi.o tp3780i.o 3780i.o
 
 # To have the mwave driver disable other uarts if necessary
 # EXTRA_CFLAGS += -DMWAVE_FUTZ_WITH_OTHER_DEVICES
 
 # To compile in lots (~20 KiB) of run-time enablable printk()s for debugging:
-EXTRA_CFLAGS += -DMW_TRACE
+ccflags-y := -DMW_TRACE
_

Patches currently in -mm which might be from tdent48227@gmail.com are

linux-next.patch
drivers-char-ip2-makefile-replace-the-use-of-module-objs-with-module-y.patch
drivers-char-ipmi-makefile-replace-the-use-of-module-objs-with-module-y.patch
drivers-char-mwave-makefile-clean-up.patch
drivers-char-pcmcia-ipwireless-makefile-makefile-replace-the-use-of-module-objs-with-module-y.patch
drivers-char-rio-makefile-replace-the-use-of-module-objs-with-module-y.patch

