Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792862691;
	b=kzlW7NRikV0vaph5Qh5i+Fo8hQm/skp/xwIE0/RLUTtjj8Auy1sdeRqY8j57taDSlHyY
	 GZN1bPugVi/1t/YE4ofVr8N61anYiL6g844i1T2cs1H4p4VFkkS8fRt+v+SqBJYJufA6O
	 f0OhKx+TEjbeWLg2PNypp/J18NVG++89ThE3HkuPXOj94zxwxaX5h+YE5QX81E1xodLYt
	 fCMv3gCLrrT5fdT1NeHr0MpEHue9pjc1wK1fjgV6QW7GTO55xXGj3Aw52vNmPatxPP0HX
	 1iE07BNE7bEKLtdZo1jUccK8g+FoEZewX2Jg/GW/WQgS/qrLekaD3iayB2gBJrkpwrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792862691;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Nx2Z0xhq704i0xpgzn1CCJZTCQQtkIFfSMDswotsH8U=;
	b=0HaZD8GVyBzZ0VnkGPkvLz4BHLcDkIhQvTwo9Kl2IRL9GYZztcRWEv/riFxEvorB+KVE
	 8nMRiGtXGaXp9pb8rYXzM9EEnZOsQAJngYQLtMV5RLaSQUJZ+umwR8hqeCeplG1Lx95zP
	 fo7MPpkmiMrLScQm7lYLbGlkWg0x5h7qoE1+7PLZVlWLvxrcnJ50OdWmGMsVlGH3JiqkP
	 /I/Rp8LQW2M8zLAQCXcrM9z97GIhyrNHHRF4tZT1RB6Zua8y5VzqKQJiy9/kO5zfvGMcW
	 AgTM232cFUZHcZ/58RClJmZgmInFeZFMjv73gqovc1cBTdInJrfvlpWfT3a27b3wACQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=A8le0I4W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7185D606A31D;
	Sat, 24 Oct 2026 17:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=A8le0I4W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDB681F031E5;
	Sat, 24 Oct 2026 17:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792862689;
	bh=Nx2Z0xhq704i0xpgzn1CCJZTCQQtkIFfSMDswotsH8U=;
	h=Date:To:From:Subject;
	b=A8le0I4Wm7Qz6lmPQ8CeRQIGKBIOTRUa+A2t8ulOjinWG4NdJhIA/400VcEfNmMG9
	 v651aegXJSkBoCFsb9VrCbrgLmz4qKE7dpyGxbMBxy33vabaIo6EynmuuYlpnjZtSD
	 DfibsidxyGSfc0NTiobOZy/LpBrwmcHcodu2I3Ow=
Date: Sat, 24 Oct 2026 10:24:49 -0700
To: mm-commits@vger.kernel.org,zzzccc427@gmail.com,
	syzbot+5d4e96acd0febccb5e87@syzkaller.appspotmail.com,stable@vger.kernel.org,
	mark@fasheh.com,kartikey406@gmail.com,joseph.qi@linux.alibaba.com,
	jlbec@evilplan.org,heming.zhao@suse.com,eklavyasingh2106@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-heartbeat-serialize-concurrent-writes-to-a-regions-dev-attribute.patch added to mm-nonmm-unstable branch
Message-Id: <20261024172449.CDB681F031E5@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2/heartbeat: serialize concurrent writes to a region's dev attribute
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-heartbeat-serialize-concurrent-writes-to-a-regions-dev-attribute.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-heartbeat-serialize-concurrent-writes-to-a-regions-dev-attribute.patch

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
From: Eklavya Singh <eklavyasingh2106@gmail.com>
Subject: ocfs2/heartbeat: serialize concurrent writes to a region's dev attribute
Date: Wed, 21 Oct 2026 02:53:39 +0530

o2hb_region_dev_store() checks reg->hr_bdev_file to see if the region
is already started, but nothing stops two writers from doing that at
the same time. configfs only serializes writes through the same open
file, so two processes that each open the dev attribute can both get
past the check:

  A: hr_bdev_file is NULL, opens file A, sets hr_bdev_file = A
  B: hr_bdev_file is NULL, opens file B, sets hr_bdev_file = B
  A: start fails, fput(hr_bdev_file) drops B, sets it to NULL
  B: start fails, fput(NULL)

Both calls also use the same hr_slots, hr_slot_data and hr_tmp_block,
so the error paths can free the slot data twice.

syzbot hit the fput(NULL) with an unbound loop device, where every
start fails with -EIO. With four threads doing the same thing on a
KASAN kernel I get both crashes within a second:

  BUG: KASAN: double-free in o2hb_unmap_slot_data+0x14d/0x2f0
  BUG: kernel NULL pointer dereference, address: 0000000000000158

Add a mutex to the region and hold it in dev_store(), in the
block_bytes, start_block and blocks stores, and in dev_show(), since
they all look at hr_bdev_file. dev_store() cleans up with goto, so it
takes the mutex in a small wrapper rather than with guard(). The mutex
is dropped while dev_store() waits for the heartbeat to become steady,
which takes seconds, so a read of dev doesn't stall behind a start.
hr_bdev_file is already set at that point, so other writers still get
-EINVAL, and the cleanup after the wait retakes the mutex.

With the patch the same test ran for 10 minutes with lockdep on and
nothing was reported. So did a second one, with a working loop device,
that interrupts starts during the wait while other threads read and
write the attributes.

