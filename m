From: akpm@linux-foundation.org
Subject: [merged] mmvmacache-optimize-overflow-system-wide-flushing.patch
 removed from -mm tree
Date: Thu, 05 Jun 2014 12:49:01 -0700
Message-ID: <5390c9ad.2ySwSNC54CNtPFtu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55730 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbaFETtB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:49:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, oleg@redhat.com, aswin@hp.com, davidlohr@hp.com

Subject: [merged] mmvmacache-optimize-overflow-system-wide-flushing.patch removed from -mm tree
To: davidlohr@hp.com,aswin@hp.com,oleg@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:49:01 -0700


The patch titled
     Subject: mm,vmacache: optimize overflow system-wide flushing
has been removed from the -mm tree.  Its filename was
     mmvmacache-optimize-overflow-system-wide-flushing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: mm,vmacache: optimize overflow system-wide flushing

For single threaded workloads, we can avoid flushing and iterating through
the entire list of tasks, making the whole function a lot faster,
requiring only a single atomic read for the mm_users.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Suggested-by: Oleg Nesterov <oleg@redhat.com>
Cc: Aswin Chandramouleeswaran <aswin@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmacache.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN mm/vmacache.c~mmvmacache-optimize-overflow-system-wide-flushing mm/vmacache.c
--- a/mm/vmacache.c~mmvmacache-optimize-overflow-system-wide-flushing
+++ a/mm/vmacache.c
@@ -17,6 +17,16 @@ void vmacache_flush_all(struct mm_struct
 {
 	struct task_struct *g, *p;
 
+	/*
+	 * Single threaded tasks need not iterate the entire
+	 * list of process. We can avoid the flushing as well
+	 * since the mm's seqnum was increased and don't have
+	 * to worry about other threads' seqnum. Current's
+	 * flush will occur upon the next lookup.
+	 */
+	if (atomic_read(&mm->mm_users) == 1)
+		return;
+
 	rcu_read_lock();
 	for_each_process_thread(g, p) {
 		/*
_

Patches currently in -mm which might be from davidlohr@hp.com are

origin.patch
m68k-call-find_vma-with-the-mmap_sem-held-in-sys_cacheflush.patch
ipc-constify-ipc_ops.patch
ipc-shmc-check-for-ulong-overflows-in-shmat.patch
ipc-shmc-check-for-overflows-of-shm_tot.patch
ipc-shmc-check-for-integer-overflow-during-shmget.patch
ipc-shmc-increase-the-defaults-for-shmall-shmmax.patch
ipcshm-document-new-limits-in-the-uapi-header.patch
ipcshm-document-new-limits-in-the-uapi-header-v2.patch
ipcshm-document-new-limits-in-the-uapi-header-v3.patch
ipcmsg-use-current-state-helpers.patch
ipcmsg-move-some-msgq-ns-code-around.patch
ipcmsg-document-volatile-r_msg.patch
ipc-semc-add-a-printk_once-for-semctlgetncnt-getzcnt.patch
linux-next.patch
blackfin-ptrace-call-find_vma-with-the-mmap_sem-held.patch
rwsem-support-optimistic-spinning.patch

