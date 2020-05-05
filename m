From: akpm@linux-foundation.org
Subject: +
 checkpatch-use-patch-subject-when-reading-from-stdin.patch added to -mm
 tree
Date: Tue, 05 May 2020 12:18:46 -0700
Message-ID: <20200505191846.eUGRUOXlc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726350AbgEETSr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 5 May 2020 15:18:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert+renesas@glider.be, joe@perches.com, konstantin@linuxfoundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: use patch subject when reading from stdin
has been added to the -mm tree.  Its filename is
     checkpatch-use-patch-subject-when-reading-from-stdin.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-use-patch-subject-when-reading-from-stdin.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-use-patch-subject-when-reading-from-stdin.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Link: http://lkml.kernel.org/r/20200505132613.17452-1-geert+renesas@glider.be
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Joe Perches <joe@perches.com>
Cc: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++++
 1 file changed, 4 insertions(+)

--- a/scripts/checkpatch.pl~checkpatch-use-patch-subject-when-reading-from-stdin
+++ a/scripts/checkpatch.pl
@@ -1061,6 +1061,10 @@ for my $filename (@ARGV) {
 	}
 	while (<$FILE>) {
 		chomp;
+		if ($vname eq 'Your patch') {
+			my ($subject) = $_ =~ /^Subject:\s*(.*)/;
+			$vname = '"' . $subject . '"' if $subject;
+		}
 		push(@rawlines, $_);
 	}
 	close($FILE);
_

Patches currently in -mm which might be from geert+renesas@glider.be are

sh-fault-modernize-printing-of-kernel-messages.patch
checkpatch-use-patch-subject-when-reading-from-stdin.patch
