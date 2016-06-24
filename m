From: akpm@linux-foundation.org
Subject: [patch 04/41] tmpfs: don't undo fallocate past its last page
Date: Fri, 24 Jun 2016 14:48:43 -0700
Message-ID: <576daabb.OzoVHjRe4ae18abt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40868 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbcFXVso (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jun 2016 17:48:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, anthony.romano@coreos.com, brandon@ifup.co, hughd@google.com, stable@vger.kernel.org, vbabka@suse.cz

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
