From: akpm@linux-foundation.org
Subject: [merged] checkpatch-add-strict-test-for-switch-default-missing-break.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:07:00 -0800
Message-ID: <20121218200700.BA11282004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:55620 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978Ab2LRUHB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:07:01 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so125705qcq.5
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:07:01 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@canonical.com, peter.senna@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add --strict test for switch/default missing break
has been removed from the -mm tree.  Its filename was
     checkpatch-add-strict-test-for-switch-default-missing-break.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -3448,8 +3448,22 @@ sub process {
 
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

