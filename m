From: akpm@linux-foundation.org
Subject: + tridentfb-convert-is_blade-and-is_xp-macros-into-functions.patch added to -mm tree
Date: Mon, 05 May 2008 23:12:27 -0700
Message-ID: <200805060612.m466CRkB025137@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37752 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754415AbYEFGNA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 02:13:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@pol.net


The patch titled
     tridentfb: convert is_blade and is_xp macros into functions
has been added to the -mm tree.  Its filename is
     tridentfb-convert-is_blade-and-is_xp-macros-into-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tridentfb: convert is_blade and is_xp macros into functions
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch converts the is_blade() and is_xp() macros into local functions.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tridentfb.c |   19 +++++++++++++++++++
 include/video/trident.h   |   19 -------------------
 2 files changed, 19 insertions(+), 19 deletions(-)

diff -puN drivers/video/tridentfb.c~tridentfb-convert-is_blade-and-is_xp-macros-into-functions drivers/video/tridentfb.c
--- a/drivers/video/tridentfb.c~tridentfb-convert-is_blade-and-is_xp-macros-into-functions
+++ a/drivers/video/tridentfb.c
@@ -78,6 +78,25 @@ MODULE_PARM_DESC(fp, "Define if flatpane
 module_param(crt, int, 0);
 MODULE_PARM_DESC(crt, "Define if CRT is connected");
 
+static int is_blade(int id)
+{
+	return	(id == BLADE3D) ||
+		(id == CYBERBLADEE4) ||
+		(id == CYBERBLADEi7) ||
+		(id == CYBERBLADEi7D) ||
+		(id == CYBERBLADEi1) ||
+		(id == CYBERBLADEi1D) ||
+		(id == CYBERBLADEAi1) ||
+		(id == CYBERBLADEAi1D);
+}
+
+static int is_xp(int id)
+{
+	return	(id == CYBERBLADEXPAi1) ||
+		(id == CYBERBLADEXPm8) ||
+		(id == CYBERBLADEXPm16);
+}
+
 static int is3Dchip(int id)
 {
 	return ((id == BLADE3D) || (id == CYBERBLADEE4) ||
diff -puN include/video/trident.h~tridentfb-convert-is_blade-and-is_xp-macros-into-functions include/video/trident.h
--- a/include/video/trident.h~tridentfb-convert-is_blade-and-is_xp-macros-into-functions
+++ a/include/video/trident.h
@@ -39,25 +39,6 @@
 #define CYBERBLADEXPm8  0x9910
 #define CYBERBLADEXPm16 0x9930
 
-/* acceleration families */
-#define IMAGE	0
-#define BLADE	1
-#define XP	2
-
-#define is_image(id)	
-#define is_xp(id)	((id == CYBERBLADEXPAi1) ||\
-			 (id == CYBERBLADEXPm8) ||\
-			 (id == CYBERBLADEXPm16)) 
-
-#define is_blade(id)	((id == BLADE3D) ||\
-			 (id == CYBERBLADEE4) ||\
-			 (id == CYBERBLADEi7) ||\
-			 (id == CYBERBLADEi7D) ||\
-			 (id == CYBERBLADEi1) ||\
-			 (id == CYBERBLADEi1D) ||\
-			 (id ==	CYBERBLADEAi1) ||\
-			 (id ==	CYBERBLADEAi1D))
