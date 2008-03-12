From: akpm@linux-foundation.org
Subject: + mm-save-some-bytes-in-mm_struct-by-filling-holes-on-64bit.patch added to -mm tree
Date: Wed, 12 Mar 2008 11:05:46 -0700
Message-ID: <200803121805.m2CI5kRB006433@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40659 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754741AbYCLSGl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Mar 2008 14:06:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@suse.de


The patch titled
     mm: save some bytes in mm_struct by filling holes on 64bit
has been added to the -mm tree.  Its filename is
     mm-save-some-bytes-in-mm_struct-by-filling-holes-on-64bit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: save some bytes in mm_struct by filling holes on 64bit
From: Andi Kleen <ak@suse.de>

Save some bytes in mm_struct by filling holes

Putting int values together for better packing on 64bit shrinks sizeof(struct
mm_struct) from 776 bytes to 760 bytes.

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
+	rwlock_t		ioctx_list_lock;	/* aio lock */
 	struct rw_semaphore mmap_sem;
 	spinlock_t page_table_lock;		/* Protects page tables and some counters */
 
@@ -213,14 +214,13 @@ struct mm_struct {
 	unsigned int token_priority;
 	unsigned int last_interval;
 
+	int core_waiters;
 	unsigned long flags; /* Must use atomic bitops to access the bits */
 
 	/* coredumping support */
-	int core_waiters;
 	struct completion *core_startup_done, core_done;
 
 	/* aio bits */
-	rwlock_t		ioctx_list_lock;
 	struct kioctx		*ioctx_list;
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
 	struct mem_cgroup *mem_cgroup;
_

Patches currently in -mm which might be from ak@suse.de are

origin.patch
git-x86.patch
bkl-removal-convert-cifs-over-to-unlocked_ioctl.patch
git-ocfs2.patch
git-scsi-misc.patch
block-fix-memory-hotplug-and-bouncing-in-block-layer.patch
mempolicy-convert-mpol-constants-to-enum.patch
mempolicy-support-optional-mode-flags.patch
mempolicy-support-optional-mode-flags-fix.patch
mempolicy-add-mpol_f_static_nodes-flag.patch
mempolicy-add-bitmap_onto-and-bitmap_fold-operations.patch
mempolicy-add-mpol_f_relative_nodes-flag.patch
mempolicy-update-numa-memory-policy-documentation.patch
mempolicy-move-rebind-functions.patch
mempolicy-create-mempolicy_operations-structure.patch
mempolicy-create-mempolicy_operations-structure-fix.patch
mempolicy-small-header-file-cleanup.patch
mempolicy-disallow-static-or-relative-flags-for-local-preferred-mode.patch
mm-fix-alloc_bootmem_core-to-use-fast-searching-for-all-nodes.patch
mm-fix-boundary-checking-in-free_bootmem_core.patch
dmapool-enable-debugging-for-config_slub_debug_on-too.patch
mm-save-some-bytes-in-mm_struct-by-filling-holes-on-64bit.patch
tty_ioctl-locking-for-tty_wait_until_sent.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch

