From: akpm@linux-foundation.org
Subject: - checkpatch-improve-type-matcher-debug.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:26:36 -0700
Message-ID: <200807242326.m6ONQaQN010993@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53931 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755897AbYGXX0o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:26:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: improve type matcher debug
has been removed from the -mm tree.  Its filename was
     checkpatch-improve-type-matcher-debug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: improve type matcher debug
From: Andy Whitcroft <apw@shadowen.org>

Improve type matcher debug so we can see what it does match.  As part
of this move us to to using the common debug framework.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-type-matcher-debug scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-type-matcher-debug
+++ a/scripts/checkpatch.pl
@@ -17,7 +17,6 @@ my $quiet = 0;
 my $tree = 1;
 my $chk_signoff = 1;
 my $chk_patch = 1;
-my $tst_type = 0;
 my $tst_only;
 my $emacs = 0;
 my $terse = 0;
@@ -44,7 +43,6 @@ GetOptions(
 	'summary-file!'	=> \$summary_file,
 
 	'debug=s'	=> \%debug,
-	'test-type!'	=> \$tst_type,
 	'test-only=s'	=> \$tst_only,
 ) or exit;
 
@@ -67,6 +65,7 @@ if ($#ARGV < 0) {
 
 my $dbg_values = 0;
 my $dbg_possible = 0;
+my $dbg_type = 0;
 for my $key (keys %debug) {
 	eval "\${dbg_$key} = '$debug{$key}';"
 }
@@ -1307,8 +1306,12 @@ sub process {
 		if ($line=~/^[^\+]/) {next;}
 
 # TEST: allow direct testing of the type matcher.
-		if ($tst_type && $line =~ /^.$Declare$/) {
-			ERROR("TEST: is type $Declare\n" . $herecurr);
+		if ($dbg_type) {
+			if ($line =~ /^.\s*$Declare\s*$/) {
+				ERROR("TEST: is type\n" . $herecurr);
+			} elsif ($dbg_type > 1 && $line =~ /^.+($Declare)/) {
+				ERROR("TEST: is not type ($1 is)\n". $herecurr);
+			}
 			next;
 		}
 
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
x86-implement-pte_special.patch
x86-implement-pte_special-fix.patch
mm-introduce-get_user_pages_fast.patch
mm-introduce-get_user_pages_fast-fix.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-2.patch
x86-lockless-get_user_pages_fast-fix-2-fix-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
page-owner-tracking-leak-detector.patch

