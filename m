From: akpm@linux-foundation.org
Subject: [merged]
 jbd2-make-the-whole-kjournald2-kthread-nofs-safe.patch removed from -mm
 tree
Date: Thu, 04 May 2017 12:10:40 -0700
Message-ID: <20170504191040._m1uhMNE9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51226 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752637AbdEDTKl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 4 May 2017 15:10:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfoster@redhat.com, clm@fb.com, darrick.wong@oracle.com, david@fromorbit.com, dsterba@suse.cz, jack@suse.cz, mhocko@suse.com, mm-commits@vger.kernel.org, nborisov@suse.com, peterz@infradead.org, tytso@mit.edu, vbabka@suse.cz


The patch titled
     Subject: jbd2: make the whole kjournald2 kthread NOFS safe
has been removed from the -mm tree.  Its filename was
     jbd2-make-the-whole-kjournald2-kthread-nofs-safe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: jbd2: make the whole kjournald2 kthread NOFS safe

kjournald2 is central to the transaction commit processing.  As such any
potential allocation from this kernel thread has to be GFP_NOFS.  Make
sure to mark the whole kernel thread GFP_NOFS by the memalloc_nofs_save.

[akpm@linux-foundation.org: coding-style fixes]
Link: http://lkml.kernel.org/r/20170306131408.9828-8-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Suggested-by: Jan Kara <jack@suse.cz>
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

 fs/jbd2/journal.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN fs/jbd2/journal.c~jbd2-make-the-whole-kjournald2-kthread-nofs-safe fs/jbd2/journal.c
--- a/fs/jbd2/journal.c~jbd2-make-the-whole-kjournald2-kthread-nofs-safe
+++ a/fs/jbd2/journal.c
@@ -43,6 +43,7 @@
 #include <linux/backing-dev.h>
 #include <linux/bitops.h>
 #include <linux/ratelimit.h>
+#include <linux/sched/mm.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/jbd2.h>
@@ -206,6 +207,14 @@ static int kjournald2(void *arg)
 	wake_up(&journal->j_wait_done_commit);
 
 	/*
+	 * Make sure that no allocations from this kernel thread will ever
+	 * recurse to the fs layer because we are responsible for the
+	 * transaction commit and any fs involvement might get stuck waiting for
+	 * the trasn. commit.
+	 */
+	memalloc_nofs_save();
+
+	/*
 	 * And now, wait forever for commit wakeup events.
 	 */
 	write_lock(&journal->j_state_lock);
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

