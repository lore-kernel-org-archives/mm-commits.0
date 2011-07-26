From: akpm@linux-foundation.org
Subject: [merged] checkpatchpl-update-logfunctions.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:56:13 -0700
Message-ID: <201107260755.p6Q7tGot003443@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58819 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753117Ab1GZH4J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:56:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@canonical.com, kvalo@qca.qualcomm.com, mm-commits@vger.kernel.org


The patch titled
     checkpatch.pl: update $logFunctions
has been removed from the -mm tree.  Its filename was
     checkpatchpl-update-logfunctions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch.pl: update $logFunctions
From: Joe Perches <joe@perches.com>

Previous behavior allowed only alphabetic prefixes like pr_info to exceed
the 80 column line length limit.

ath6kl wants to add a digit into the prefix, so allow numbers as well as
digits in the <prefix>_<level> printks.

<prefix>_<level>_ratelimited and <prefix>_<level>_once and WARN_RATELIMIT
and WARN_ONCE may now exceed 80 cols.

Add missing <prefix>_printk type for completeness.

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

origin.patch
linux-next.patch
maintainers-orphan-framerelay-dlci.patch
ramoops-use-module-parameters-instead-of-platform-data-if-not-available.patch
ramoops-use-module-parameters-instead-of-platform-data-if-not-available-checkpatch-fixes.patch
ramoops-add-new-line-to-each-print.patch

