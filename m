From: akpm@linux-foundation.org
Subject: [merged] nilfs2-fix-problems-of-memory-allocation-in-ioctl.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:09:09 -0700
Message-ID: <200904071909.n37J99xk012164@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38687 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760122AbZDGTLw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:11:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, andi@firstfloor.org, mm-commits@vger.kernel.org


The patch titled
     nilfs2: fix problems of memory allocation in ioctl
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-problems-of-memory-allocation-in-ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nilfs2: fix problems of memory allocation in ioctl
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

This is another patch for fixing the following problems of a memory
copy function in nilfs2 ioctl:

(1) It tries to allocate 128KB size of memory even for small objects.

(2) Though the function repeatedly tries large memory allocations
    while reducing the size, GFP_NOWAIT flag is not specified.
    This increases the possibility of system memory shortage.

(3) During the retries of (2), verbose warnings are printed
    because _GFP_NOWARN flag is not used for the kmalloc calls.

The first patch was still doing large allocations by kmalloc which are
repeatedly tried while reducing the size.

Andi Kleen told me that using copy_from_user for large memory is not
good from the viewpoint of preempt latency:

 On Fri, 12 Dec 2008 21:24:11 +0100, Andi Kleen <andi@firstfloor.org> wrote:
 > > In the current interface, each data item is copied twice: one is to
 > > the allocated memory from user space (via copy_from_user), and another
 >
 > For such large copies it is better to use multiple smaller (e.g. 4K)
 > copy user, that gives better real time preempt latencies. Each cfu has a
 > cond_resched(), but only one, not multiple times in the inner loop.

He also advised me that:

 On Sun, 14 Dec 2008 16:13:27 +0100, Andi Kleen <andi@firstfloor.org> wrote:
 > Better would be if you could go to PAGE_SIZE. order 0 allocations
 > are typically the fastest / least likely to stall.
 >
 > Also in this case it's a good idea to use __get_free_pages()
 > directly, kmalloc tends to be become less efficient at larger
 > sizes.

For the function in question, the size of buffer memory can be reduced
since the buffer is repeatedly used for a number of small objects.  On
the other hand, it may incur large preempt latencies for larger buffer
because a copy_from_user (and a copy_to_user) was applied only once
each cycle.

With that, this revision uses the order 0 allocations with
__get_free_pages() to fix the original problems.

Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/ioctl.c |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff -puN fs/nilfs2/ioctl.c~nilfs2-fix-problems-of-memory-allocation-in-ioctl fs/nilfs2/ioctl.c
--- a/fs/nilfs2/ioctl.c~nilfs2-fix-problems-of-memory-allocation-in-ioctl
+++ a/fs/nilfs2/ioctl.c
@@ -34,9 +34,6 @@
 #include "dat.h"
 
 
-#define KMALLOC_SIZE_MIN	4096	/* 4KB */
-#define KMALLOC_SIZE_MAX	131072	/* 128 KB */
-
 static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilfs,
 				 struct nilfs_argv *argv, int dir,
 				 ssize_t (*dofunc)(struct the_nilfs *,
@@ -44,21 +41,20 @@ static int nilfs_ioctl_wrap_copy(struct 
 						   void *, size_t, size_t))
 {
 	void *buf;
-	size_t ksize, maxmembs, total, n;
+	size_t maxmembs, total, n;
 	ssize_t nr;
 	int ret, i;
 
 	if (argv->v_nmembs == 0)
 		return 0;
 
-	for (ksize = KMALLOC_SIZE_MAX; ksize >= KMALLOC_SIZE_MIN; ksize /= 2) {
-		buf = kmalloc(ksize, GFP_NOFS);
-		if (buf != NULL)
-			break;
-	}
-	if (ksize < KMALLOC_SIZE_MIN)
+	if (argv->v_size > PAGE_SIZE)
+		return -EINVAL;
+
+	buf = (void *)__get_free_pages(GFP_NOFS, 0);
+	if (unlikely(!buf))
 		return -ENOMEM;
-	maxmembs = ksize / argv->v_size;
+	maxmembs = PAGE_SIZE / argv->v_size;
 
 	ret = 0;
 	total = 0;
@@ -89,7 +85,7 @@ static int nilfs_ioctl_wrap_copy(struct 
 	}
 	argv->v_nmembs = total;
 
-	kfree(buf);
+	free_pages((unsigned long)buf, 0);
 	return ret;
 }
 
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

origin.patch

