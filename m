From: akpm@linux-foundation.org
Subject: + checkpatch-add-strict-test-for-switch-default-missing-break.patch added to -mm tree
Date: Wed, 12 Dec 2012 12:58:03 -0800
Message-ID: <20121212205804.1B750200061@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:42962 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932169Ab2LLU6G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 15:58:06 -0500
Received: by mail-we0-f202.google.com with SMTP id t57so66833wey.1
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 12:58:05 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, apw@canonical.com, peter.senna@gmail.com


The patch titled
     Subject: checkpatch: add --strict test for switch/default missing break
has been added to the -mm tree.  Its filename is
     checkpatch-add-strict-test-for-switch-default-missing-break.patch

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
Subject: checkpatch: add --strict test for switch/default missing break

switch default case is sometimes written as "default:;".  This can cause
new cases added below the default to be defective.

Suggest adding a break; after empty default cases to avoid fallthrough
defects.

Fixed indentation in the other semicolon test above it.

Suggested-by: Peter Senna Tschudin <peter.senna@gmail.com>
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-strict-test-for-switch-default-missing-break scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-strict-test-for-switch-default-missing-break
+++ a/scripts/checkpatch.pl
@@ -3450,8 +3450,22 @@ sub process {
 
 # check for multiple semicolons
 		if ($line =~ /;\s*;\s*$/) {
-		    WARN("ONE_SEMICOLON",
-			 "Statements terminations use 1 semicolon\n" . $herecurr);
+			WARN("ONE_SEMICOLON",
+			     "Statements terminations use 1 semicolon\n" . $herecurr);
+		}
+
+# check for switch/default statements without a break;
+		if ($^V && $^V ge 5.10.0 &&
+		    defined $stat &&
+		    $stat =~ /^\+[$;\s]*(?:case[$;\s]+\w+[$;\s]*:[$;\s]*|)*[$;\s]*\bdefault[$;\s]*:[$;\s]*;/g) {
+			my $ctx = '';
+			my $herectx = $here . "\n";
+			my $cnt = statement_rawlines($stat);
+			for (my $n = 0; $n < $cnt; $n++) {
+				$herectx .= raw_line($linenr, $n) . "\n";
+			}
+			WARN("DEFAULT_NO_BREAK",
+			     "switch default: should use break\n" . $herectx);
 		}
 
 # check for gcc specific __FUNCTION__
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
printk-boot_delay-should-only-affect-output.patch
maintainers-chinese-maintainers-mailing-list-is-subscribers-only.patch
checkpatch-warn-on-unnecessary-line-continuations.patch
checkpatch-warn-about-using-config_experimental.patch
checkpatch-remove-reference-to-feature-removal-scheduletxt.patch
checkpatch-consolidate-if-foo-barfoo-checks-and-add-debugfs_remove.patch
checkpatch-allow-control-over-line-length-warning-default-remains-80.patch
checkpatch-extend-line-continuation-test.patch
checkpatch-add-strict-messages-for-blank-lines-around-braces.patch
checkpatch-warn-when-declaring-struct-spinlock-foo.patch
checkpatch-add-strict-test-for-switch-default-missing-break.patch
kstrto-add-documentation.patch
simple_strto-annotate-function-as-obsolete.patch

