Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5DF24414;
	Fri, 10 Oct 2025 01:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760060240; cv=none; b=UbJMHz/4NNYzGM6aXRejhXZaUEBp/vvQwq8C70d0vmyh9DLC/uXwblDs4YQr4W+FqTKq5uMedLpzvCZkaa2riPvP2Is2e4GDXFxNj4c3d3w3yJOEs6h9WO9652av4gc3q0TS/meSpvtdEdcBHbdK2+uPdHrJx8R1Ur5yyox4FWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760060240; c=relaxed/simple;
	bh=ICGtdc+W283AJLCbLKZ0mN7CGUAWKw0o1yda3RxRAW4=;
	h=Date:To:From:Subject:Message-Id; b=Ug5iDWgxrt7jUpLcjQdQSWTnvJZuq7aAxKLLLUOYlC30sWlDw+WjwmaJO6F/kCLu5k7qyTcEaDG1xFG8Hv4Z1yJfcQa5gAILUjsZZVcgn0SCCdR79AeeQE8Q4o64hkyXrrqab4py3c7kl5aKVJK1ck+lwh+7bcd8x0IOtgsBKL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0LRi9nCY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0LRi9nCY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49996C4CEE7;
	Fri, 10 Oct 2025 01:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760060239;
	bh=ICGtdc+W283AJLCbLKZ0mN7CGUAWKw0o1yda3RxRAW4=;
	h=Date:To:From:Subject:From;
	b=0LRi9nCYfL9qKA07PFbiWyY867/sotNmd370PDOH2PaguFXpYbM8SfxrZ/6Su2b88
	 W/tjRbS45in30u7hzKjZNtG4Og+3M5DPnR6t+g+JqsicuU4wPtqJsGi+2XvV2aJJc8
	 oC9ETApOQ4AdclubQFTw1fwCqkziLEUurefs3t0w=
Date: Thu, 09 Oct 2025 18:37:18 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,kartikey406@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-clear-extent-cache-after-moving-defragmenting-extents.patch added to mm-hotfixes-unstable branch
Message-Id: <20251010013719.49996C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: clear extent cache after moving/defragmenting extents
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     ocfs2-clear-extent-cache-after-moving-defragmenting-extents.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-clear-extent-cache-after-moving-defragmenting-extents.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

hugetlbfs-check-for-shareable-lock-before-calling-huge_pmd_unshare.patch
ocfs2-clear-extent-cache-after-moving-defragmenting-extents.patch

