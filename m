Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43638C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:05:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 245BA611C8
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:05:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345284AbhIIVG0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:06:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:55914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346415AbhIIVGB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:06:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8975F611C4;
        Thu,  9 Sep 2021 21:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221491;
        bh=cd45iVyCAGOY7ln8l4MWGSrn41HAGAMXqMrZtRpEBwY=;
        h=Date:From:To:Subject:From;
        b=NPQYrIMFGKp9O57fjH9pTR4F/hu0IhCQ4ieVq3NO98pmdlmdMrN2ygsZnKQRZ8l3p
         ODTlRox/nGvBwso0XG88HsJHTxhfCeCnccNFhOu4mBgwXM/GzXKCnxEl9yn8aL2oCy
         Ps3qshpB0NmSgNNAv/BA/QMIq1aAnGwzjwJhG6aQ=
Date:   Thu, 09 Sep 2021 14:04:51 -0700
From:   akpm@linux-foundation.org
To:     dwaipayanray1@gmail.com, efremov@linux.com, joe@perches.com,
        lukas.bulwahn@gmail.com, mm-commits@vger.kernel.org
Subject:  [merged] checkpatch-improve-git_commit_id-test.patch
 removed from -mm tree
Message-ID: <20210909210451.J6LJzxEyS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve GIT_COMMIT_ID test
has been removed from the -mm tree.  Its filename was
     checkpatch-improve-git_commit_id-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: improve GIT_COMMIT_ID test

The preferred git commit id reference has the form

	commit <SHA-1> ("Title line")

