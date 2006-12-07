From: akpm@osdl.org
Subject: - mlock-cleanup.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:56:58 -0800
Message-ID: <200612072256.kB7MuwgZ029251@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51200 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163696AbWLGXAS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:00:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Rik.Bobbaers@cc.kuleuven.be, hugh@veritas.com, mm-commits@vger.kernel.org


The patch titled
     mlock cleanup
has been removed from the -mm tree.  Its filename was
     mlock-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mlock cleanup
From: Rik Bobbaers <Rik.Bobbaers@cc.kuleuven.be>

mm is defined as vma->vm_mm, so use that.

Acked-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/mlock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mlock.c~mlock-cleanup mm/mlock.c
--- a/mm/mlock.c~mlock-cleanup
+++ a/mm/mlock.c
@@ -65,7 +65,7 @@ success:
 			ret = make_pages_present(start, end);
 	}
 
-	vma->vm_mm->locked_vm -= pages;
+	mm->locked_vm -= pages;
 out:
 	if (ret == -ENOMEM)
 		ret = -EAGAIN;
_

Patches currently in -mm which might be from Rik.Bobbaers@cc.kuleuven.be are

origin.patch

