From: akpm@linux-foundation.org
Subject: + fs-anon_inodes-implement-dname.patch added to -mm tree
Date: Fri, 20 Nov 2009 14:28:35 -0800
Message-ID: <200911202228.nAKMSZDT018977@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41733 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753818AbZKTW3U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Nov 2009 17:29:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, davem@davemloft.net, davidel@xmailserver.org, hch@lst.de, jens.axboe@oracle.com, mszeredi@suse.cz, viro@zeniv.linux.org.uk


The patch titled
     fs: anon_inodes implement dname
has been added to the -mm tree.  Its filename is
     fs-anon_inodes-implement-dname.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs: anon_inodes implement dname
From: Nick Piggin <npiggin@suse.de>

Add a d_dname method for anon_inodes filesystem, the same way pipefs and
sockfs pseudo filesystems.  This allows us to remove the DCACHE_UNHASHED
hack from anon_inodes.c (see next patch).

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Miklos Szeredi <mszeredi@suse.cz>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/anon_inodes.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN fs/anon_inodes.c~fs-anon_inodes-implement-dname fs/anon_inodes.c
--- a/fs/anon_inodes.c~fs-anon_inodes-implement-dname
+++ a/fs/anon_inodes.c
@@ -45,6 +45,15 @@ static int anon_inodefs_delete_dentry(st
 	return 1;
 }
 
+/*
+ * anon_inodefs_dname() is called from d_path().
+ */
+static char *anon_inodefs_dname(struct dentry *dentry, char *buffer, int buflen)
+{
+	return dynamic_dname(dentry, buffer, buflen, "anon_inode:%s",
+				dentry->d_name.name, dentry->d_inode->i_ino);
+}
+
 static struct file_system_type anon_inode_fs_type = {
 	.name		= "anon_inodefs",
 	.get_sb		= anon_inodefs_get_sb,
@@ -52,6 +61,7 @@ static struct file_system_type anon_inod
 };
 static const struct dentry_operations anon_inodefs_dentry_operations = {
 	.d_delete	= anon_inodefs_delete_dentry,
+	.d_dname	= anon_inodefs_dname,
 };
 
 /*
_

Patches currently in -mm which might be from npiggin@suse.de are

linux-next.patch
fs-anon_inodes-implement-dname.patch
fs-remove-unneeded-dcache_unhashed-tricks.patch
fs-improve-remountro-vs-buffercache-coherency.patch
mm-define-page_mapping_flags.patch
mm-mlocking-in-try_to_unmap_one.patch
mm-mlocking-in-try_to_unmap_one-fix.patch
mm-mlocking-in-try_to_unmap_one-fix-fix.patch
mm-config_mmu-for-pg_mlocked.patch
mm-pass-address-down-to-rmap-ones.patch
mm-stop-ptlock-enlarging-struct-page.patch
mm-sigbus-instead-of-abusing-oom.patch
ipc-semc-sem-optimise-undo-list-search.patch
ipc-semc-sem-use-list-operations.patch
ipc-semc-sem-preempt-improve.patch
ipc-semc-optimize-if-semops-fail.patch
ipc-semc-add-a-per-semaphore-pending-list.patch
ipc-semc-optimize-single-semop-operations.patch
ipc-semc-optimize-single-sops-when-semval-is-zero.patch
reiser4.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

