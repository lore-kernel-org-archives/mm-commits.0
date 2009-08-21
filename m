From: akpm@linux-foundation.org
Subject: + checkpatch-format-strings-should-not-have-brackets-in-macros.patch added to -mm tree
Date: Fri, 21 Aug 2009 15:24:59 -0700
Message-ID: <200908212224.n7LMOxmn016000@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35970 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932686AbZHUWZA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Aug 2009 18:25:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@canonical.com


The patch titled
     checkpatch: format strings should not have brackets in macros
has been added to the -mm tree.  Its filename is
     checkpatch-format-strings-should-not-have-brackets-in-macros.patch

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
Subject: checkpatch: format strings should not have brackets in macros
From: Andy Whitcroft <apw@canonical.com>

We should not recommend braces for the following:

    #define pr_fmt(fmt)    "%s: " fmt, __func__

allow things with double quotes round them to avoid this check.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-format-strings-should-not-have-brackets-in-macros scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-format-strings-should-not-have-brackets-in-macros
+++ a/scripts/checkpatch.pl
@@ -2288,7 +2288,8 @@ sub process {
 				DECLARE_PER_CPU|
 				DEFINE_PER_CPU|
 				__typeof__\(|
-				\.$Ident\s*=\s*
+				\.$Ident\s*=\s*|
+				^\"|\"$
 			}x;
 			#print "REST<$rest> dstat<$dstat>\n";
 			if ($rest ne '') {
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

