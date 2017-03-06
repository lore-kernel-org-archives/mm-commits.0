From: akpm@linux-foundation.org
Subject: +
 jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context.patch
 added to -mm tree
Date: Mon, 06 Mar 2017 13:26:25 -0800
Message-ID: <58bdd401.Yz1sWp2XnnqENsL9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45626 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932367AbdCFVfz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Mar 2017 16:35:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, bfoster@redhat.com, clm@fb.com, darrick.wong@oracle.com, david@fromorbit.com, dsterba@suse.cz, jack@suse.cz, nborisov@suse.com, peterz@infradead.org, tytso@mit.edu, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: jbd2: mark the transaction context with the scope GFP_NOFS context
has been added to the -mm tree.  Its filename is
     jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: jbd2: mark the transaction context with the scope GFP_NOFS context

now that we have memalloc_nofs_{save,restore} api we can mark the whole
transaction context as implicitly GFP_NOFS.  All allocations will
automatically inherit GFP_NOFS this way.  This means that we do not have
to mark any of those requests with GFP_NOFS and moreover all the
ext4_kv[mz]alloc(GFP_NOFS) are also safe now because even the hardcoded
GFP_KERNEL allocations deep inside the vmalloc will be NOFS now.

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
+	 * Make sure that no allocations done while the transaction is
+	 * open is going to recurse back to the fs layer.
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
+	 * scope of th GFP_NOFS context is over here and so we can
+	 * restore the original alloc context.
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

lockdep-allow-to-disable-reclaim-lockup-detection.patch
xfs-abstract-pf_fstrans-to-pf_memalloc_nofs.patch
mm-introduce-memalloc_nofs_saverestore-api.patch
xfs-use-memalloc_nofs_saverestore-instead-of-memalloc_noio.patch
jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context.patch
jbd2-make-the-whole-kjournald2-kthread-nofs-safe.patch

