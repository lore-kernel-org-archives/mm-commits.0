From: akpm@linux-foundation.org
Subject: + misc-remove-mac-pmu-function-declaration-from-misc-device-class.patch added to -mm tree
Date: Mon, 09 Nov 2009 12:27:46 -0800
Message-ID: <200911092027.nA9KRkxW002907@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41677 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754435AbZKIU1n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2009 15:27:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cascardo@holoscopio.com


The patch titled
     misc: remove MAC pmu function declaration from misc device class
has been added to the -mm tree.  Its filename is
     misc-remove-mac-pmu-function-declaration-from-misc-device-class.patch

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
Subject: misc: remove MAC pmu function declaration from misc device class
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>

Commit 8c8709334cec803368a432a33e0f2e116d48fe07 has removed the
pmu_device_init call from misc_init, but unlike other similar commits,
has not removed its declaration.


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/char/misc.c~misc-remove-mac-pmu-function-declaration-from-misc-device-class drivers/char/misc.c
--- a/drivers/char/misc.c~misc-remove-mac-pmu-function-declaration-from-misc-device-class
+++ a/drivers/char/misc.c
@@ -63,8 +63,6 @@ static DEFINE_MUTEX(misc_mtx);
 #define DYNAMIC_MINORS 64 /* like dynamic majors */
 static unsigned char misc_minors[DYNAMIC_MINORS / 8];
 
-extern int pmu_device_init(void);