where SHA-1 is the commit hex hash with a minimum lenth of 12 and ("Title
line") is the complete title line of the commit with a (" prefix and ")
suffix.

The current tests fail when the "Title line" has one or more embedded
double quotes.

Improve the test that finds the commit SHA-1 hex hash then ("Title line")
by using $balanced_parens for a maximum of 3 consecutive lines.

[akpm@linux-foundation.org: add missing &&]
Link: https://lkml.kernel.org/r/976c6cdd680db4b55ae31b5fc2d1779da5c0dc66.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Denis Efremov <efremov@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   82 ++++++++++++++++++++++++----------------
 1 file changed, 51 insertions(+), 31 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-improve-git_commit_id-test
+++ a/scripts/checkpatch.pl
@@ -1181,7 +1181,8 @@ sub git_commit_info {
 #		    git log --format='%H %s' -1 $line |
 #		    echo "commit $(cut -c 1-12,41-)"
 #		done
-	} elsif ($lines[0] =~ /^fatal: ambiguous argument '$commit': unknown revision or path not in the working tree\./) {
+	} elsif ($lines[0] =~ /^fatal: ambiguous argument '$commit': unknown revision or path not in the working tree\./ ||
+		 $lines[0] =~ /^fatal: bad object $commit/) {
 		$id = undef;
 	} else {
 		$id = substr($lines[0], 0, 12);
@@ -2587,6 +2588,8 @@ sub process {
 	my $reported_maintainer_file = 0;
 	my $non_utf8_charset = 0;
 
+	my $last_git_commit_id_linenr = -1;
+
 	my $last_blank_line = 0;
 	my $last_coalesced_string_linenr = -1;
 
@@ -3170,10 +3173,20 @@ sub process {
 		}
 
 # Check for git id commit length and improperly formed commit descriptions
-		if ($in_commit_log && !$commit_log_possible_stack_dump &&
+# A correctly formed commit description is:
+#    commit <SHA-1 hash length 12+ chars> ("Complete commit subject")
+# with the commit subject '("' prefix and '")' suffix
+# This is a fairly compilicated block as it tests for what appears to be
+# bare SHA-1 hash with  minimum length of 5.  It also avoids several types of
+# possible SHA-1 matches.
+# A commit match can span multiple lines so this block attempts to find a
+# complete typical commit on a maximum of 3 lines
+		if ($perl_version_ok &&
+		    $in_commit_log && !$commit_log_possible_stack_dump &&
 		    $line !~ /^\s*(?:Link|Patchwork|http|https|BugLink|base-commit):/i &&
 		    $line !~ /^This reverts commit [0-9a-f]{7,40}/ &&
-		    ($line =~ /\bcommit\s+[0-9a-f]{5,}\b/i ||
+		    (($line =~ /\bcommit\s+[0-9a-f]{5,}\b/i ||
+		      ($line =~ /\bcommit\s*$/i && defined($rawlines[$linenr]) && $rawlines[$linenr] =~ /^\s*[0-9a-f]{5,}\b/i)) ||
 		     ($line =~ /(?:\s|^)[0-9a-f]{12,40}(?:[\s"'\(\[]|$)/i &&
 		      $line !~ /[\<\[][0-9a-f]{12,40}[\>\]]/i &&
 		      $line !~ /\bfixes:\s*[0-9a-f]{12,40}/i))) {
@@ -3183,49 +3196,56 @@ sub process {
 			my $long = 0;
 			my $case = 1;
 			my $space = 1;
-			my $hasdesc = 0;
-			my $hasparens = 0;
 			my $id = '0123456789ab';
 			my $orig_desc = "commit description";
 			my $description = "";
+			my $herectx = $herecurr;
+			my $has_parens = 0;
+			my $has_quotes = 0;
+
+			my $input = $line;
+			if ($line =~ /(?:\bcommit\s+[0-9a-f]{5,}|\bcommit\s*$)/i) {
+				for (my $n = 0; $n < 2; $n++) {
+					if ($input =~ /\bcommit\s+[0-9a-f]{5,}\s*($balanced_parens)/i) {
+						$orig_desc = $1;
+						$has_parens = 1;
+						# Always strip leading/trailing parens then double quotes if existing
+						$orig_desc = substr($orig_desc, 1, -1);
+						if ($orig_desc =~ /^".*"$/) {
+							$orig_desc = substr($orig_desc, 1, -1);
+							$has_quotes = 1;
+						}
+						last;
+					}
+					last if ($#lines < $linenr + $n);
+					$input .= " " . trim($rawlines[$linenr + $n]);
+					$herectx .= "$rawlines[$linenr + $n]\n";
+				}
+				$herectx = $herecurr if (!$has_parens);
+			}
 
-			if ($line =~ /\b(c)ommit\s+([0-9a-f]{5,})\b/i) {
+			if ($input =~ /\b(c)ommit\s+([0-9a-f]{5,})\b/i) {
 				$init_char = $1;
 				$orig_commit = lc($2);
-			} elsif ($line =~ /\b([0-9a-f]{12,40})\b/i) {
+				$short = 0 if ($input =~ /\bcommit\s+[0-9a-f]{12,40}/i);
+				$long = 1 if ($input =~ /\bcommit\s+[0-9a-f]{41,}/i);
+				$space = 0 if ($input =~ /\bcommit [0-9a-f]/i);
+				$case = 0 if ($input =~ /\b[Cc]ommit\s+[0-9a-f]{5,40}[^A-F]/);
+			} elsif ($input =~ /\b([0-9a-f]{12,40})\b/i) {
 				$orig_commit = lc($1);
 			}
 
-			$short = 0 if ($line =~ /\bcommit\s+[0-9a-f]{12,40}/i);
-			$long = 1 if ($line =~ /\bcommit\s+[0-9a-f]{41,}/i);
-			$space = 0 if ($line =~ /\bcommit [0-9a-f]/i);
-			$case = 0 if ($line =~ /\b[Cc]ommit\s+[0-9a-f]{5,40}[^A-F]/);
-			if ($line =~ /\bcommit\s+[0-9a-f]{5,}\s+\("([^"]+)"\)/i) {
-				$orig_desc = $1;
-				$hasparens = 1;
-			} elsif ($line =~ /\bcommit\s+[0-9a-f]{5,}\s*$/i &&
-				 defined $rawlines[$linenr] &&
-				 $rawlines[$linenr] =~ /^\s*\("([^"]+)"\)/) {
-				$orig_desc = $1;
-				$hasparens = 1;
-			} elsif ($line =~ /\bcommit\s+[0-9a-f]{5,}\s+\("[^"]+$/i &&
-				 defined $rawlines[$linenr] &&
-				 $rawlines[$linenr] =~ /^\s*[^"]+"\)/) {
-				$line =~ /\bcommit\s+[0-9a-f]{5,}\s+\("([^"]+)$/i;
-				$orig_desc = $1;
-				$rawlines[$linenr] =~ /^\s*([^"]+)"\)/;
-				$orig_desc .= " " . $1;
-				$hasparens = 1;
-			}
-
 			($id, $description) = git_commit_info($orig_commit,
 							      $id, $orig_desc);
 
 			if (defined($id) &&
-			   ($short || $long || $space || $case || ($orig_desc ne $description) || !$hasparens)) {
+			    ($short || $long || $space || $case || ($orig_desc ne $description) || !$has_quotes) &&
+			    $last_git_commit_id_linenr != $linenr - 1) {
 				ERROR("GIT_COMMIT_ID",
-				      "Please use git commit description style 'commit <12+ chars of sha1> (\"<title line>\")' - ie: '${init_char}ommit $id (\"$description\")'\n" . $herecurr);
+				      "Please use git commit description style 'commit <12+ chars of sha1> (\"<title line>\")' - ie: '${init_char}ommit $id (\"$description\")'\n" . $herectx);
 			}
+			#don't report the next line if this line ends in commit and the sha1 hash is the next line
+			$last_git_commit_id_linenr = $linenr if ($line =~ /\bcommit\s*$/i);
 		}
 
 # Check for added, moved or deleted files
_

Patches currently in -mm which might be from joe@perches.com are


