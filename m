From: akpm@linux-foundation.org
Subject: - checkpatch-____cacheline_aligned-et-al-are-modifiers.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:13:18 -0700
Message-ID: <200810182313.m9INDIdp028164@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38549 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751377AbYJRXN1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:13:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: ____cacheline_aligned et al are modifiers
has been removed from the -mm tree.  Its filename was
     checkpatch-____cacheline_aligned-et-al-are-modifiers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: ____cacheline_aligned et al are modifiers
From: Andy Whitcroft <apw@shadowen.org>

Add the cacheline alignment modifiers to the attribute lists.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-____cacheline_aligned-et-al-are-modifiers scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-____cacheline_aligned-et-al-are-modifiers
+++ a/scripts/checkpatch.pl
@@ -113,7 +113,10 @@ our $Attribute	= qr{
 			const|
 			__read_mostly|
 			__kprobes|
-			__(?:mem|cpu|dev|)(?:initdata|init)
+			__(?:mem|cpu|dev|)(?:initdata|init)|
+			____cacheline_aligned|
+			____cacheline_aligned_in_smp|
+			____cacheline_internodealigned_in_smp
 		  }x;
 our $Modifier;
 our $Inline	= qr{inline|__always_inline|noinline};
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch

