From: akpm@linux-foundation.org
Subject: + checkpatch-limit-sn-un-matches-to-actual-bit-sizes.patch added to -mm tree
Date: Fri, 21 Aug 2009 15:25:01 -0700
Message-ID: <200908212225.n7LMP15x016004@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44827 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932952AbZHUWZC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Aug 2009 18:25:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@canonical.com


The patch titled
     checkpatch: limit sN/uN matches to actual bit sizes
has been added to the -mm tree.  Its filename is
     checkpatch-limit-sn-un-matches-to-actual-bit-sizes.patch

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
Subject: checkpatch: limit sN/uN matches to actual bit sizes
From: Andy Whitcroft <apw@canonical.com>

Limit our type matcher to the s/u/le/be etc sizes that actually exist to
prevent miss categorising s2 as a type.  Fix up the spelling of the error
also.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-limit-sn-un-matches-to-actual-bit-sizes scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-limit-sn-un-matches-to-actual-bit-sizes
+++ a/scripts/checkpatch.pl
@@ -182,7 +182,7 @@ our $UTF8	= qr {
 }x;
 
 our $typeTypedefs = qr{(?x:
-	(?:__)?(?:u|s|be|le)(?:\d|\d\d)|
+	(?:__)?(?:u|s|be|le)(?:8|16|32|64)|
 	atomic_t
 )};
 
@@ -1936,7 +1936,7 @@ sub process {
 						# A unary '*' may be const
 
 					} elsif ($ctx =~ /.xW/) {
-						ERROR("Aspace prohibited after that '$op' $at\n" . $hereptr);
+						ERROR("space prohibited after that '$op' $at\n" . $hereptr);
 					}
 
 				# unary ++ and unary -- are allowed no space on one side.
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

