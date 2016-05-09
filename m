From: akpm@linux-foundation.org
Subject: + checkpatch-reduce-number-of-git-log-calls-with-git.patch added
 to -mm tree
Date: Mon, 09 May 2016 14:40:54 -0700
Message-ID: <573103e6.elZXujd+DLw5VjeH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55677 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040AbcEIVk4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 May 2016 17:40:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: reduce number of `git log` calls with --git
has been added to the -mm tree.  Its filename is
     checkpatch-reduce-number-of-git-log-calls-with-git.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-reduce-number-of-git-log-calls-with-git.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-reduce-number-of-git-log-calls-with-git.patch

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
Subject: checkpatch: reduce number of `git log` calls with --git

checkpatch currently calls git log multiple times to first get the
<revision range> sha1 values and again to get the subject for each
individual sha1 commit.

Always get the sha1 and subject at the same time instead.  Store the
subject in a sha1 hash to avoid the second git log exec.

Link: http://lkml.kernel.org/r/274efab2332ad2308ab5de85a95d255f6e2de5f3.1462711962.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-reduce-number-of-git-log-calls-with-git scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-reduce-number-of-git-log-calls-with-git
+++ a/scripts/checkpatch.pl
@@ -28,6 +28,7 @@ my $terse = 0;
 my $showfile = 0;
 my $file = 0;
 my $git = 0;
+my %git_commits = ();
 my $check = 0;
 my $check_orig = 0;
 my $summary = 1;
@@ -806,23 +807,25 @@ die "$P: No git repository found\n" if (
 
 if ($git) {
 	my @commits = ();
-	for my $commit_expr (@ARGV) {
+	foreach my $commit_expr (@ARGV) {
 		my $git_range;
 		if ($commit_expr =~ m/-/) {
 			my @tmp = split(/-/, $commit_expr);
-			die "$P: incorrect git commits expression $commit_expr$!\n"
+			die "$P: incorrect git commit expression '$commit_expr' $!\n"
 			    if (@tmp != 2);
 			$git_range = "-$tmp[1] $tmp[0]";
 		} elsif ($commit_expr =~ m/\.\./) {
 			$git_range = "$commit_expr";
-		}
-		if (defined $git_range) {
-			my $lines = `git log --no-merges --pretty=format:'%H' $git_range`;
-			foreach my $line (split(/\n/, $lines)) {
-				unshift(@commits, $line);
-			}
 		} else {
-			unshift(@commits, $commit_expr);
+			$git_range = "-1 $commit_expr";
+		}
+		my $lines = `git log --no-color --no-merges --pretty=format:'%H %s' $git_range`;
+		foreach my $line (split(/\n/, $lines)) {
+			$line =~ /(^\w+) (.*)/;
+			my $sha1 = $1;
+			my $subject = $2;
+			unshift(@commits, $sha1);
+			$git_commits{$sha1} = $subject;
 		}
 	}
 	die "$P: no git commits after extraction!\n" if (@commits == 0);
@@ -847,7 +850,7 @@ for my $filename (@ARGV) {
 	if ($filename eq '-') {
 		$vname = 'Your patch';
 	} elsif ($git) {
-		$vname = "Commit " . substr($filename, 0, 12) . `git log -1 --pretty=format:' ("%s")' $filename`;
+		$vname = "Commit " . substr($filename, 0, 12) . ' ("' . $git_commits{$filename} . '")';
 	} else {
 		$vname = $filename;
 	}
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-add-prefer_is_enabled-test.patch
checkpatch-improve-constant_comparison-test-for-structure-members.patch
checkpatch-add-test-for-keywords-not-starting-on-tabstops.patch
checkpatch-whine-about-access_once.patch
checkpatch-advertise-the-fix-and-fix-inplace-options-more.patch
checkpatch-add-list-types-to-show-message-types-to-show-or-ignore.patch
checkpatch-reduce-number-of-git-log-calls-with-git.patch
checkpatch-improve-git-commit-count-shortcut.patch

