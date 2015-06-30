From: akpm@linux-foundation.org
Subject: [folded-merged]
 devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx-fix.patch
 removed from -mm tree
Date: Tue, 30 Jun 2015 14:50:06 -0700
Message-ID: <55930f0e.44EJztAxHM8yFYFO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53223 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbbF3VuI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Jun 2015 17:50:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, josh@joshtriplett.org, mm-commits@vger.kernel.org


The patch titled
     Subject: devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx-fix
has been removed from the -mm tree.  Its filename was
     devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx-fix.patch

This patch was dropped because it was folded into devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx-fix

remove unneeded static

Cc: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/devpts/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/devpts/inode.c~devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx-fix fs/devpts/inode.c
--- a/fs/devpts/inode.c~devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx-fix
+++ a/fs/devpts/inode.c
@@ -689,7 +689,8 @@ static int __init init_devpts_fs(void)
 	struct ctl_table_header *table;
 
 	if (!err) {
-		static struct vfsmount *mnt;
+		struct vfsmount *mnt;
+
 		table = register_sysctl_table(pty_root_table);
 		mnt = kern_mount(&devpts_fs_type);
 		if (IS_ERR(mnt)) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-meminit-inline-some-helper-functions.patch
mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup.patch
devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx.patch
ipcshm-move-bug_on-check-into-shm_lock-fix.patch
scsi-resolve-sg-buffer-const-ness-issue-fix.patch
genalloc-rename-dev_get_gen_pool-to-gen_pool_get-fix.patch

