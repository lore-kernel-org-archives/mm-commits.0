From: akpm@linux-foundation.org
Subject: - input-i8042-fix-warning-on-non-x86-builds.patch removed from -mm tree
Date: Mon, 17 Mar 2008 14:00:12 -0700
Message-ID: <200803172100.m2HL0C5d030838@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33201 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753938AbYCQVAl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 17:00:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdreier@cisco.com, dtor@mail.ru, rolandd@cisco.com, mm-commits@vger.kernel.org


The patch titled
     Input: i8042: fix warning on non-x86 builds
has been removed from the -mm tree.  Its filename was
     input-i8042-fix-warning-on-non-x86-builds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-input.patch
git-nfsd.patch
git-watchdog.patch

