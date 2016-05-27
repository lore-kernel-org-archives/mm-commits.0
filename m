From: akpm@linux-foundation.org
Subject: [merged] aio-make-aio_setup_ring-killable.patch removed from -mm
 tree
Date: Fri, 27 May 2016 11:45:00 -0700
Message-ID: <574895ac.2jKZUH+XKyuRa+tG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42664 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbcE0SpB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 14:45:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, bcrl@kvack.org, jmoyer@redhat.com, vbabka@suse.cz, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: aio: make aio_setup_ring killable
has been removed from the -mm tree.  Its filename was
     aio-make-aio_setup_ring-killable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: aio: make aio_setup_ring killable

aio_setup_ring waits for mmap_sem in writable mode.  If the waiting task
gets killed by the oom killer it would block oom_reaper from asynchronous
address space reclaim and reduce the chances of timely OOM resolving. 
Wait for the lock in the killable mode and return with EINTR if the task
got killed while waiting.  This will also expedite the return to the
userspace and do_exit.

Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Benamin LaHaise <bcrl@kvack.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN fs/aio.c~aio-make-aio_setup_ring-killable fs/aio.c
--- a/fs/aio.c~aio-make-aio_setup_ring-killable
+++ a/fs/aio.c
@@ -496,7 +496,12 @@ static int aio_setup_ring(struct kioctx
 	ctx->mmap_size = nr_pages * PAGE_SIZE;
 	pr_debug("attempting mmap of %lu bytes\n", ctx->mmap_size);
 
-	down_write(&mm->mmap_sem);
+	if (down_write_killable(&mm->mmap_sem)) {
+		ctx->mmap_size = 0;
+		aio_free_ring(ctx);
+		return -EINTR;
+	}
+
 	ctx->mmap_base = do_mmap_pgoff(ctx->aio_ring_file, 0, ctx->mmap_size,
 				       PROT_READ | PROT_WRITE,
 				       MAP_SHARED, 0, &unused);
_

Patches currently in -mm which might be from mhocko@suse.com are

oom_reaper-close-race-with-exiting-task.patch

