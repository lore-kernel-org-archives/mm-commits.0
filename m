From: akpm@linux-foundation.org
Subject: [merged] gru-fix-potential-use-after-free-when-purging-gru-tlbs.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:49:10 -0700
Message-ID: <200906182249.n5IMnAll008307@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39138 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755575AbZFRWti (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:49:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     gru: fix potential use-after-free when purging GRU tlbs
has been removed from the -mm tree.  Its filename was
     gru-fix-potential-use-after-free-when-purging-gru-tlbs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gru: fix potential use-after-free when purging GRU tlbs
From: Jack Steiner <steiner@sgi.com>

Fix potential SGI GRU bug that could cause a use-after-free.  If one
thread in a task is flushing the GRU and another thread destroys the GRU
context, there is the potential to access a table after it has been freed.

Copy the gms pointer to a local variable before unlocking the gts table. 
Note that no refcnt is needed for the gms - the reference is held
indirectly by the task's mm_struct.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grufault.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/misc/sgi-gru/grufault.c~gru-fix-potential-use-after-free-when-purging-gru-tlbs drivers/misc/sgi-gru/grufault.c
--- a/drivers/misc/sgi-gru/grufault.c~gru-fix-potential-use-after-free-when-purging-gru-tlbs
+++ a/drivers/misc/sgi-gru/grufault.c
@@ -702,6 +702,7 @@ int gru_user_flush_tlb(unsigned long arg
 {
 	struct gru_thread_state *gts;
 	struct gru_flush_tlb_req req;
+	struct gru_mm_struct *gms;
 
 	STAT(user_flush_tlb);
 	if (copy_from_user(&req, (void __user *)arg, sizeof(req)))
@@ -714,8 +715,9 @@ int gru_user_flush_tlb(unsigned long arg
 	if (!gts)
 		return -EINVAL;
 
-	gru_flush_tlb_range(gts->ts_gms, req.vaddr, req.len);
+	gms = gts->ts_gms;
 	gru_unlock_gts(gts);
+	gru_flush_tlb_range(gms, req.vaddr, req.len);
 
 	return 0;
 }
_

Patches currently in -mm which might be from steiner@sgi.com are

origin.patch

