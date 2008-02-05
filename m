From: akpm@linux-foundation.org
Subject: - dio-array_size-cleanup.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:34:32 -0800
Message-ID: <200802052234.m15MYDvA012495@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60798 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762682AbYBEWmd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:42:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex@flawedcode.org, geert@linux-m68k.org, ricknu-0@student.ltu.se, mm-commits@vger.kernel.org


The patch titled
     dio: ARRAY_SIZE() cleanup
has been removed from the -mm tree.  Its filename was
     dio-array_size-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dio: ARRAY_SIZE() cleanup
From: Alejandro Martinez Ruiz <alex@flawedcode.org>

[Geert: eliminate NUMNAMES, as suggested by Richard Knutsson ]
[akpm@linux-foundation.org: coding-syle fixes]
Signed-off-by: Alejandro Martinez Ruiz <alex@flawedcode.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Richard Knutsson <ricknu-0@student.ltu.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dio/dio.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/dio/dio.c~dio-array_size-cleanup drivers/dio/dio.c
--- a/drivers/dio/dio.c~dio-array_size-cleanup
+++ a/drivers/dio/dio.c
@@ -88,8 +88,6 @@ static struct dioname names[] = 
 #undef DIONAME
 #undef DIOFBNAME
 
-#define NUMNAMES (sizeof(names) / sizeof(struct dioname))
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
