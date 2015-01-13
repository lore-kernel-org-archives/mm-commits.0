From: akpm@linux-foundation.org
Subject: + checkpatch-update-git-commit-message.patch added to -mm tree
Date: Mon, 12 Jan 2015 16:19:15 -0800
Message-ID: <54b46483.uLz9M62BHtAubXv6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37506 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbbAMATQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jan 2015 19:19:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, chris@rorvick.com, daniel.baluta@intel.com, prarit@redhat.com, mm-commits@vger.kernel.org


The patch titled
     From: Joe Perches <joe@perches.com>
has been added to the -mm tree.  Its filename is
     checkpatch-update-git-commit-message.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-update-git-commit-message.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-update-git-commit-message.patch

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
Subject: checkpatch: Update git commit message

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

printk-correct-timeout-comment-neaten-module_parm_desc.patch
mm-utilc-add-kstrimdup.patch
checkpatch-emit-an-error-when-using-predefined-timestamp-macros.patch
checkpatch-improve-octal-permissions-tests.patch
checkpatch-ignore-__pure-attribute.patch
checkpatch-fix-unnecessary_kern_level-false-positive.patch
checkpatch-add-check-for-keyword-boolean-in-kconfig-definitions.patch
checkpatch-allow-comments-in-macros-tested-for-single-statements.patch
checkpatch-update-git-commit-message.patch
fs-ufs-superc-remove-unnecessary-casting.patch
linux-next.patch

