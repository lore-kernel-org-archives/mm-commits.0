From: akpm@linux-foundation.org
Subject: + documentation-networking-wavelantxt-deleted-not-in-tree.patch added to -mm tree
Date: Fri, 11 Jun 2010 13:12:36 -0700
Message-ID: <201006112012.o5BKCa0f017010@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35402 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756640Ab0FKUTv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jun 2010 16:19:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, jt@hpl.hp.com, rdunlap@xenotime.net


The patch titled
     Documentation/networking/wavelan.txt: deleted, not in tree
has been added to the -mm tree.  Its filename is
     documentation-networking-wavelantxt-deleted-not-in-tree.patch

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
Subject: Documentation/networking/wavelan.txt: deleted, not in tree
From: Joe Perches <joe@perches.com>

Commit 1d794e3b353b50ab5d9d46f7c15607f9ec8c78e0 ("Staging: wavelan: delete
the driver") removed the source, so remove the documentation as well.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Jean Tourrilhes <jt@hpl.hp.com>
Acked-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/networking/wavelan.txt |   73 -------------------------
 1 file changed, 73 deletions(-)

diff -puN Documentation/networking/wavelan.txt~documentation-networking-wavelantxt-deleted-not-in-tree /dev/null
--- a/Documentation/networking/wavelan.txt
+++ /dev/null
@@ -1,73 +0,0 @@
-	The Wavelan drivers saga
-	------------------------
-
-	By Jean Tourrilhes <jt@hpl.hp.com>
-
-	The Wavelan is a Radio network adapter designed by
-Lucent. Under this generic name is hidden quite a variety of hardware,
-and many Linux driver to support it.
-	The get the full story on Wireless LANs, please consult :
-		http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/
-
-"wavelan" driver (old ISA Wavelan)
-----------------
-	o Config :	Network device -> Wireless LAN -> AT&T WaveLAN
-	o Location :	.../drivers/net/wireless/wavelan*
-	o in-line doc :	.../drivers/net/wireless/wavelan.p.h
-	o on-line doc :
-	    http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/Wavelan.html
-
-	This is the driver for the ISA version of the first generation
-of the Wavelan, now discontinued. The device is 2 Mb/s, composed of a
-Intel 82586 controller and a Lucent Modem, and is NOT 802.11 compliant.
-	The driver has been tested with the following hardware :
-	o Wavelan ISA 915 MHz (full length ISA card) 
-	o Wavelan ISA 915 MHz 2.0 (half length ISA card) 
-	o Wavelan ISA 2.4 GHz (full length ISA card, fixed frequency) 
-	o Wavelan ISA 2.4 GHz 2.0 (half length ISA card, frequency selectable) 
-	o Above cards with the optional DES encryption feature 
-
-"wavelan_cs" driver (old Pcmcia Wavelan)
--------------------
-	o Config :	Network device -> PCMCIA network ->
-				Pcmcia Wireless LAN -> AT&T/Lucent WaveLAN
-	o Location :	.../drivers/net/pcmcia/wavelan*
-	o in-line doc :	.../drivers/net/pcmcia/wavelan_cs.h
-	o on-line doc :
-	    http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/Wavelan.html
-
-	This is the driver for the PCMCIA version of the first
-generation of the Wavelan, now discontinued. The device is 2 Mb/s,
-composed of a Intel 82593 controller (totally different from the 82586)
-and a Lucent Modem, and NOT 802.11 compatible.
-	The driver has been tested with the following hardware :
-	o Wavelan Pcmcia 915 MHz 2.0 (Pcmcia card + separate
-					modem/antenna block) 
-	o Wavelan Pcmcia 2.4 GHz 2.0 (Pcmcia card + separate
-					modem/antenna block) 
-
-"wvlan_cs" driver (Wavelan IEEE, GPL)
------------------
-	o Config :	Not yet in kernel
-	o Location :	Pcmcia package 3.1.10+
-	o on-line doc :	http://www.fasta.fh-dortmund.de/users/andy/wvlan/
-
-	This is the driver for the current generation of Wavelan IEEE,
-which is 802.11 compatible. Depending on version, it is 2 Mb/s or 11
-Mb/s, with or without encryption, all implemented in Lucent specific
-DSP (the Hermes).
-	This is a GPL full source PCMCIA driver (ISA is just a Pcmcia
-card with ISA-Pcmcia bridge).
-
-"wavelan2_cs" driver (Wavelan IEEE, binary)
---------------------
-	o Config :	Not yet in kernel
-	o Location :	ftp://sourceforge.org/pcmcia/contrib/
-
-	This driver support exactly the same hardware as the previous
-driver, the main difference is that it is based on a binary library
-and supported by Lucent.
-
-	I hope it clears the confusion ;-)
