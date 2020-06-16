From: akpm@linux-foundation.org
Subject: + hugetlbfs-prevent-filesystem-stacking-of-hugetlbfs.patch
 added to -mm tree
Date: Tue, 16 Jun 2020 13:26:50 -0700
Message-ID: <20200616202650.-S9H6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726428AbgFPU0v (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 16 Jun 2020 16:26:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, willy@infradead.org, walters@verbum.org, viro@zeniv.linux.org.uk, mszeredi@redhat.com, amir73il@gmail.com, mike.kravetz@oracle.com


The patch titled
     Subject: hugetlbfs: prevent filesystem stacking of hugetlbfs
has been added to the -mm tree.  Its filename is
     hugetlbfs-prevent-filesystem-stacking-of-hugetlbfs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hugetlbfs-prevent-filesystem-stacking-of-hugetlbfs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hugetlbfs-prevent-filesystem-stacking-of-hugetlbfs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlbfs: prevent filesystem stacking of hugetlbfs

syzbot found issues with having hugetlbfs on a union/overlay as reported
in [1].  Due to the limitations (no write) and special functionality of
hugetlbfs, it does not work well in filesystem stacking.  There are no
know use cases for hugetlbfs stacking.  Rather than making modifications
to get hugetlbfs working in such environments, simply prevent stacking.

[1] https://lore.kernel.org/linux-mm/000000000000b4684e05a2968ca6@google.com/

Link: http://lkml.kernel.org/r/80f869aa-810d-ef6c-8888-b46cee135907@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reported-by: syzbot+d6ec23007e951dadf3de@syzkaller.appspotmail.com
Suggested-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Miklos Szeredi <mszeredi@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Colin Walters <walters@verbum.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-prevent-filesystem-stacking-of-hugetlbfs
+++ a/fs/hugetlbfs/inode.c
@@ -1364,6 +1364,12 @@ hugetlbfs_fill_super(struct super_block
 	sb->s_magic = HUGETLBFS_MAGIC;
 	sb->s_op = &hugetlbfs_ops;
 	sb->s_time_gran = 1;
+
+	/*
+	 * Due to the special and limited functionality of hugetlbfs, it does
+	 * not work well as a stacking filesystem.
+	 */
+	sb->s_stack_depth = FILESYSTEM_MAX_STACK_DEPTH;
 	sb->s_root = d_make_root(hugetlbfs_get_root(sb, ctx));
 	if (!sb->s_root)
 		goto out_free;
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlbfs-prevent-filesystem-stacking-of-hugetlbfs.patch
