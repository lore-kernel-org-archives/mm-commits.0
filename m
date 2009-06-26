From: akpm@linux-foundation.org
Subject: + lis3-fix-typo.patch added to -mm tree
Date: Fri, 26 Jun 2009 14:32:44 -0700
Message-ID: <200906262132.n5QLWidf023498@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49948 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752116AbZFZVc7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jun 2009 17:32:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: daniel@caiaq.de, eric.piel@tremplin-utc.net, pavel@ucw.cz


The patch titled
     lis3: fix typo
has been added to the -mm tree.  Its filename is
     lis3-fix-typo.patch

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
Subject: lis3: fix typo
From: Daniel Mack <daniel@caiaq.de>

Bit 0x80 in CTRL_REG3 is an ACTIVE_LOW rather than an ACTIVE_HIGH
function, I got that wrong during my last change.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Eric Piel <eric.piel@tremplin-utc.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/lis3lv02d.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/lis3lv02d.h~lis3-fix-typo include/linux/lis3lv02d.h
--- a/include/linux/lis3lv02d.h~lis3-fix-typo
+++ a/include/linux/lis3lv02d.h
@@ -32,7 +32,7 @@ struct lis3lv02d_platform_data {
 #define LIS3_IRQ2_DATA_READY	(4 << 3)
 #define LIS3_IRQ2_CLICK		(7 << 3)
 #define LIS3_IRQ_OPEN_DRAIN	(1 << 6)
-#define LIS3_IRQ_ACTIVE_HIGH	(1 << 7)
+#define LIS3_IRQ_ACTIVE_LOW	(1 << 7)
 	unsigned char irq_cfg;
 };
 
_

Patches currently in -mm which might be from daniel@caiaq.de are

lis3-fix-typo.patch
lis3-add-free-fall-wakeup-function-via-platform_data.patch
lis3-add-power-management-functions.patch
lis3_spi-code-cleanups.patch