Link: https://lore.kernel.org/20261020212339.46591-1-eklavyasingh2106@gmail.com
Fixes: a7f6a5fb4bde ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Signed-off-by: Eklavya Singh <eklavyasingh2106@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: <syzbot+5d4e96acd0febccb5e87@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=5d4e96acd0febccb5e87
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: Cen Zhang <zzzccc427@gmail.com>
Cc: <stable@vger.kernel.org>
---

 fs/ocfs2/cluster/heartbeat.c |   40 ++++++++++++++++++++++++++++-----
 1 file changed, 34 insertions(+), 6 deletions(-)

--- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-heartbeat-serialize-concurrent-writes-to-a-regions-dev-attribute
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -269,6 +269,8 @@ struct o2hb_region {
 	struct list_head	hr_handler_list;
 	/* Serializes timeout arming against failed-start and teardown. */
 	struct mutex		hr_arming_mutex;
+	/* Serializes the dev, block_bytes, start_block and blocks attributes. */
+	struct mutex		hr_dev_mutex;
 	bool			hr_stopping;
 
 	/* last hb status, 0 for success, other value for error. */
@@ -1681,6 +1683,7 @@ static ssize_t o2hb_region_block_bytes_s
 	unsigned long block_bytes;
 	unsigned int block_bits;
 
+	guard(mutex)(&reg->hr_dev_mutex);
 	if (reg->hr_bdev_file)
 		return -EINVAL;
 
@@ -1710,6 +1713,7 @@ static ssize_t o2hb_region_start_block_s
 	char *p = (char *)page;
 	ssize_t ret;
 
+	guard(mutex)(&reg->hr_dev_mutex);
 	if (reg->hr_bdev_file)
 		return -EINVAL;
 
@@ -1736,6 +1740,7 @@ static ssize_t o2hb_region_blocks_store(
 	char *p = (char *)page;
 	int ret;
 
+	guard(mutex)(&reg->hr_dev_mutex);
 	if (reg->hr_bdev_file)
 		return -EINVAL;
 
@@ -1753,10 +1758,12 @@ static ssize_t o2hb_region_blocks_store(
 
 static ssize_t o2hb_region_dev_show(struct config_item *item, char *page)
 {
+	struct o2hb_region *reg = to_o2hb_region(item);
 	unsigned int ret = 0;
 
-	if (to_o2hb_region(item)->hr_bdev_file)
-		ret = sprintf(page, "%pg\n", reg_bdev(to_o2hb_region(item)));
+	guard(mutex)(&reg->hr_dev_mutex);
+	if (reg->hr_bdev_file)
+		ret = sprintf(page, "%pg\n", reg_bdev(reg));
 
 	return ret;
 }
@@ -1872,11 +1879,9 @@ out:
  * this is acting as commit; we set up all of hr_bdev_file and hr_task or
  * nothing
  */
-static ssize_t o2hb_region_dev_store(struct config_item *item,
-				     const char *page,
-				     size_t count)
+static ssize_t __o2hb_region_dev_store(struct o2hb_region *reg,
+				       const char *page, size_t count)
 {
-	struct o2hb_region *reg = to_o2hb_region(item);
 	struct task_struct *hb_task;
 	long fd;
 	int sectsize;
@@ -1884,6 +1889,8 @@ static ssize_t o2hb_region_dev_store(str
 	ssize_t ret = -EINVAL;
 	int live_threshold;
 
+	lockdep_assert_held(&reg->hr_dev_mutex);
+
 	if (reg->hr_bdev_file)
 		return -EINVAL;
 
@@ -1987,9 +1994,15 @@ static ssize_t o2hb_region_dev_store(str
 
 	wake_up_process(hb_task);
 
+	/*
+	 * Don't hold hr_dev_mutex across the wait, which can take seconds.
+	 * hr_bdev_file is already set, so other writers still get -EINVAL.
+	 */
+	mutex_unlock(&reg->hr_dev_mutex);
 	ret = wait_event_interruptible(o2hb_steady_queue,
 				atomic_read(&reg->hr_steady_iterations) == 0 ||
 				reg->hr_node_deleted);
+	mutex_lock(&reg->hr_dev_mutex);
 	if (ret) {
 		atomic_set(&reg->hr_steady_iterations, 0);
 		reg->hr_aborted_start = 1;
@@ -2041,6 +2054,20 @@ out:
 	return ret;
 }
 
+static ssize_t o2hb_region_dev_store(struct config_item *item,
+				     const char *page,
+				     size_t count)
+{
+	struct o2hb_region *reg = to_o2hb_region(item);
+	ssize_t ret;
+
+	mutex_lock(&reg->hr_dev_mutex);
+	ret = __o2hb_region_dev_store(reg, page, count);
+	mutex_unlock(&reg->hr_dev_mutex);
+
+	return ret;
+}
+
 static ssize_t o2hb_region_pid_show(struct config_item *item, char *page)
 {
 	struct o2hb_region *reg = to_o2hb_region(item);
@@ -2143,6 +2170,7 @@ static struct config_item *o2hb_heartbea
 
 	INIT_LIST_HEAD(&reg->hr_all_item);
 	mutex_init(&reg->hr_arming_mutex);
+	mutex_init(&reg->hr_dev_mutex);
 	reg->hr_stopping = true;
 	INIT_DELAYED_WORK(&reg->hr_write_timeout_work, o2hb_write_timeout);
 	INIT_DELAYED_WORK(&reg->hr_nego_timeout_work, o2hb_nego_timeout);
_

Patches currently in -mm which might be from eklavyasingh2106@gmail.com are

ocfs2-heartbeat-serialize-concurrent-writes-to-a-regions-dev-attribute.patch

