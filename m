Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D552E3C0630
	for <mm-commits@vger.kernel.org>; Thu, 13 Aug 2026 22:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786660973; cv=none; b=dnkRZ5xiODmnxHNGZ55lJ9l+jyd6026OWjT9EIKgDQPq8V5PVvCo9Cx3OQdhXfJlYpSawP0rLsJnK5grVb7tl6hEF9B2yEWgH1nTNAwxWwPkFh1YsHrOhkYVWJEWQPJJTWToAJoH0Ox57gCLY9VZaqZuibX9Ietz6vZNbq6y4Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786660973; c=relaxed/simple;
	bh=SQbJluZWubaXxlezUIrTQLeBs8cCJYJOlN4DEEoqaVc=;
	h=Date:To:From:Subject:Message-Id; b=DQPYDBJptV1ssFWk6oA2vpfnsUd3TCAnaogqVsPdLmEYrGZvSLUxh8qqjGSM4GcxJWmHIuhuNB1pAOi0n723KiWzANv7LVeZaNjTdekIZDgv+L39488bEBHVefA97WkrAm5FxJkbKOJ9nP2L256t/JWgijQd3FKaI/8HwoRL+bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DLlAyv5l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DLlAyv5l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A79561F000E9;
	Thu, 13 Aug 2026 22:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786660971;
	bh=RJOwVw2rWUM/f/ftBq7c9ZcDSvnG7+vnze+gAinGQMU=;
	h=Date:To:From:Subject;
	b=DLlAyv5lPZb8yoj52BOZw/7SizW8bn4K82eh/oKffMcUpG3lEy2t85nQc82hyrIX4
	 6+r6ODoSXVrQ2mPJGWJL0Hcn4yl+UEIscahNBxGo700tquu0B3xN5oHoQ3QFkl8KEI
	 HlN31qM9gJcVoylhYP5IuUJCVwT/1YCJD4jmZDK4=
Date: Thu, 13 Aug 2026 15:42:51 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,gality369@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-validate-dio-orphan-slot-during-inode-read.patch removed from -mm tree
Message-Id: <20260813224251.A79561F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: validate DIO orphan slot during inode read
has been removed from the -mm tree.  Its filename was
     ocfs2-validate-dio-orphan-slot-during-inode-read.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: ZhengYuan Huang <gality369@gmail.com>
Subject: ocfs2: validate DIO orphan slot during inode read
Date: Mon, 3 Aug 2026 11:00:07 +0800

[BUG]
A corrupted append-DIO dinode (high byte at offset 0xa1
corrupted from 0 to 1) can carry an i_dio_orphaned_slot
outside the mounted filesystem slot range and trigger a
use-after-free error:

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
ocfs2_del_inode_from_orphan() uses i_dio_orphaned_slot to index the
slot-local system inode cache. The dinode validator does not check
this active slot, so an out-of-range value produces an invalid cache
entry pointer that is dereferenced as an inode pointer.

[FIX]
Reject an active i_dio_orphaned_slot outside the slot range during
dinode validation, before DIO orphan recovery can consume it.

Link: https://lore.kernel.org/20260803030007.3993199-3-gality369@gmail.com
Fixes: 06ee5c75b575 ("ocfs2: add functions to add and remove inode in orphan dir")
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

--- a/fs/ocfs2/inode.c~ocfs2-validate-dio-orphan-slot-during-inode-read
+++ a/fs/ocfs2/inode.c
@@ -1536,6 +1536,14 @@ int ocfs2_validate_inode_block(struct su
 		goto bail;
 	}
 
+	if ((le32_to_cpu(di->i_flags) & OCFS2_DIO_ORPHANED_FL) &&
+	    le16_to_cpu(di->i_dio_orphaned_slot) >= OCFS2_SB(sb)->max_slots) {
+		rc = ocfs2_error(sb, "Invalid dinode %llu: DIO orphaned slot %u\n",
+				 (unsigned long long)bh->b_blocknr,
+				 le16_to_cpu(di->i_dio_orphaned_slot));
+		goto bail;
+	}
+
 	/*
 	 * Reject dinodes whose i_mode does not name one of the seven
 	 * canonical POSIX file types.  ocfs2_populate_inode() copies
_

Patches currently in -mm which might be from gality369@gmail.com are


