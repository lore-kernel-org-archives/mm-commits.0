From: akpm@linux-foundation.org
Subject: [merged] checkpatch-add-check-for-use-of-sizeof-without-parenthesis.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:51:41 -0700
Message-ID: <20120731185142.0FD2A20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:50337 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756333Ab2GaSvn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:51:43 -0400
Received: by mail-ey0-f202.google.com with SMTP id o12so241482eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:51:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@canonical.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: Add acheck for use of sizeof without parenthesis
has been removed from the -mm tree.  Its filename was
     checkpatch-add-check-for-use-of-sizeof-without-parenthesis.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: Add acheck for use of sizeof without parenthesis

Kernel style uses parenthesis around sizeof.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-check-for-use-of-sizeof-without-parenthesis scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-check-for-use-of-sizeof-without-parenthesis
+++ a/scripts/checkpatch.pl
@@ -3265,6 +3265,12 @@ sub process {
 			     "sizeof(& should be avoided\n" . $herecurr);
 		}
 
+# check for sizeof without parenthesis
+		if ($line =~ /\bsizeof\s+((?:\*\s*|)$Lval|$Type(?:\s+$Lval|))/) {
+			WARN("SIZEOF_PARENTHESIS",
+			     "sizeof $1 should be sizeof($1)\n" . $herecurr);
+		}
+
 # check for line continuations in quoted strings with odd counts of "
 		if ($rawline =~ /\\$/ && $rawline =~ tr/"/"/ % 2) {
 			WARN("LINE_CONTINUATIONS",
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
dynamic_debug-restore-dev_dbg-netdev_dbg-functionality-reduce-stack-use.patch
dynamic_debug-restore-dev_dbg-netdev_dbg-functionality-reduce-stack-use-v2.patch
linux-next.patch
thermal-add-renesas-r-car-thermal-sensor-support.patch

