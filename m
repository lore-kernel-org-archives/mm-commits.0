From: akpm@linux-foundation.org
Subject: - sparse-pointer-use-of-zero-as-null.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:46:07 -0700
Message-ID: <200710190346.l9J3k7mi013284@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38513 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934597AbXJSD41 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:56:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shemminger@linux-foundation.org, ak@suse.de, arnd@arndb.de, davidel@xmailserver.org, jeff@garzik.org, mpm@selenic.com, raven@themaw.net, sds@tycho.nsa.gov, mm-commits@vger.kernel.org


The patch titled
     sparse pointer use of zero as null
has been removed from the -mm tree.  Its filename was
     sparse-pointer-use-of-zero-as-null.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sparse pointer use of zero as null
From: Stephen Hemminger <shemminger@linux-foundation.org>

Get rid of sparse related warnings from places that use integer as NULL
pointer.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Ian Kent <raven@themaw.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/vsyscall_64.c |    2 +-
 drivers/ata/libata-sff.c      |    2 +-
 drivers/base/dmapool.c        |    2 +-
 drivers/char/random.c         |    2 +-
 fs/autofs/waitq.c             |    2 +-
 fs/autofs4/waitq.c            |    2 +-
 fs/compat_ioctl.c             |    2 +-
 fs/eventpoll.c                |    2 +-
 fs/ext3/fsync.c               |    2 +-
 fs/ext3/inode.c               |    2 +-
 fs/jbd/journal.c              |    9 +++++----
 fs/jbd/transaction.c          |   12 ++++++------
 fs/nls/nls_base.c             |    2 +-
 init/do_mounts_rd.c           |    6 +++---
 kernel/futex.c                |    4 ++--
 kernel/kexec.c                |    4 ++--
 mm/hugetlb.c                  |    2 +-
 mm/mremap.c                   |    4 ++--
 mm/vmscan.c                   |    2 +-
 security/selinux/xfrm.c       |    2 +-
 20 files changed, 34 insertions(+), 33 deletions(-)

diff -puN arch/x86/kernel/vsyscall_64.c~sparse-pointer-use-of-zero-as-null arch/x86/kernel/vsyscall_64.c
--- a/arch/x86/kernel/vsyscall_64.c~sparse-pointer-use-of-zero-as-null
+++ a/arch/x86/kernel/vsyscall_64.c
@@ -172,7 +172,7 @@ time_t __vsyscall(1) vtime(time_t *t)
 	if (unlikely(!__vsyscall_gtod_data.sysctl_enabled))
 		return time_syscall(t);
 
-	vgettimeofday(&tv, 0);
+	vgettimeofday(&tv, NULL);
 	result = tv.tv_sec;
 	if (t)
 		*t = result;
diff -puN drivers/ata/libata-sff.c~sparse-pointer-use-of-zero-as-null drivers/ata/libata-sff.c
--- a/drivers/ata/libata-sff.c~sparse-pointer-use-of-zero-as-null
+++ a/drivers/ata/libata-sff.c
@@ -882,7 +882,7 @@ unsigned long ata_pci_default_filter(str
 	/* Filter out DMA modes if the device has been configured by
 	   the BIOS as PIO only */
 
-	if (adev->link->ap->ioaddr.bmdma_addr == 0)
+	if (adev->link->ap->ioaddr.bmdma_addr == NULL)
 		xfer_mask &= ~(ATA_MASK_MWDMA | ATA_MASK_UDMA);
 	return xfer_mask;
 }
