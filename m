From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 checkpatch-use-patch-subject-when-reading-from-stdin-fix.patch added to -mm
 tree
Date: Fri, 08 May 2020 14:32:09 -0700
Message-ID: <20200508213209.OD2RkM-FX%akpm@linux-foundation.org>
References: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726811AbgEHVcL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 8 May 2020 17:32:11 -0400
In-Reply-To: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert+renesas@glider.be, joe@perches.com, konstantin@linuxfoundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch-use-patch-subject-when-reading-from-stdin-fix
has been added to the -mm tree.  Its filename is
     checkpatch-use-patch-subject-when-reading-from-stdin-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-use-patch-subject-when-reading-from-stdin-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-use-patch-subject-when-reading-from-stdin-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1061,11 +1061,8 @@ for my $filename (@ARGV) {
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

checkpatch-test-git_dir-changes.patch
get_maintainer-add-email-addresses-from-yaml-files.patch
percpu_ref-use-a-more-common-logging-style.patch
checkpatch-additional-maintainer-section-entry-ordering-checks.patch
checkpatch-look-for-c99-comments-in-ctx_locate_comment.patch
checkpatch-disallow-git-and-file-fix.patch
checkpatch-use-patch-subject-when-reading-from-stdin-fix.patch
fs-seq_filec-seq_read-update-pr_info_ratelimited.patch
