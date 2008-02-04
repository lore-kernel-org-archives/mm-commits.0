From: akpm@linux-foundation.org
Subject: - dio-array_size-cleanup-update.patch removed from -mm tree
Date: Sun, 03 Feb 2008 20:05:25 -0800
Message-ID: <200802040405.m14456Av013061@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42446 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754532AbYBDEFy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 3 Feb 2008 23:05:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex@flawedcode.org, geert@linux-m68k.org, ricknu-0@student.ltu.se, mm-commits@vger.kernel.org


The patch titled
     dio: ARRAY_SIZE() cleanup (update)
has been removed from the -mm tree.  Its filename was
     dio-array_size-cleanup-update.patch

This patch was dropped because it was folded into dio-array_size-cleanup.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dio: ARRAY_SIZE() cleanup (update)
From: Alejandro Martinez Ruiz <alex@flawedcode.org>

dio: ARRAY_SIZE() cleanup

[Geert: eliminate NUMNAMES, as suggested by Richard Knutsson ]
[akpm@linux-foundation.org: coding-syle fixes]
Signed-off-by: Alejandro Martinez Ruiz <alex@flawedcode.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Richard Knutsson <ricknu-0@student.ltu.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dio/dio.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/dio/dio.c~dio-array_size-cleanup-update drivers/dio/dio.c
--- a/drivers/dio/dio.c~dio-array_size-cleanup-update
+++ a/drivers/dio/dio.c
@@ -88,8 +88,6 @@ static struct dioname names[] = 
 #undef DIONAME
 #undef DIOFBNAME
 
-#define NUMNAMES ARRAY_SIZE(names)
-
 static const char *unknowndioname 
         = "unknown DIO board -- please email <linux-m68k@lists.linux-m68k.org>!";
 
@@ -97,7 +95,7 @@ static const char *dio_getname(int id)
 {
         /* return pointer to a constant string describing the board with given ID */
 	unsigned int i;
-        for (i = 0; i < NUMNAMES; i++)
+	for (i = 0; i < ARRAY_SIZE(names); i++)
                 if (names[i].id == id) 
                         return names[i].name;
 
_

Patches currently in -mm which might be from alex@flawedcode.org are

origin.patch
m68k-array_size-cleanup.patch
dio-array_size-cleanup.patch
dio-array_size-cleanup-update.patch
