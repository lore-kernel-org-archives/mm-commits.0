From: akpm@linux-foundation.org
Subject: [merged] checkpatch-add-check-for-kcalloc-argument-order.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:42:56 -0800
Message-ID: <20130222204256.A2FEC31C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:33022 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758001Ab3BVUm5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:42:57 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so103911ghb.5
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:42:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: Add check for kcalloc argument order
has been removed from the -mm tree.  Its filename was
     checkpatch-add-check-for-kcalloc-argument-order.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: Add check for kcalloc argument order

kcalloc is sometimes misused with the first and second arguments switched.

Same issue with kmalloc_array too.

Bleat if sizeof is the first argument

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-check-for-kcalloc-argument-order scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-check-for-kcalloc-argument-order
+++ a/scripts/checkpatch.pl
@@ -3476,6 +3476,12 @@ sub process {
 			     "unnecessary cast may hide bugs, see http://c-faq.com/malloc/mallocnocast.html\n" . $herecurr);
 		}
 
+# check for alloc argument mismatch
+		if ($line =~ /\b(kcalloc|kmalloc_array)\s*\(\s*sizeof\b/) {
+			WARN("ALLOC_ARRAY_ARGS",
+			     "$1 uses number as first arg, sizeof is generally wrong\n" . $herecurr);
+		}
+
 # check for multiple semicolons
 		if ($line =~ /;\s*;\s*$/) {
 			WARN("ONE_SEMICOLON",
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
get_maintainer-allow-keywords-to-match-filenames.patch
fs-proc-clean-up-printks.patch
fs-proc-clean-up-printks-fix.patch
fs-proc-clean-up-printks-fix-fix.patch

