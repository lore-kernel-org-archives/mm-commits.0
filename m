From: akpm@linux-foundation.org
Subject: + checkpatch-consolidate-if-foo-barfoo-checks-and-add-debugfs_remove.patch added to -mm tree
Date: Tue, 20 Nov 2012 11:53:12 -0800
Message-ID: <20121120195313.1B3F820005C@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:60451 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab2KTTxQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Nov 2012 14:53:16 -0500
Received: by mail-ea0-f202.google.com with SMTP id j12so101940eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 20 Nov 2012 11:53:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@canonical.com, const@MakeLinux.com, joe@perches.com


The patch titled
     Subject: checkpatch: consolidate if (foo) bar(foo) checks and add debugfs_remove
has been added to the -mm tree.  Its filename is
     checkpatch-consolidate-if-foo-barfoo-checks-and-add-debugfs_remove.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andy Whitcroft <apw@canonical.com>
Subject: checkpatch: consolidate if (foo) bar(foo) checks and add debugfs_remove

Consolidate the if (foo) bar(foo) detectors into a single check.  Add
debugfs_remove and family.

Based on a patch by Constantine Shulyupin.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Cc: Constantine Shulyupin <const@MakeLinux.com>.
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-consolidate-if-foo-barfoo-checks-and-add-debugfs_remove scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-consolidate-if-foo-barfoo-checks-and-add-debugfs_remove
+++ a/scripts/checkpatch.pl
@@ -3198,20 +3198,12 @@ sub process {
 				$herecurr);
 		}
 
-# check for needless kfree() checks
-		if ($prevline =~ /\bif\s*\(([^\)]*)\)/) {
-			my $expr = $1;
-			if ($line =~ /\bkfree\(\Q$expr\E\);/) {
-				WARN("NEEDLESS_KFREE",
-				     "kfree(NULL) is safe this check is probably not required\n" . $hereprev);
-			}
-		}
-# check for needless usb_free_urb() checks
-		if ($prevline =~ /\bif\s*\(([^\)]*)\)/) {
-			my $expr = $1;
-			if ($line =~ /\busb_free_urb\(\Q$expr\E\);/) {
-				WARN("NEEDLESS_USB_FREE_URB",
-				     "usb_free_urb(NULL) is safe this check is probably not required\n" . $hereprev);
+# check for needless "if (<foo>) fn(<foo>)" uses
+		if ($prevline =~ /\bif\s*\(\s*($Lval)\s*\)/) {
+			my $expr = '\s*\(\s*' . quotemeta($1) . '\s*\)\s*;';
+			if ($line =~ /\b(kfree|usb_free_urb|debugfs_remove(?:_recursive)?)$expr/) {
+				WARN('NEEDLESS_IF',
+				     "$1(NULL) is safe this check is probably not required\n" . $hereprev);
 			}
 		}
 
_

Patches currently in -mm which might be from apw@canonical.com are

checkpatch-warn-on-unnecessary-line-continuations.patch
checkpatch-warn-about-using-config_experimental.patch
checkpatch-remove-reference-to-feature-removal-scheduletxt.patch
checkpatch-consolidate-if-foo-barfoo-checks-and-add-debugfs_remove.patch

