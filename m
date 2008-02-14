From: akpm@linux-foundation.org
Subject: - dentries-extract-common-code-to-remove-dentry-from-lru-fix.patch removed from -mm tree
Date: Thu, 14 Feb 2008 15:28:02 -0800
Message-ID: <200802142328.m1ENS379008663@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42879 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758055AbYBNX2d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 18:28:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     dcache: use the correct variable.
has been removed from the -mm tree.  Its filename was
     dentries-extract-common-code-to-remove-dentry-from-lru-fix.patch

This patch was dropped because it was folded into dentries-extract-common-code-to-remove-dentry-from-lru.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dcache: use the correct variable.
From: Christoph Lameter <clameter@sgi.com>

We need to use "loop" instead of "dentry"

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/dcache.c~dentries-extract-common-code-to-remove-dentry-from-lru-fix fs/dcache.c
--- a/fs/dcache.c~dentries-extract-common-code-to-remove-dentry-from-lru-fix
+++ a/fs/dcache.c
@@ -606,7 +606,7 @@ static void shrink_dcache_for_umount_sub
 			spin_lock(&dcache_lock);
 			list_for_each_entry(loop, &dentry->d_subdirs,
 					    d_u.d_child) {
-				dentry_lru_remove(dentry);
+				dentry_lru_remove(loop);
 				__d_drop(loop);
 				cond_resched_lock(&dcache_lock);
 			}
_

Patches currently in -mm which might be from clameter@sgi.com are

gregkh-driver-kset-move-sys-slab-to-sys-kernel-slab-slabinfo-fallback-from-sys-kernel-slab-to-sys-slab.patch
git-unionfs.patch
x86-cast-cmpxchg-and-cmpxchg_local-result-for-386-and-486.patch
remove-set_migrateflags.patch
dentries-extract-common-code-to-remove-dentry-from-lru.patch
dentries-extract-common-code-to-remove-dentry-from-lru-fix.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch
