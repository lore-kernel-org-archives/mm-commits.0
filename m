From: akpm@linux-foundation.org
Subject: + checkpatch-indent-checks-stop-when-we-run-out-of-continuation-lines.patch added to -mm tree
Date: Fri, 21 Aug 2009 15:24:55 -0700
Message-ID: <200908212224.n7LMOtSR015922@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42299 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932609AbZHUWY5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Aug 2009 18:24:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@canonical.com, daikerjohn@gmail.com


The patch titled
     checkpatch: indent checks -- stop when we run out of continuation lines
has been added to the -mm tree.  Its filename is
     checkpatch-indent-checks-stop-when-we-run-out-of-continuation-lines.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: indent checks -- stop when we run out of continuation lines
From: Andy Whitcroft <apw@canonical.com>

Ensure we terminate when there are no futher continuation lines when
trying to determine relative indent of conditionals and their blocks.

Reported-by: John Daiker <daikerjohn@gmail.com>
Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-indent-checks-stop-when-we-run-out-of-continuation-lines scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-indent-checks-stop-when-we-run-out-of-continuation-lines
+++ a/scripts/checkpatch.pl
@@ -1547,8 +1547,9 @@ sub process {
 				    $s =~ /^\s*#\s*?/ ||
 				    $s =~ /^\s*$Ident\s*:/) {
 					$continuation = ($s =~ /^.*?\\\n/) ? 1 : 0;
-					$s =~ s/^.*?\n//;
-					$cond_lines++;
+					if ($s =~ s/^.*?\n//) {
+						$cond_lines++;
+					}
 				}
 			}
 
_

Patches currently in -mm which might be from apw@canonical.com are

hugetlb-balance-freeing-of-huge-pages-across-nodes.patch
hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages.patch
hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages-fix.patch
hugetlb-clean-up-and-update-huge-pages-documentation.patch
hugetlb-restore-interleaving-of-bootmem-huge-pages.patch
checkpatch-possible-types-else-cannot-start-a-type.patch
checkpatch-handle-c99-comments-correctly-performance-issue.patch
checkpatch-indent-checks-stop-when-we-run-out-of-continuation-lines.patch
checkpatch-make-f-alias-file-add-help-more-verbose-help-message.patch
checkpatch-format-strings-should-not-have-brackets-in-macros.patch
checkpatch-limit-sn-un-matches-to-actual-bit-sizes.patch
checkpatch-version-029.patch

