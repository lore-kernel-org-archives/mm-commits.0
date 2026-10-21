Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792560630;
	b=d55CHM1guYUTNj11wf3ZZHPamWTG3Hwdwetbz7575MDOSwdene+E4RqWc86/JDs/GfQw
	 V6MeoUPVZTvvnqL/844vqgpLr/LOT7cHfSi0EamLP+Zwyxmb0mJLxx0WAhp40/q3sbcTp
	 7gGqndCRea3qrmXCwSr3KIYMuUJZ7flAJpKHzcUKkkjZMad0baCmXNvZ9Fvave6z/UMQ7
	 tR0vXncb7NqI0KdWejIcc4BrnEcxL/SPO6EHWNOTgNN8K8jgs3Sims+vFtRzZRFlfROBe
	 WiGJJWT47mQWjuTK9XVYF+CO1iq3reTTOTaPtUxGbOK7B/Gri6s5bzRNL7sZ9K6c0Ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792560630;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=J4cOgLsEQVxb5AVgVGiQZxK7G88Fuc3vrt/hbpCN5HI=;
	b=gZbpzQquDDoOQ8eVeUgTxDQVk97KnGtbBQziA0ca6JhApmA44Al23uDJqs3KchcXjIq0
	 ekEMGMB/W+2D/0tM6M3EhYtQbOi8BlTTUo71v+5Refu0vzNKQ3e/izIEz5f4I6ZKsWUbO
	 BRHarqqCQJB+J3kXuOtq8XlNiNs12GtYkZlOxBQdRPoS7KYp71WvocVKDQWlXVLSwZrYo
	 SNOf/khEI0AQU8zb1xMUs4lGlBShajajSRzUkkdXHmwuRhlBMXOGge+xKWoHC8Sjzzlnh
	 R5KEvMYHMSifx0b0lE3BjANERpyTjYAp66RoIJmmDTw+172WZHncLGpQiKMdskiyuAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=XX54EGCl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC05C606A32D;
	Wed, 21 Oct 2026 05:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=XX54EGCl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 642041F000CA;
	Wed, 21 Oct 2026 05:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792560629;
	bh=J4cOgLsEQVxb5AVgVGiQZxK7G88Fuc3vrt/hbpCN5HI=;
	h=Date:To:From:Subject;
	b=XX54EGCldzHyRbvIQxi4ybNwsu1mYh4zKLr+WUpQmliKPPjgkKIHHqrnkqKFQ2pMG
	 xSRvICi8/ajoAxLeZSsNkTAMRf030bj+MElYcFgpR7NYUnQXvvTnwz08b4DegwTIuu
	 fd++okIidVxzgTqHo7rePjS937RquqZpJkjikW84=
Date: Tue, 20 Oct 2026 22:30:28 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mark@fasheh.com,kees@kernel.org,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,jjzuming@gmail.com,ericterminal@gmail.com,baijiaju1990@gmail.com,zzzccc427@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-heartbeat-unlink-live-slots-when-their-node-is-missing.patch removed from -mm tree
Message-Id: <20261021053029.642041F000CA@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: ocfs2/heartbeat: unlink live slots when their node is missing
has been removed from the -mm tree.  Its filename was
     ocfs2-heartbeat-unlink-live-slots-when-their-node-is-missing.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Cen Zhang <zzzccc427@gmail.com>
Subject: ocfs2/heartbeat: unlink live slots when their node is missing
Date: Fri,  9 Oct 2026 13:21:42 +0800

o2hb_shutdown_slot() returns immediately when its node is no longer in the
configfs registry.  A slot can still be linked in o2hb_live_slots when
that lookup fails.  Region teardown or startup-error cleanup then frees
the slot array without removing its embedded list member.

With the same peer live in another region, the next list update can follow
a predecessor into the freed array.  Reusing the node number can also make
a later insertion encounter that stale member.

Always remove the slot under o2hb_live_lock, even when node lookup fails. 
Preserve aggregate membership accounting and the last-region DOWN
callback: the existing callback interface explicitly permits a NULL node
for DOWN events.  Only drop the node reference when lookup returned one. 
This closes both normal release and startup-abort paths without changing
the publication or callback locking protocol.

