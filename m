Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EBE23BBFA2
	for <mm-commits@vger.kernel.org>; Thu,  4 Jun 2026 21:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780609801; cv=none; b=Y2LVfP6VL7sNlOfX+riOwoFPaUbNUDAIX3+UYGdIdEmwUGDinrO+oLHrwbow5UppEUOVJ9swuZlXfZPmkdYNiFYtDhMkRdH9maqZNTAwfKkGxYk1aZx38XFqrca4fAhKtkvRw3sII4/ehv4+CvhUM44gSHcrYF+MR9G8z3PRDhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780609801; c=relaxed/simple;
	bh=IdS3pn65egL6RAXMqn3tjeWSHeZ/Db/4FJIipHEUIQU=;
	h=Date:To:From:Subject:Message-Id; b=cfN7D2wpDskeyA7f6/KduKPieBOCrMu8Z80iArt2Ts8hd/jnJD95/qChRtD954sZEw0iGvEuCJAgXlYlIZSa4DffScsnA8y0M5thkN21nJSCVFhRUUhCQdWFta1PIZaCE7rqNltKSlovTU7HxOjGwvq8ExIcdMzf96BHV0Fj4Z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gQYblGDT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gQYblGDT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66E1D1F00893;
	Thu,  4 Jun 2026 21:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780609800;
	bh=W9iX4yZoVwPu1RWVrUZVRU+3KpDqzp0r5YKrTJ8gQnQ=;
	h=Date:To:From:Subject;
	b=gQYblGDTlt04zBPIyw+VRVorzKQiSF5TJcfCWHQvN6yGEU3CtCIT5r2vgFU6rdEJp
	 ykcUkG9IfGfsLM2gROjhQvOww6D1Vpc63CoWzbn+Hk3iXgqSQuuAfMg0KIBFHnOKfY
	 uhIqagxg89uLAc31A2hGN3+3gd6hOPBd6IMLhc5Q=
Date: Thu, 04 Jun 2026 14:49:59 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,rollkingzzc@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-rebase-copied-fsdlm-lvb-pointers-in-locking_state.patch removed from -mm tree
Message-Id: <20260604215000.66E1D1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: rebase copied fsdlm LVB pointers in locking_state
has been removed from the -mm tree.  Its filename was
     ocfs2-rebase-copied-fsdlm-lvb-pointers-in-locking_state.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhang Cen <rollkingzzc@gmail.com>
Subject: ocfs2: rebase copied fsdlm LVB pointers in locking_state
Date: Mon, 25 May 2026 12:17:26 +0800

The locking_state debugfs iterator snapshots struct ocfs2_lock_res by
value under ocfs2_dlm_tracking_lock and later formats that copy in
ocfs2_dlm_seq_show().  That is fine for the inline fields, but the
userspace fsdlm stack stores the LVB through lksb_fsdlm.sb_lvbptr.  Once
the iterator drops the tracking lock, a copied non-NULL sb_lvbptr still
points into the original lockres owner, so teardown can free that
container before the debugfs dump walks the raw LVB bytes.

Rebase the copied sb_lvbptr to the copied l_lksb before dumping the raw
LVB.  The seq snapshot already carries the inline LVB storage reserved in
struct ocfs2_dlm_lksb, so the debugfs reader can dump the copied bytes
without borrowing the original lockres lifetime.

The buggy scenario involves two paths, with each column showing the order
within that path:

locking_state reader:                  lockres teardown:
1. ocfs2_dlm_seq_start()/next()        1. file release or another owner
   copies struct ocfs2_lock_res           teardown reaches
2. ocfs2_dlm_seq_show() formats           ocfs2_lock_res_free()
   the copied row                      2. the lockres is removed from the
3. ocfs2_dlm_lvb() follows the            tracking list
   copied sb_lvbptr                   3. the owner frees the original
                                          lockres container

