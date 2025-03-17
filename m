Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D474D17597;
	Mon, 17 Mar 2025 00:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742172066; cv=none; b=V71B1eKaBIEKrdyNmsiB+Fzj1ViaBPpIyF7VOr1KBysTcE2wX6ycViaftyFETP574+nCn/jvTZafqZ0m/U42nXFdd9qo3AViypEReDf1agPkbeBMZPz0N1ZpWfhgKZBZTE2XuX8Cft3eW52c0IjDrC0S1kVR2MyHBq+92MGs0Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742172066; c=relaxed/simple;
	bh=pxed0V27qj42qE7RxAJuHvrCPrWViCCKuSoeF/+wqrU=;
	h=Date:To:From:Subject:Message-Id; b=cjJE2jJAZq35rMtoIKVoJgZeFyFRhxKidburia/CzB3ObaSHKEkHkkNt/3u/tJ7cNxJm9EmRs0PScD+so+SEVmFbkaQ89Jy1/WC/TcQ9BjHmHay8qbVjhL2Lai8a6Sylp14wcY7l7FttRpqz4MmmyVhmuD8hrYIOGHOKYdJRzG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oEqynbH7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oEqynbH7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D8CC4CEDD;
	Mon, 17 Mar 2025 00:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742172065;
	bh=pxed0V27qj42qE7RxAJuHvrCPrWViCCKuSoeF/+wqrU=;
	h=Date:To:From:Subject:From;
	b=oEqynbH7ODB9klbrxaTv2k/7qjhDzrvuKRwb2fqdMEQAYBPTn41aF21QQvvPNdhWd
	 TFfO3hVi2uENHTbcerAazcDbY+8mKMArct3FeevUHNS4vIcQzeVYHkOemLEZSoZN/C
	 hbnCckoSthqzoL0GFunuBy9F07v1ltL4kD8YjDKQ=
Date: Sun, 16 Mar 2025 17:41:04 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,stable@vger.kernel.org,davem@davemloft.net,adobriyan@gmail.com,yebin10@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] proc-fix-uaf-in-proc_get_inode.patch removed from -mm tree
Message-Id: <20250317004105.44D8CC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: proc: fix UAF in proc_get_inode()
has been removed from the -mm tree.  Its filename was
     proc-fix-uaf-in-proc_get_inode.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ye Bin <yebin10@huawei.com>
Subject: proc: fix UAF in proc_get_inode()
Date: Sat, 1 Mar 2025 15:06:24 +0300

Fix race between rmmod and /proc/XXX's inode instantiation.

The bug is that pde->proc_ops don't belong to /proc, it belongs to a
module, therefore dereferencing it after /proc entry has been registered
is a bug unless use_pde/unuse_pde() pair has been used.

use_pde/unuse_pde can be avoided (2 atomic ops!) because pde->proc_ops
never changes so information necessary for inode instantiation can be
saved _before_ proc_register() in PDE itself and used later, avoiding
pde->proc_ops->...  dereference.

      rmmod                         lookup
sys_delete_module
                         proc_lookup_de
			   pde_get(de);
			   proc_get_inode(dir->i_sb, de);
  mod->exit()
    proc_remove
      remove_proc_subtree
       proc_entry_rundown(de);
  free_module(mod);

                               if (S_ISREG(inode->i_mode))
	                         if (de->proc_ops->proc_read_iter)
                           --> As module is already freed, will trigger UAF

BUG: unable to handle page fault for address: fffffbfff80a702b
PGD 817fc4067 P4D 817fc4067 PUD 817fc0067 PMD 102ef4067 PTE 0
Oops: Oops: 0000 [#1] PREEMPT SMP KASAN PTI
CPU: 26 UID: 0 PID: 2667 Comm: ls Tainted: G
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)
RIP: 0010:proc_get_inode+0x302/0x6e0
RSP: 0018:ffff88811c837998 EFLAGS: 00010a06
RAX: dffffc0000000000 RBX: ffffffffc0538140 RCX: 0000000000000007
RDX: 1ffffffff80a702b RSI: 0000000000000001 RDI: ffffffffc0538158
RBP: ffff8881299a6000 R08: 0000000067bbe1e5 R09: 1ffff11023906f20
R10: ffffffffb560ca07 R11: ffffffffb2b43a58 R12: ffff888105bb78f0
R13: ffff888100518048 R14: ffff8881299a6004 R15: 0000000000000001
FS:  00007f95b9686840(0000) GS:ffff8883af100000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff80a702b CR3: 0000000117dd2000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 proc_lookup_de+0x11f/0x2e0
 __lookup_slow+0x188/0x350
 walk_component+0x2ab/0x4f0
 path_lookupat+0x120/0x660
 filename_lookup+0x1ce/0x560
 vfs_statx+0xac/0x150
 __do_sys_newstat+0x96/0x110
 do_syscall_64+0x5f/0x170
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

