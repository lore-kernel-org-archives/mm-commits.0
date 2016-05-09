From: akpm@linux-foundation.org
Subject: + checkpatch-improve-git-commit-count-shortcut.patch added to -mm tree
Date: Mon, 09 May 2016 14:40:56 -0700
Message-ID: <573103e8.vL26eQBfeL39N1nB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55680 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055AbcEIVk5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 May 2016 17:40:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve --git <commit-count> shortcut
has been added to the -mm tree.  Its filename is
     checkpatch-improve-git-commit-count-shortcut.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-improve-git-commit-count-shortcut.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-improve-git-commit-count-shortcut.patch

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
Subject: checkpatch: improve --git <commit-count> shortcut

The --git <commit-count> shortcut can be confused by a tag with a dash
like v4.4-rc1.

Improve the test to verify the <commit-count> expression ends with a
dash followed by a numeric value.

Improve the git log result to verify the "<sha1> <subject>" output
as well.

Link: http://lkml.kernel.org/r/c4a3f759291d967641860c3a54bb81177f34325f.1462711962.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-git-commit-count-shortcut scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-git-commit-count-shortcut
+++ a/scripts/checkpatch.pl
@@ -809,11 +809,8 @@ if ($git) {
 	my @commits = ();
 	foreach my $commit_expr (@ARGV) {
 		my $git_range;
-		if ($commit_expr =~ m/-/) {
-			my @tmp = split(/-/, $commit_expr);
-			die "$P: incorrect git commit expression '$commit_expr' $!\n"
-			    if (@tmp != 2);
-			$git_range = "-$tmp[1] $tmp[0]";
+		if ($commit_expr =~ m/^(.*)-(\d+)$/) {
+			$git_range = "-$2 $1";
 		} elsif ($commit_expr =~ m/\.\./) {
 			$git_range = "$commit_expr";
 		} else {
@@ -821,7 +818,8 @@ if ($git) {
 		}
 		my $lines = `git log --no-color --no-merges --pretty=format:'%H %s' $git_range`;
 		foreach my $line (split(/\n/, $lines)) {
-			$line =~ /(^\w+) (.*)/;
+			$line =~ /^([0-9a-fA-F]{40,40}) (.*)$/;
+			next if (!defined($1) || !defined($2));
 			my $sha1 = $1;
 			my $subject = $2;
 			unshift(@commits, $sha1);
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

