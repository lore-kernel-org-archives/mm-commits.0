From: akpm@linux-foundation.org
Subject: + input-i8042-fix-warning-on-non-x86-builds.patch added to -mm tree
Date: Fri, 08 Feb 2008 21:05:12 -0800
Message-ID: <200802090505.m1954r9F031128@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32837 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751001AbYBIFMU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 9 Feb 2008 00:12:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rdreier@cisco.com, dtor@mail.ru, rolandd@cisco.com


The patch titled
     Input: i8042: fix warning on non-x86 builds
has been added to the -mm tree.  Its filename is
     input-i8042-fix-warning-on-non-x86-builds.patch

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
Subject: Input: i8042: fix warning on non-x86 builds
From: Roland Dreier <rdreier@cisco.com>

Commit c18bab80 ("Input: i8042 - non-x86 build fix") introduced the
following warning on non-x86 builds:

    drivers/input/serio/i8042.c: In function 'i8042_probe':
    drivers/input/serio/i8042.c:1154: warning: unused variable 'param'

Fix this by moving the parameter variable declaration into the #ifdef too.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/serio/i8042.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/input/serio/i8042.c~input-i8042-fix-warning-on-non-x86-builds drivers/input/serio/i8042.c
--- a/drivers/input/serio/i8042.c~input-i8042-fix-warning-on-non-x86-builds
+++ a/drivers/input/serio/i8042.c
@@ -1151,7 +1151,6 @@ static int __devinit i8042_setup_kbd(voi
 static int __devinit i8042_probe(struct platform_device *dev)
 {
 	int error;
-	char param;
 
 	error = i8042_controller_selftest();
 	if (error)
@@ -1174,7 +1173,7 @@ static int __devinit i8042_probe(struct 
 	}
 #ifdef CONFIG_X86
 	if (i8042_dritek) {
-		param = 0x90;
+		char param = 0x90;
 		error = i8042_command(&param, 0x1059);
 		if (error)
 			goto out_fail;
_

Patches currently in -mm which might be from rdreier@cisco.com are

origin.patch
input-i8042-fix-warning-on-non-x86-builds.patch
