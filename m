From: akpm@linux-foundation.org
Subject: [merged] checkpatch-update-logfunctions.patch removed from -mm
 tree
Date: Mon, 27 Feb 2017 12:29:25 -0800
Message-ID: <58b48c25.ATip1zK6Nly4ZPMI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34534 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751583AbdB0Ukd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 15:40:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: miles.chen@mediatek.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: update $logFunctions
has been removed from the -mm tree.  Its filename was
     checkpatch-update-logfunctions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miles Chen <miles.chen@mediatek.com>
Subject: checkpatch: update $logFunctions

Currently checkpatch.pl does not recognize printk_deferred* functions as
log functions and complains about the line length of printk_deferred*
functions.  Add printk_deferred* to logFunctions to fix it.

Link: http://lkml.kernel.org/r/1484537124-18083-1-git-send-email-miles.chen@mediatek.com
Signed-off-by: Miles Chen <miles.chen@mediatek.com>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-update-logfunctions scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-update-logfunctions
+++ a/scripts/checkpatch.pl
@@ -424,7 +424,7 @@ our $typeTypedefs = qr{(?x:
 our $zero_initializer = qr{(?:(?:0[xX])?0+$Int_type?|NULL|false)\b};
 
 our $logFunctions = qr{(?x:
-	printk(?:_ratelimited|_once|)|
+	printk(?:_ratelimited|_once|_deferred_once|_deferred|)|
 	(?:[a-z0-9]+_){1,2}(?:printk|emerg|alert|crit|err|warning|warn|notice|info|debug|dbg|vdbg|devel|cont|WARN)(?:_ratelimited|_once|)|
 	WARN(?:_RATELIMIT|_ONCE|)|
 	panic|
_

Patches currently in -mm which might be from miles.chen@mediatek.com are


