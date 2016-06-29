From: akpm@linux-foundation.org
Subject: [merged] tmpfs-dont-undo-fallocate-past-its-last-page.patch
 removed from -mm tree
Date: Tue, 28 Jun 2016 19:01:44 -0700
Message-ID: <57732c08.Kim5WLCYPfaet1wr%akpm__16400.6743384109$1467165722$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41393 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbcF2CBp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jun 2016 22:01:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anthony.romano@coreos.com, brandon@ifup.co, hughd@google.com, stable@vger.kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: tmpfs: don't undo fallocate past its last page
has been removed from the -mm tree.  Its filename was
     tmpfs-dont-undo-fallocate-past-its-last-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Anthony Romano <anthony.romano@coreos.com>
Subject: tmpfs: don't undo fallocate past its last page

When fallocate is interrupted it will undo a range that extends one byte
past its range of allocated pages.  This can corrupt an in-use page by
zeroing out its first byte.  Instead, undo using the inclusive byte range.

Fixes: 1635f6a74152f1d ("tmpfs: undo fallocation on failure")
Link: http://lkml.kernel.org/r/1462713387-16724-1-git-send-email-anthony.romano@coreos.com
Signed-off-by: Anthony Romano <anthony.romano@coreos.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Brandon Philips <brandon@ifup.co>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/shmem.c~tmpfs-dont-undo-fallocate-past-its-last-page mm/shmem.c
--- a/mm/shmem.c~tmpfs-dont-undo-fallocate-past-its-last-page
+++ a/mm/shmem.c
@@ -2227,7 +2227,7 @@ static long shmem_fallocate(struct file
 			/* Remove the !PageUptodate pages we added */
 			shmem_undo_range(inode,
 				(loff_t)start << PAGE_SHIFT,
-				(loff_t)index << PAGE_SHIFT, true);
+				((loff_t)index << PAGE_SHIFT) - 1, true);
 			goto undone;
 		}
 
_

Patches currently in -mm which might be from anthony.romano@coreos.com are


