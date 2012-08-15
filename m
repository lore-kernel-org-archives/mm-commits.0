From: akpm@linux-foundation.org
Subject: + checkpatch-add-control-statement-test-to-single_statement_do_while_macro.patch added to -mm tree
Date: Wed, 15 Aug 2012 15:06:24 -0700
Message-ID: <20120815220625.41E9F5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:43134 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751287Ab2HOWG2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2012 18:06:28 -0400
Received: by lagw12 with SMTP id w12so97733lag.1
        for <mm-commits@vger.kernel.org>; Wed, 15 Aug 2012 15:06:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, apw@canonical.com, franzschrober@yahoo.de, sfr@canb.auug.org.au


The patch titled
     Subject: checkpatch: add control statement test to SINGLE_STATEMENT_DO_WHILE_MACRO
has been added to the -mm tree.  Its filename is
     checkpatch-add-control-statement-test-to-single_statement_do_while_macro.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
checkpatch-add-control-statement-test-to-single_statement_do_while_macro.patch

