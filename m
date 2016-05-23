From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-add-support-to-check-already-applied-git-commits.patch removed
 from -mm tree
Date: Mon, 23 May 2016 12:51:43 -0700
Message-ID: <57435f4f.E4DUGXU4TsxyDXXT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38221 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304AbcEWTvo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:51:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: changbin.du@intel.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add support to check already applied git commits
has been removed from the -mm tree.  Its filename was
     checkpatch-add-support-to-check-already-applied-git-commits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Du, Changbin" <changbin.du@intel.com>
Subject: checkpatch: add support to check already applied git commits

It's sometimes useful to scan already committed patches.

Add --git <revision range> to scan specific or multiple commits.

Single commits are scanned with
	--git <rev>
Multiple commits are scanned with
	--git <range>
	--git <commit>-<count>

[joe@perches.com:
o Don't exec git for each <commit>-<count>,
  use a single "git log -<count> <commit>"
o Consolidate the git exec for the <range> and <commit>-<count> variants
o Output 12 character commit hash ids
o Don't scan git commit merges
o Use -M to reduce the size of rename commits]

Signed-off-by: "Du, Changbin" <changbin.du@intel.com>
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   48 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 47 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-support-to-check-already-applied-git-commits scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-support-to-check-already-applied-git-commits
+++ a/scripts/checkpatch.pl
@@ -27,6 +27,7 @@ my $emacs = 0;
 my $terse = 0;
 my $showfile = 0;
 my $file = 0;
+my $git = 0;
 my $check = 0;
 my $check_orig = 0;
 my $summary = 1;
@@ -69,6 +70,16 @@ Options:
   --emacs                    emacs compile window format
   --terse                    one line per report
   --showfile                 emit diffed file position, not input file position
+  -g, --git                  treat FILE as a single commit or git revision range
+                             single git commit with:
+                               <rev>
+                               <rev>^
+                               <rev>~n
+                             multiple git commits with:
+                               <rev1>..<rev2>
+                               <rev1>...<rev2>
+                               <rev>-<count>
+                             git merges are ignored
   -f, --file                 treat FILE as regular source file
   --subjective, --strict     enable more subjective tests
   --list-types               list the possible message types
@@ -174,6 +185,7 @@ GetOptions(
 	'terse!'	=> \$terse,
 	'showfile!'	=> \$showfile,
 	'f|file!'	=> \$file,
+	'g|git!'	=> \$git,
 	'subjective!'	=> \$check,
 	'strict!'	=> \$check,
 	'ignore=s'	=> \@ignore,
@@ -788,10 +800,42 @@ my @fixed_inserted = ();
 my @fixed_deleted = ();
 my $fixlinenr = -1;
 
+# If input is git commits, extract all commits from the commit expressions.
+# For example, HEAD-3 means we need check 'HEAD, HEAD~1, HEAD~2'.
+die "$P: No git repository found\n" if ($git && !-e ".git");
+
+if ($git) {
+	my @commits = ();
+	for my $commit_expr (@ARGV) {
+		my $git_range;
+		if ($commit_expr =~ m/-/) {
+			my @tmp = split(/-/, $commit_expr);
+			die "$P: incorrect git commits expression $commit_expr$!\n"
+			    if (@tmp != 2);
+			$git_range = "-$tmp[1] $tmp[0]";
+		} elsif ($commit_expr =~ m/\.\./) {
+			$git_range = "$commit_expr";
+		}
+		if (defined $git_range) {
+			my $lines = `git log --no-merges --pretty=format:'%H' $git_range`;
+			foreach my $line (split(/\n/, $lines)) {
+				unshift(@commits, $line);
+			}
+		} else {
+			unshift(@commits, $commit_expr);
+		}
+	}
+	die "$P: no git commits after extraction!\n" if (@commits == 0);
+	@ARGV = @commits;
+}
+
 my $vname;
 for my $filename (@ARGV) {
 	my $FILE;
-	if ($file) {
+	if ($git) {
+		open($FILE, '-|', "git format-patch -M --stdout -1 $filename") ||
+			die "$P: $filename: git format-patch failed - $!\n";
+	} elsif ($file) {
 		open($FILE, '-|', "diff -u /dev/null $filename") ||
 			die "$P: $filename: diff failed - $!\n";
 	} elsif ($filename eq '-') {
@@ -802,6 +846,8 @@ for my $filename (@ARGV) {
 	}
 	if ($filename eq '-') {
 		$vname = 'Your patch';
+	} elsif ($git) {
+		$vname = "Commit " . substr($filename, 0, 12) . `git log -1 --pretty=format:' ("%s")' $filename`;
 	} else {
 		$vname = $filename;
 	}
_

Patches currently in -mm which might be from changbin.du@intel.com are


