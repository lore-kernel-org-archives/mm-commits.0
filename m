From: akpm@linux-foundation.org
Subject: [patch 121/123] checkpatch: don't emit unified-diff error for
 rename-only patches
Date: Mon, 12 Dec 2016 16:46:37 -0800
Message-ID: <584f44ed.wr2tt+6fk2RbtgZ7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42144 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753137AbcLMAqi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:46:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, andrew@aj.id.au, joe@perches.com

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