[adobriyan@gmail.com: don't do 2 atomic ops on the common path]
Link: https://lkml.kernel.org/r/3d25ded0-1739-447e-812b-e34da7990dcf@p183
Fixes: 778f3dd5a13c ("Fix procfs compat_ioctl regression")
Signed-off-by: Ye Bin <yebin10@huawei.com>
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: David S. Miller <davem@davemloft.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c       |   10 +++++++++-
 fs/proc/inode.c         |    6 +++---
 fs/proc/internal.h      |   14 ++++++++++++++
 include/linux/proc_fs.h |    7 +++++--
 4 files changed, 31 insertions(+), 6 deletions(-)

--- a/fs/proc/generic.c~proc-fix-uaf-in-proc_get_inode
+++ a/fs/proc/generic.c
@@ -559,10 +559,16 @@ struct proc_dir_entry *proc_create_reg(c
 	return p;
 }
 
-static inline void pde_set_flags(struct proc_dir_entry *pde)
+static void pde_set_flags(struct proc_dir_entry *pde)
 {
 	if (pde->proc_ops->proc_flags & PROC_ENTRY_PERMANENT)
 		pde->flags |= PROC_ENTRY_PERMANENT;
+	if (pde->proc_ops->proc_read_iter)
+		pde->flags |= PROC_ENTRY_proc_read_iter;
+#ifdef CONFIG_COMPAT
+	if (pde->proc_ops->proc_compat_ioctl)
+		pde->flags |= PROC_ENTRY_proc_compat_ioctl;
+#endif
 }
 
 struct proc_dir_entry *proc_create_data(const char *name, umode_t mode,
@@ -626,6 +632,7 @@ struct proc_dir_entry *proc_create_seq_p
 	p->proc_ops = &proc_seq_ops;
 	p->seq_ops = ops;
 	p->state_size = state_size;
+	pde_set_flags(p);
 	return proc_register(parent, p);
 }
 EXPORT_SYMBOL(proc_create_seq_private);
@@ -656,6 +663,7 @@ struct proc_dir_entry *proc_create_singl
 		return NULL;
 	p->proc_ops = &proc_single_ops;
 	p->single_show = show;
+	pde_set_flags(p);
 	return proc_register(parent, p);
 }
 EXPORT_SYMBOL(proc_create_single_data);
--- a/fs/proc/inode.c~proc-fix-uaf-in-proc_get_inode
+++ a/fs/proc/inode.c
@@ -656,13 +656,13 @@ struct inode *proc_get_inode(struct supe
 
 	if (S_ISREG(inode->i_mode)) {
 		inode->i_op = de->proc_iops;
-		if (de->proc_ops->proc_read_iter)
+		if (pde_has_proc_read_iter(de))
 			inode->i_fop = &proc_iter_file_ops;
 		else
 			inode->i_fop = &proc_reg_file_ops;
 #ifdef CONFIG_COMPAT
-		if (de->proc_ops->proc_compat_ioctl) {
-			if (de->proc_ops->proc_read_iter)
+		if (pde_has_proc_compat_ioctl(de)) {
+			if (pde_has_proc_read_iter(de))
 				inode->i_fop = &proc_iter_file_ops_compat;
 			else
 				inode->i_fop = &proc_reg_file_ops_compat;
--- a/fs/proc/internal.h~proc-fix-uaf-in-proc_get_inode
+++ a/fs/proc/internal.h
@@ -85,6 +85,20 @@ static inline void pde_make_permanent(st
 	pde->flags |= PROC_ENTRY_PERMANENT;
 }
 
+static inline bool pde_has_proc_read_iter(const struct proc_dir_entry *pde)
+{
+	return pde->flags & PROC_ENTRY_proc_read_iter;
+}
+
+static inline bool pde_has_proc_compat_ioctl(const struct proc_dir_entry *pde)
+{
+#ifdef CONFIG_COMPAT
+	return pde->flags & PROC_ENTRY_proc_compat_ioctl;
+#else
+	return false;
+#endif
+}
+
 extern struct kmem_cache *proc_dir_entry_cache;
 void pde_free(struct proc_dir_entry *pde);
 
--- a/include/linux/proc_fs.h~proc-fix-uaf-in-proc_get_inode
+++ a/include/linux/proc_fs.h
@@ -20,10 +20,13 @@ enum {
 	 * If in doubt, ignore this flag.
 	 */
 #ifdef MODULE
-	PROC_ENTRY_PERMANENT = 0U,
+	PROC_ENTRY_PERMANENT		= 0U,
 #else
-	PROC_ENTRY_PERMANENT = 1U << 0,
+	PROC_ENTRY_PERMANENT		= 1U << 0,
 #endif
+
+	PROC_ENTRY_proc_read_iter	= 1U << 1,
+	PROC_ENTRY_proc_compat_ioctl	= 1U << 2,
 };
 
 struct proc_ops {
_

Patches currently in -mm which might be from yebin10@huawei.com are


