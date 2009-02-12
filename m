From: akpm@linux-foundation.org
Subject: [merged] w1-w1-temp-calculation-overflow-fix.patch removed from -mm tree
Date: Thu, 12 Feb 2009 12:26:06 -0800
Message-ID: <200902122026.n1CKQ6dc015644@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50742 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758760AbZBLUfo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Feb 2009 15:35:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ian@beware.dropbear.id.au, stable@kernel.org, zbr@ioremap.net, mm-commits@vger.kernel.org


The patch titled
     w1: w1 temp calculation overflow fix
has been removed from the -mm tree.  Its filename was
     w1-w1-temp-calculation-overflow-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: w1: w1 temp calculation overflow fix
From: Ian Dall <ian@beware.dropbear.id.au>

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=12646

When the temperature exceeds 32767 milli-degrees the temperature overflows
to -32768 millidegrees.  These are bothe well within the -55 - +125 degree
range for the sensor.

Fix overflow in left-shift of a u8.

Signed-off-by: Ian Dall <ian@beware.dropbear.id.au>
Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>
Cc: <stable@kernel.org>
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

origin.patch

