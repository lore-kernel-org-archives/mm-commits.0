From: akpm@linux-foundation.org
Subject: [merged] fs-devpts-inodec-correctly-check-d_alloc_name-return-code-in-devpts_pty_new.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:41:16 -0700
Message-ID: <201103232044.p2NKiq7b029134@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37948 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933486Ab1CWUp0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:45:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avagin@openvz.org, mm-commits@vger.kernel.org


The patch titled
     fs/devpts/inode.c: correctly check d_alloc_name() return code in devpts_pty_new()
has been removed from the -mm tree.  Its filename was
     fs-devpts-inodec-correctly-check-d_alloc_name-return-code-in-devpts_pty_new.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/devpts/inode.c: correctly check d_alloc_name() return code in devpts_pty_new()
From: Andrey Vagin <avagin@openvz.org>

d_alloc_name return NULL in case error, but we expect errno in
devpts_pty_new.

Addresses http://bugzilla.openvz.org/show_bug.cgi?id=1758

Signed-off-by: Andrey Vagin <avagin@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/devpts/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/devpts/inode.c~fs-devpts-inodec-correctly-check-d_alloc_name-return-code-in-devpts_pty_new fs/devpts/inode.c
--- a/fs/devpts/inode.c~fs-devpts-inodec-correctly-check-d_alloc_name-return-code-in-devpts_pty_new
+++ a/fs/devpts/inode.c
@@ -502,7 +502,7 @@ int devpts_pty_new(struct inode *ptmx_in
 	mutex_lock(&root->d_inode->i_mutex);
 
 	dentry = d_alloc_name(root, s);
-	if (!IS_ERR(dentry)) {
+	if (dentry) {
 		d_add(dentry, inode);
 		fsnotify_create(root->d_inode, dentry);
 	} else {
_

Patches currently in -mm which might be from avagin@openvz.org are

origin.patch

