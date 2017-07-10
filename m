From: akpm@linux-foundation.org
Subject: [patch 101/115] checkpatch: remove false warning for
 commit reference
Date: Mon, 10 Jul 2017 15:52:16 -0700
Message-ID: <20170710225216.5paFquaJz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43544 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754106AbdGJWwR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:52:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, xypron.glpk@gmx.de

From: Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: checkpatch: remove false warning for commit reference

Checkpatch warns of an incorrect commit reference style for any
hexadecimal number of 12 digits and more.

Numbers of 12 digits are not necessarily commit ids.

For an example provoking the problem see
https://patchwork.kernel.org/patch/9170897/

Checkpatch should only warn if the number refers to an existing commit.

Link: http://lkml.kernel.org/r/20170607184008.5869-1-xypron.glpk@gmx.de
Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-remove-false-warning-for-commit-reference scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-remove-false-warning-for-commit-reference
+++ a/scripts/checkpatch.pl
@@ -867,6 +867,7 @@ sub git_commit_info {
 #		    echo "commit $(cut -c 1-12,41-)"
 #		done
 	} elsif ($lines[0] =~ /^fatal: ambiguous argument '$commit': unknown revision or path not in the working tree\./) {
+		$id = undef;
 	} else {
 		$id = substr($lines[0], 0, 12);
 		$desc = substr($lines[0], 41);
@@ -2606,7 +2607,8 @@ sub process {
 			($id, $description) = git_commit_info($orig_commit,
 							      $id, $orig_desc);
 
-			if ($short || $long || $space || $case || ($orig_desc ne $description) || !$hasparens) {
+			if (defined($id) &&
+			   ($short || $long || $space || $case || ($orig_desc ne $description) || !$hasparens)) {
 				ERROR("GIT_COMMIT_ID",
 				      "Please use git commit description style 'commit <12+ chars of sha1> (\"<title line>\")' - ie: '${init_char}ommit $id (\"$description\")'\n" . $herecurr);
 			}
_
