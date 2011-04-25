From: akpm@linux-foundation.org
Subject: + checkpatch-add-foo_level-and-module_bar-to-80-column-exceptions.patch added to -mm tree
Date: Mon, 25 Apr 2011 14:00:22 -0700
Message-ID: <201104252100.p3PL0M3x009251@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48904 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756795Ab1DYVA0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Apr 2011 17:00:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, apw@canonical.com


The patch titled
     checkpatch: add <foo>_<level> and MODULE_<BAR> to 80 column exceptions
has been added to the -mm tree.  Its filename is
     checkpatch-add-foo_level-and-module_bar-to-80-column-exceptions.patch

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

linux-next.patch
checkpatch-add-check-for-line-continuations-in-quoted-strings.patch
checkpatch-add-foo_level-and-module_bar-to-80-column-exceptions.patch
checkpatch-fix-defect-in-printkkern_level-80-column-exceptions.patch

