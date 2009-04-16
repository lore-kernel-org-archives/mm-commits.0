From: akpm@linux-foundation.org
Subject: + mm-close-page_mkwrite-races-try-3.patch added to -mm tree
Date: Wed, 15 Apr 2009 18:39:17 -0700
Message-ID: <200904160139.n3G1dIik002874@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55172 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756780AbZDPBlh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Apr 2009 21:41:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, sage@newdream.net, trond.myklebust@fys.uio.no


The patch titled
     mm: close page_mkwrite races
has been added to the -mm tree.  Its filename is
     mm-close-page_mkwrite-races-try-3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: close page_mkwrite races
From: Nick Piggin <npiggin@suse.de>

Change page_mkwrite to allow implementations to return with the page
locked, and also change it's callers (in page fault paths) to hold the
lock until the page is marked dirty.  This allows the filesystem to have
full control of page dirtying events coming from the VM.

Rather than simply hold the page locked over the page_mkwrite call, we
call page_mkwrite with the page unlocked and allow callers to return with
it locked, so filesystems can avoid LOR conditions with page lock.

The problem with the current scheme is this: a filesystem that wants to
associate some metadata with a page as long as the page is dirty, will
perform this manipulation in its ->page_mkwrite.  It currently then must
return with the page unlocked and may not hold any other locks (according
to existing page_mkwrite convention).

In this window, the VM could write out the page, clearing page-dirty.  The
filesystem has no good way to detect that a dirty pte is about to be
attached, so it will happily write out the page, at which point, the
filesystem may manipulate the metadata to reflect that the page is no
longer dirty.

It is not always possible to perform the required metadata manipulation in
->set_page_dirty, because that function cannot block or fail.  The
filesystem may need to allocate some data structure, for example.

And the VM cannot mark the pte dirty before page_mkwrite, because
page_mkwrite is allowed to fail, so we must not allow any window where the
page could be written to if page_mkwrite does fail.

This solution of holding the page locked over the 3 critical operations
(page_mkwrite, setting the pte dirty, and finally setting the page dirty)
closes out races nicely, preventing page cleaning for writeout being
initiated in that window.  This provides the filesystem with a strong
synchronisation against the VM here.

- Sage needs this race closed for ceph filesystem.
- Trond for NFS (http://bugzilla.kernel.org/show_bug.cgi?id=12913).
- I need it for fsblock.
- I suspect other filesystems may need it too (eg. btrfs).
- I have converted buffer.c to the new locking. Even simple block allocation
  under dirty pages might be susceptible to i_size changing under partial page
  at the end of file (we also have a buffer.c-side problem here, but it cannot
  be fixed properly without this patch).
- Other filesystems (eg. NFS, maybe btrfs) will need to change their
  page_mkwrite functions themselves.

[ This also moves page_mkwrite another step closer to fault, which should
  eventually allow page_mkwrite to be moved into ->fault, and thus avoiding a
  filesystem calldown and page lock/unlock cycle in __do_fault. ]

Cc: Sage Weil <sage@newdream.net>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/Locking |   24 +++++--
 fs/buffer.c                       |   10 +--
 mm/memory.c                       |   85 +++++++++++++++++++---------
 3 files changed, 80 insertions(+), 39 deletions(-)

diff -puN Documentation/filesystems/Locking~mm-close-page_mkwrite-races-try-3 Documentation/filesystems/Locking
--- a/Documentation/filesystems/Locking~mm-close-page_mkwrite-races-try-3
+++ a/Documentation/filesystems/Locking
@@ -512,16 +512,24 @@ locking rules:
 		BKL	mmap_sem	PageLocked(page)
 open:		no	yes
 close:		no	yes
-fault:		no	yes
-page_mkwrite:	no	yes		no
+fault:		no	yes		can return with page locked
+page_mkwrite:	no	yes		can return with page locked
 access:		no	yes
 
-	->page_mkwrite() is called when a previously read-only page is
-about to become writeable. The file system is responsible for
-protecting against truncate races. Once appropriate action has been
-taking to lock out truncate, the page range should be verified to be
-within i_size. The page mapping should also be checked that it is not
-NULL.
+	->fault() is called when a previously not present pte is about
+to be faulted in. The filesystem must find and return the page associated
+with the passed in "pgoff" in the vm_fault structure. If it is possible that
+the page may be truncated and/or invalidated, then the filesystem must lock
+the page, then ensure it is not already truncated (the page lock will block
+subsequent truncate), and then return with VM_FAULT_LOCKED, and the page
+locked. The VM will unlock the page.
+
+	->page_mkwrite() is called when a previously read-only pte is
+about to become writeable. The filesystem again must ensure that there are
+no truncate/invalidate races, and then return with the page locked. If
+the page has been truncated, the filesystem should not look up a new page
+like the ->fault() handler, but simply return with VM_FAULT_NOPAGE, which
+will cause the VM to retry the fault.
 
 	->access() is called when get_user_pages() fails in
 acces_process_vm(), typically used to debug a process through
diff -puN fs/buffer.c~mm-close-page_mkwrite-races-try-3 fs/buffer.c
--- a/fs/buffer.c~mm-close-page_mkwrite-races-try-3
+++ a/fs/buffer.c
@@ -2390,7 +2390,8 @@ block_page_mkwrite(struct vm_area_struct
 	if ((page->mapping != inode->i_mapping) ||
 	    (page_offset(page) > size)) {
 		/* page got truncated out from underneath us */
-		goto out_unlock;
+		unlock_page(page);
+		goto out;
 	}
 
 	/* page is wholly or partially inside EOF */
@@ -2404,14 +2405,15 @@ block_page_mkwrite(struct vm_area_struct
 		ret = block_commit_write(page, 0, end);
 
 	if (unlikely(ret)) {
+		unlock_page(page);
 		if (ret == -ENOMEM)
 			ret = VM_FAULT_OOM;
 		else /* -ENOSPC, -EIO, etc */
 			ret = VM_FAULT_SIGBUS;
-	}
+	} else
+		ret = VM_FAULT_LOCKED;
 
-out_unlock:
-	unlock_page(page);
+out:
 	return ret;
 }
 
diff -puN mm/memory.c~mm-close-page_mkwrite-races-try-3 mm/memory.c
--- a/mm/memory.c~mm-close-page_mkwrite-races-try-3
+++ a/mm/memory.c
@@ -1973,6 +1973,15 @@ static int do_wp_page(struct mm_struct *
 				ret = tmp;
 				goto unwritable_page;
 			}
+			if (unlikely(!(tmp & VM_FAULT_LOCKED))) {
+				lock_page(old_page);
+				if (!old_page->mapping) {
+					ret = 0; /* retry the fault */
+					unlock_page(old_page);
+					goto unwritable_page;
+				}
+			} else
+				VM_BUG_ON(!PageLocked(old_page));
 
 			/*
 			 * Since we dropped the lock we need to revalidate
@@ -1982,9 +1991,11 @@ static int do_wp_page(struct mm_struct *
 			 */
 			page_table = pte_offset_map_lock(mm, pmd, address,
 							 &ptl);
-			page_cache_release(old_page);
-			if (!pte_same(*page_table, orig_pte))
+			if (!pte_same(*page_table, orig_pte)) {
+				unlock_page(old_page);
+				page_cache_release(old_page);
 				goto unlock;
+			}
 
 			page_mkwrite = 1;
 		}
@@ -2107,16 +2118,31 @@ unlock:
 		 *
 		 * do_no_page is protected similarly.
 		 */
-		wait_on_page_locked(dirty_page);
-		set_page_dirty_balance(dirty_page, page_mkwrite);
+		if (!page_mkwrite) {
+			wait_on_page_locked(dirty_page);
+			set_page_dirty_balance(dirty_page, page_mkwrite);
+		}
 		put_page(dirty_page);
+		if (page_mkwrite) {
+			struct address_space *mapping = dirty_page->mapping;
+
+			set_page_dirty(dirty_page);
+			unlock_page(dirty_page);
+			page_cache_release(dirty_page);
+			balance_dirty_pages_ratelimited(mapping);
+		}
 	}
 	return ret;
 oom_free_new:
 	page_cache_release(new_page);
 oom:
-	if (old_page)
+	if (old_page) {
+		if (page_mkwrite) {
+			unlock_page(old_page);
+			page_cache_release(old_page);
+		}
 		page_cache_release(old_page);
+	}
 	return VM_FAULT_OOM;
 
 unwritable_page:
@@ -2666,27 +2692,22 @@ static int __do_fault(struct mm_struct *
 				int tmp;
 
 				unlock_page(page);
-				vmf.flags |= FAULT_FLAG_MKWRITE;
+				vmf.flags = FAULT_FLAG_WRITE|FAULT_FLAG_MKWRITE;
 				tmp = vma->vm_ops->page_mkwrite(vma, &vmf);
 				if (unlikely(tmp &
 					  (VM_FAULT_ERROR | VM_FAULT_NOPAGE))) {
 					ret = tmp;
-					anon = 1; /* no anon but release vmf.page */
-					goto out_unlocked;
-				}
-				lock_page(page);
-				/*
-				 * XXX: this is not quite right (racy vs
-				 * invalidate) to unlock and relock the page
-				 * like this, however a better fix requires
-				 * reworking page_mkwrite locking API, which
-				 * is better done later.
-				 */
-				if (!page->mapping) {
-					ret = 0;
-					anon = 1; /* no anon but release vmf.page */
-					goto out;
+					goto unwritable_page;
 				}
+				if (unlikely(!(tmp & VM_FAULT_LOCKED))) {
+					lock_page(page);
+					if (!page->mapping) {
+						ret = 0; /* retry the fault */
+						unlock_page(page);
+						goto unwritable_page;
+					}
+				} else
+					VM_BUG_ON(!PageLocked(page));
 				page_mkwrite = 1;
 			}
 		}
@@ -2738,19 +2759,29 @@ static int __do_fault(struct mm_struct *
 	pte_unmap_unlock(page_table, ptl);
 
 out:
-	unlock_page(vmf.page);
-out_unlocked:
-	if (anon)
-		page_cache_release(vmf.page);
-	else if (dirty_page) {
+	if (dirty_page) {
+		struct address_space *mapping = page->mapping;
+
 		if (vma->vm_file)
 			file_update_time(vma->vm_file);
 
-		set_page_dirty_balance(dirty_page, page_mkwrite);
+		if (set_page_dirty(dirty_page))
+			page_mkwrite = 1;
+		unlock_page(dirty_page);
 		put_page(dirty_page);
+		if (page_mkwrite)
+			balance_dirty_pages_ratelimited(mapping);
+	} else {
+		unlock_page(vmf.page);
+		if (anon)
+			page_cache_release(vmf.page);
 	}
 
 	return ret;
+
+unwritable_page:
+	page_cache_release(page);
+	return ret;
 }
 
 static int do_linear_fault(struct mm_struct *mm, struct vm_area_struct *vma,
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
linux-next.patch
readahead-move-max_sane_readahead-calls-into-force_page_cache_readahead.patch
readahead-apply-max_sane_readahead-limit-in-ondemand_readahead.patch
readahead-remove-sync-async-readahead-call-dependency.patch
readahead-clean-up-and-simplify-the-code-for-filemap-page-fault-readahead.patch
readahead-sequential-mmap-readahead.patch
readahead-enforce-full-readahead-size-on-async-mmap-readahead.patch
readahead-record-mmap-read-around-states-in-file_ra_state.patch
mm-close-page_mkwrite-races-try-3.patch
reiser4.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

