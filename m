From: akpm@linux-foundation.org
Subject: + checkpatch-update-signature-might-be-better-as-warning.patch added to -mm tree
Date: Tue, 08 Nov 2011 14:39:57 -0800
Message-ID: <201111082239.pA8MdvmE028540@hpaq13.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:54798 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932562Ab1KHWkH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2011 17:40:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, julia.lawall@lip6.fr


The patch titled
     Subject: checkpatch: update signature "might be better as" warning
has been added to the -mm tree.  Its filename is
     checkpatch-update-signature-might-be-better-as-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: update signature "might be better as" warning

email header lines can look like signature tags.  It's valid to have
multiple email recipients on a single line but not valid to have multiple
signatures on a single line.

Validate signatures only when not in the email headers.

Clear the $in_commit_log flag when the patch filename appears.

Add '-' to the valid chars in a message header for headers
like "Message-Id:" and "In-Reply-To:".

Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Julia Lawall <julia.lawall@lip6.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-update-signature-might-be-better-as-warning scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-update-signature-might-be-better-as-warning
+++ a/scripts/checkpatch.pl
@@ -1504,9 +1504,11 @@ sub process {
 		if ($line =~ /^diff --git.*?(\S+)$/) {
 			$realfile = $1;
 			$realfile =~ s@^([^/]*)/@@;
+			$in_commit_log = 0;
 		} elsif ($line =~ /^\+\+\+\s+(\S+)/) {
 			$realfile = $1;
 			$realfile =~ s@^([^/]*)/@@;
+			$in_commit_log = 0;
 
 			$p1_prefix = $1;
 			if (!$file && $tree && $p1_prefix ne '' &&
@@ -1546,7 +1548,8 @@ sub process {
 		}
 
 # Check signature styles
-		if ($line =~ /^(\s*)($signature_tags)(\s*)(.*)/) {
+		if (!$in_header_lines &&
+		    $line =~ /^(\s*)($signature_tags)(\s*)(.*)/) {
 			my $space_before = $1;
 			my $sign_off = $2;
 			my $space_after = $3;
@@ -1623,7 +1626,7 @@ sub process {
 # Check if it's the start of a commit log
 # (not a header line and we haven't seen the patch filename)
 		if ($in_header_lines && $realfile =~ /^$/ &&
-		    $rawline !~ /^(commit\b|from\b|\w+:).+$/i) {
+		    $rawline !~ /^(commit\b|from\b|[\w-]+:).+$/i) {
 			$in_header_lines = 0;
 			$in_commit_log = 1;
 		}
_
Subject: Subject: checkpatch: update signature "might be better as" warning

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
checkpatch-update-signature-might-be-better-as-warning.patch

