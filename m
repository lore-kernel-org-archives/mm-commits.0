From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 checkpatch-correct-check-for-kernel-parameters-doc.patch added to -mm tree
Date: Mon, 08 Jun 2020 16:42:06 -0700
Message-ID: <20200608234206.OfNG3jQ23%akpm@linux-foundation.org>
References: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730627AbgFHXmN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 19:42:13 -0400
In-Reply-To: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mchehab@kernel.org, mm-commits@vger.kernel.org, tim.froidcoeur@tessares.net


The patch titled
     Subject: checkpatch: correct check for kernel parameters doc
has been added to the -mm tree.  Its filename is
     checkpatch-correct-check-for-kernel-parameters-doc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-correct-check-for-kernel-parameters-doc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-correct-check-for-kernel-parameters-doc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tim Froidcoeur <tim.froidcoeur@tessares.net>
Subject: checkpatch: correct check for kernel parameters doc

Adding a new kernel parameter with documentation makes checkpatch complain
"__setup appears un-documented -- check
Documentation/admin-guide/kernel-parameters.rst".  The list of kernel
parameters has moved to a separate txt file, but checkpatch has not been
updated for this.

Make checkpatch.pl look for the documentation for new kernel parameters in
kernel-parameters.txt instead of kernel-parameters.rst.

Fixes: e52347bd66f6 ("Documentation/admin-guide: split the kernel parameter list to a separate file")
Signed-off-by: Tim Froidcoeur <tim.froidcoeur@tessares.net>
Acked-by: Joe Perches <joe@perches.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-correct-check-for-kernel-parameters-doc
+++ a/scripts/checkpatch.pl
@@ -2409,7 +2409,7 @@ sub process {
 
 		if ($rawline=~/^\+\+\+\s+(\S+)/) {
 			$setup_docs = 0;
-			if ($1 =~ m@Documentation/admin-guide/kernel-parameters.rst$@) {
+			if ($1 =~ m@Documentation/admin-guide/kernel-parameters.txt$@) {
 				$setup_docs = 1;
 			}
 			#next;
@@ -6390,7 +6390,7 @@ sub process {
 
 			if (!grep(/$name/, @setup_docs)) {
 				CHK("UNDOCUMENTED_SETUP",
-				    "__setup appears un-documented -- check Documentation/admin-guide/kernel-parameters.rst\n" . $herecurr);
+				    "__setup appears un-documented -- check Documentation/admin-guide/kernel-parameters.txt\n" . $herecurr);
 			}
 		}
 
_

Patches currently in -mm which might be from tim.froidcoeur@tessares.net are

checkpatch-correct-check-for-kernel-parameters-doc.patch
