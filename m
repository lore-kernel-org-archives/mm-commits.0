From: akpm@linux-foundation.org
Subject: + checkpatch-rename-variables-to-avoid-confusion.patch added to
 -mm tree
Date: Tue, 05 Sep 2017 16:41:22 -0700
Message-ID: <59af3622.ERVBbFpIaTI6nrjS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42612 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753652AbdIEXlX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Sep 2017 19:41:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdelvare@suse.de, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: rename variables to avoid confusion
has been added to the -mm tree.  Its filename is
     checkpatch-rename-variables-to-avoid-confusion.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-rename-variables-to-avoid-confusion.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-rename-variables-to-avoid-confusion.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jean Delvare <jdelvare@suse.de>
Subject: checkpatch: rename variables to avoid confusion

The variable name "$msg_type" is sometimes used to set the message type,
and sometimes used to set the message level.  This works but is kind of
confusing.  Use "$msg_level" in the latter case instead, to make the code
clearer.

Link: http://lkml.kernel.org/r/20170902175345.175db33a@endymion
Signed-off-by: Jean Delvare <jdelvare@suse.de>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-rename-variables-to-avoid-confusion scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-rename-variables-to-avoid-confusion
+++ a/scripts/checkpatch.pl
@@ -2715,10 +2715,10 @@ sub process {
 				my $typo_fix = $spelling_fix{lc($typo)};
 				$typo_fix = ucfirst($typo_fix) if ($typo =~ /^[A-Z]/);
 				$typo_fix = uc($typo_fix) if ($typo =~ /^[A-Z]+$/);
-				my $msg_type = \&WARN;
-				$msg_type = \&CHK if ($file);
-				if (&{$msg_type}("TYPO_SPELLING",
-						 "'$typo' may be misspelled - perhaps '$typo_fix'?\n" . $herecurr) &&
+				my $msg_level = \&WARN;
+				$msg_level = \&CHK if ($file);
+				if (&{$msg_level}("TYPO_SPELLING",
+						  "'$typo' may be misspelled - perhaps '$typo_fix'?\n" . $herecurr) &&
 				    $fix) {
 					$fixed[$fixlinenr] =~ s/(^|[^A-Za-z@])($typo)($|[^A-Za-z@])/$1$typo_fix$3/;
 				}
@@ -2753,10 +2753,10 @@ sub process {
 		    $rawline =~ /\b59\s+Temple\s+Pl/i ||
 		    $rawline =~ /\b51\s+Franklin\s+St/i) {
 			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
-			my $msg_type = \&ERROR;
-			$msg_type = \&CHK if ($file);
-			&{$msg_type}("FSF_MAILING_ADDRESS",
-				     "Do not include the paragraph about writing to the Free Software Foundation's mailing address from the sample GPL notice. The FSF has changed addresses in the past, and may do so again. Linux already includes a copy of the GPL.\n" . $herevet)
+			my $msg_level = \&ERROR;
+			$msg_level = \&CHK if ($file);
+			&{$msg_level}("FSF_MAILING_ADDRESS",
+				      "Do not include the paragraph about writing to the Free Software Foundation's mailing address from the sample GPL notice. The FSF has changed addresses in the past, and may do so again. Linux already includes a copy of the GPL.\n" . $herevet)
 		}
 
 # check for Kconfig help text having a real description
@@ -3810,10 +3810,10 @@ sub process {
 
 # avoid BUG() or BUG_ON()
 		if ($line =~ /\b(?:BUG|BUG_ON)\b/) {
-			my $msg_type = \&WARN;
-			$msg_type = \&CHK if ($file);
-			&{$msg_type}("AVOID_BUG",
-				     "Avoid crashing the kernel - try using WARN_ON & recovery code rather than BUG() or BUG_ON()\n" . $herecurr);
+			my $msg_level = \&WARN;
+			$msg_level = \&CHK if ($file);
+			&{$msg_level}("AVOID_BUG",
+				      "Avoid crashing the kernel - try using WARN_ON & recovery code rather than BUG() or BUG_ON()\n" . $herecurr);
 		}
 
 # avoid LINUX_VERSION_CODE
@@ -4339,11 +4339,11 @@ sub process {
 
 					# messages are ERROR, but ?: are CHK
 					if ($ok == 0) {
-						my $msg_type = \&ERROR;
-						$msg_type = \&CHK if (($op eq '?:' || $op eq '?' || $op eq ':') && $ctx =~ /VxV/);
+						my $msg_level = \&ERROR;
+						$msg_level = \&CHK if (($op eq '?:' || $op eq '?' || $op eq ':') && $ctx =~ /VxV/);
 
-						if (&{$msg_type}("SPACING",
-								 "spaces required around that '$op' $at\n" . $hereptr)) {
+						if (&{$msg_level}("SPACING",
+								  "spaces required around that '$op' $at\n" . $hereptr)) {
 							$good = rtrim($fix_elements[$n]) . " " . trim($fix_elements[$n + 1]) . " ";
 							if (defined $fix_elements[$n + 2]) {
 								$fix_elements[$n + 2] =~ s/^\s+//;
_

Patches currently in -mm which might be from jdelvare@suse.de are

checkpatch-fix-typo-in-comment.patch
checkpatch-rename-variables-to-avoid-confusion.patch
checkpatch-add-6-missing-types-to-list-types.patch

