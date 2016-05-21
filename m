From: akpm@linux-foundation.org
Subject: [patch 157/162] checkpatch: improve --git <commit-count> shortcut
Date: Fri, 20 May 2016 17:04:22 -0700
Message-ID: <573fa606.xbM8cx69mZFD+NJZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53209 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbcEUAEX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 20:04:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, joe@perches.com

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
