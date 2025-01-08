Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C9D20B20
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 04:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736309403; cv=none; b=PRM/lb6BMmPlelXB+jZAgX+Y0AwIL8/YnPPED0VjFB0tlDmZAAUuf5Sy3UE+K7K/jLErixze3zrEiLoIaDa4zPJNUTY+ziXUofimLxHBouRHtls0zbm8y5mUazk6YSTbyU+9eq9h8LA+cxsmJkC5scAJMOYzThEwB/W5NxfmGuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736309403; c=relaxed/simple;
	bh=WTp5W7miWrpWIHYpKviLIFKJnhiPWwO4t4VdJ+cBAPk=;
	h=Date:To:From:Subject:Message-Id; b=ew4dswdw7F/+ChlufrIorqZR2Ne296pCXyj7ZaKdIMogYyEOVVcHxjcAEk4UAJkDyaSaoRK3LVjg8sL6XK/+4IpxNWXUp7y3tRrRINEDIZpRTgnKYnxvu/NbtOVRD+WWtwal150zvM/Q+0r22T/Cs4BkvkfAm+OIOjMWA95UCD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hQZT3NiD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hQZT3NiD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BB1EC4CED0;
	Wed,  8 Jan 2025 04:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736309402;
	bh=WTp5W7miWrpWIHYpKviLIFKJnhiPWwO4t4VdJ+cBAPk=;
	h=Date:To:From:Subject:From;
	b=hQZT3NiDT+QujJNOnHHz8cO3Bc6LVedFXkP3bvx5xyGn7D5I/XWMJ3Df67sd0GmlJ
	 Qe4c6pM6DcQSPq05EFhtO+e2VkPgQLOcgcMaItI/9XruLlW3EPArf7vHH8Xoqni4AD
	 mT5GBOxxb8lX/jtP4zi/0Af5nUIgrVpd5cUVxuTA=
Date: Tue, 07 Jan 2025 20:10:01 -0800
To: mm-commits@vger.kernel.org,wanghaichi0403@gmail.com,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,glass.su@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-check-tl-count-of-truncate-log-inode-in-ocfs2_get_truncate_log_info.patch added to mm-nonmm-unstable branch
Message-Id: <20250108041002.6BB1EC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: check tl->count of truncate log inode in ocfs2_get_truncate_log_info
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-check-tl-count-of-truncate-log-inode-in-ocfs2_get_truncate_log_info.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-check-tl-count-of-truncate-log-inode-in-ocfs2_get_truncate_log_info.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Su Yue <glass.su@suse.com>
Subject: ocfs2: check tl->count of truncate log inode in ocfs2_get_truncate_log_info
Date: Wed, 8 Jan 2025 10:41:19 +0800

syz reported:

