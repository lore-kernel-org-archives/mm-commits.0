From: akpm@linux-foundation.org
Subject: + checkpatch-update-logfunctions.patch added to -mm tree
Date: Tue, 17 Jan 2017 15:18:55 -0800
Message-ID: <587ea65f.7q4ED55/2b98If53%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51786 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751651AbdAQX2a (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jan 2017 18:28:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: miles.chen@mediatek.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: update $logFunctions
has been added to the -mm tree.  Its filename is
     checkpatch-update-logfunctions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-update-logfunctions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-update-logfunctions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

dma-debug-add-comment-for-failed-to-check-map-error.patch
checkpatch-update-logfunctions.patch

