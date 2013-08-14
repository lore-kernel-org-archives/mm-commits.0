From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-fix-null-pointer-dereference-in-ocfs2_dir_foreach_blk_id.patch
 removed from -mm tree
Date: Wed, 14 Aug 2013 12:35:46 -0700
Message-ID: <520bdc12.4yzbvzTZFkkg/sZz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54244 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932817Ab3HNTfr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Aug 2013 15:35:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, wb@munzinger.de, viro@zeniv.linux.org.uk, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com

Subject: [merged] ocfs2-fix-null-pointer-dereference-in-ocfs2_dir_foreach_blk_id.patch removed from -mm tree
To: jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,viro@zeniv.linux.org.uk,wb@munzinger.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 14 Aug 2013 12:35:46 -0700


The patch titled
     Subject: ocfs2: fix null pointer dereference in ocfs2_dir_foreach_blk_id()
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-null-pointer-dereference-in-ocfs2_dir_foreach_blk_id.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jeff Liu <jeff.liu@oracle.com>
Subject: ocfs2: fix null pointer dereference in ocfs2_dir_foreach_blk_id()

Fix a NULL pointer deference while removing an empty directory, which was
introduced by 3704412bdbf3 ("[readdir] convert ocfs2").

BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<          (null)>]           (null)
PGD 6da85067 PUD 6da89067 PMD 0
Oops: 0010 [#1] SMP
CPU: 0 PID: 6564 Comm: rmdir Tainted: G           O 3.11.0-rc1 #4
RIP: 0010:[<0000000000000000>]  [<          (null)>]           (null)
Call Trace:
[<ffffffffa038a30e>] ? ocfs2_dir_foreach_blk_id+0x17e/0x220 [ocfs2]
[<ffffffffa038e5f9>] ocfs2_dir_foreach+0x49/0x50 [ocfs2]
[<ffffffffa038ec2c>] ocfs2_empty_dir+0x12c/0x3e0 [ocfs2]
[<ffffffffa03b3ade>] ocfs2_unlink+0x56e/0xc10 [ocfs2]
[<ffffffff811b3a05>] vfs_rmdir+0xd5/0x140
[<ffffffff811b3c3b>] do_rmdir+0x1cb/0x1e0
[<ffffffff813697f4>] ? lockdep_sys_exit_thunk+0x35/0x67
[<ffffffff8136977e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[<ffffffff811b6996>] SyS_rmdir+0x16/0x20
[<ffffffff816e2a82>] system_call_fastpath+0x16/0x1b
Code:  Bad RIP value.
RIP  [<          (null)>]           (null)
RSP <ffff88006daddc10>
CR2: 0000000000000000

[dan.carpenter@oracle.com: fix pointer math]
Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Reported-by: David Weber <wb@munzinger.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dir.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN fs/ocfs2/dir.c~ocfs2-fix-null-pointer-dereference-in-ocfs2_dir_foreach_blk_id fs/ocfs2/dir.c
--- a/fs/ocfs2/dir.c~ocfs2-fix-null-pointer-dereference-in-ocfs2_dir_foreach_blk_id
+++ a/fs/ocfs2/dir.c
@@ -2153,11 +2153,9 @@ int ocfs2_empty_dir(struct inode *inode)
 {
 	int ret;
 	struct ocfs2_empty_dir_priv priv = {
-		.ctx.actor = ocfs2_empty_dir_filldir
+		.ctx.actor = ocfs2_empty_dir_filldir,
 	};
 
-	memset(&priv, 0, sizeof(priv));