diff -puN drivers/base/dmapool.c~sparse-pointer-use-of-zero-as-null drivers/base/dmapool.c
--- a/drivers/base/dmapool.c~sparse-pointer-use-of-zero-as-null
+++ a/drivers/base/dmapool.c
@@ -366,7 +366,7 @@ dma_pool_free (struct dma_pool *pool, vo
 	unsigned long		flags;
 	int			map, block;
 
-	if ((page = pool_find_page (pool, dma)) == 0) {
+	if ((page = pool_find_page(pool, dma)) == NULL) {
 		if (pool->dev)
 			dev_err(pool->dev, "dma_pool_free %s, %p/%lx (bad dma)\n",
 				pool->name, vaddr, (unsigned long) dma);
diff -puN drivers/char/random.c~sparse-pointer-use-of-zero-as-null drivers/char/random.c
--- a/drivers/char/random.c~sparse-pointer-use-of-zero-as-null
+++ a/drivers/char/random.c
@@ -649,7 +649,7 @@ EXPORT_SYMBOL_GPL(add_input_randomness);
 
 void add_interrupt_randomness(int irq)
 {
-	if (irq >= NR_IRQS || irq_timer_state[irq] == 0)
+	if (irq >= NR_IRQS || irq_timer_state[irq] == NULL)
 		return;
 
 	DEBUG_ENT("irq event %d\n", irq);
diff -puN fs/autofs/waitq.c~sparse-pointer-use-of-zero-as-null fs/autofs/waitq.c
--- a/fs/autofs/waitq.c~sparse-pointer-use-of-zero-as-null
+++ a/fs/autofs/waitq.c
@@ -182,7 +182,7 @@ int autofs_wait_release(struct autofs_sb
 {
 	struct autofs_wait_queue *wq, **wql;
 
-	for ( wql = &sbi->queues ; (wq = *wql) != 0 ; wql = &wq->next ) {
+	for (wql = &sbi->queues; (wq = *wql) != NULL; wql = &wq->next) {
 		if ( wq->wait_queue_token == wait_queue_token )
 			break;
 	}
diff -puN fs/autofs4/waitq.c~sparse-pointer-use-of-zero-as-null fs/autofs4/waitq.c
--- a/fs/autofs4/waitq.c~sparse-pointer-use-of-zero-as-null
+++ a/fs/autofs4/waitq.c
@@ -376,7 +376,7 @@ int autofs4_wait_release(struct autofs_s
 	struct autofs_wait_queue *wq, **wql;
 
 	mutex_lock(&sbi->wq_mutex);
-	for (wql = &sbi->queues ; (wq = *wql) != 0 ; wql = &wq->next) {
+	for (wql = &sbi->queues; (wq = *wql) != NULL; wql = &wq->next) {
 		if (wq->wait_queue_token == wait_queue_token)
 			break;
 	}
diff -puN fs/compat_ioctl.c~sparse-pointer-use-of-zero-as-null fs/compat_ioctl.c
--- a/fs/compat_ioctl.c~sparse-pointer-use-of-zero-as-null
+++ a/fs/compat_ioctl.c
@@ -3001,7 +3001,7 @@ static int __init init_sys32_ioctl(void)
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(ioctl_start); i++) {
-		if (ioctl_start[i].next != 0) {
+		if (ioctl_start[i].next) {
 			printk("ioctl translation %d bad\n",i);
 			return -1;
 		}
diff -puN fs/eventpoll.c~sparse-pointer-use-of-zero-as-null fs/eventpoll.c
--- a/fs/eventpoll.c~sparse-pointer-use-of-zero-as-null
+++ a/fs/eventpoll.c
@@ -463,7 +463,7 @@ static void ep_free(struct eventpoll *ep
 	 * holding "epmutex" we can be sure that no file cleanup code will hit
 	 * us during this operation. So we can avoid the lock on "ep->lock".
 	 */
-	while ((rbp = rb_first(&ep->rbr)) != 0) {
+	while ((rbp = rb_first(&ep->rbr)) != NULL) {
 		epi = rb_entry(rbp, struct epitem, rbn);
 		ep_remove(ep, epi);
 	}
diff -puN fs/ext3/fsync.c~sparse-pointer-use-of-zero-as-null fs/ext3/fsync.c
--- a/fs/ext3/fsync.c~sparse-pointer-use-of-zero-as-null
+++ a/fs/ext3/fsync.c
@@ -47,7 +47,7 @@ int ext3_sync_file(struct file * file, s
 	struct inode *inode = dentry->d_inode;
 	int ret = 0;
 
-	J_ASSERT(ext3_journal_current_handle() == 0);
+	J_ASSERT(ext3_journal_current_handle() == NULL);
 
 	/*
 	 * data=writeback:
diff -puN fs/ext3/inode.c~sparse-pointer-use-of-zero-as-null fs/ext3/inode.c
--- a/fs/ext3/inode.c~sparse-pointer-use-of-zero-as-null
+++ a/fs/ext3/inode.c
@@ -1028,7 +1028,7 @@ struct buffer_head *ext3_getblk(handle_t
 		}
 		if (buffer_new(&dummy)) {
 			J_ASSERT(create != 0);
-			J_ASSERT(handle != 0);
+			J_ASSERT(handle != NULL);
 
 			/*
 			 * Now that we do not always journal data, we should
diff -puN fs/jbd/journal.c~sparse-pointer-use-of-zero-as-null fs/jbd/journal.c
--- a/fs/jbd/journal.c~sparse-pointer-use-of-zero-as-null
+++ a/fs/jbd/journal.c
@@ -218,7 +218,7 @@ static int journal_start_thread(journal_
 	if (IS_ERR(t))
 		return PTR_ERR(t);
 
-	wait_event(journal->j_wait_done_commit, journal->j_task != 0);
+	wait_event(journal->j_wait_done_commit, journal->j_task != NULL);
 	return 0;
 }
 
@@ -230,7 +230,8 @@ static void journal_kill_thread(journal_
 	while (journal->j_task) {
 		wake_up(&journal->j_wait_commit);
 		spin_unlock(&journal->j_state_lock);
-		wait_event(journal->j_wait_done_commit, journal->j_task == 0);
+		wait_event(journal->j_wait_done_commit,
+				journal->j_task == NULL);
 		spin_lock(&journal->j_state_lock);
 	}
 	spin_unlock(&journal->j_state_lock);
@@ -1739,14 +1740,14 @@ static struct journal_head *journal_allo
 	atomic_inc(&nr_journal_heads);
 #endif
 	ret = kmem_cache_alloc(journal_head_cache, GFP_NOFS);
-	if (ret == 0) {
+	if (ret == NULL) {
 		jbd_debug(1, "out of memory for journal_head\n");
 		if (time_after(jiffies, last_warning + 5*HZ)) {
 			printk(KERN_NOTICE "ENOMEM in %s, retrying.\n",
 			       __FUNCTION__);
 			last_warning = jiffies;
 		}
-		while (ret == 0) {
+		while (ret == NULL) {
 			yield();
 			ret = kmem_cache_alloc(journal_head_cache, GFP_NOFS);
 		}
diff -puN fs/jbd/transaction.c~sparse-pointer-use-of-zero-as-null fs/jbd/transaction.c
--- a/fs/jbd/transaction.c~sparse-pointer-use-of-zero-as-null
+++ a/fs/jbd/transaction.c
@@ -1172,7 +1172,7 @@ int journal_dirty_metadata(handle_t *han
 	}
 
 	/* That test should have eliminated the following case: */
-	J_ASSERT_JH(jh, jh->b_frozen_data == 0);
+	J_ASSERT_JH(jh, jh->b_frozen_data == NULL);
 
 	JBUFFER_TRACE(jh, "file as BJ_Metadata");
 	spin_lock(&journal->j_list_lock);
@@ -1522,7 +1522,7 @@ static void __journal_temp_unlink_buffer
 
 	J_ASSERT_JH(jh, jh->b_jlist < BJ_Types);
 	if (jh->b_jlist != BJ_None)
-		J_ASSERT_JH(jh, transaction != 0);
+		J_ASSERT_JH(jh, transaction != NULL);
 
 	switch (jh->b_jlist) {
 	case BJ_None:
@@ -1591,11 +1591,11 @@ __journal_try_to_free_buffer(journal_t *
 	if (buffer_locked(bh) || buffer_dirty(bh))
 		goto out;
 
-	if (jh->b_next_transaction != 0)
+	if (jh->b_next_transaction != NULL)
 		goto out;
 
 	spin_lock(&journal->j_list_lock);
-	if (jh->b_transaction != 0 && jh->b_cp_transaction == 0) {
+	if (jh->b_transaction != NULL && jh->b_cp_transaction == NULL) {
 		if (jh->b_jlist == BJ_SyncData || jh->b_jlist == BJ_Locked) {
 			/* A written-back ordered data buffer */
 			JBUFFER_TRACE(jh, "release data");
@@ -1603,7 +1603,7 @@ __journal_try_to_free_buffer(journal_t *
 			journal_remove_journal_head(bh);
 			__brelse(bh);
 		}
-	} else if (jh->b_cp_transaction != 0 && jh->b_transaction == 0) {
+	} else if (jh->b_cp_transaction != NULL && jh->b_transaction == NULL) {
 		/* written-back checkpointed metadata buffer */
 		if (jh->b_jlist == BJ_None) {
 			JBUFFER_TRACE(jh, "remove from checkpoint list");
@@ -1963,7 +1963,7 @@ void __journal_file_buffer(struct journa
 
 	J_ASSERT_JH(jh, jh->b_jlist < BJ_Types);
 	J_ASSERT_JH(jh, jh->b_transaction == transaction ||
-				jh->b_transaction == 0);
+				jh->b_transaction == NULL);
 
 	if (jh->b_transaction && jh->b_jlist == jlist)
 		return;
diff -puN fs/nls/nls_base.c~sparse-pointer-use-of-zero-as-null fs/nls/nls_base.c
--- a/fs/nls/nls_base.c~sparse-pointer-use-of-zero-as-null
+++ a/fs/nls/nls_base.c
@@ -111,7 +111,7 @@ utf8_wctomb(__u8 *s, wchar_t wc, int max
 	int c, nc;
 	const struct utf8_table *t;
   
-	if (s == 0)
+	if (!s)
 		return 0;
   
 	l = wc;
diff -puN init/do_mounts_rd.c~sparse-pointer-use-of-zero-as-null init/do_mounts_rd.c
--- a/init/do_mounts_rd.c~sparse-pointer-use-of-zero-as-null
+++ a/init/do_mounts_rd.c
@@ -57,7 +57,7 @@ identify_ramdisk_image(int fd, int start
 	unsigned char *buf;
 
 	buf = kmalloc(size, GFP_KERNEL);
-	if (buf == 0)
+	if (!buf)
 		return -1;
 
 	minixsb = (struct minix_super_block *) buf;
@@ -407,12 +407,12 @@ static int __init crd_load(int in_fd, in
 	crd_infd = in_fd;
 	crd_outfd = out_fd;
 	inbuf = kmalloc(INBUFSIZ, GFP_KERNEL);
-	if (inbuf == 0) {
+	if (!inbuf) {
 		printk(KERN_ERR "RAMDISK: Couldn't allocate gzip buffer\n");
 		return -1;
 	}
 	window = kmalloc(WSIZE, GFP_KERNEL);
-	if (window == 0) {
+	if (!window) {
 		printk(KERN_ERR "RAMDISK: Couldn't allocate gzip window\n");
 		kfree(inbuf);
 		return -1;
diff -puN kernel/futex.c~sparse-pointer-use-of-zero-as-null kernel/futex.c
--- a/kernel/futex.c~sparse-pointer-use-of-zero-as-null
+++ a/kernel/futex.c
@@ -293,7 +293,7 @@ EXPORT_SYMBOL_GPL(get_futex_key_refs);
  */
 void drop_futex_key_refs(union futex_key *key)
 {
-	if (key->both.ptr == 0)
+	if (!key->both.ptr)
 		return;
 	switch (key->both.offset & (FUT_OFF_INODE|FUT_OFF_MMSHARED)) {
 		case FUT_OFF_INODE:
@@ -1046,7 +1046,7 @@ static int unqueue_me(struct futex_q *q)
  retry:
 	lock_ptr = q->lock_ptr;
 	barrier();
-	if (lock_ptr != 0) {
+	if (lock_ptr != NULL) {
 		spin_lock(lock_ptr);
 		/*
 		 * q->lock_ptr can change between reading it and
diff -puN kernel/kexec.c~sparse-pointer-use-of-zero-as-null kernel/kexec.c
--- a/kernel/kexec.c~sparse-pointer-use-of-zero-as-null
+++ a/kernel/kexec.c
@@ -785,7 +785,7 @@ static int kimage_load_normal_segment(st
 		size_t uchunk, mchunk;
 
 		page = kimage_alloc_page(image, GFP_HIGHUSER, maddr);
-		if (page == 0) {
+		if (!page) {
 			result  = -ENOMEM;
 			goto out;
 		}
@@ -844,7 +844,7 @@ static int kimage_load_crash_segment(str
 		size_t uchunk, mchunk;
 
 		page = pfn_to_page(maddr >> PAGE_SHIFT);
-		if (page == 0) {
+		if (!page) {
 			result  = -ENOMEM;
 			goto out;
 		}
diff -puN mm/hugetlb.c~sparse-pointer-use-of-zero-as-null mm/hugetlb.c
--- a/mm/hugetlb.c~sparse-pointer-use-of-zero-as-null
+++ a/mm/hugetlb.c
@@ -1020,7 +1020,7 @@ static long region_chg(struct list_head 
 	 * size such that we can guarentee to record the reservation. */
 	if (&rg->link == head || t < rg->from) {
 		nrg = kmalloc(sizeof(*nrg), GFP_KERNEL);
-		if (nrg == 0)
+		if (!nrg)
 			return -ENOMEM;
 		nrg->from = f;
 		nrg->to   = f;
diff -puN mm/mremap.c~sparse-pointer-use-of-zero-as-null mm/mremap.c
--- a/mm/mremap.c~sparse-pointer-use-of-zero-as-null
+++ a/mm/mremap.c
@@ -291,7 +291,7 @@ unsigned long do_mremap(unsigned long ad
 		if ((addr <= new_addr) && (addr+old_len) > new_addr)
 			goto out;
 
-		ret = security_file_mmap(0, 0, 0, 0, new_addr, 1);
+		ret = security_file_mmap(NULL, 0, 0, 0, new_addr, 1);
 		if (ret)
 			goto out;
 
@@ -399,7 +399,7 @@ unsigned long do_mremap(unsigned long ad
 				goto out;
 			}
 
-			ret = security_file_mmap(0, 0, 0, 0, new_addr, 1);
+			ret = security_file_mmap(NULL, 0, 0, 0, new_addr, 1);
 			if (ret)
 				goto out;
 		}
diff -puN mm/vmscan.c~sparse-pointer-use-of-zero-as-null mm/vmscan.c
--- a/mm/vmscan.c~sparse-pointer-use-of-zero-as-null
+++ a/mm/vmscan.c
@@ -1282,7 +1282,7 @@ out:
 	 */
 	if (priority < 0)
 		priority = 0;
-	for (i = 0; zones[i] != 0; i++) {
+	for (i = 0; zones[i] != NULL; i++) {
 		struct zone *zone = zones[i];
 
 		if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
diff -puN security/selinux/xfrm.c~sparse-pointer-use-of-zero-as-null security/selinux/xfrm.c
--- a/security/selinux/xfrm.c~sparse-pointer-use-of-zero-as-null
+++ a/security/selinux/xfrm.c
@@ -448,7 +448,7 @@ int selinux_xfrm_postroute_last(u32 isec
 	if (dst) {
 		struct dst_entry *dst_test;
 
-		for (dst_test = dst; dst_test != 0;
+		for (dst_test = dst; dst_test != NULL;
 		     dst_test = dst_test->child) {
 			struct xfrm_state *x = dst_test->xfrm;
 
_

Patches currently in -mm which might be from shemminger@linux-foundation.org are

origin.patch
ip-justification-for-local-port-range-robustness.patch
git-wireless.patch
