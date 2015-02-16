From: akpm@linux-foundation.org
Subject: [merged] checkpatch-update-git-commit-message.patch removed from
 -mm tree
Date: Mon, 16 Feb 2015 12:17:14 -0800
Message-ID: <54e2504a.svrkc7eHmj44NecE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51040 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbbBPURv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:17:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, chris@rorvick.com, daniel.baluta@intel.com, prarit@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: update git commit message
has been removed from the -mm tree.  Its filename was
     checkpatch-update-git-commit-message.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: update git commit message

The git commit message can be confusing,

Try to clarify the message a bit to reduce the confusion when emitted.

Show the correct form using
	Please use git commit description style 'commit <12+ chars of sha1> ("<title line>")'
and if the git commit sha1 is unique, show
the right sha1 to use with the actual title

Signed-off-by: Joe Perches <joe@perches.com>
Original-patch-by: Prarit Bhargava <prarit@redhat.com>
Tested-by: Chris Rorvick <chris@rorvick.com>
Acked-by: Prarit Bhargava <prarit@redhat.com>
Cc: Daniel Baluta <daniel.baluta@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   45 ++++++++++++++++++++++++++++------------
 1 file changed, 32 insertions(+), 13 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-update-git-commit-message scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-update-git-commit-message
+++ a/scripts/checkpatch.pl
@@ -634,6 +634,8 @@ sub git_commit_info {
 	$output =~ s/^\s*//gm;
 	my @lines = split("\n", $output);
 
+	return ($id, $desc) if ($#lines < 0);
+
 	if ($lines[0] =~ /^error: short SHA1 $commit is ambiguous\./) {
 # Maybe one day convert this block of bash into something that returns
 # all matching commit ids, but it's very slow...
@@ -2173,21 +2175,38 @@ sub process {
 			      "Remove Gerrit Change-Id's before submitting upstream.\n" . $herecurr);
 		}
 
-# Check for improperly formed commit descriptions
-		if ($in_commit_log &&
-		    $line =~ /\bcommit\s+[0-9a-f]{5,}/i &&
-		    !($line =~ /\b[Cc]ommit [0-9a-f]{12,40} \("/ ||
-		      ($line =~ /\b[Cc]ommit [0-9a-f]{12,40}\s*$/ &&
-		       defined $rawlines[$linenr] &&
-		       $rawlines[$linenr] =~ /^\s*\("/))) {
-			$line =~ /\b(c)ommit\s+([0-9a-f]{5,})/i;
+# Check for git id commit length and improperly formed commit descriptions
+		if ($in_commit_log && $line =~ /\b(c)ommit\s+([0-9a-f]{5,})/i) {
 			my $init_char = $1;
 			my $orig_commit = lc($2);
-			my $id = '01234567890ab';
-			my $desc = 'commit description';
-		        ($id, $desc) = git_commit_info($orig_commit, $id, $desc);
-			ERROR("GIT_COMMIT_ID",
-			      "Please use 12 or more chars for the git commit ID like: '${init_char}ommit $id (\"$desc\")'\n" . $herecurr);
+			my $short = 1;
+			my $long = 0;
+			my $case = 1;
+			my $space = 1;
+			my $hasdesc = 0;
+			my $id = '0123456789ab';
+			my $orig_desc = "commit description";
+			my $description = "";
+
+			$short = 0 if ($line =~ /\bcommit\s+[0-9a-f]{12,40}/i);
+			$long = 1 if ($line =~ /\bcommit\s+[0-9a-f]{41,}/i);
+			$space = 0 if ($line =~ /\bcommit [0-9a-f]/i);
+			$case = 0 if ($line =~ /\b[Cc]ommit\s+[0-9a-f]{5,40}[^A-F]/);
+			if ($line =~ /\bcommit\s+[0-9a-f]{5,}\s+\("([^"]+)"\)/i) {
+				$orig_desc = $1;
+			} elsif ($line =~ /\bcommit\s+[0-9a-f]{5,}\s*$/i &&
+				 defined $rawlines[$linenr] &&
+				 $rawlines[$linenr] =~ /^\s*\("([^"]+)"\)/) {
+				$orig_desc = $1;
+			}
+
+			($id, $description) = git_commit_info($orig_commit,
+							      $id, $orig_desc);
+
+			if ($short || $long || $space || $case || ($orig_desc ne $description)) {
+				ERROR("GIT_COMMIT_ID",
+				      "Please use git commit description style 'commit <12+ chars of sha1> (\"<title line>\")' - ie: '${init_char}ommit $id (\"$description\")'\n" . $herecurr);
+			}
 		}
 
 # Check for added, moved or deleted files
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-ufs-superc-remove-unnecessary-casting.patch
linux-next.patch

