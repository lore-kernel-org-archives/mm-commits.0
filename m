From: akpm@linux-foundation.org
Subject: + proc-remove-pathetic-remount-code.patch added to -mm tree
Date: Mon, 23 Jun 2008 23:49:27 -0700
Message-ID: <200806240649.m5O6nRtN005149@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35098 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750962AbYFXGta (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jun 2008 02:49:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com


The patch titled
     proc: remove pathetic remount code
has been added to the -mm tree.  Its filename is
     proc-remove-pathetic-remount-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
cifs-switch-to-seq_files.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
move-proc_kmsg_operations-to-fs-proc-internalh.patch
proc-always-do-release.patch
proc-remove-pathetic-remount-code.patch
proc-move-kconfig-to-fs-proc-kconfig.patch
sysctl-allow-override-of-proc-sys-net-with-cap_net_admin.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

