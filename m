Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBAE828725B
	for <mm-commits@vger.kernel.org>; Mon, 15 Jun 2026 23:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781565684; cv=none; b=JpXqP+OWOT8X338QPv9I+R5zxnp3kPHxkvT6XrrwDBZwSIJujrCHwLYROLp2dBl9WKnwr1SwF3SJSuLE6ouuiNrYVniGVQsxPI2uWEbEjqXHFxxbyZ7eGcOCZqBXzekxt+Kv7S/JQwkHQ9nMDuI0Q2UBN85ZHOtE/vCfxcH5JRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781565684; c=relaxed/simple;
	bh=van4TwxVwbfBWdRSK2KRWw5AfjhRWdcx4MgCB5raMq0=;
	h=Date:To:From:Subject:Message-Id; b=O7sVkfnE19GsOK+SBP6utEetS5+eLCeb5m8PEpVIw6QZPPB11uRlmUs0pz/FemAefqDq4wBqOmWlGaCPIT6zVURMVeMthD1SYSp2pusT1SZuflwt1BDkyP3cFPuluczLifpamYVD5xoHMz1dBiBK5AyqYJMvj5jnelB9PJ3huhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SaX9+Dqp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SaX9+Dqp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B6E11F000E9;
	Mon, 15 Jun 2026 23:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781565682;
	bh=AVOeUlNREpVV7QfyMVs6Q6YE/wkuqDB0cR0p54q/Rnc=;
	h=Date:To:From:Subject;
	b=SaX9+Dqpjaea2zKBHmyi29sYH5Bs2qERKH0fMWt+HtTcNjGMWqbJYzgjYjsIr5pPj
	 kYWFz4ha7OlGWhx7BbDMDKOKiWxNO7/61OM1snxBi/x5a52aZGyjU5TScxjktXCayj
	 aWdJ/x+IPAr1aq4/SpzWx0mNtRdHxnF/L+dxbaYQ=
Date: Mon, 15 Jun 2026 16:21:21 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,jiangqi903@gmail.com,heming.zhao@suse.com,gechangwei@live.cn,nogikh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-circular-locking-dependency-in-ocfs2_dio_end_io_write.patch added to mm-nonmm-unstable branch
Message-Id: <20260615232122.6B6E11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: fix circular locking dependency in ocfs2_dio_end_io_write
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-fix-circular-locking-dependency-in-ocfs2_dio_end_io_write.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-circular-locking-dependency-in-ocfs2_dio_end_io_write.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Aleksandr Nogikh <nogikh@google.com>
Subject: ocfs2: fix circular locking dependency in ocfs2_dio_end_io_write
Date: Fri, 12 Jun 2026 11:50:20 +0000 (UTC)

A circular locking dependency involves INODE_ALLOC_SYSTEM_INODE,
EXTENT_ALLOC_SYSTEM_INODE, and ORPHAN_DIR_SYSTEM_INODE.

1. ocfs2_mknod() acquires INODE_ALLOC then EXTENT_ALLOC.

2. ocfs2_dio_end_io_write() acquires EXTENT_ALLOC for unwritten
   extents, then ORPHAN_DIR via ocfs2_del_inode_from_orphan() while still
   holding EXTENT_ALLOC.

3. ocfs2_wipe_inode() acquires ORPHAN_DIR then INODE_ALLOC via
   ocfs2_remove_inode.

Break the cycle in ocfs2_dio_end_io_write() by freeing the allocation
contexts (releasing EXTENT_ALLOC) before acquiring ORPHAN_DIR.

WARNING: possible circular locking dependency detected
------------------------------------------------------
is trying to acquire lock:
ffff8881e78b33a0
(&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at:
ocfs2_evict_inode+0x1539/0x43b0 fs/ocfs2/inode.c:1299

but task is already holding lock:
ffff8881e78b4fa0
(&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at:
ocfs2_evict_inode+0xe97/0x43b0 fs/ocfs2/inode.c:1299

the existing dependency chain (in reverse order) is:

-> #2 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}:
       inode_lock include/linux/fs.h:1029 [inline]
       ocfs2_del_inode_from_orphan+0x12e/0x7a0 fs/ocfs2/namei.c:2728
       ocfs2_dio_end_io+0xf9c/0x1370 fs/ocfs2/aops.c:2418
       dio_complete+0x25b/0x790 fs/direct-io.c:281

-> #1 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}:
       inode_lock include/linux/fs.h:1029 [inline]
       ocfs2_reserve_suballoc_bits+0x16d/0x4840 fs/ocfs2/suballoc.c:882
       ocfs2_reserve_new_metadata_blocks+0x415/0x9a0
       fs/ocfs2/suballoc.c:1078
       ocfs2_mknod+0x10f3/0x2260 fs/ocfs2/namei.c:351

-> #0 (&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}:
       __lock_acquire+0x15a5/0x2cf0 kernel/locking/lockdep.c:5237
       lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
       down_write+0x96/0x200 kernel/locking/rwsem.c:1625
       inode_lock include/linux/fs.h:1029 [inline]
       ocfs2_remove_inode fs/ocfs2/inode.c:733 [inline]
       ocfs2_wipe_inode fs/ocfs2/inode.c:896 [inline]
       ocfs2_delete_inode fs/ocfs2/inode.c:1157 [inline]
       ocfs2_evict_inode+0x1539/0x43b0 fs/ocfs2/inode.c:1299

Chain exists of:
  &ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE] -->
  &ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE] -->
  &ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]);
                               lock(&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]);
                               lock(&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]);
  lock(&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]);

 *** DEADLOCK ***

Link: https://lore.kernel.org/97c902a6-3bcf-43ea-9b70-f1f136a6c3f2@mail.kernel.org
Fixes: d647c5b2fbf8 ("ocfs2: split transactions in dio completion to avoid credit exhaustion")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
Reported-by: syzbot+b225d4dfce6219600c42@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b225d4dfce6219600c42
Link: https://syzkaller.appspot.com/ai_job?id=0b53ce1e-2972-4192-aa85-8097a702762c
Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/fs/ocfs2/aops.c~ocfs2-fix-circular-locking-dependency-in-ocfs2_dio_end_io_write
+++ a/fs/ocfs2/aops.c
@@ -2372,6 +2372,15 @@ commit:
 unlock:
 	up_write(&oi->ip_alloc_sem);
 
+	if (data_ac) {
+		ocfs2_free_alloc_context(data_ac);
+		data_ac = NULL;
+	}
+	if (meta_ac) {
+		ocfs2_free_alloc_context(meta_ac);
+		meta_ac = NULL;
+	}
+
 	/* everything looks good, let's start the cleanup */
 	if (!ret && dwc->dw_orphaned) {
 		BUG_ON(dwc->dw_writer_pid != task_pid_nr(current));
@@ -2383,10 +2392,6 @@ unlock:
 	ocfs2_inode_unlock(inode, 1);
 	brelse(di_bh);
 out:
-	if (data_ac)
-		ocfs2_free_alloc_context(data_ac);
-	if (meta_ac)
-		ocfs2_free_alloc_context(meta_ac);
 	ocfs2_run_deallocs(osb, &dealloc);
 	ocfs2_dio_free_write_ctx(inode, dwc);
 
_

Patches currently in -mm which might be from nogikh@google.com are

ocfs2-fix-circular-locking-dependency-in-ocfs2_dio_end_io_write.patch

