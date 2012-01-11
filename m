From: akpm@linux-foundation.org
Subject: [merged] checkpatch-update-signature-might-be-better-as-warning.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:30:55 -0800
Message-ID: <20120111213056.16DD1200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:59532 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933921Ab2AKVa5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:30:57 -0500
Received: by mail-ee0-f74.google.com with SMTP id d41so44333eek.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:30:56 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, julia.lawall@lip6.fr, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: update signature "might be better as" warning
has been removed from the -mm tree.  Its filename was
     checkpatch-update-signature-might-be-better-as-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
maintainers-staging-cx25821-add-l-linux-media.patch
kernelh-neaten-panic-prototype.patch
linkage-remove-unused-noret_and-macro.patch
treewide-remove-useless-noret_type-macro-and-uses.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes.patch
linkage-remove-unused-attrib_noret-macro.patch

