From: akpm@linux-foundation.org
Subject: + viafb-remove-dead-code.patch added to -mm tree
Date: Tue, 22 Dec 2009 15:59:23 -0800
Message-ID: <200912222359.nBMNxNCe032297@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41775 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751537AbZLVX7u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Dec 2009 18:59:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn, krzysztof.h1@poczta.fm


The patch titled
     viafb: remove dead code
has been added to the -mm tree.  Its filename is
     viafb-remove-dead-code.patch

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
