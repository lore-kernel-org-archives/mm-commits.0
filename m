From: akpm@linux-foundation.org
Subject: - proc-remove-pathetic-remount-code.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:02:13 -0700
Message-ID: <200807252302.m6PN2D6C003807@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41911 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753211AbYGYXCp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:02:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     proc: remove pathetic remount code
has been removed from the -mm tree.  Its filename was
     proc-remove-pathetic-remount-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: remove pathetic remount code
From: Alexey Dobriyan <adobriyan@gmail.com>

MS_RMT_MASK will unmask changes in do_remount_sb() anyway.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/inode.c |    7 -------
 1 file changed, 7 deletions(-)

diff -puN fs/proc/inode.c~proc-remove-pathetic-remount-code fs/proc/inode.c
--- a/fs/proc/inode.c~proc-remove-pathetic-remount-code
+++ a/fs/proc/inode.c
@@ -111,19 +111,12 @@ int __init proc_init_inodecache(void)
 	return 0;
 }
 
-static int proc_remount(struct super_block *sb, int *flags, char *data)
-{
-	*flags |= MS_NODIRATIME;
-	return 0;
-}
-
 static const struct super_operations proc_sops = {
 	.alloc_inode	= proc_alloc_inode,
 	.destroy_inode	= proc_destroy_inode,
 	.drop_inode	= generic_delete_inode,
 	.delete_inode	= proc_delete_inode,
 	.statfs		= simple_statfs,
-	.remount_fs	= proc_remount,
 };
 
 static void __pde_users_dec(struct proc_dir_entry *pde)
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
cdc-acm-dont-unlock-acm-mutex-on-error-path.patch
slb-drop-kmem-cache-argument-from-constructor.patch
slb-drop-kmem-cache-argument-from-constructor-fix.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix-logfs.patch
slb-drop-kmem-cache-argument-from-constructor-ubifs.patch
use-warn-in-fs-proc.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

