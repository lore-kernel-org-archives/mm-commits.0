From: akpm@linux-foundation.org
Subject: + smackfs-remove-redundant-lock-fix-openo_rdwr.patch added to -mm tree
Date: Fri, 21 Mar 2008 15:56:36 -0700
Message-ID: <200803212256.m2LMuaJ6014946@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42415 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764250AbYCUW4m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 18:56:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: darwish.07@gmail.com, casey@schaufler-ca.com, corbet@lwn.net


The patch titled
     smackfs: remove redundant lock, fix open(,O_RDWR)
has been added to the -mm tree.  Its filename is
     smackfs-remove-redundant-lock-fix-openo_rdwr.patch

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
Subject: smackfs: remove redundant lock, fix open(,O_RDWR)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>

Older smackfs was parsing MAC rules by characters, thus a need of locking
write sessions on open() was needed.  This lock is no longer useful now since
each rule is handled by a single write() call.

This is also a bugfix since seq_open() was not called if an open() O_RDWR flag
was given, leading to a seq_read() without an initialized seq_file, thus an
Oops.

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Reported-by: Jonathan Corbet <corbet@lwn.net>
Acked-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/smack/smackfs.c |   35 ++---------------------------------
 1 file changed, 2 insertions(+), 33 deletions(-)

diff -puN security/smack/smackfs.c~smackfs-remove-redundant-lock-fix-openo_rdwr security/smack/smackfs.c
--- a/security/smack/smackfs.c~smackfs-remove-redundant-lock-fix-openo_rdwr
+++ a/security/smack/smackfs.c
@@ -74,11 +74,6 @@ struct smk_list_entry *smack_list;
 #define	SEQ_READ_FINISHED	1
 
 /*
- * Disable concurrent writing open() operations
- */
-static struct semaphore smack_write_sem;
-
-/*
  * Values for parsing cipso rules
  * SMK_DIGITLEN: Length of a digit field in a rule.
  * SMK_CIPSOMIN: Minimum possible cipso rule length.
@@ -168,32 +163,7 @@ static struct seq_operations load_seq_op
  */
 static int smk_open_load(struct inode *inode, struct file *file)
 {
-	if ((file->f_flags & O_ACCMODE) == O_RDONLY)
-		return seq_open(file, &load_seq_ops);
-
-	if (down_interruptible(&smack_write_sem))
-		return -ERESTARTSYS;
-
-	return 0;
-}
-
-/**
- * smk_release_load - release() for /smack/load
- * @inode: inode structure representing file
- * @file: "load" file pointer
- *
- * For a reading session, use the seq_file release
- * implementation.
- * Otherwise, we are at the end of a writing session so
- * clean everything up.
- */
-static int smk_release_load(struct inode *inode, struct file *file)
-{
-	if ((file->f_flags & O_ACCMODE) == O_RDONLY)
-		return seq_release(inode, file);
-
-	up(&smack_write_sem);
-	return 0;
+	return seq_open(file, &load_seq_ops);
 }
 
 /**
@@ -341,7 +311,7 @@ static const struct file_operations smk_
 	.read		= seq_read,
 	.llseek         = seq_lseek,
 	.write		= smk_write_load,
-	.release        = smk_release_load,
+	.release        = seq_release,
 };
 
 /**
@@ -1011,7 +981,6 @@ static int __init init_smk_fs(void)
 		}
 	}
 
-	sema_init(&smack_write_sem, 1);
 	smk_cipso_doi();
 	smk_unlbl_ambient(NULL);
 
_

Patches currently in -mm which might be from darwish.07@gmail.com are

origin.patch
smackfs-remove-redundant-lock-fix-openo_rdwr.patch
git-kvm.patch
git-security-testing.patch
lsm-introduce-inode_getsecid-and-ipc_getsecid-hooks-checkpatch-fixes.patch
lsm-audit-introduce-generic-audit-lsm-hooks-checkpatch-fixes.patch
selinux-use-new-audit-hooks-remove-redundant-exports-checkpatch-fixes.patch
audit-final-renamings-and-cleanup-checkpatch-fixes.patch

