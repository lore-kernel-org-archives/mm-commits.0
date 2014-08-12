From: akpm@linux-foundation.org
Subject: + checkpatch-relax-check-for-length-of-git-commit-ids.patch added to -mm tree
Date: Tue, 12 Aug 2014 14:49:19 -0700
Message-ID: <53ea8bdf.CmEdExseXHz0XJME%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:54788 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995AbaHLVtU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 17:49:20 -0400
Received: by mail-ob0-f202.google.com with SMTP id wp18so1960230obc.3
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 14:49:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: relax check for length of git commit IDs
has been added to the -mm tree.  Its filename is
     checkpatch-relax-check-for-length-of-git-commit-ids.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-relax-check-for-length-of-git-commit-ids.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-relax-check-for-length-of-git-commit-ids.patch

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
Subject: checkpatch: relax check for length of git commit IDs

Checkpatch currently warns if a git commit ID (in the changelog, usually)
is less than 12 characters or more than 16.  The "more than 16" is
excessive.  Make it "more than 40".

Cc: Geert Uytterhoeven <geert@linux-m68k.org
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-relax-check-for-length-of-git-commit-ids scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-relax-check-for-length-of-git-commit-ids
+++ a/scripts/checkpatch.pl
@@ -2133,7 +2133,7 @@ sub process {
 # Check for improperly formed commit descriptions
 		if ($in_commit_log &&
 		    $line =~ /\bcommit\s+[0-9a-f]{5,}/i &&
-		    $line !~ /\b[Cc]ommit [0-9a-f]{12,16} \("/) {
+		    $line !~ /\b[Cc]ommit [0-9a-f]{12,40} \("/) {
 			$line =~ /\b(c)ommit\s+([0-9a-f]{5,})/i;
 			my $init_char = $1;
 			my $orig_commit = lc($2);
@@ -2141,7 +2141,7 @@ sub process {
 			my $desc = 'commit description';
 		        ($id, $desc) = git_commit_info($orig_commit, $id, $desc);
 			ERROR("GIT_COMMIT_ID",
-			      "Please use 12 to 16 chars for the git commit ID like: '${init_char}ommit $id (\"$desc\")'\n" . $herecurr);
+			      "Please use 12 or more chars for the git commit ID like: '${init_char}ommit $id (\"$desc\")'\n" . $herecurr);
 		}
 
 # Check for added, moved or deleted files
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
checkpatch-relax-check-for-length-of-git-commit-ids.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch

