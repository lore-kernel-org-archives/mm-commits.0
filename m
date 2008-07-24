From: akpm@linux-foundation.org
Subject: - fs-check-for-statfs-overflow.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:23:36 -0700
Message-ID: <200807242323.m6ONNaIf010691@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41141 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754477AbYGXXXy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:23:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, kniht@linux.vnet.ibm.com, nacc@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     fs: check for statfs overflow
has been removed from the -mm tree.  Its filename was
     fs-check-for-statfs-overflow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs: check for statfs overflow
From: Nick Piggin <npiggin@suse.de>

Adds a check for an overflow in the filesystem size so if someone is
checking with statfs() on a 16G blocksize hugetlbfs in a 32bit binary that
it will report back EOVERFLOW instead of a size of 0.

Acked-by: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Jon Tollefson <kniht@linux.vnet.ibm.com>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat.c |    8 ++++----
 fs/open.c   |    3 ++-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff -puN fs/compat.c~fs-check-for-statfs-overflow fs/compat.c
--- a/fs/compat.c~fs-check-for-statfs-overflow
+++ a/fs/compat.c
@@ -197,8 +197,8 @@ static int put_compat_statfs(struct comp
 {
 	
 	if (sizeof ubuf->f_blocks == 4) {
-		if ((kbuf->f_blocks | kbuf->f_bfree | kbuf->f_bavail) &
-		    0xffffffff00000000ULL)
+		if ((kbuf->f_blocks | kbuf->f_bfree | kbuf->f_bavail |
+		     kbuf->f_bsize | kbuf->f_frsize) & 0xffffffff00000000ULL)
 			return -EOVERFLOW;
 		/* f_files and f_ffree may be -1; it's okay
 		 * to stuff that into 32 bits */
@@ -271,8 +271,8 @@ out:
 static int put_compat_statfs64(struct compat_statfs64 __user *ubuf, struct kstatfs *kbuf)
 {
 	if (sizeof ubuf->f_blocks == 4) {
-		if ((kbuf->f_blocks | kbuf->f_bfree | kbuf->f_bavail) &
-		    0xffffffff00000000ULL)
+		if ((kbuf->f_blocks | kbuf->f_bfree | kbuf->f_bavail |
+		     kbuf->f_bsize | kbuf->f_frsize) & 0xffffffff00000000ULL)
 			return -EOVERFLOW;
 		/* f_files and f_ffree may be -1; it's okay
 		 * to stuff that into 32 bits */
diff -puN fs/open.c~fs-check-for-statfs-overflow fs/open.c
--- a/fs/open.c~fs-check-for-statfs-overflow
+++ a/fs/open.c
@@ -64,7 +64,8 @@ static int vfs_statfs_native(struct dent
 		memcpy(buf, &st, sizeof(st));
 	else {
 		if (sizeof buf->f_blocks == 4) {
-			if ((st.f_blocks | st.f_bfree | st.f_bavail) &
+			if ((st.f_blocks | st.f_bfree | st.f_bavail |
+			     st.f_bsize | st.f_frsize) &
 			    0xffffffff00000000ULL)
 				return -EOVERFLOW;
 			/*
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
linux-next.patch
mmu-notifiers-add-list_del_init_rcu.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifier-core.patch
x86-implement-pte_special.patch
x86-implement-pte_special-fix.patch
mm-introduce-get_user_pages_fast.patch
mm-introduce-get_user_pages_fast-fix.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-2.patch
x86-lockless-get_user_pages_fast-fix-2-fix-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
x86-support-1gb-hugepages-with-get_user_pages_lockless.patch
mm-readahead-scan-lockless.patch
radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag.patch
mm-speculative-page-references.patch
mm-speculative-page-references-fix.patch
mm-speculative-page-references-fix-add_to_page_cache.patch
mm-speculative-page-references-fix-add_to_page_cache-fix.patch
mm-lockless-pagecache.patch
mm-spinlock-tree_lock.patch
powerpc-implement-pte_special.patch
powerpc-implement-pte_special-update.patch
powerpc-lockless-get_user_pages.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
vmscan-move-isolate_lru_page-to-vmscanc-fix.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-bdi_cap_swap_backed.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mlock-mlocked-pages-are-unevictable-fix-fix.patch
mlock-mlocked-pages-are-unevictable-fix-3.patch
mlock-mlocked-pages-are-unevictable-fix-fix-munlock-page-table-walk-now-requires-mm.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-cleanup.patch
fix-double-unlock_page-in-2626-rc5-mm3-kernel-bug-at-mm-filemapc-575.patch
vmstat-mlocked-pages-statistics.patch
vmstat-mlocked-pages-statistics-fix-incorrect-mlocked-field-of-proc-meminfo.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch

