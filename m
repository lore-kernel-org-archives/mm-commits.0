From: akpm@linux-foundation.org
Subject: [merged] checkpatch-consolidate-if-foo-barfoo-checks-and-add-debugfs_remove.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:06:50 -0800
Message-ID: <20121218200651.2088420004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f73.google.com ([209.85.215.73]:61758 "EHLO
	mail-la0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947Ab2LRUGx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:06:53 -0500
Received: by mail-la0-f73.google.com with SMTP id d3so63468lah.2
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:06:52 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, const@MakeLinux.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: consolidate if (foo) bar(foo) checks and add debugfs_remove
has been removed from the -mm tree.  Its filename was
     checkpatch-consolidate-if-foo-barfoo-checks-and-add-debugfs_remove.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

