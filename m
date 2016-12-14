From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-dont-emit-unified-diff-error-for-rename-only-patches.patch
 removed from -mm tree
Date: Wed, 14 Dec 2016 11:27:58 -0800
Message-ID: <58519d3e.Pbj/XTC+z15+2STX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45860 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756540AbcLNT3j (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 14:29:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andrew@aj.id.au, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: don't emit unified-diff error for rename-only patches
has been removed from the -mm tree.  Its filename was
     checkpatch-dont-emit-unified-diff-error-for-rename-only-patches.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