(syz-executor404,5313,0):ocfs2_truncate_log_append:5874 ERROR: bug
expression: tl_count > ocfs2_truncate_recs_per_inode(osb->sb) ||
tl_count == 0
(syz-executor404,5313,0):ocfs2_truncate_log_append:5874 ERROR: Truncate
record count on #77 invalid wanted 39, actual 2087
------------[ cut here  ]------------
kernel BUG at fs/ocfs2/alloc.c:5874!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5313 Comm: syz-executor404 Not tainted
6.12.0-rc5-syzkaller-00299-g11066801dd4b #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:ocfs2_truncate_log_append+0x9a8/0x9c0 fs/ocfs2/alloc.c:5868
RSP: 0018:ffffc9000cf16f40 EFLAGS: 00010292
RAX: b4b54f1d10640800 RBX: 0000000000000027 RCX: b4b54f1d10640800
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: ffffc9000cf17070 R08: ffffffff8174a14c R09: 1ffff11003f8519a
R10: dffffc0000000000 R11: ffffed1003f8519b R12: 1ffff110085f5f58
R13: ffffff3800000000 R14: 000000000000004d R15: ffff8880438f0008
FS:  00005555722df380(0000) GS:ffff88801fc00000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000002000f000 CR3: 000000004010e000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
<TASK>
ocfs2_remove_btree_range+0x1303/0x1860 fs/ocfs2/alloc.c:5789
ocfs2_remove_inode_range+0xff3/0x29f0 fs/ocfs2/file.c:1907
ocfs2_reflink_remap_extent fs/ocfs2/refcounttree.c:4537 [inline]
ocfs2_reflink_remap_blocks+0xcd4/0x1f30 fs/ocfs2/refcounttree.c:4684
ocfs2_remap_file_range+0x5fa/0x8d0 fs/ocfs2/file.c:2736
vfs_copy_file_range+0xc07/0x1510 fs/read_write.c:1615
__do_sys_copy_file_range fs/read_write.c:1705 [inline]
__se_sys_copy_file_range+0x3f2/0x5d0 fs/read_write.c:1668
do_syscall_x64 arch/x86/entry/common.c:52 [inline]
do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fd327167af9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 61 17 00 00 90 48 89 f8 48 89
f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01
f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe6b8e22e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000146
RAX: ffffffffffffffda RBX: 00007fd3271b005e RCX: 00007fd327167af9
RDX: 0000000000000006 RSI: 0000000000000000 RDI: 0000000000000004
RBP: 00007fd3271de610 R08: 000000000000d8c2 R09: 0000000000000000
R10: 0000000020000640 R11: 0000000000000246 R12: 0000000000000001
R13: 00007ffe6b8e24b8 R14: 0000000000000001 R15: 0000000000000001
</TASK>

The fuzz image has a truncate log inode whose tl_count is bigger than
ocfs2_truncate_recs_per_inode() so it triggers the BUG in
ocfs2_truncate_log_append().

As what the check in ocfs2_truncate_log_append() does, just do same check
into ocfs2_get_truncate_log_info when truncate log inode is reading in so
we can bail out earlier.

Link: https://lkml.kernel.org/r/20250108024119.60313-1-glass.su@suse.com
Signed-off-by: Su Yue <glass.su@suse.com>
Reported-by: Liebes Wang <wanghaichi0403@gmail.com>
Link: https://lore.kernel.org/ocfs2-devel/CADCV8souQhdP0RdQF1U7KTWtuHDfpn+3LnTt-EEuMmB-pMRrgQ@mail.gmail.com/T/#u
Reported-by: syzbot+a66542ca5ebb4233b563@syzkaller.appspotmail.com
Tested-by: syzbot+a66542ca5ebb4233b563@syzkaller.appspotmail.com
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/fs/ocfs2/alloc.c~ocfs2-check-tl-count-of-truncate-log-inode-in-ocfs2_get_truncate_log_info
+++ a/fs/ocfs2/alloc.c
@@ -6154,6 +6154,9 @@ static int ocfs2_get_truncate_log_info(s
 	int status;
 	struct inode *inode = NULL;
 	struct buffer_head *bh = NULL;
+	struct ocfs2_dinode *di;
+	struct ocfs2_truncate_log *tl;
+	unsigned int tl_count;
 
 	inode = ocfs2_get_system_file_inode(osb,
 					   TRUNCATE_LOG_SYSTEM_INODE,
@@ -6170,6 +6173,18 @@ static int ocfs2_get_truncate_log_info(s
 		mlog_errno(status);
 		goto bail;
 	}
+
+	di = (struct ocfs2_dinode *)bh->b_data;
+	tl = &di->id2.i_dealloc;
+	tl_count = le16_to_cpu(tl->tl_count);
+	if (unlikely(tl_count > ocfs2_truncate_recs_per_inode(osb->sb) ||
+		     tl_count == 0)) {
+		status = -EFSCORRUPTED;
+		iput(inode);
+		brelse(bh);
+		mlog_errno(status);
+		goto bail;
+	}
 
 	*tl_inode = inode;
 	*tl_bh    = bh;
_

Patches currently in -mm which might be from glass.su@suse.com are

ocfs2-check-tl-count-of-truncate-log-inode-in-ocfs2_get_truncate_log_info.patch

