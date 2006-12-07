From: akpm@osdl.org
Subject: - vfs-extra-check-inside-dentry_unhash.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:03:51 -0800
Message-ID: <200612072303.kB7N3pqq029997@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52049 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163847AbWLGXE2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:04:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vvs@sw.ru, mm-commits@vger.kernel.org


The patch titled
     VFS: extra check inside dentry_unhash()
has been removed from the -mm tree.  Its filename was
     vfs-extra-check-inside-dentry_unhash.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: VFS: extra check inside dentry_unhash()
From: Vasily Averin <vvs@sw.ru>

d_count check after dget() is always true.

Signed-off-by:	Vasily Averin <vvs@sw.ru>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/namei.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/namei.c~vfs-extra-check-inside-dentry_unhash fs/namei.c
--- a/fs/namei.c~vfs-extra-check-inside-dentry_unhash
+++ a/fs/namei.c
@@ -1998,8 +1998,7 @@ asmlinkage long sys_mkdir(const char __u
 void dentry_unhash(struct dentry *dentry)
 {
 	dget(dentry);
-	if (atomic_read(&dentry->d_count))
-		shrink_dcache_parent(dentry);
+	shrink_dcache_parent(dentry);
 	spin_lock(&dcache_lock);
 	spin_lock(&dentry->d_lock);
 	if (atomic_read(&dentry->d_count) == 2)
_

Patches currently in -mm which might be from vvs@sw.ru are

origin.patch

