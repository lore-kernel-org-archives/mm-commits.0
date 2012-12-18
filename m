From: akpm@linux-foundation.org
Subject: [merged] checkpatch-remove-reference-to-feature-removal-scheduletxt.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:06:46 -0800
Message-ID: <20121218200647.2021120004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:55989 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921Ab2LRUGt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:06:49 -0500
Received: by mail-ea0-f202.google.com with SMTP id j12so63438eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:06:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: boyu.mt@taobao.com, apw@canonical.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: remove reference to feature-removal-schedule.txt
has been removed from the -mm tree.  Its filename was
     checkpatch-remove-reference-to-feature-removal-scheduletxt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tao Ma <boyu.mt@taobao.com>
Subject: checkpatch: remove reference to feature-removal-schedule.txt

In 9c0ece069, Linus removes feature-removal-schedule.txt from
Documentation, but there is still some reference to this file.  So remove
them.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
Acked-by: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   37 -------------------------------------
 1 file changed, 37 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-remove-reference-to-feature-removal-scheduletxt scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-remove-reference-to-feature-removal-scheduletxt
+++ a/scripts/checkpatch.pl
@@ -352,27 +352,6 @@ sub deparenthesize {
 
 $chk_signoff = 0 if ($file);
 
-my @dep_includes = ();
-my @dep_functions = ();
-my $removal = "Documentation/feature-removal-schedule.txt";
-if ($tree && -f "$root/$removal") {
-	open(my $REMOVE, '<', "$root/$removal") ||
-				die "$P: $removal: open failed - $!\n";
-	while (<$REMOVE>) {
-		if (/^Check:\s+(.*\S)/) {
-			for my $entry (split(/[, ]+/, $1)) {
-				if ($entry =~ m@include/(.*)@) {
-					push(@dep_includes, $1);
-
-				} elsif ($entry !~ m@/@) {
-					push(@dep_functions, $entry);
-				}
-			}
-		}
-	}
-	close($REMOVE);
-}
-
 my @rawlines = ();
 my @lines = ();
 my $vname;
@@ -3205,22 +3184,6 @@ sub process {
 			}
 		}
 
-# don't include deprecated include files (uses RAW line)
-		for my $inc (@dep_includes) {
-			if ($rawline =~ m@^.\s*\#\s*include\s*\<$inc>@) {
-				ERROR("DEPRECATED_INCLUDE",
-				      "Don't use <$inc>: see Documentation/feature-removal-schedule.txt\n" . $herecurr);
-			}
-		}
-
-# don't use deprecated functions
-		for my $func (@dep_functions) {
-			if ($line =~ /\b$func\b/) {
-				ERROR("DEPRECATED_FUNCTION",
-				      "Don't use $func(): see Documentation/feature-removal-schedule.txt\n" . $herecurr);
-			}
-		}
