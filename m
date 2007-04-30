From: akpm@linux-foundation.org
Subject: - epoll-optimizations-and-cleanups-tidy.patch removed from -mm tree
Date: Mon, 30 Apr 2007 12:33:25 -0700
Message-ID: <200704301933.l3UJXP0u012989@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35305 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946722AbXD3Td4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 15:33:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davidel@xmailserver.org, mm-commits@vger.kernel.org


The patch titled
     epoll-optimizations-and-cleanups-tidy
has been removed from the -mm tree.  Its filename was
     epoll-optimizations-and-cleanups-tidy.patch

This patch was dropped because it was folded into epoll-optimizations-and-cleanups.patch

------------------------------------------------------
Subject: epoll-optimizations-and-cleanups-tidy
From: Andrew Morton <akpm@osdl.org>

80 cols.

Cc: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   33 ++++++++++++++++-----------------
 1 files changed, 16 insertions(+), 17 deletions(-)

diff -puN fs/eventpoll.c~epoll-optimizations-and-cleanups-tidy fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-optimizations-and-cleanups-tidy
+++ a/fs/eventpoll.c
@@ -1356,7 +1356,8 @@ static int ep_send_events(struct eventpo
 	/*
 	 * We can loop without lock because this is a task private list.
 	 * We just splice'd out the ep->rdllist in ep_collect_ready_items().
-	 * Items cannot vanish during the loop because we are holding "sem" in read.
+	 * Items cannot vanish during the loop because we are holding "sem" in
+	 * read.
 	 */
 	for (eventcnt = 0; !list_empty(txlist) && eventcnt < maxevents;) {
 		epi = list_entry(txlist->next, struct epitem, rdllink);
@@ -1390,24 +1391,25 @@ static int ep_send_events(struct eventpo
 		/*
 		 * This is tricky. We are holding the "sem" in read, and this
 		 * means that the operations that can change the "linked" status
-		 * of the epoll item (epi->rbn and epi->rdllink), cannot touch them.
-		 * Also, since we are "linked" from a epi->rdllink POV (the item
-		 * is linked to our transmission list, we just splice'd), the
-		 * ep_poll_callback() cannot touch us either, because of the check
-		 * present in there. Another parallel epoll_wait() will not
-		 * get the same result set, since we spliced the ready list before.
-		 * Note that list_del() still shows the item as linked to the test
-		 * in ep_poll_callback().
+		 * of the epoll item (epi->rbn and epi->rdllink), cannot touch
+		 * them.  Also, since we are "linked" from a epi->rdllink POV
+		 * (the item is linked to our transmission list we just
+		 * spliced), the ep_poll_callback() cannot touch us either,
+		 * because of the check present in there. Another parallel
+		 * epoll_wait() will not get the same result set, since we
+		 * spliced the ready list before.  Note that list_del() still
+		 * shows the item as linked to the test in ep_poll_callback().
 		 */
 		list_del(&epi->rdllink);
-		if (!(epi->event.events & EPOLLET) && (revents & epi->event.events))
+		if (!(epi->event.events & EPOLLET) &&
+				(revents & epi->event.events))
 			list_add_tail(&epi->rdllink, &injlist);
 		else {
 			/*
-			 * Be sure the item is totally detached before re-init the
-			 * list_head. After INIT_LIST_HEAD() is committed, the
-			 * ep_poll_callback() can requeue the item again, but we
-			 * don't care since we are already past it.
+			 * Be sure the item is totally detached before re-init
+			 * the list_head. After INIT_LIST_HEAD() is committed,
+			 * the ep_poll_callback() can requeue the item again,
+			 * but we don't care since we are already past it.
 			 */
 			smp_mb();
 			INIT_LIST_HEAD(&epi->rdllink);
@@ -1552,14 +1554,12 @@ retry:
 	return res;
 }
 
-
 static int eventpollfs_delete_dentry(struct dentry *dentry)
 {
 
 	return 1;
 }
 
-
 static struct inode *ep_eventpoll_inode(void)
 {
 	int error = -ENOMEM;
@@ -1587,7 +1587,6 @@ eexit_1:
 	return ERR_PTR(error);
 }
 
-
 static int
 eventpollfs_get_sb(struct file_system_type *fs_type, int flags,
 		   const char *dev_name, void *data, struct vfsmount *mnt)
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
git-powerpc.patch
git-ia64.patch
git-ieee1394.patch
git-netdev-all.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
git-ioat-vs-git-md-accel.patch
ioat-warning-fix.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver.patch
git-ipwireless_cs.patch
lumpy-reclaim-v4.patch
deprecate-smbfs-in-favour-of-cifs.patch
block_write_full_page-handle-enospc.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch
epoll-optimizations-and-cleanups.patch
epoll-optimizations-and-cleanups-tidy.patch
sync_sb_inodes-propagate-errors.patch
mips-convert-to-use-shared-apm-emulation-fix.patch
schedule_on_each_cpu-use-preempt_disable.patch
implement-flush_work-sanity.patch
implement-flush_work_keventd.patch
flush_workqueue-use-preempt_disable-to-hold-off-cpu-hotplug.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc.patch
move-page-writeback-acounting-out-of-macros.patch
ext2-reservations.patch
aio-is-unlikely.patch
mm-implement-swap-prefetching.patch
readahead-kconfig-options.patch
readahead-minmax_ra_pages.patch
readahead-sysctl-parameters.patch
readahead-context-based-method.patch
readahead-call-scheme.patch
readahead-nfsd-case.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
slab-leaks3-default-y.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
acpi_format_exception-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
squash-ipc-warnings.patch
