From: akpm@linux-foundation.org
Subject: + tmpfs-dont-undo-fallocate-past-its-last-page.patch added to -mm tree
Date: Wed, 08 Jun 2016 13:47:42 -0700
Message-ID: <5758846e.nCoYfRqGE/CEytcP%akpm__7405.02134799517$1465418878$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36030 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161400AbcFHUrn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jun 2016 16:47:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anthony.romano@coreos.com, hughd@google.com, stable@vger.kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: tmpfs: don't undo fallocate past its last page
has been added to the -mm tree.  Its filename is
     tmpfs-dont-undo-fallocate-past-its-last-page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tmpfs-dont-undo-fallocate-past-its-last-page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tmpfs-dont-undo-fallocate-past-its-last-page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

tmpfs-dont-undo-fallocate-past-its-last-page.patch

