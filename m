From: akpm@linux-foundation.org
Subject: - mm-save-some-bytes-in-mm_struct-by-filling-holes-on-64bit.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:51:55 -0700
Message-ID: <200804282151.m3SLptWm017619@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60951 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964989AbYD1Vv7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:51:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     mm: save some bytes in mm_struct by filling holes on 64bit
has been removed from the -mm tree.  Its filename was
     mm-save-some-bytes-in-mm_struct-by-filling-holes-on-64bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: save some bytes in mm_struct by filling holes on 64bit
From: Andi Kleen <ak@suse.de>

Save some bytes in mm_struct by filling holes

Putting int values together for better packing on 64bit shrinks sizeof(struct
mm_struct) from 776 bytes to 764 bytes.

Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/mm_types.h~mm-save-some-bytes-in-mm_struct-by-filling-holes-on-64bit include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-save-some-bytes-in-mm_struct-by-filling-holes-on-64bit
+++ a/include/linux/mm_types.h
@@ -172,6 +172,7 @@ struct mm_struct {
 	atomic_t mm_users;			/* How many users with user space? */
 	atomic_t mm_count;			/* How many references to "struct mm_struct" (users count as 1) */
 	int map_count;				/* number of VMAs */
+	int core_waiters;
 	struct rw_semaphore mmap_sem;
 	spinlock_t page_table_lock;		/* Protects page tables and some counters */
 
@@ -216,11 +217,10 @@ struct mm_struct {
 	unsigned long flags; /* Must use atomic bitops to access the bits */
 
 	/* coredumping support */
-	int core_waiters;
 	struct completion *core_startup_done, core_done;
 
 	/* aio bits */
-	rwlock_t		ioctx_list_lock;
+	rwlock_t		ioctx_list_lock;	/* aio lock */
 	struct kioctx		*ioctx_list;
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
 	struct mem_cgroup *mem_cgroup;
_

Patches currently in -mm which might be from ak@suse.de are

origin.patch
x86-ptrace-pebs-support.patch
x86-ptrace-pebs-support-warning-fix.patch
bkl-removal-convert-cifs-over-to-unlocked_ioctl.patch
lib-swiotlbc-cleanups.patch
x86-olpc-add-one-laptop-per-child-architecture-support.patch
x86-olpc-add-one-laptop-per-child-architecture-support-fix.patch
x86-olpc-add-one-laptop-per-child-architecture-support-fix-2.patch
tty_ioctl-locking-for-tty_wait_until_sent.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch

