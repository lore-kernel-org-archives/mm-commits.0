From: akpm@linux-foundation.org
Subject: [merged] m32r-remove-abort.patch removed from -mm tree
Date: Thu, 01 Feb 2018 11:29:00 -0800
Message-ID: <20180201192900.YG9YpKiYe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56484 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754695AbeBAT3C (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Feb 2018 14:29:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, sudipm.mukherjee@gmail.com


The patch titled
     Subject: m32r: remove abort()
has been removed from the -mm tree.  Its filename was
     m32r-remove-abort.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: m32r: remove abort()

7c2c11b208be ("arch: define weak abort()") has introduced a weak abort()
which is common for all arch.  And, so we will not need arch specific
abort which has the same code as the weak abort().  Remove the abort() for
m32r.

Link: http://lkml.kernel.org/r/1516912339-5665-1-git-send-email-sudipm.mukherjee@gmail.com
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/kernel/traps.c |    8 --------
 1 file changed, 8 deletions(-)

diff -puN arch/m32r/kernel/traps.c~m32r-remove-abort arch/m32r/kernel/traps.c
--- a/arch/m32r/kernel/traps.c~m32r-remove-abort
+++ a/arch/m32r/kernel/traps.c
@@ -115,14 +115,6 @@ static void set_eit_vector_entries(void)
 	_flush_cache_copyback_all();
 }
 
-void abort(void)
-{
-	BUG();
-
-	/* if that doesn't kill us, halt */
-	panic("Oops failed to kill thread");
-}
