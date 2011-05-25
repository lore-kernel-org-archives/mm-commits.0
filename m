From: akpm@linux-foundation.org
Subject: [merged] checkpatch-add-foo_level-and-module_bar-to-80-column-exceptions.patch removed from -mm tree
Date: Wed, 25 May 2011 13:32:28 -0700
Message-ID: <201105252030.p4PKUpUM015000@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50565 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932225Ab1EYUb0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:31:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@canonical.com, mm-commits@vger.kernel.org


The patch titled
     checkpatch: add <foo>_<level> and MODULE_<BAR> to 80 column exceptions
has been removed from the -mm tree.  Its filename was
     checkpatch-add-foo_level-and-module_bar-to-80-column-exceptions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: add <foo>_<level> and MODULE_<BAR> to 80 column exceptions
From: Joe Perches <joe@perches.com>

Many module or file local logging functions use specific prefixes other
than pr|dev|netdev.  Allow all forms like foo_printk and foo_err to be
longer than 80 columns.

Also allow MODULE_<BAR> declarations to be longer than 80 columns.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-foo_level-and-module_bar-to-80-column-exceptions scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-foo_level-and-module_bar-to-80-column-exceptions
+++ a/scripts/checkpatch.pl
@@ -210,10 +210,10 @@ our $typeTypedefs = qr{(?x:
 
 our $logFunctions = qr{(?x:
 	printk|
-	pr_(debug|dbg|vdbg|devel|info|warning|err|notice|alert|crit|emerg|cont)|
-	(dev|netdev|netif)_(printk|dbg|vdbg|info|warn|err|notice|alert|crit|emerg|WARN)|
+	[a-z]+_(emerg|alert|crit|err|warning|warn|notice|info|debug|dbg|vdbg|devel|cont|WARN)|
 	WARN|
-	panic
+	panic|
+	MODULE_[A-Z_]+
 )};
 
 our @typeList = (
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
checkpatch-suggest-using-min_t-or-max_t.patch

