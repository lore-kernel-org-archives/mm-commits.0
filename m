From: akpm@linux-foundation.org
Subject: + checkpatchpl-update-logfunctions.patch added to -mm tree
Date: Wed, 13 Jul 2011 16:17:04 -0700
Message-ID: <201107132317.p6DNH4lg009621@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48491 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752859Ab1GMXRI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Jul 2011 19:17:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, apw@canonical.com, kvalo@qca.qualcomm.com


The patch titled
     checkpatch.pl: update $logFunctions
has been added to the -mm tree.  Its filename is
     checkpatchpl-update-logfunctions.patch

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
Subject: checkpatch.pl: update $logFunctions
From: Joe Perches <joe@perches.com>

Allow numbers in leading prefix.
Add logging functions with _once and _ratelimit.
Add <prefix>_printk.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatchpl-update-logfunctions scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatchpl-update-logfunctions
+++ a/scripts/checkpatch.pl
@@ -257,9 +257,9 @@ our $typeTypedefs = qr{(?x:
 )};
 
 our $logFunctions = qr{(?x:
-	printk|
-	[a-z]+_(emerg|alert|crit|err|warning|warn|notice|info|debug|dbg|vdbg|devel|cont|WARN)|
-	WARN|
+	printk(?:_ratelimited|_once|)|
+	[a-z0-9]+_(?:printk|emerg|alert|crit|err|warning|warn|notice|info|debug|dbg|vdbg|devel|cont|WARN)(?:_ratelimited|_once|)|
+	WARN(?:_RATELIMIT|_ONCE|)|
 	panic|
 	MODULE_[A-Z_]+
 )};
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
maintainers-orphan-framerelay-dlci.patch
drivers-use-kzalloc-kcalloc-instead-of-kmallocmemset-where-possible.patch
get_maintainerspl-improve-mailmap-parsing.patch
maintainers-update-high-resolution-timers-patterns.patch
checkpatch-suggest-using-min_t-or-max_t-v2.patch
checkpatch-add-__rcu-as-a-sparse-modifier.patch
checkpatch-validate-signature-styles-and-to-and-cc-lines.patch
checkpatch-add-a-prefer-__aligned-check.patch
checkpatchpl-add-ability-to-ignore-various-messages.patch
checkpatch-make-utf-8-test-strict.patch
checkpatchpl-update-logfunctions.patch
ramoops-use-module-parameters-instead-of-platform-data-if-not-available.patch
ramoops-use-module-parameters-instead-of-platform-data-if-not-available-checkpatch-fixes.patch
ramoops-add-new-line-to-each-print.patch

