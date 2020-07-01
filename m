From: akpm@linux-foundation.org
Subject: + ocfs2-change-slot-number-type-s16-to-u16.patch added to
 -mm tree
Date: Tue, 30 Jun 2020 19:02:03 -0700
Message-ID: <20200701020203.5R2L4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725805AbgGACCF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 30 Jun 2020 22:02:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com, joseph.qi@linux.alibaba.com, jlbec@evilplan.org, ghe@suse.com, gechangwei@live.cn, dan.carpenter@oracle.com, junxiao.bi@oracle.com


The patch titled
     Subject: ocfs2: change slot number type s16 to u16
has been added to the -mm tree.  Its filename is
     ocfs2-change-slot-number-type-s16-to-u16.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-change-slot-number-type-s16-to-u16.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-change-slot-number-type-s16-to-u16.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: ocfs2: change slot number type s16 to u16

Dan Carpenter reported the following static checker warning.

	fs/ocfs2/super.c:1269 ocfs2_parse_options() warn: '(-1)' 65535 can't fit into 32767 'mopt->slot'
	fs/ocfs2/suballoc.c:859 ocfs2_init_inode_steal_slot() warn: '(-1)' 65535 can't fit into 32767 'osb->s_inode_steal_slot'
	fs/ocfs2/suballoc.c:867 ocfs2_init_meta_steal_slot() warn: '(-1)' 65535 can't fit into 32767 'osb->s_meta_steal_slot'

That's because OCFS2_INVALID_SLOT is (u16)-1. Slot number in ocfs2 can be
never negative, so change s16 to u16.

Link: http://lkml.kernel.org/r/20200627001259.19757-1-junxiao.bi@oracle.com
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/ocfs2.h    |    4 ++--
 fs/ocfs2/suballoc.c |    4 ++--
 fs/ocfs2/super.c    |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

--- a/fs/ocfs2/ocfs2.h~ocfs2-change-slot-number-type-s16-to-u16
+++ a/fs/ocfs2/ocfs2.h
@@ -327,8 +327,8 @@ struct ocfs2_super
 	spinlock_t osb_lock;
 	u32 s_next_generation;
 	unsigned long osb_flags;
-	s16 s_inode_steal_slot;
-	s16 s_meta_steal_slot;
+	u16 s_inode_steal_slot;
+	u16 s_meta_steal_slot;
 	atomic_t s_num_inodes_stolen;
 	atomic_t s_num_meta_stolen;
 
--- a/fs/ocfs2/suballoc.c~ocfs2-change-slot-number-type-s16-to-u16
+++ a/fs/ocfs2/suballoc.c
@@ -879,9 +879,9 @@ static void __ocfs2_set_steal_slot(struc
 {
 	spin_lock(&osb->osb_lock);
 	if (type == INODE_ALLOC_SYSTEM_INODE)
-		osb->s_inode_steal_slot = slot;
+		osb->s_inode_steal_slot = (u16)slot;
 	else if (type == EXTENT_ALLOC_SYSTEM_INODE)
-		osb->s_meta_steal_slot = slot;
+		osb->s_meta_steal_slot = (u16)slot;
 	spin_unlock(&osb->osb_lock);
 }
 
--- a/fs/ocfs2/super.c~ocfs2-change-slot-number-type-s16-to-u16
+++ a/fs/ocfs2/super.c
@@ -78,7 +78,7 @@ struct mount_options
 	unsigned long	commit_interval;
 	unsigned long	mount_opt;
 	unsigned int	atime_quantum;
-	signed short	slot;
+	unsigned short	slot;
 	int		localalloc_opt;
 	unsigned int	resv_level;
 	int		dir_resv_level;
@@ -1349,7 +1349,7 @@ static int ocfs2_parse_options(struct su
 				goto bail;
 			}
 			if (option)
-				mopt->slot = (s16)option;
+				mopt->slot = (u16)option;
 			break;
 		case Opt_commit:
 			if (match_int(&args[0], &option)) {
_

Patches currently in -mm which might be from junxiao.bi@oracle.com are

ocfs2-change-slot-number-type-s16-to-u16.patch
