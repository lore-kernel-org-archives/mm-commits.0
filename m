From: akpm@linux-foundation.org
Subject: + checkpatch-remove-reference-to-feature-removal-scheduletxt.patch added to -mm tree
Date: Wed, 14 Nov 2012 13:45:05 -0800
Message-ID: <20121114214506.154FA200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:44203 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932381Ab2KNVpI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Nov 2012 16:45:08 -0500
Received: by mail-wi0-f202.google.com with SMTP id hm14so66410wib.1
        for <mm-commits@vger.kernel.org>; Wed, 14 Nov 2012 13:45:07 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: boyu.mt@taobao.com, apw@canonical.com, joe@perches.com


The patch titled
     Subject: checkpatch: remove reference to feature-removal-schedule.txt
has been added to the -mm tree.  Its filename is
     checkpatch-remove-reference-to-feature-removal-scheduletxt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
