From: akpm@linux-foundation.org
Subject: + w1-w1-temp-calculation-overflow-fix.patch added to -mm tree
Date: Mon, 09 Feb 2009 13:56:51 -0800
Message-ID: <200902092156.n19LupQv016086@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56273 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755791AbZBIV5Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Feb 2009 16:57:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ian@beware.dropbear.id.au, zbr@ioremap.net


The patch titled
     w1: w1 temp calculation overflow fix.
has been added to the -mm tree.  Its filename is
     w1-w1-temp-calculation-overflow-fix.patch

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
Subject: w1: w1 temp calculation overflow fix.
From: Ian Dall <ian@beware.dropbear.id.au>

Fix overflow in left-shift of a u8.

Signed-off-by: Ian Dall <ian@beware.dropbear.id.au>
Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/slaves/w1_therm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/w1/slaves/w1_therm.c~w1-w1-temp-calculation-overflow-fix drivers/w1/slaves/w1_therm.c
--- a/drivers/w1/slaves/w1_therm.c~w1-w1-temp-calculation-overflow-fix
+++ a/drivers/w1/slaves/w1_therm.c
@@ -115,7 +115,7 @@ static struct w1_therm_family_converter 
 
 static inline int w1_DS18B20_convert_temp(u8 rom[9])
 {
-	s16 t = (rom[1] << 8) | rom[0];
+	int t = ((s16)rom[1] << 8) | rom[0];
 	t = t*1000/16;
 	return t;
 }
_

Patches currently in -mm which might be from ian@beware.dropbear.id.au are

w1-w1-temp-calculation-overflow-fix.patch

