From: akpm@linux-foundation.org
Subject: +
 checkpatch-make-sure-a-commit-reference-description-uses-parentheses.patch
 added to -mm tree
Date: Mon, 02 Feb 2015 15:21:32 -0800
Message-ID: <54d0067c.a4yXlZP2UowDuo3Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35411 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070AbbBBXVd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Feb 2015 18:21:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: make sure a commit reference description uses parentheses
has been added to the -mm tree.  Its filename is
     checkpatch-make-sure-a-commit-reference-description-uses-parentheses.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-make-sure-a-commit-reference-description-uses-parentheses.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-make-sure-a-commit-reference-description-uses-parentheses.patch

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
Subject: checkpatch: make sure a commit reference description uses parentheses

The preferred style for a commit reference in a commit log is:

    commit <foo> ("<title line>")

A recent commit removed this check for parentheses.  Add it back.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-make-sure-a-commit-reference-description-uses-parentheses scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-make-sure-a-commit-reference-description-uses-parentheses
+++ a/scripts/checkpatch.pl
@@ -2191,6 +2191,7 @@ sub process {
 			my $case = 1;
 			my $space = 1;
 			my $hasdesc = 0;
+			my $hasparens = 0;
 			my $id = '0123456789ab';
 			my $orig_desc = "commit description";
 			my $description = "";
@@ -2201,10 +2202,12 @@ sub process {
 			$case = 0 if ($line =~ /\b[Cc]ommit\s+[0-9a-f]{5,40}[^A-F]/);
 			if ($line =~ /\bcommit\s+[0-9a-f]{5,}\s+\("([^"]+)"\)/i) {
 				$orig_desc = $1;
+				$hasparens = 1;
 			} elsif ($line =~ /\bcommit\s+[0-9a-f]{5,}\s*$/i &&
 				 defined $rawlines[$linenr] &&
 				 $rawlines[$linenr] =~ /^\s*\("([^"]+)"\)/) {
 				$orig_desc = $1;
+				$hasparens = 1;
 			} elsif ($line =~ /\bcommit\s+[0-9a-f]{5,}\s+\("[^"]+$/i &&
 				 defined $rawlines[$linenr] &&
 				 $rawlines[$linenr] =~ /^\s*[^"]+"\)/) {
@@ -2212,12 +2215,13 @@ sub process {
 				$orig_desc = $1;
 				$rawlines[$linenr] =~ /^\s*([^"]+)"\)/;
 				$orig_desc .= " " . $1;
+				$hasparens = 1;
 			}
 
 			($id, $description) = git_commit_info($orig_commit,
 							      $id, $orig_desc);
 
-			if ($short || $long || $space || $case || ($orig_desc ne $description)) {
+			if ($short || $long || $space || $case || ($orig_desc ne $description) || !$hasparens) {
 				ERROR("GIT_COMMIT_ID",
 				      "Please use git commit description style 'commit <12+ chars of sha1> (\"<title line>\")' - ie: '${init_char}ommit $id (\"$description\")'\n" . $herecurr);
 			}
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
checkpatch-add-likely-unlikely-comparison-misuse-test.patch
checkpatch-add-ability-to-coalesce-commit-descriptions-on-multiple-lines.patch
checkpatch-add-types-for-other-os-typedefs.patch
checkpatch-add-ability-to-fix-unnecessary-blank-lines-around-braces.patch
checkpatch-improve-seq_print-seq_puts-suggestion.patch
checkpatch-improve-no-space-necessary-after-cast-test.patch
checkpatch-neaten-printk_ratelimited-message-position.patch
checkpatch-add-strict-test-for-spaces-around-arithmetic.patch
checkpatch-make-sure-a-commit-reference-description-uses-parentheses.patch
fs-ufs-superc-remove-unnecessary-casting.patch
linux-next.patch

