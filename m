From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-use-patch-subject-when-reading-from-stdin.patch removed from -mm
 tree
Date: Fri, 05 Jun 2020 13:19:28 -0700
Message-ID: <20200605201928.d5MP1HMln%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728126AbgFEUT3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:19:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert+renesas@glider.be, joe@perches.com, konstantin@linuxfoundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: use patch subject when reading from stdin
has been removed from the -mm tree.  Its filename was
     checkpatch-use-patch-subject-when-reading-from-stdin.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: checkpatch: use patch subject when reading from stdin

While "git am" can apply an mbox file containing multiple patches (e.g. 
as created by b4[1], or a patch bundle downloaded from patchwork),
checkpatch does not have proper support for that.  When operating on an
mbox, checkpatch will merge all detected tags, and complain falsely about
duplicates:

    WARNING: Duplicate signature

As modifying checkpatch to reset state in between each patch is a lot of
work, a simple solution is splitting the mbox into individual patches, and
invoking checkpatch for each of them.  Fortunately checkpatch can read a
patch from stdin, so the classic "formail" tool can be used to split the
mbox, and pipe all individual patches to checkpatch:

    formail -s scripts/checkpatch.pl < my-mbox

However, when reading a patch file from standard input, checkpatch calls
it "Your patch", and reports its state as:

    Your patch has style problems, please review.

or:

    Your patch has no obvious style problems and is ready for submission.

Hence it can be difficult to identify which patches need to be reviewed
and improved.

Fix this by replacing "Your patch" by (the first line of) the email
subject, if present.

Note that "git mailsplit" can also be used to split an mbox, but it will
create individual files for each patch, thus requiring cleanup afterwards.
Formail does not have this disadvantage.

[1] https://git.kernel.org/pub/scm/utils/b4/b4.git

[joe@perches.com: reduce cpu usage]
  Link: http://lkml.kernel.org/r/c9d89bb24c7414142414c60371e210fdcf4617d2.camel@perches.com
Link: http://lkml.kernel.org/r/20200505132613.17452-1-geert+renesas@glider.be
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Joe Perches <joe@perches.com>
Cc: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/checkpatch.pl~checkpatch-use-patch-subject-when-reading-from-stdin
+++ a/scripts/checkpatch.pl
@@ -1062,6 +1062,7 @@ for my $filename (@ARGV) {
 	while (<$FILE>) {
 		chomp;
 		push(@rawlines, $_);
+		$vname = qq("$1") if ($filename eq '-' && $_ =~ m/^Subject:\s+(.+)/i);
 	}
 	close($FILE);
 
_

Patches currently in -mm which might be from geert+renesas@glider.be are