Validation reproduced this kernel report:
KASAN slab-use-after-free in ocfs2_dlm_seq_show+0x1bd/0x430
RIP: 0033:0x7f8ec4b1e29d
The buggy address belongs to the object at ffff88810a1e0800 which belongs
to the cache kmalloc-1k of size 1024
The buggy address is located 368 bytes inside of freed 1024-byte region
[ffff88810a1e0800, ffff88810a1e0c00)
Read of size 1
Call trace:
  dump_stack_lvl+0x66/0xa0
  print_report+0xce/0x630
  ocfs2_dlm_seq_show+0x1bd/0x430 (fs/ocfs2/dlmglue.c:3137)
  srso_alias_return_thunk+0x5/0xfbef5
  __virt_addr_valid+0x19f/0x330
  kasan_report+0xe0/0x110
  seq_read_iter+0x29d/0x790
  seq_read+0x20a/0x280
  find_held_lock+0x2b/0x80
  rcu_read_unlock+0x18/0x70
  full_proxy_read+0x9e/0xd0
  vfs_read+0x12c/0x590
  ksys_read+0xd2/0x170
  do_user_addr_fault+0x65a/0x890
  do_syscall_64+0x115/0x6a0 (arch/x86/entry/syscall_64.c:87)
  entry_SYSCALL_64_after_hwframe+0x77/0x7f
Allocated by task stack:
  kasan_save_stack+0x33/0x60
  kasan_save_track+0x14/0x30
  __kasan_kmalloc+0xaa/0xb0
  ocfs2_file_open+0x13e/0x300
  do_dentry_open+0x233/0x7f0
  vfs_open+0x5a/0x1b0
  path_openat+0x66d/0x1540
  do_file_open+0x186/0x2b0
  do_sys_openat2+0xce/0x150
  __x64_sys_openat+0xd0/0x140
  do_syscall_64+0x115/0x6a0 (arch/x86/entry/syscall_64.c:87)
  entry_SYSCALL_64_after_hwframe+0x77/0x7f
Freed by task stack:
  kasan_save_stack+0x33/0x60
  kasan_save_track+0x14/0x30
  kasan_save_free_info+0x3b/0x60
  __kasan_slab_free+0x5f/0x80
  kfree+0x313/0x590
  ocfs2_file_release+0x138/0x260
  __fput+0x1df/0x4b0
  fput_close_sync+0xd2/0x170
  __x64_sys_close+0x55/0x90
  do_syscall_64+0x115/0x6a0 (arch/x86/entry/syscall_64.c:87)
  entry_SYSCALL_64_after_hwframe+0x77/0x7f

Link: https://lore.kernel.org/20260525041726.4112882-1-rollkingzzc@gmail.com
Fixes: cf4d8d75d8ab ("ocfs2: add fsdlm to stackglue")
Assisted-by: Codex:gpt-5.5
Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmglue.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/fs/ocfs2/dlmglue.c~ocfs2-rebase-copied-fsdlm-lvb-pointers-in-locking_state
+++ a/fs/ocfs2/dlmglue.c
@@ -3134,6 +3134,22 @@ static void *ocfs2_dlm_seq_next(struct s
  *	- Add last pr/ex unlock times and first lock wait time in usecs
  */
 #define OCFS2_DLM_DEBUG_STR_VERSION 4
+
+/*
+ * The debug iterator snapshots lockres by value, so a userspace-stack LVB
+ * pointer copied from the original lockres must be rebased to the copied
+ * lksb before the dump walks the raw bytes.
+ */
+static void ocfs2_dlm_seq_rebase_lvb(struct ocfs2_lock_res *lockres)
+{
+	if (!ocfs2_stack_supports_plocks())
+		return;
+
+	if (lockres->l_lksb.lksb_fsdlm.sb_lvbptr)
+		lockres->l_lksb.lksb_fsdlm.sb_lvbptr =
+			(char *)&lockres->l_lksb + sizeof(struct dlm_lksb);
+}
+
 static int ocfs2_dlm_seq_show(struct seq_file *m, void *v)
 {
 	int i;
@@ -3191,6 +3207,7 @@ static int ocfs2_dlm_seq_show(struct seq
 		   lockres->l_blocking);
 
 	/* Dump the raw LVB */
+	ocfs2_dlm_seq_rebase_lvb(lockres);
 	lvb = ocfs2_dlm_lvb(&lockres->l_lksb);
 	for(i = 0; i < DLM_LVB_LEN; i++)
 		seq_printf(m, "0x%x\t", lvb[i]);
_

Patches currently in -mm which might be from rollkingzzc@gmail.com are


