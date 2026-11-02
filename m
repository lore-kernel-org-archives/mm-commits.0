Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793647460;
	b=DlP9D5H30gPpWSpWmmI5dhT+luTwtv8M9c25AwvqCHqCViA2fnczc9ZiRe1tWyqR+VrA
	 KS0C/YP0zw19I0AqfilXcVH/eKjRdt70sonteEP60cbA6UelSdCyHIK1tz9MhaTFmysQ3
	 q1OcKvDYvAwnodAigKierQytDDqOy0BBju+IvA1qIZ1noLrmD4PDuLVeOQx2lK47tTIqw
	 NnYhMDbtyIFAesPRXo1e1t5wIZngy2bFqKYp4zc7pmScD8m76fTYDnNEHtRrvWB0x7jJY
	 9HizaPtDkq72uHoSyck0Wuqa/N5Q14lEg/CBA4jlouqW3R5TCbZCsfRbGd/yOl0CO0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793647460;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=TIBBUAvEtQeArVnjwAP9IUVl35HIH7XXYJv0dZj3AFQ=;
	b=0HZfwpPwv6aikSx43t4olBoXD4FDtv6aAYLB4KfzZ/lokF3/cOjMv6jaNI1SCSiUTH+S
	 tbbuoi9lm++8jAhhGempHX3WAeBwIF63Qh2XZLipPedgHqqFpv2DUE+ZBiplEEaYSUuIS
	 XmZBBkvgoIa4h9EtFU4Xu695pM2A00HoizwUQawUC/GqvlnqCSUE5GJoc9xllI86u+S0q
	 qtszjrnM0BtaileDIEboUMy/p8gY61Ov4JSr2NCPp3wa0uhyhvMNqgDVFEybCQlI6K+xh
	 vOsZROTzwf3hZrPs/SMjcJGJ6UM086piTnSkrG5R2PKOQa1SUu89shANWBmkX49v2aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Ku+TbzJ9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F23B606A32D;
	Mon,  2 Nov 2026 19:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Ku+TbzJ9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECCA21F00A1C;
	Mon,  2 Nov 2026 19:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793647460;
	bh=TIBBUAvEtQeArVnjwAP9IUVl35HIH7XXYJv0dZj3AFQ=;
	h=Date:To:From:Subject;
	b=Ku+TbzJ9dQhYRjp/N6iTtyurIv38rVm3hmLuZZ9qK/W9b47A7strC4hnOtPME5jt2
	 t994dUxLIDOWzGPMDAYgSj4GJZkoAawowENKLiuUNP9hzU6G1B5DQmb6f1PFRJoi4R
	 oo+lJ7WoSQM4RYRl96zx7Inn+UE1+ouFvBtbnm9s=
Date: Mon, 02 Nov 2026 11:24:18 -0800
To: mm-commits@vger.kernel.org,
	syzbot+91e1fc35f51774c479b2@syzkaller.appspotmail.com,stable@vger.kernel.org,
	osalvador@suse.de,muchun.song@linux.dev,lihongbo22@huawei.com,
	david@kernel.org,joasantonio108@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlbfs-move-hugetlbfs_free_inode-tracepoint-to-destroy_inode.patch added to mm-hotfixes-unstable branch
Message-Id: <20261102192419.ECCA21F00A1C@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: hugetlbfs: move hugetlbfs_free_inode tracepoint to ->destroy_inode()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     hugetlbfs-move-hugetlbfs_free_inode-tracepoint-to-destroy_inode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlbfs-move-hugetlbfs_free_inode-tracepoint-to-destroy_inode.patch

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
Subject: hugetlbfs: move hugetlbfs_free_inode tracepoint to ->destroy_inode()
Date: Mon, 02 Nov 2026 13:03:56 +0000

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

Since the event no longer fires from ->free_inode(), rename it to
hugetlbfs_destroy_inode so that its name matches where it is emitted, as
suggested by David and Muchun.

Found by syzbot; analysed and tested with the syzbot C reproducer on an
arm64 KASAN kernel.

Link: https://lore.kernel.org/20261102-b4-hugetlbfs-trace-v4-1-72371825bb5e@gmail.com
Fixes: 014ad7c42a69 ("hugetlbfs: use tracepoints in hugetlbfs functions.")
Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: <syzbot+91e1fc35f51774c479b2@syzkaller.appspotmail.com>
Closes: https://lore.kernel.org/all/6ae27525.5451848c.f7707.0001.GAE@google.com/
Suggested-by: David Hildenbrand <david@kernel.org>
Suggested-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Hongbo Li <lihongbo22@huawei.com>
Cc: <stable@vger.kernel.org>
---

 fs/hugetlbfs/inode.c             |    2 +-
 include/trace/events/hugetlbfs.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-move-hugetlbfs_free_inode-tracepoint-to-destroy_inode
+++ a/fs/hugetlbfs/inode.c
@@ -1179,12 +1179,12 @@ static struct inode *hugetlbfs_alloc_ino
 
 static void hugetlbfs_free_inode(struct inode *inode)
 {
-	trace_hugetlbfs_free_inode(inode);
 	kmem_cache_free(hugetlbfs_inode_cachep, HUGETLBFS_I(inode));
 }
 
 static void hugetlbfs_destroy_inode(struct inode *inode)
 {
+	trace_hugetlbfs_destroy_inode(inode);
 	hugetlbfs_inc_free_inodes(HUGETLBFS_SB(inode->i_sb));
 }
 
--- a/include/trace/events/hugetlbfs.h~hugetlbfs-move-hugetlbfs_free_inode-tracepoint-to-destroy_inode
+++ a/include/trace/events/hugetlbfs.h
@@ -72,7 +72,7 @@ DEFINE_EVENT(hugetlbfs__inode, hugetlbfs
 	TP_ARGS(inode)
 );
 
-DEFINE_EVENT(hugetlbfs__inode, hugetlbfs_free_inode,
+DEFINE_EVENT(hugetlbfs__inode, hugetlbfs_destroy_inode,
 
 	TP_PROTO(struct inode *inode),
 
_

Patches currently in -mm which might be from joasantonio108@gmail.com are

hugetlbfs-move-hugetlbfs_free_inode-tracepoint-to-destroy_inode.patch

