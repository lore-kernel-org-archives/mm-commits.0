From: akpm@linux-foundation.org
Subject: + documentation-dvb-bt8xxtxt-update.patch added to -mm tree
Date: Wed, 23 May 2007 01:16:12 -0700
Message-ID: <200705230816.l4N8GGgl019645@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45728 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756506AbXEWIRE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 May 2007 04:17:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: uwe.bugla@gmx.de, manu@linuxtv.org, mchehab@infradead.org


The patch titled
     Documentation/dvb/bt8xx.txt update
has been added to the -mm tree.  Its filename is
     documentation-dvb-bt8xxtxt-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Documentation/dvb/bt8xx.txt update
From: "Uwe Bugla" <uwe.bugla@gmx.de>

This patch synchronizes the Documentation for bt8xx-based cards to the
actual state of kernel 2.6.22-rc1.

Signed-off-by: Uwe Bugla <uwe.bugla@gmx.de>
Signed-off-by: Manu Abraham <manu@linuxtv.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dvb/bt8xx.txt |   32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff -puN Documentation/dvb/bt8xx.txt~documentation-dvb-bt8xxtxt-update Documentation/dvb/bt8xx.txt
--- a/Documentation/dvb/bt8xx.txt~documentation-dvb-bt8xxtxt-update
+++ a/Documentation/dvb/bt8xx.txt
@@ -9,19 +9,29 @@ for accessing the i2c bus and the gpio p
 Please see Documentation/dvb/cards.txt => o Cards based on the Conexant Bt8xx PCI bridge:
 
 Compiling kernel please enable:
-a.)"Device drivers" => "Multimedia devices" => "Video For Linux" => "BT848 Video For Linux"
-b.)"Device drivers" => "Multimedia devices" => "Digital Video Broadcasting Devices"
- => "DVB for Linux" "DVB Core Support" "Bt8xx based PCI Cards"
+a.)"Device drivers" => "Multimedia devices" => "Video For Linux" => "Enable Video for Linux API 1 (DEPRECATED)"
+b.)"Device drivers" => "Multimedia devices" => "Video For Linux" => "Video Capture Adapters" => "BT848 Video For Linux"
+c.)"Device drivers" => "Multimedia devices" => "Digital Video Broadcasting Devices" => "DVB for Linux" "DVB Core Support" "Bt8xx based PCI Cards"
+
+Please use the following options with care as deselection of drivers which are in fact necessary
+may result in DVB devices that cannot be tuned due to lack of driver support:
+You can save RAM by deselecting every frontend module that your DVB card does not need.
+
+First please remove the static dependency of DVB card drivers on all frontend modules for all possible card variants by enabling:
+d.) "Device drivers" => "Multimedia devices" => "Digital Video Broadcasting Devices"
+ => "DVB for Linux" "DVB Core Support" "Load and attach frontend modules as needed"
+
+If you know the frontend driver that your card needs please enable:
+e.)"Device drivers" => "Multimedia devices" => "Digital Video Broadcasting Devices"
+ => "DVB for Linux" "DVB Core Support" "Customise DVB Frontends" => "Customise the frontend modules to build"
+ Then please select your card-specific frontend module.
 
 2) Loading Modules
 ==================
 
-In default cases bttv is loaded automatically.
-To load the backend either place dvb-bt8xx in etc/modules, or apply manually:
-
-	$ modprobe dvb-bt8xx
-
-All frontends will be loaded automatically.
+Regular case: If the bttv driver detects a bt8xx-based DVB card, all frontend and backend modules will be loaded automatically.
+Exceptions are:
+- Old TwinHan DST cards or clones with or without CA slot and not containing an Eeprom.
 People running udev please see Documentation/dvb/udev.txt.
 
 In the following cases overriding the PCI type detection for dvb-bt8xx might be necessary:
@@ -30,7 +40,6 @@ In the following cases overriding the PC
 ------------------------------
 
 	$ modprobe bttv card=113
-	$ modprobe dvb-bt8xx
 	$ modprobe dst
 
 Useful parameters for verbosity level and debugging the dst module:
@@ -65,10 +74,9 @@ DViCO FusionHDTV 5 Lite:	135
 Notice: The order of the card ID should be uprising:
 Example:
 	$ modprobe bttv card=113 card=135
-	$ modprobe dvb-bt8xx
 
 For a full list of card ID's please see Documentation/video4linux/CARDLIST.bttv.
-In case of further problems send questions to the mailing list: www.linuxdvb.org.
+In case of further problems please subscribe and send questions to the mailing list: linux-dvb@linuxtv.org.
 
 Authors: Richard Walker,
 	 Jamie Honan,
_

Patches currently in -mm which might be from uwe.bugla@gmx.de are

documentation-dvb-bt8xxtxt-update.patch
