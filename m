Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C2D33D9552
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 20:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785876140; cv=none; b=e0Q4Iu+cY5Xho2+PVsALJEpiQ/dFlEcN/EWXUZv7nIqeJlTVLewRXshvQpB95n1sj44XbnQIV90nmM+95G28/iuN2GLHs/vzanQPwmC1cVPiH+0AqFChmNcJ0I6tOKEPYY+UCj0JEyJge6HE6cC6pxJwWFVEAUk3xiasq13iWZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785876140; c=relaxed/simple;
	bh=JBDLdjO1G82cyVlr6MOTft+zW4cl+HAgCGOYr58AWhk=;
	h=Date:To:From:Subject:Message-Id; b=V440bShviv96as/QL5iLlnPHtz4sDMSfWqvuRHes2vC+DMls600BufmGcKnoBrWB3pMuTAB7EDWj1BsB9IDUeitceGDt9SVdA0QogK+lqP7wbYJShnsNyJ979rwh/4lY0Y8h0PHLfYW+CSbbvmOHtKpFxkhOm+dSDVEjNFkslNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LVUXl0aT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LVUXl0aT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1A041F000E9;
	Tue,  4 Aug 2026 20:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785876138;
	bh=4tUOBKW/eoYYEkVhRW+uIrSiKc0h9dzO/Yxy/quc1nQ=;
	h=Date:To:From:Subject;
	b=LVUXl0aTd56sYHy2UDDN3OOyEBnBIYU1E0RV7th2SL2e0XPtKmSf+VdN67KeteBPz
	 ZbrKLKk5D0p+FlMgpuLJumX6rLDWW1QS+ZNqZpKCfwWtODZgz84FW42ARC6lD9aSRJ
	 fYGssTBPSDlIaMYdKNefGKryyHt0+FrBIIJ4722Q=
Date: Tue, 04 Aug 2026 13:42:18 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,gality369@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-validate-orphan-slot-during-inode-read.patch added to mm-nonmm-unstable branch
Message-Id: <20260804204218.D1A041F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: validate orphan slot during inode read
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-validate-orphan-slot-during-inode-read.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-validate-orphan-slot-during-inode-read.patch

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

ocfs2-validate-orphan-slot-during-inode-read.patch
ocfs2-validate-dio-orphan-slot-during-inode-read.patch

