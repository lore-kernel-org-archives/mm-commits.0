From: akpm@linux-foundation.org
Subject: + checkpatch-remove-false-warning-for-commit-reference.patch
 added to -mm tree
Date: Thu, 15 Jun 2017 15:55:35 -0700
Message-ID: <59431067.XKQa5Drhg0pcdrqI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46670 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751883AbdFOWzg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jun 2017 18:55:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xypron.glpk@gmx.de, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: remove false warning for commit reference
has been added to the -mm tree.  Its filename is
     checkpatch-remove-false-warning-for-commit-reference.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-remove-false-warning-for-commit-reference.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-remove-false-warning-for-commit-reference.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -866,6 +866,7 @@ sub git_commit_info {
 #		    echo "commit $(cut -c 1-12,41-)"
 #		done
 	} elsif ($lines[0] =~ /^fatal: ambiguous argument '$commit': unknown revision or path not in the working tree\./) {
+		$id = undef;
 	} else {
 		$id = substr($lines[0], 0, 12);
 		$desc = substr($lines[0], 41);
@@ -2605,7 +2606,8 @@ sub process {
 			($id, $description) = git_commit_info($orig_commit,
 							      $id, $orig_desc);
 
-			if ($short || $long || $space || $case || ($orig_desc ne $description) || !$hasparens) {
+			if (defined($id) &&
+			   ($short || $long || $space || $case || ($orig_desc ne $description) || !$hasparens)) {
 				ERROR("GIT_COMMIT_ID",
 				      "Please use git commit description style 'commit <12+ chars of sha1> (\"<title line>\")' - ie: '${init_char}ommit $id (\"$description\")'\n" . $herecurr);
 			}
_

Patches currently in -mm which might be from xypron.glpk@gmx.de are

checkpatch-remove-false-warning-for-commit-reference.patch

