From: akpm@linux-foundation.org
Subject: - char-isicom-use-pr_debug.patch removed from -mm tree
Date: Tue, 08 May 2007 19:57:20 -0700
Message-ID: <200705090257.l492vKcQ010176@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37379 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032771AbXEIC5Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:57:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: isicom, use pr_debug
has been removed from the -mm tree.  Its filename was
     char-isicom-use-pr_debug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: isicom, use pr_debug
From: Jiri Slaby <jirislaby@gmail.com>

isicom, use pr_debug

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/isicom.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/char/isicom.c~char-isicom-use-pr_debug drivers/char/isicom.c
--- a/drivers/char/isicom.c~char-isicom-use-pr_debug
+++ a/drivers/char/isicom.c
@@ -137,11 +137,10 @@
 #define InterruptTheCard(base) outw(0, (base) + 0xc)
 #define ClearInterrupt(base) inw((base) + 0x0a)
 
+#define pr_dbg(str...) pr_debug("ISICOM: " str)
 #ifdef DEBUG
-#define pr_dbg(str...) printk(KERN_DEBUG "ISICOM: " str)
 #define isicom_paranoia_check(a, b, c) __isicom_paranoia_check((a), (b), (c))
 #else
-#define pr_dbg(str...) do { } while (0)
 #define isicom_paranoia_check(a, b, c) 0
 #endif
 
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-dvb.patch
cinergyt2-fix-file-release-handler.patch
auerswald-fix-file-release-handler.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
vmstat-use-our-own-timer-events-fix.patch
shrink_slab-handle-bad-shrinkers.patch
