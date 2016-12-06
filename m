From: akpm@linux-foundation.org
Subject: +
 checkpatch-dont-emit-unified-diff-error-for-rename-only-patches.patch added to -mm tree
Date: Tue, 06 Dec 2016 13:43:54 -0800
Message-ID: <5847311a.uu1LSJ1oP3V+5SZy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41382 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750813AbcLFVoL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Dec 2016 16:44:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andrew@aj.id.au, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: don't emit unified-diff error for rename-only patches
has been added to the -mm tree.  Its filename is
     checkpatch-dont-emit-unified-diff-error-for-rename-only-patches.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-dont-emit-unified-diff-error-for-rename-only-patches.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-dont-emit-unified-diff-error-for-rename-only-patches.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Jeffery <andrew@aj.id.au>
Subject: checkpatch: don't emit unified-diff error for rename-only patches

I generated a patch with `git format-patch` which checkpatch thinks is
invalid:

    $ ./scripts/checkpatch.pl lpc-dt/0006-mfd-dt-Move-syscon-bindings-to-syscon-subdirectory.patch
    WARNING: added, moved or deleted file(s), does MAINTAINERS need updating?
     Documentation/devicetree/bindings/mfd/{ => syscon}/aspeed-scu.txt         | 0

    ERROR: Does not appear to be a unified-diff format patch

    total: 1 errors, 1 warnings, 0 lines checked

    NOTE: For some of the reported defects, checkpatch may be able to
          mechanically convert to the typical style using --fix or --fix-inplace.

    lpc-dt/0006-mfd-dt-Move-syscon-bindings-to-syscon-subdirectory.patch has style problems, please review.

    NOTE: If any of the errors are false positives, please report
          them to the maintainer, see CHECKPATCH in MAINTAINERS.

The patch in question was all renames with no edits, giving 100% similarity and
thus no diff markers.

Set '$is_patch = 1;' in the add/remove/rename detection to avoid
generating spurious warnings.

Link: http://lkml.kernel.org/r/20161205232224.22685-1-andrew@aj.id.au
Signed-off-by: Andrew Jeffery <andrew@aj.id.au>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    1 +
 1 file changed, 1 insertion(+)

diff -puN scripts/checkpatch.pl~checkpatch-dont-emit-unified-diff-error-for-rename-only-patches scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-dont-emit-unified-diff-error-for-rename-only-patches
+++ a/scripts/checkpatch.pl
@@ -2589,6 +2589,7 @@ sub process {
 		     $line =~ /^rename (?:from|to) [\w\/\.\-]+\s*$/ ||
 		     ($line =~ /\{\s*([\w\/\.\-]*)\s*\=\>\s*([\w\/\.\-]*)\s*\}/ &&
 		      (defined($1) || defined($2))))) {
+			$is_patch = 1;
 			$reported_maintainer_file = 1;
 			WARN("FILE_PATH_CHANGES",
 			     "added, moved or deleted file(s), does MAINTAINERS need updating?\n" . $herecurr);
_

Patches currently in -mm which might be from andrew@aj.id.au are

checkpatch-dont-emit-unified-diff-error-for-rename-only-patches.patch

