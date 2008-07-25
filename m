From: akpm@linux-foundation.org
Subject: - proc-always-do-release-fix.patch removed from -mm tree
Date: Thu, 24 Jul 2008 17:35:43 -0700
Message-ID: <200807250035.m6P0Zhs1014499@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40097 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753108AbYGYAfq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 20:35:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     proc-always-do-release fix
has been removed from the -mm tree.  Its filename was
     proc-always-do-release-fix.patch

This patch was dropped because it was folded into proc-always-do-release.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc-always-do-release fix
From: Alexey Dobriyan <adobriyan@gmail.com>

Don't add ->release'less PDEs into openers list.

This fixes possible call to NULL if ->release is not needed for some reason.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |    3 +--
 fs/proc/inode.c   |    2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/proc/generic.c~proc-always-do-release-fix fs/proc/generic.c
--- a/fs/proc/generic.c~proc-always-do-release-fix
+++ a/fs/proc/generic.c
@@ -797,8 +797,7 @@ continue_removing:
 		pdeo = list_first_entry(&de->pde_openers, struct pde_opener, lh);
 		list_del(&pdeo->lh);
 		spin_unlock(&de->pde_unload_lock);
-		if (pdeo->release)
-			pdeo->release(pdeo->inode, pdeo->file);
+		pdeo->release(pdeo->inode, pdeo->file);
 		kfree(pdeo);
 		spin_lock(&de->pde_unload_lock);
 	}
diff -puN fs/proc/inode.c~proc-always-do-release-fix fs/proc/inode.c
--- a/fs/proc/inode.c~proc-always-do-release-fix
+++ a/fs/proc/inode.c
@@ -360,7 +360,7 @@ static int proc_reg_open(struct inode *i
 		rv = open(inode, file);
 
 	spin_lock(&pde->pde_unload_lock);
-	if (rv == 0) {
+	if (rv == 0 && release) {
 		/* To know what to release. */
 		pdeo->inode = inode;
 		pdeo->file = file;
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
move-proc_kmsg_operations-to-fs-proc-internalh.patch
proc-always-do-release.patch
proc-always-do-release-fix.patch
proc-remove-pathetic-remount-code.patch
proc-move-kconfig-to-fs-proc-kconfig.patch
sysctl-allow-override-of-proc-sys-net-with-cap_net_admin.patch

