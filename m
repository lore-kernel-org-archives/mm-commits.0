From: akpm@osdl.org
Subject: - lockdep-annotate-nfsd4-recover-code.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:10:58 -0800
Message-ID: <200612082010.kB8KAwsp002867@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58985 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946552AbWLHULH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:11:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     lockdep: annotate nfsd4 recover code
has been removed from the -mm tree.  Its filename was
     lockdep-annotate-nfsd4-recover-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lockdep: annotate nfsd4 recover code
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

> =============================================
> [ INFO: possible recursive locking detected ]
> 2.6.18-1.2724.lockdepPAE #1
> ---------------------------------------------
> nfsd/6884 is trying to acquire lock:
>  (&inode->i_mutex){--..}, at: [<c04811e5>] vfs_rmdir+0x73/0xf4
>
> but task is already holding lock:
>  (&inode->i_mutex){--..}, at: [<f8dfa621>]
> nfsd4_clear_clid_dir+0x1f/0x3d [nfsd]
>
> other info that might help us debug this:
> 3 locks held by nfsd/6884:
>  #0:  (hash_sem){----}, at: [<f8de05eb>] nfsd+0x181/0x2ea [nfsd]
>  #1:  (client_mutex){--..}, at: [<f8df6d19>]
> nfsd4_setclientid_confirm+0x3b/0x2cf [nfsd]
>  #2:  (&inode->i_mutex){--..}, at: [<f8dfa621>]
> nfsd4_clear_clid_dir+0x1f/0x3d [nfsd]
>
> stack backtrace:
>  [<c040524d>] dump_trace+0x69/0x1af
>  [<c04053ab>] show_trace_log_lvl+0x18/0x2c
>  [<c040595f>] show_trace+0xf/0x11
>  [<c0405a53>] dump_stack+0x15/0x17
>  [<c043ca7a>] __lock_acquire+0x110/0x9b6
>  [<c043d91e>] lock_acquire+0x5c/0x7a
>  [<c061a41b>] __mutex_lock_slowpath+0xde/0x234
>  [<c04811e5>] vfs_rmdir+0x73/0xf4
>  [<f8dfa62b>] nfsd4_clear_clid_dir+0x29/0x3d [nfsd]
>  [<f8dfa733>] nfsd4_remove_clid_dir+0xb8/0xf8 [nfsd]
>  [<f8df6e90>] nfsd4_setclientid_confirm+0x1b2/0x2cf [nfsd]
>  [<f8def19a>] nfsd4_proc_compound+0x137a/0x166c [nfsd]
>  [<f8de00d5>] nfsd_dispatch+0xc5/0x180 [nfsd]
>  [<f8d09d83>] svc_process+0x3bd/0x631 [sunrpc]
>  [<f8de0604>] nfsd+0x19a/0x2ea [nfsd]
>  [<c0404e27>] kernel_thread_helper+0x7/0x10
> DWARF2 unwinder stuck at kernel_thread_helper+0x7/0x10
> Leftover inexact backtrace:
>  =======================

Some nesting annotation to the nfsd4 recovery code.
The vfs operations called will take dentry->d_inode->i_mutex.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/nfsd/nfs4recover.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/nfsd/nfs4recover.c~lockdep-annotate-nfsd4-recover-code fs/nfsd/nfs4recover.c
--- a/fs/nfsd/nfs4recover.c~lockdep-annotate-nfsd4-recover-code
+++ a/fs/nfsd/nfs4recover.c
@@ -259,7 +259,7 @@ nfsd4_remove_clid_file(struct dentry *di
 		printk("nfsd4: non-file found in client recovery directory\n");
 		return -EINVAL;
 	}
-	mutex_lock(&dir->d_inode->i_mutex);
+	mutex_lock_nested(&dir->d_inode->i_mutex, I_MUTEX_PARENT);
 	status = vfs_unlink(dir->d_inode, dentry);
 	mutex_unlock(&dir->d_inode->i_mutex);
 	return status;
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
lockdep-annotate-nfsd4-recover-code.patch

