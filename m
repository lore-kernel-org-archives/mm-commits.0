From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-correct-check-for-kernel-parameters-doc.patch removed from -mm
 tree
Date: Thu, 11 Jun 2020 15:22:56 -0700
Message-ID: <20200611222256.-Q2KqLfgh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726260AbgFKWW5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 11 Jun 2020 18:22:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mchehab@kernel.org, mm-commits@vger.kernel.org, tim.froidcoeur@tessares.net


The patch titled
     Subject: checkpatch: correct check for kernel parameters doc
has been removed from the -mm tree.  Its filename was
     checkpatch-correct-check-for-kernel-parameters-doc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -2407,7 +2407,7 @@ sub process {
 
 		if ($rawline=~/^\+\+\+\s+(\S+)/) {
 			$setup_docs = 0;
-			if ($1 =~ m@Documentation/admin-guide/kernel-parameters.rst$@) {
+			if ($1 =~ m@Documentation/admin-guide/kernel-parameters.txt$@) {
 				$setup_docs = 1;
 			}
 			#next;
@@ -6388,7 +6388,7 @@ sub process {
 
 			if (!grep(/$name/, @setup_docs)) {
 				CHK("UNDOCUMENTED_SETUP",
-				    "__setup appears un-documented -- check Documentation/admin-guide/kernel-parameters.rst\n" . $herecurr);
+				    "__setup appears un-documented -- check Documentation/admin-guide/kernel-parameters.txt\n" . $herecurr);
 			}
 		}
 
_

Patches currently in -mm which might be from tim.froidcoeur@tessares.net are
