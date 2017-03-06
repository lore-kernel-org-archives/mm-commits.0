From: akpm@linux-foundation.org
Subject: + jbd2-make-the-whole-kjournald2-kthread-nofs-safe.patch added to -mm tree
Date: Mon, 06 Mar 2017 13:26:30 -0800
Message-ID: <58bdd406.7I73/vAex4/ueSFJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45646 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932400AbdCFVf4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Mar 2017 16:35:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, bfoster@redhat.com, clm@fb.com, darrick.wong@oracle.com, david@fromorbit.com, dsterba@suse.cz, jack@suse.cz, nborisov@suse.com, peterz@infradead.org, tytso@mit.edu, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: jbd2: make the whole kjournald2 kthread NOFS safe
has been added to the -mm tree.  Its filename is
     jbd2-make-the-whole-kjournald2-kthread-nofs-safe.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/jbd2-make-the-whole-kjournald2-kthread-nofs-safe.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/jbd2-make-the-whole-kjournald2-kthread-nofs-safe.patch

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
Subject: jbd2: make the whole kjournald2 kthread NOFS safe

kjournald2 is central to the transaction commit processing.  As such any
potential allocation from this kernel thread has to be GFP_NOFS.  Make
sure to mark the whole kernel thread GFP_NOFS by the memalloc_nofs_save.

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

 fs/jbd2/journal.c |    8 ++++++++
 1 file changed, 8 insertions(+)

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
@@ -206,6 +207,13 @@ static int kjournald2(void *arg)
 	wake_up(&journal->j_wait_done_commit);
 
 	/*
+	 * Make sure that no allocations from this kernel thread will ever recurse
+	 * to the fs layer because we are responsible for the transaction commit
+	 * and any fs involvement might get stuck waiting for the trasn. commit.
+	 */
+	memalloc_nofs_save();
+
+	/*
 	 * And now, wait forever for commit wakeup events.
 	 */
 	write_lock(&journal->j_state_lock);
_

Patches currently in -mm which might be from mhocko@suse.com are

lockdep-allow-to-disable-reclaim-lockup-detection.patch
xfs-abstract-pf_fstrans-to-pf_memalloc_nofs.patch
mm-introduce-memalloc_nofs_saverestore-api.patch
xfs-use-memalloc_nofs_saverestore-instead-of-memalloc_noio.patch
jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context.patch
jbd2-make-the-whole-kjournald2-kthread-nofs-safe.patch

