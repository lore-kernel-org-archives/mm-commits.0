From: akpm@linux-foundation.org
Subject: [patch 77/84] aio: make aio_setup_ring killable
Date: Mon, 23 May 2016 16:25:59 -0700
Message-ID: <57439187.BnkoNOU5hqnyCo3C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42428 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342AbcEWX0B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 19:26:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, bcrl@kvack.org, jmoyer@redhat.com, vbabka@suse.cz, viro@zeniv.linux.org.uk

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
