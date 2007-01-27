From: akpm@osdl.org
Subject: - mm-remove-invalidate_inode_pages2_range-debug.patch removed from -mm tree
Date: Fri, 26 Jan 2007 17:32:27 -0800
Message-ID: <200701270132.l0R1WRi8031932@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35572 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752230AbXA0Bch (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 20:32:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Trond.Myklebust@netapp.com, mm-commits@vger.kernel.org


The patch titled
     MM: Remove [PATCH] invalidate_inode_pages2_range() debug
has been removed from the -mm tree.  Its filename was
     mm-remove-invalidate_inode_pages2_range-debug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: MM: Remove [PATCH] invalidate_inode_pages2_range() debug
From: Trond Myklebust <Trond.Myklebust@netapp.com>

NFS can handle the case where invalidate_inode_pages2_range() fails, so the
premise behind commit 8258d4a574d3a8c01f0ef68aa26b969398a0e140 is now gone.

Remove the WARN_ON_ONCE() which is causing users grief as we can see from
http://bugzilla.kernel.org/show_bug.cgi?id=7826

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/truncate.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/truncate.c~mm-remove-invalidate_inode_pages2_range-debug mm/truncate.c
--- a/mm/truncate.c~mm-remove-invalidate_inode_pages2_range-debug
+++ a/mm/truncate.c
@@ -422,7 +422,6 @@ int invalidate_inode_pages2_range(struct
 		pagevec_release(&pvec);
 		cond_resched();
 	}
-	WARN_ON_ONCE(ret);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(invalidate_inode_pages2_range);
_

Patches currently in -mm which might be from Trond.Myklebust@netapp.com are

origin.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
nfs-kill-the-obsolete-nfs_paranoia.patch
