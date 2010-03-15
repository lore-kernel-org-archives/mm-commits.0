From: akpm@linux-foundation.org
Subject: [merged] viafb-remove-dead-code.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:55:59 -0400
Message-ID: <201003150656.o2F6uWL4016288@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40675 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934451Ab0COG4k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:56:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     viafb: remove dead code
has been removed from the -mm tree.  Its filename was
     viafb-remove-dead-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: viafb: remove dead code
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

Remove a completly unused function.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/via_utility.c |   12 ------------
 drivers/video/via/via_utility.h |    1 -
 2 files changed, 13 deletions(-)

diff -puN drivers/video/via/via_utility.c~viafb-remove-dead-code drivers/video/via/via_utility.c
--- a/drivers/video/via/via_utility.c~viafb-remove-dead-code
+++ a/drivers/video/via/via_utility.c
@@ -239,15 +239,3 @@ void viafb_get_gamma_support_state(int b
 	else
 		*support_state = CRT_Device | DVI_Device | LCD_Device;
 }
-
-int viafb_input_parameter_converter(int parameter_value)
-{
-	int result;
-
-	if (parameter_value >= 1 && parameter_value <= 9)
-		result = 1 << (parameter_value - 1);
-	else
-		result = 1;
