From: akpm@linux-foundation.org
Subject: [patch 44/94] checkpatch: add TP_printk to list of logging
 functions
Date: Fri, 17 Nov 2017 15:28:48 -0800
Message-ID: <20171117232848.L-PdJ-0Qt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55658 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759270AbdKQX2u (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:28:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, mm-commits@vger.kernel.org, songliubraving@fb.com, torvalds@linux-foundation.org

From: Joe Perches <joe@perches.com>
Subject: checkpatch: add TP_printk to list of logging functions

So the line length check can be bypassed by its callers.

Link: http://lkml.kernel.org/r/7de542c08a6e79f2ebe7c1416c9f403c23fdcc09.1508282823.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Song Liu <songliubraving@fb.com>
Tested-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    1 +
 1 file changed, 1 insertion(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-tp_printk-to-list-of-logging-functions scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-tp_printk-to-list-of-logging-functions
+++ a/scripts/checkpatch.pl
@@ -454,6 +454,7 @@ our $zero_initializer = qr{(?:(?:0[xX])?
 our $logFunctions = qr{(?x:
 	printk(?:_ratelimited|_once|_deferred_once|_deferred|)|
 	(?:[a-z0-9]+_){1,2}(?:printk|emerg|alert|crit|err|warning|warn|notice|info|debug|dbg|vdbg|devel|cont|WARN)(?:_ratelimited|_once|)|
+	TP_printk|
 	WARN(?:_RATELIMIT|_ONCE|)|
 	panic|
 	MODULE_[A-Z_]+|
_
