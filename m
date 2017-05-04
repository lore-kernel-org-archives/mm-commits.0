From: akpm@linux-foundation.org
Subject: [merged]
 jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context.patch
 removed from -mm tree
Date: Thu, 04 May 2017 12:10:37 -0700
Message-ID: <20170504191037.IvwrgJQpD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51208 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752637AbdEDTKj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 4 May 2017 15:10:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfoster@redhat.com, clm@fb.com, darrick.wong@oracle.com, david@fromorbit.com, dsterba@suse.cz, jack@suse.cz, mhocko@suse.com, mm-commits@vger.kernel.org, nborisov@suse.com, peterz@infradead.org, tytso@mit.edu, vbabka@suse.cz


The patch titled
     Subject: jbd2: mark the transaction context with the scope GFP_NOFS context
has been removed from the -mm tree.  Its filename was
     jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: jbd2: mark the transaction context with the scope GFP_NOFS context

now that we have memalloc_nofs_{save,restore} api we can mark the whole
transaction context as implicitly GFP_NOFS.  All allocations will
automatically inherit GFP_NOFS this way.  This means that we do not have
to mark any of those requests with GFP_NOFS and moreover all the
ext4_kv[mz]alloc(GFP_NOFS) are also safe now because even the hardcoded
GFP_KERNEL allocations deep inside the vmalloc will be NOFS now.

[akpm@linux-foundation.org: tweak comments]
Link: http://lkml.kernel.org/r/20170306131408.9828-7-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Chris Mason <clm@fb.com>
Cc: David Sterba <dsterba@suse.cz>
Cc: Brian Foster <bfoster@redhat.com>
Cc: Darrick J. Wong <darrick.wong@oracle.com>
Cc: Nikolay Borisov <nborisov@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd2/transaction.c |   12 ++++++++++++
 include/linux/jbd2.h  |    2 ++
 2 files changed, 14 insertions(+)

diff -puN fs/jbd2/transaction.c~jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context fs/jbd2/transaction.c
--- a/fs/jbd2/transaction.c~jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context
+++ a/fs/jbd2/transaction.c
@@ -29,6 +29,7 @@
 #include <linux/backing-dev.h>
 #include <linux/bug.h>
 #include <linux/module.h>
+#include <linux/sched/mm.h>
 
 #include <trace/events/jbd2.h>
 
@@ -388,6 +389,11 @@ repeat:
 
 	rwsem_acquire_read(&journal->j_trans_commit_map, 0, 0, _THIS_IP_);
 	jbd2_journal_free_transaction(new_transaction);
+	/*
+	 * Ensure that no allocations done while the transaction is open are
+	 * going to recurse back to the fs layer.
+	 */
+	handle->saved_alloc_context = memalloc_nofs_save();
 	return 0;
 }
 
@@ -466,6 +472,7 @@ handle_t *jbd2__journal_start(journal_t
 	trace_jbd2_handle_start(journal->j_fs_dev->bd_dev,
 				handle->h_transaction->t_tid, type,
 				line_no, nblocks);
+
 	return handle;
 }
 EXPORT_SYMBOL(jbd2__journal_start);
@@ -1760,6 +1767,11 @@ int jbd2_journal_stop(handle_t *handle)
 	if (handle->h_rsv_handle)
 		jbd2_journal_free_reserved(handle->h_rsv_handle);
 free_and_exit:
+	/*
+	 * Scope of the GFP_NOFS context is over here and so we can restore the
+	 * original alloc context.
+	 */
+	memalloc_nofs_restore(handle->saved_alloc_context);
 	jbd2_free_handle(handle);
 	return err;
 }
diff -puN include/linux/jbd2.h~jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context include/linux/jbd2.h
--- a/include/linux/jbd2.h~jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context
+++ a/include/linux/jbd2.h
@@ -491,6 +491,8 @@ struct jbd2_journal_handle
 
 	unsigned long		h_start_jiffies;
 	unsigned int		h_requested_credits;
+
+	unsigned int		saved_alloc_context;
 };
 
 
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-introduce-kvalloc-helpers.patch
mm-vmalloc-properly-track-vmalloc-users.patch
mm-support-__gfp_repeat-in-kvmalloc_node-for-32kb.patch
rhashtable-simplify-a-strange-allocation-pattern.patch
ila-simplify-a-strange-allocation-pattern.patch
xattr-zero-out-memory-copied-to-userspace-in-getxattr.patch
treewide-use-kvalloc-rather-than-opencoded-variants.patch
net-use-kvmalloc-with-__gfp_repeat-rather-than-open-coded-variant.patch
md-use-kvmalloc-rather-than-opencoded-variant.patch
bcache-use-kvmalloc.patch
mm-vmalloc-use-__gfp_highmem-implicitly.patch

