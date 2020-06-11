From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 06/25] checkpatch: correct check for kernel
 parameters doc
Date: Wed, 10 Jun 2020 18:41:38 -0700
Message-ID: <20200611014138.3OCM1QxQa%akpm@linux-foundation.org>
References: <20200610184053.3fa7368ab80e23bfd44de71f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726163AbgFKBlj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Jun 2020 21:41:39 -0400
In-Reply-To: <20200610184053.3fa7368ab80e23bfd44de71f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, linux-mm@kvack.org, mchehab@kernel.org, mm-commits@vger.kernel.org, tim.froidcoeur@tessares.net, torvalds@linux-foundation.org

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
