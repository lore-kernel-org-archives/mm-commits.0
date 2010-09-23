From: akpm@linux-foundation.org
Subject: + viafb-use-proper-register-for-colour-when-doing-fill-ops.patch added to -mm tree
Date: Thu, 23 Sep 2010 16:22:09 -0700
Message-ID: <201009232322.o8NNM93e025381@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47972 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752254Ab0IWXWU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Sep 2010 19:22:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, corbet@lwn.net, dsd@laptop.org, jon.nettleton@gmail.com, stable@kernel.org


The patch titled
     viafb: use proper register for colour when doing fill ops
has been added to the -mm tree.  Its filename is
     viafb-use-proper-register-for-colour-when-doing-fill-ops.patch

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
Subject: viafb: use proper register for colour when doing fill ops
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

The colour was written to a wrong register for fillrect operations.  This
sometimes caused empty console space (for example after 'clear') to have a
different colour than desired.  Fix this by writing to the correct
register.

Many thanks to Daniel Drake and Jon Nettleton for pointing out this issue
and pointing me in the right direction for the fix.

Fixes http://dev.laptop.org/ticket/9323

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Daniel Drake <dsd@laptop.org>
Cc: Jon Nettleton <jon.nettleton@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/accel.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/video/via/accel.c~viafb-use-proper-register-for-colour-when-doing-fill-ops drivers/video/via/accel.c
--- a/drivers/video/via/accel.c~viafb-use-proper-register-for-colour-when-doing-fill-ops
+++ a/drivers/video/via/accel.c
@@ -283,11 +283,12 @@ static int hw_bitblt_2(void __iomem *eng
 		writel(tmp, engine + 0x1C);
 	}
 
-	if (op != VIA_BITBLT_COLOR)
+	if (op == VIA_BITBLT_FILL) {
+		writel(fg_color, engine + 0x58);
+	} else if (op == VIA_BITBLT_MONO) {
 		writel(fg_color, engine + 0x4C);
