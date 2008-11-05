From: akpm@linux-foundation.org
Subject: + linux-serialh-touchup-for-userspace.patch added to -mm tree
Date: Wed, 05 Nov 2008 12:16:29 -0800
Message-ID: <200811052016.mA5KGTPd000483@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44509 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754985AbYKEURI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Nov 2008 15:17:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, alan@lxorguk.ukuu.org.uk


The patch titled
     linux/serial.h: touchup for userspace
has been added to the -mm tree.  Its filename is
     linux-serialh-touchup-for-userspace.patch

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
Subject: linux/serial.h: touchup for userspace
From: Mike Frysinger <vapier@gentoo.org>

The linux/serial.h header has __u32 in some structs it exports to userspace,
so make sure we pull in linux/types.h all the time.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/serial.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/serial.h~linux-serialh-touchup-for-userspace include/linux/serial.h
--- a/include/linux/serial.h~linux-serialh-touchup-for-userspace
+++ a/include/linux/serial.h
@@ -10,8 +10,9 @@
 #ifndef _LINUX_SERIAL_H
 #define _LINUX_SERIAL_H
 
-#ifdef __KERNEL__
 #include <linux/types.h>
+
+#ifdef __KERNEL__
 #include <asm/page.h>
 
 /*
_

Patches currently in -mm which might be from vapier@gentoo.org are

linux-next.patch
linux-timexh-cleanup-for-userspace.patch
m25p80-fix-detection-of-spi-parts.patch
m25p80-fix-detection-of-m25p16-flashes.patch
linux-serialh-touchup-for-userspace.patch

