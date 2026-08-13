Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C492B381B0C
	for <mm-commits@vger.kernel.org>; Thu, 13 Aug 2026 22:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786660972; cv=none; b=SLOXzzWmEVboDhXjeC+68pWaZYPA94cx+DQ0xrtwnqxdKPY0Fmu8IuLAdW+7XP+3f6hKOH8N8rrdK1E/1LfA3bJCYj3zrDzP970MujqOHX8nf5UcYflE565JfGjoq3q+qFZW1pZJmu46s0ZBpGZs2c0RfiuYB7nO84l6kXAzX58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786660972; c=relaxed/simple;
	bh=TdpygWimxy6oXO6rbQystN84/DU8kJ537fHdss+YaAE=;
	h=Date:To:From:Subject:Message-Id; b=dD9QzITr9niH9WRk6nJ1auA71TMu1mrhtEgHMw2TOv5jK2zHgVGHuauLmObDiyDbfN1VULVRKpfyR1pvgNA5jIZLGTkqsyFqclb9OqAYgcJnhH8CG49+GSQooiDIU0OLytUAeBMtyga2/Kp3JfSJnwgj+4BEahZT4gxGf8/loXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KgCD1L4N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KgCD1L4N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 527F51F00A3A;
	Thu, 13 Aug 2026 22:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786660970;
	bh=hlxIe+w+fSvlJeKixj0TpRUOfDD+pl4KnVtnBM3lQiE=;
	h=Date:To:From:Subject;
	b=KgCD1L4N8n3ZWpSGWoOOXXpHqEqeNSm030ZZT20CmzjGzLvUnAjkUn0iDyE6ZPdGc
	 WV6Y3V4qOlCswcy8hOhp41dAdVKWjytohErIu80Q8FEdfr92vREOCnX0Q+ZS//eCkP
	 7tSUW2RAk2Ye8qff9bFdCHehV1JX0YeZ677pJR4M=
Date: Thu, 13 Aug 2026 15:42:49 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,gality369@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-validate-orphan-slot-during-inode-read.patch removed from -mm tree
Message-Id: <20260813224250.527F51F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: validate orphan slot during inode read
has been removed from the -mm tree.  Its filename was
     ocfs2-validate-orphan-slot-during-inode-read.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: ZhengYuan Huang <gality369@gmail.com>
Subject: ocfs2: validate orphan slot during inode read
Date: Mon, 3 Aug 2026 11:00:06 +0800

Patch series "ocfs2: validate active orphan slots during inode read".

OCFS2 trusts active ordinary and append-DIO orphan slots read from dinodes.
A corrupted slot can therefore index osb_orphan_wipes or the slot-local
system-inode cache outside their allocations before the corruption is
reported.

Patch 1 validates the ordinary orphan slot used by inode wipe processing.
Patch 2 validates the append-DIO orphan slot used by DIO completion and
orphan recovery.  Both checks reject corrupt metadata at the existing inode
validation boundary.


This patch (of 2):

[BUG]
A corrupted dinode with OCFS2_ORPHANED_FL can carry an
i_orphaned_slot outside the mounted filesystem slot range.
ocfs2_wipe_inode() uses it to index osb_orphan_wipes before looking
up the orphan directory, causing an out-of-bounds memory access.

BUG: KASAN: slab-use-after-free in ocfs2_get_system_file_inode+0x780/0x820 fs/ocfs2/sysfile.c:102
Read of size 8 at addr ffff88800b767c00 by task kworker/u8:3/85
Call Trace:
 ...
 ocfs2_get_system_file_inode+0x780/0x820 fs/ocfs2/sysfile.c:102
 ocfs2_wipe_inode+0x292/0xf70 fs/ocfs2/inode.c:840
 ocfs2_delete_inode fs/ocfs2/inode.c:1155 [inline]
 ocfs2_evict_inode+0x6c9/0x1170 fs/ocfs2/inode.c:1295
 evict+0x38e/0x8f0 fs/inode.c:810
 iput_final fs/inode.c:1914 [inline]
 iput fs/inode.c:1966 [inline]
 iput+0x55b/0x8b0 fs/inode.c:1926
 ocfs2_recover_orphans+0x610/0xe40 fs/ocfs2/journal.c:2374
 ocfs2_complete_recovery+0x5af/0xd00 fs/ocfs2/journal.c:1373
 ...

[CAUSE]
ocfs2_validate_inode_block() validates i_suballoc_slot but leaves
the active ordinary orphan slot unchecked. Downstream consumers
assume that the value is smaller than osb->max_slots.

[FIX]
Reject an active i_orphaned_slot outside the slot range during
dinode validation, before the inode reaches orphan wipe processing.

Link: https://lore.kernel.org/20260803030007.3993199-1-gality369@gmail.com
Link: https://lore.kernel.org/20260803030007.3993199-2-gality369@gmail.com
Fixes: b4df6ed8db0c ("[PATCH] ocfs2: fix orphan recovery deadlock")
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/ocfs2/inode.c~ocfs2-validate-orphan-slot-during-inode-read
+++ a/fs/ocfs2/inode.c
@@ -1528,6 +1528,14 @@ int ocfs2_validate_inode_block(struct su
 		goto bail;
 	}
 
+	if ((le32_to_cpu(di->i_flags) & OCFS2_ORPHANED_FL) &&
+	    le16_to_cpu(di->i_orphaned_slot) >= OCFS2_SB(sb)->max_slots) {
+		rc = ocfs2_error(sb, "Invalid dinode %llu: orphaned slot %u\n",
+				 (unsigned long long)bh->b_blocknr,
+				 le16_to_cpu(di->i_orphaned_slot));
+		goto bail;
+	}
+
 	/*
 	 * Reject dinodes whose i_mode does not name one of the seven
 	 * canonical POSIX file types.  ocfs2_populate_inode() copies
_

Patches currently in -mm which might be from gality369@gmail.com are


