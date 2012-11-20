From: akpm@linux-foundation.org
Subject: + checkpatch-extend-line-continuation-test.patch added to -mm tree
Date: Tue, 20 Nov 2012 14:57:12 -0800
Message-ID: <20121120225713.1032E20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:65035 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab2KTW5P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Nov 2012 17:57:15 -0500
Received: by mail-la0-f74.google.com with SMTP id v3so427594lag.1
        for <mm-commits@vger.kernel.org>; Tue, 20 Nov 2012 14:57:14 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, jg1.han@samsung.com


The patch titled
     Subject: checkpatch: extend line continuation test
has been added to the -mm tree.  Its filename is
     checkpatch-extend-line-continuation-test.patch

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
Subject: checkpatch: extend line continuation test

Preprocessor directives and asm statements should be allowed to have a
line continuation.

Signed-off-by: Joe Perches <joe@perches.com>
Tested-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-extend-line-continuation-test scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-extend-line-continuation-test
+++ a/scripts/checkpatch.pl
@@ -3009,10 +3009,12 @@ sub process {
 				}
 			}
 
-# check for line continuations outside of #defines
+# check for line continuations outside of #defines, preprocessor #, and asm
 
 		} else {
 			if ($prevline !~ /^..*\\$/ &&
+			    $line !~ /^\+\s*\#.*\\$/ &&		# preprocessor
+			    $line !~ /^\+.*\b(__asm__|asm)\b.*\\$/ &&	# asm
 			    $line =~ /^\+.*\\$/) {
 				WARN("LINE_CONTINUATIONS",
 				     "Avoid unnecessary line continuations\n" . $herecurr);
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
printk-boot_delay-should-only-affect-output.patch
checkpatch-warn-on-unnecessary-line-continuations.patch
checkpatch-warn-about-using-config_experimental.patch
checkpatch-remove-reference-to-feature-removal-scheduletxt.patch
checkpatch-consolidate-if-foo-barfoo-checks-and-add-debugfs_remove.patch
checkpatch-allow-control-over-line-length-warning-default-remains-80.patch
checkpatch-extend-line-continuation-test.patch
kstrto-add-documentation.patch
simple_strto-annotate-function-as-obsolete.patch

