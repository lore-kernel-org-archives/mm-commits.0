From: akpm@linux-foundation.org
Subject: [merged] 9pfs-fix-filesystem-to-wait-for-stable-page-writeback.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:39:21 -0800
Message-ID: <20130222203922.0C5575A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:38015 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757561Ab3BVUjY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:39:24 -0500
Received: by mail-vb0-f73.google.com with SMTP id fj18so103392vbb.4
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:39:23 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: darrick.wong@oracle.com, adrian.hunter@intel.com, axboe@kernel.dk, dedekind1@gmail.com, ericvh@gmail.com, jack@suse.cz, jlbec@evilplan.org, lucho@ionkov.net, luto@amacapital.net, mfasheh@suse.com, rminnich@sandia.gov, swhiteho@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: 9pfs: fix filesystem to wait for stable page writeback
has been removed from the -mm tree.  Its filename was
     9pfs-fix-filesystem-to-wait-for-stable-page-writeback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: 9pfs: fix filesystem to wait for stable page writeback

Fix up the ->page_mkwrite handler to provide stable page writes if necessary.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Ron Minnich <rminnich@sandia.gov>
Cc: Latchesar Ionkov <lucho@ionkov.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/9p/vfs_file.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/9p/vfs_file.c~9pfs-fix-filesystem-to-wait-for-stable-page-writeback fs/9p/vfs_file.c
--- a/fs/9p/vfs_file.c~9pfs-fix-filesystem-to-wait-for-stable-page-writeback
+++ a/fs/9p/vfs_file.c
@@ -616,6 +616,7 @@ v9fs_vm_page_mkwrite(struct vm_area_stru
 	lock_page(page);
 	if (page->mapping != inode->i_mapping)
 		goto out_unlock;
+	wait_for_stable_page(page);
 
 	return VM_FAULT_LOCKED;
 out_unlock:
_

Patches currently in -mm which might be from darrick.wong@oracle.com are

origin.patch
linux-next.patch

