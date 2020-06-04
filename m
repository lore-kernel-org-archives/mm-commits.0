From: akpm@linux-foundation.org
Subject: [folded-merged]
 checkpatch-use-patch-subject-when-reading-from-stdin-fix.patch removed from
 -mm tree
Date: Thu, 04 Jun 2020 16:23:01 -0700
Message-ID: <20200604232301.6ZCOS6SfT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725863AbgFDXXD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:23:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert+renesas@glider.be, joe@perches.com, konstantin@linuxfoundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch-use-patch-subject-when-reading-from-stdin-fix
has been removed from the -mm tree.  Its filename was
     checkpatch-use-patch-subject-when-reading-from-stdin-fix.patch

This patch was dropped because it was folded into checkpatch-use-patch-subject-when-reading-from-stdin.patch

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch-use-patch-subject-when-reading-from-stdin-fix

reduce cpu usage

Link: http://lkml.kernel.org/r/c9d89bb24c7414142414c60371e210fdcf4617d2.camel@perches.com
Cc: Joe Perches <joe@perches.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Joe Perches <joe@perches.com>
Cc: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-use-patch-subject-when-reading-from-stdin-fix
+++ a/scripts/checkpatch.pl
@@ -1063,11 +1063,8 @@ for my $filename (@ARGV) {
 	}
 	while (<$FILE>) {
 		chomp;
-		if ($vname eq 'Your patch') {
-			my ($subject) = $_ =~ /^Subject:\s*(.*)/;
-			$vname = '"' . $subject . '"' if $subject;
-		}
 		push(@rawlines, $_);
+		$vname = qq("$1") if ($filename eq '-' && $_ =~ m/^Subject:\s+(.+)/i);
 	}
 	close($FILE);
 
_

Patches currently in -mm which might be from joe@perches.com are

get_maintainer-add-email-addresses-from-yaml-files.patch
get_maintainer-fix-unexpected-behavior-for-path-to-file-double-slashes.patch
percpu_ref-use-a-more-common-logging-style.patch
checkpatch-additional-maintainer-section-entry-ordering-checks.patch
checkpatch-look-for-c99-comments-in-ctx_locate_comment.patch
checkpatch-disallow-git-and-file-fix.patch
checkpatch-use-patch-subject-when-reading-from-stdin.patch
fs-seq_filec-seq_read-update-pr_info_ratelimited.patch
checkpatch-test-git_dir-changes.patch
