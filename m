Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793501060;
	b=rIZ9l8FrnHSNg5L+SxD46BRCrb25e0Wg73Bc0eHl4rGHmTN9R2MvQ5FrsZYoiR2D5rvS
	 1XbDrejzE8b/mG/6d8kz/n3Ry0MgpEScWjTgFWcAxeZH/jaQGpKTYSM5YH4+Lw4Lg58pv
	 EAUFKhvuVqyTgk47JmcFsp3R4eSENZkAzLzi70VOtRPiMQ1BlGzLk+7dkWVUEVawdOVhs
	 9jiiyaK4jznEQ+eoynAn0ey1E0N6n+0cMUqcI2Qvr2CGCOUJbs2b9mqb87yaoJ1QKAZGE
	 h21XbecA9XY7rdiG8pbGhxHvHFkye4cFKR1WqkYgbBJpBbW4pDwAY/eDfQj4VMU4pyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793501060;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=AQhsTj6J4VeJju9a4m1xsG9CxzpJTmjRdR5MN+DRV58=;
	b=VdTLIUmDEQAfwWOE4Cw0mn0CvMG1RHvNhtPvfpsVFLIFJhOtTbEcIA5I0RL8iEagUQ71
	 Z3F7rrb4O+1yxFgeEzDai8CNSn05Q235qPQIvq1F8XyQU6SExjpgELRG7eQGzBKm+1Qi6
	 Ayd3IQyVO4PyJRJbVu7Vn5mW4trOeuh/Hn84zcqL4Ang0OU1+8uWkxgZP9wSR19dYyyzR
	 Lpu7qvIiOIWvh3LwMk4hVgx+kgYqYxRQJlnLZ7u3YLTYTS/9U8/YXbGGGm8WKE4Kq8Ma8
	 e6iCzpLqmy53i4Bo6QyG4lIver/hpwPKoJJ8TUW3M8snYpytg2INOQ5wFsLqyk9WcBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=DoOCw5Sf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEDF5606A324;
	Sun,  1 Nov 2026 02:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=DoOCw5Sf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67A0D1F000C1;
	Sun,  1 Nov 2026 02:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793501059;
	bh=AQhsTj6J4VeJju9a4m1xsG9CxzpJTmjRdR5MN+DRV58=;
	h=Date:To:From:Subject;
	b=DoOCw5SfDLN4qG/N5dQwMquZV0mw5+KxfqnAc45n6JNCRKj8mdF/gw80o3EBx2Yvn
	 1yXYTGGZipFRWIx9Z8xuZGVjuTrCZHu/YkkItspTBFvGNaq6VemaQkj19BDmVyjk8S
	 p7yfabWeUMqP1S/WI+tCwyrS+uPqCBNrCvU2U+78=
Date: Sat, 31 Oct 2026 19:44:19 -0700
To: mm-commits@vger.kernel.org,
	syzbot+91e1fc35f51774c479b2@syzkaller.appspotmail.com,stable@vger.kernel.org,
	osalvador@suse.de,muchun.song@linux.dev,lihongbo22@huawei.com,
	david@kernel.org,joasantonio108@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlbfs-emit-hugetlbfs_free_inode-from-destroy_inode.patch added to mm-hotfixes-unstable branch
Message-Id: <20261101024419.67A0D1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: hugetlbfs: emit hugetlbfs_free_inode from ->destroy_inode()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     hugetlbfs-emit-hugetlbfs_free_inode-from-destroy_inode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlbfs-emit-hugetlbfs_free_inode-from-destroy_inode.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Joas Antonio dos Santos <joasantonio108@gmail.com>
Subject: hugetlbfs: emit hugetlbfs_free_inode from ->destroy_inode()
Date: Sat, 31 Oct 2026 16:06:02 +0000

hugetlbfs_free_inode() calls trace_hugetlbfs_free_inode(), and the
hugetlbfs__inode event class records inode->i_sb->s_dev.  ->free_inode()
runs from an RCU callback (destroy_inode() queues i_callback() with
call_rcu()), and Documentation/filesystems/porting.rst says that this
callback "is *NOT* ordered wrt superblock destruction; as the matter of
fact, the superblock and all associated structures might be already gone".
put_super() frees the superblock with call_rcu() followed by a workqueue
item (destroy_super_rcu() -> destroy_super_work()).  syzbot hit this with
the event enabled:

  BUG: KASAN: slab-use-after-free in trace_event_raw_event_hugetlbfs__inode+0x45b/0x4c0 include/trace/events/hugetlbfs.h:36
  Read of size 4 at addr ffff888038850010 by task syz-executor952/6134
   hugetlbfs_free_inode+0x15e/0x1f0 fs/hugetlbfs/inode.c:1182
   i_callback+0x46/0x80 fs/inode.c:317
   rcu_do_batch kernel/rcu/tree.c:2650 [inline]
   rcu_core+0x5f0/0x1220 kernel/rcu/tree.c:2919
  Allocated by task 6134:
   alloc_super fs/super.c:326 [inline]
   sget_fc+0x1ba/0x1f60 fs/super.c:874
   hugetlbfs_get_tree+0x1e7/0x2b0 fs/hugetlbfs/inode.c:1431
  Freed by task 855:
   kfree+0x22b/0x6d0 mm/slub.c:6923
   process_one_work+0xac7/0x1b10 kernel/workqueue.c:3495

Emit the event from hugetlbfs_destroy_inode() instead.  destroy_inode()
calls ->destroy_inode() synchronously, before it queues the RCU callback,
while the superblock is still alive; hugetlbfs_destroy_inode() already
dereferences inode->i_sb there.  ->free_inode() is left with only the
kmem_cache_free().

Link: https://lore.kernel.org/20261031-b4-hugetlbfs-trace-v1-1-4ec8d02a30cc@gmail.com
Fixes: 014ad7c42a69 ("hugetlbfs: use tracepoints in hugetlbfs functions.")
Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: <syzbot+91e1fc35f51774c479b2@syzkaller.appspotmail.com>
Closes: https://lore.kernel.org/all/6ae27525.5451848c.f7707.0001.GAE@google.com/
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hongbo Li <lihongbo22@huawei.com>
Cc: <stable@vger.kernel.org>
---

 fs/hugetlbfs/inode.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-emit-hugetlbfs_free_inode-from-destroy_inode
+++ a/fs/hugetlbfs/inode.c
@@ -1179,12 +1179,16 @@ static struct inode *hugetlbfs_alloc_ino
 
 static void hugetlbfs_free_inode(struct inode *inode)
 {
-	trace_hugetlbfs_free_inode(inode);
 	kmem_cache_free(hugetlbfs_inode_cachep, HUGETLBFS_I(inode));
 }
 
 static void hugetlbfs_destroy_inode(struct inode *inode)
 {
+	/*
+	 * Not in ->free_inode(): that runs from an RCU callback, when the
+	 * superblock the event reads may already be freed.
+	 */
+	trace_hugetlbfs_free_inode(inode);
 	hugetlbfs_inc_free_inodes(HUGETLBFS_SB(inode->i_sb));
 }
 
_

Patches currently in -mm which might be from joasantonio108@gmail.com are

hugetlbfs-emit-hugetlbfs_free_inode-from-destroy_inode.patch

