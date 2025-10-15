Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7375A30749E;
	Wed, 15 Oct 2025 20:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760559910; cv=none; b=t3NrQ+mID109nwZTVkzM4azxcwMdzl+cetmR/9nDmkGi1qJoatR02GgKBxaVQDzk5KFWGo4Xkpb3/b5rJvf234FAKIX4sjFPjMqrC3gFWcpv/QEVVVBE37tfc1aBKZy3bfdTzlDfk7MTSc8sf8c7yG+ln6gAJUgoe3g7CQ2d7Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760559910; c=relaxed/simple;
	bh=tLVvGRevD/x1vJWw78sWGarGw5BINwkJyjWKB2DBUNM=;
	h=Date:To:From:Subject:Message-Id; b=f6tM6GuOzA9LBHZJeC4HuE9Cul2KDhzfrG/C3g6FtyGwkmsJ/F0mR5dykoHTuJTWekQ6cj5HQVonFUmHl4SyIrPI1jNunpeNTphXo9t78WOsuSztR5vKYgtuZTIoAkj4F7zzr3cgssFh7JbJp2yPpFPo5zSk6QwRG4rkZ/2J/PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P19lPHBF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P19lPHBF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B506C116B1;
	Wed, 15 Oct 2025 20:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760559910;
	bh=tLVvGRevD/x1vJWw78sWGarGw5BINwkJyjWKB2DBUNM=;
	h=Date:To:From:Subject:From;
	b=P19lPHBFigSay2375fP6D87IJM1Pk9lPa+V5BEhVKYjhjPUD3U4hB6miisRCjyfdl
	 avMK0hwLnWqkwxs9gzVYOLlkWxGkW+AR2oAUdfH5J/1FFvjFINKbh3Pzn4+SCStjUw
	 qfFtYRKgjzU+y3KDFGSKVco28QDh0qGZUyW317BY=
Date: Wed, 15 Oct 2025 13:25:09 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,kartikey406@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] ocfs2-clear-extent-cache-after-moving-defragmenting-extents.patch removed from -mm tree
Message-Id: <20251015202510.3B506C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: clear extent cache after moving/defragmenting extents
has been removed from the -mm tree.  Its filename was
     ocfs2-clear-extent-cache-after-moving-defragmenting-extents.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Deepanshu Kartikey <kartikey406@gmail.com>
Subject: ocfs2: clear extent cache after moving/defragmenting extents
Date: Thu, 9 Oct 2025 21:19:03 +0530

The extent map cache can become stale when extents are moved or
defragmented, causing subsequent operations to see outdated extent flags. 
This triggers a BUG_ON in ocfs2_refcount_cal_cow_clusters().

The problem occurs when:
1. copy_file_range() creates a reflinked extent with OCFS2_EXT_REFCOUNTED
2. ioctl(FITRIM) triggers ocfs2_move_extents()
3. __ocfs2_move_extents_range() reads and caches the extent (flags=0x2)
4. ocfs2_move_extent()/ocfs2_defrag_extent() calls __ocfs2_move_extent()
   which clears OCFS2_EXT_REFCOUNTED flag on disk (flags=0x0)
5. The extent map cache is not invalidated after the move
6. Later write() operations read stale cached flags (0x2) but disk has
   updated flags (0x0), causing a mismatch
7. BUG_ON(!(rec->e_flags & OCFS2_EXT_REFCOUNTED)) triggers

Fix by clearing the extent map cache after each extent move/defrag
operation in __ocfs2_move_extents_range().  This ensures subsequent
operations read fresh extent data from disk.

Link: https://lore.kernel.org/all/20251009142917.517229-1-kartikey406@gmail.com/T/
Link: https://lkml.kernel.org/r/20251009154903.522339-1-kartikey406@gmail.com
Fixes: 53069d4e7695 ("Ocfs2/move_extents: move/defrag extents within a certain range.")
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Reported-by: syzbot+6fdd8fa3380730a4b22c@syzkaller.appspotmail.com
Tested-by: syzbot+6fdd8fa3380730a4b22c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?id=2959889e1f6e216585ce522f7e8bc002b46ad9e7
Reviewed-by: Mark Fasheh <mark@fasheh.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/move_extents.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/ocfs2/move_extents.c~ocfs2-clear-extent-cache-after-moving-defragmenting-extents
+++ a/fs/ocfs2/move_extents.c
@@ -867,6 +867,11 @@ static int __ocfs2_move_extents_range(st
 			mlog_errno(ret);
 			goto out;
 		}
+		/*
+		 * Invalidate extent cache after moving/defragging to prevent
+		 * stale cached data with outdated extent flags.
+		 */
+		ocfs2_extent_map_trunc(inode, cpos);
 
 		context->clusters_moved += alloc_size;
 next:
_

Patches currently in -mm which might be from kartikey406@gmail.com are

hugetlbfs-move-lock-assertions-after-early-returns-in-huge_pmd_unshare.patch

