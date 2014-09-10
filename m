From: akpm@linux-foundation.org
Subject: + mm-clear-__gfp_fs-when-pf_memalloc_noio-is-set.patch added to
 -mm tree
Date: Wed, 10 Sep 2014 15:23:36 -0700
Message-ID: <5410cf68./gl5e3T20R05r6oQ%akpm__17978.2687024728$1410387829$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58500 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbaIJWXh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Sep 2014 18:23:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: junxiao.bi@oracle.com, david@fromorbit.com, ming.lei@canonical.com, stable@vger.kernel.org, trond.myklebust@primarydata.com, xuejiufei@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: clear __GFP_FS when PF_MEMALLOC_NOIO is set
has been added to the -mm tree.  Its filename is
     mm-clear-__gfp_fs-when-pf_memalloc_noio-is-set.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-clear-__gfp_fs-when-pf_memalloc_noio-is-set.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-clear-__gfp_fs-when-pf_memalloc_noio-is-set.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: mm: clear __GFP_FS when PF_MEMALLOC_NOIO is set

commit 21caf2fc1931 ("mm: teach mm by current context info to not do I/O
during memory allocation") introduces PF_MEMALLOC_NOIO flag to avoid doing
I/O inside memory allocation, __GFP_IO is cleared when this flag is set,
but __GFP_FS implies __GFP_IO, it should also be cleared.  Or it may still
run into I/O, like in superblock shrinker.  And this will make the kernel
run into the deadlock case described in that commit.

See Dave Chinner's comment about io in superblock shrinker:

Filesystem shrinkers do indeed perform IO from the superblock shrinker and
have for years.  Even clean inodes can require IO before they can be freed
- e.g.  on an orphan list, need truncation of post-eof blocks, need to
wait for ordered operations to complete before it can be freed, etc.

IOWs, Ext4, btrfs and XFS all can issue and/or block on arbitrary amounts
of IO in the superblock shrinker context.  XFS, in particular, has been
doing transactions and IO from the VFS inode cache shrinker since it was
first introduced....

Fix this by clearing __GFP_FS in memalloc_noio_flags(), this function has
masked all the gfp_mask that will be passed into fs for the processes
setting PF_MEMALLOC_NOIO in the direct reclaim path.

v1 thread at: https://lkml.org/lkml/2014/9/3/32

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: joyce.xue <xuejiufei@huawei.com>
Cc: Ming Lei <ming.lei@canonical.com>
Cc: Trond Myklebust <trond.myklebust@primarydata.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN include/linux/sched.h~mm-clear-__gfp_fs-when-pf_memalloc_noio-is-set include/linux/sched.h
--- a/include/linux/sched.h~mm-clear-__gfp_fs-when-pf_memalloc_noio-is-set
+++ a/include/linux/sched.h
@@ -1936,11 +1936,13 @@ extern void thread_group_cputime_adjuste
 #define tsk_used_math(p) ((p)->flags & PF_USED_MATH)
 #define used_math() tsk_used_math(current)
 
-/* __GFP_IO isn't allowed if PF_MEMALLOC_NOIO is set in current->flags */
+/* __GFP_IO isn't allowed if PF_MEMALLOC_NOIO is set in current->flags
+ * __GFP_FS is also cleared as it implies __GFP_IO.
+ */
 static inline gfp_t memalloc_noio_flags(gfp_t flags)
 {
 	if (unlikely(current->flags & PF_MEMALLOC_NOIO))
-		flags &= ~__GFP_IO;
+		flags &= ~(__GFP_IO | __GFP_FS);
 	return flags;
 }
 
_

Patches currently in -mm which might be from junxiao.bi@oracle.com are

ocfs2-reflink-fix-slow-unlink-for-refcounted-file.patch
ocfs2-fix-journal-commit-deadlock.patch
ocfs2-fix-deadlock-due-to-wrong-locking-order.patch
mm-clear-__gfp_fs-when-pf_memalloc_noio-is-set.patch