Also require a configured node before admitting a new live slot in
o2hb_check_slot().  The early live-bitmap check is not held through
admission: the last live slot in another region can be removed in between.
Without a node, admission can then queue an UP event with a NULL argument
and hit the event helper's BUG_ON.  Existing live slots can still leave
and generate NULL-node DOWN events.

A controlled probe-instrumented test reproduced this while stopping one of
two regions after removing the peer from configfs.  Its KASAN report
includes:

  BUG: KASAN: slab-use-after-free in __list_del_entry_valid_or_report+0x1e0/0x210
  Read of size 8 at addr ffff888106a4ac60 by task o2hb-pmbd0058_b/497
  Call Trace:
   <TASK>
   dump_stack_lvl+0x93/0xd0
   print_report+0xce/0x630
   kasan_report+0xe0/0x110
   __list_del_entry_valid_or_report+0x1e0/0x210
   o2hb_do_disk_heartbeat+0x1591/0x2c50
   o2hb_thread+0x1ed/0xe70
   kthread+0x351/0x460
   ret_from_fork+0x659/0x940
   ret_from_fork_asm+0x1a/0x30
   </TASK>
  Allocated by task 491:
   kasan_save_stack+0x33/0x60
   kasan_save_track+0x14/0x30
   __kasan_kmalloc+0xaa/0xb0
   __kmalloc_noprof+0x2de/0x780
   o2hb_region_dev_store+0x7c2/0x1b60
   configfs_write_iter+0x2f9/0x4f0
   vfs_write+0x639/0x1010
   ksys_write+0x111/0x200
   do_syscall_64+0x114/0x620
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
  Freed by task 491:
   kasan_save_stack+0x33/0x60
   kasan_save_track+0x14/0x30
   kasan_save_free_info+0x3b/0x60
   __kasan_slab_free+0x5f/0x80
   kfree+0x308/0x580
   o2hb_unmap_slot_data+0x1db/0x330
   o2hb_region_release+0x14b/0x4f0
   config_item_cleanup+0x14b/0x230
   config_item_put+0x79/0x90
   configfs_rmdir+0x58a/0x910
   vfs_rmdir+0x2e8/0x820
   filename_rmdir+0x3b1/0x520
   __x64_sys_rmdir+0x4b/0x70
   do_syscall_64+0x114/0x620
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

Link: https://lore.kernel.org/pm-ocfs2-objects-candidate-0058-v2-9446113c2b16c817c538@gmail.com
Fixes: a7f6a5fb4bde ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Assisted-by: LLM
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Yufan Chen <ericterminal@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: <jjzuming@gmail.com>
Cc: <stable@vger.kernel.org>
---

 fs/ocfs2/cluster/heartbeat.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-heartbeat-unlink-live-slots-when-their-node-is-missing
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -880,8 +880,11 @@ static void o2hb_shutdown_slot(struct o2
 	int queued = 0;
 
 	node = o2nm_get_node_by_num(slot->ds_node_num);
-	if (!node)
-		return;
+	/*
+	 * The node may have been removed from the node table while this
+	 * region's slot is still linked.  The list member must still be
+	 * removed before the region releases its slot array.
+	 */
 
 	spin_lock(&o2hb_live_lock);
 	if (!list_empty(&slot->ds_live_item)) {
@@ -903,7 +906,8 @@ static void o2hb_shutdown_slot(struct o2
 	if (queued)
 		o2hb_run_event_list(&event);
 
-	o2nm_node_put(node);
+	if (node)
+		o2nm_node_put(node);
 }
 
 static void o2hb_set_quorum_device(struct o2hb_region *reg)
@@ -1038,7 +1042,7 @@ static int o2hb_check_slot(struct o2hb_r
 fire_callbacks:
 	/* dead nodes only come to life after some number of
 	 * changes at any time during their dead time */
-	if (list_empty(&slot->ds_live_item) &&
+	if (node && list_empty(&slot->ds_live_item) &&
 	    slot->ds_changed_samples >= O2HB_LIVE_THRESHOLD) {
 		mlog(ML_HEARTBEAT, "Node %d (id 0x%llx) joined my region\n",
 		     slot->ds_node_num, (long long)slot->ds_last_generation);
_

Patches currently in -mm which might be from zzzccc427@gmail.com are


