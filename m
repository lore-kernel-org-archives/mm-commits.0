From: akpm@linux-foundation.org
Subject: [merged] checkpatch-add-control-statement-test-to-single_statement_do_while_macro.patch removed from -mm tree
Date: Fri, 24 Aug 2012 11:41:20 -0700
Message-ID: <20120824184120.CE47B100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:48702 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756049Ab2HXSlW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Aug 2012 14:41:22 -0400
Received: by ggnu1 with SMTP id u1so312808ggn.1
        for <mm-commits@vger.kernel.org>; Fri, 24 Aug 2012 11:41:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@canonical.com, franzschrober@yahoo.de, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add control statement test to SINGLE_STATEMENT_DO_WHILE_MACRO
has been removed from the -mm tree.  Its filename was
     checkpatch-add-control-statement-test-to-single_statement_do_while_macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add control statement test to SINGLE_STATEMENT_DO_WHILE_MACRO

commit b13edf7ff2d ("checkpatch: add checks for do {} while (0) macro
misuses") added a test that is overly simplistic for single statement
macros.

Macros that start with control tests should be enclosed
in a do {} while (0) loop.

Add the necessary control tests to the check.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Andy Whitcroft <apw@canonical.com>
Tested-by: Franz Schrober <franzschrober@yahoo.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-control-statement-test-to-single_statement_do_while_macro scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-control-statement-test-to-single_statement_do_while_macro
+++ a/scripts/checkpatch.pl
@@ -3016,7 +3016,8 @@ sub process {
 					$herectx .= raw_line($linenr, $n) . "\n";
 				}
 
-				if (($stmts =~ tr/;/;/) == 1) {
+				if (($stmts =~ tr/;/;/) == 1 &&
+				    $stmts !~ /^\s*(if|while|for|switch)\b/) {
 					WARN("SINGLE_STATEMENT_DO_WHILE_MACRO",
 					     "Single statement macros should not use a do {} while (0) loop\n" . "$herectx");
 				}
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch

