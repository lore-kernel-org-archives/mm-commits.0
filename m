From: akpm@linux-foundation.org
Subject: + fbdev-rename-imacfbtxt-to-efifbtxt-and-change-imacfb-to-efifb.patch added to -mm tree
Date: Wed, 31 Mar 2010 16:24:50 -0700
Message-ID: <201003312324.o2VNOogp015099@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57081 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754576Ab0CaXZH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Mar 2010 19:25:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: justinmattock@gmail.com, geert@linux-m68k.org


The patch titled
     fbdev: Rename imacfb.txt to efifb.txt and change imacfb to efifb.
has been added to the -mm tree.  Its filename is
     fbdev-rename-imacfbtxt-to-efifbtxt-and-change-imacfb-to-efifb.patch

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
Subject: fbdev: Rename imacfb.txt to efifb.txt and change imacfb to efifb.
From: "Justin P. Mattock" <justinmattock@gmail.com>

Rename imacfb.txt to efifb.txt since imacfb was moved to efifb,and change
imacfb to efifb.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/fb/efifb.txt  |   31 +++++++++++++++++++++++++++++++
 Documentation/fb/imacfb.txt |   31 -------------------------------
 2 files changed, 31 insertions(+), 31 deletions(-)

diff -puN /dev/null Documentation/fb/efifb.txt
--- /dev/null
+++ a/Documentation/fb/efifb.txt
@@ -0,0 +1,31 @@
+
+What is efifb?
+===============
+
+This is a generic EFI platform driver for Intel based Apple computers.
+efifb is only for EFI booted Intel Macs.
+
+Supported Hardware
+==================
+
+iMac 17"/20"
+Macbook
+Macbook Pro 15"/17"
+MacMini
+
+How to use it?
+==============
+
+efifb does not have any kind of autodetection of your machine.
+You have to add the following kernel parameters in your elilo.conf:
+	Macbook :
+		video=efifb:macbook
+	MacMini :
+		video=efifb:mini
+	Macbook Pro 15", iMac 17" :
+		video=efifb:i17
+	Macbook Pro 17", iMac 20" :
+		video=efifb:i20
+
+--
+Edgar Hucek <gimli@dark-green.com>
diff -puN Documentation/fb/imacfb.txt~fbdev-rename-imacfbtxt-to-efifbtxt-and-change-imacfb-to-efifb /dev/null
--- a/Documentation/fb/imacfb.txt
+++ /dev/null
@@ -1,31 +0,0 @@
-
-What is imacfb?
-===============
-
-This is a generic EFI platform driver for Intel based Apple computers.
-Imacfb is only for EFI booted Intel Macs.
-
-Supported Hardware
-==================
-
-iMac 17"/20"
-Macbook
-Macbook Pro 15"/17"
-MacMini
-
-How to use it?
-==============
-
-Imacfb does not have any kind of autodetection of your machine.
-You have to add the following kernel parameters in your elilo.conf:
-	Macbook :
-		video=imacfb:macbook
-	MacMini :
-		video=imacfb:mini
-	Macbook Pro 15", iMac 17" :
-		video=imacfb:i17
-	Macbook Pro 17", iMac 20" :
-		video=imacfb:i20
