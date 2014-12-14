From: akpm@linux-foundation.org
Subject: [merged]
 fs-seq_file-fallback-to-vmalloc-instead-of-oom-kill-processes.patch removed from -mm tree
Date: Sat, 13 Dec 2014 20:08:08 -0800
Message-ID: <548d0d28.cthTfKQ0d4tIb/as%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47683 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbaLNEIA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:08:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, hch@infradead.org, heiko.carstens@de.ibm.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs, seq_file: fallback to vmalloc instead of oom kill processes
has been removed from the -mm tree.  Its filename was
     fs-seq_file-fallback-to-vmalloc-instead-of-oom-kill-processes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: fs, seq_file: fallback to vmalloc instead of oom kill processes

Since commit 058504edd026 ("fs/seq_file: fallback to vmalloc allocation"),
seq_buf_alloc() falls back to vmalloc() when the kmalloc() for contiguous
memory fails.  This was done to address order-4 slab allocations for
reading /proc/stat on large machines and noticed because
PAGE_ALLOC_COSTLY_ORDER < 4, so there is no infinite loop in the page
allocator when allocating new slab for such high-order allocations.

Contiguous memory isn't necessary for caller of seq_buf_alloc(), however. 
Other GFP_KERNEL high-order allocations that are <=
PAGE_ALLOC_COSTLY_ORDER will simply loop forever in the page allocator and
oom kill processes as a result.

We don't want to kill processes so that we can allocate contiguous memory
in situations when contiguous memory isn't necessary.

This patch does the kmalloc() allocation with __GFP_NORETRY for high-order
allocations.  This still utilizes memory compaction and direct reclaim in
the allocation path, the only difference is that it will fail immediately
instead of oom kill processes when out of memory.

[akpm@linux-foundation.org: add comment]
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN fs/seq_file.c~fs-seq_file-fallback-to-vmalloc-instead-of-oom-kill-processes fs/seq_file.c
--- a/fs/seq_file.c~fs-seq_file-fallback-to-vmalloc-instead-of-oom-kill-processes
+++ a/fs/seq_file.c
@@ -25,7 +25,11 @@ static void *seq_buf_alloc(unsigned long
 {
 	void *buf;
 
-	buf = kmalloc(size, GFP_KERNEL | __GFP_NOWARN);
+	/*
+	 * __GFP_NORETRY to avoid oom-killings with high-order allocations -
+	 * it's better to fall back to vmalloc() than to kill things.
+	 */
+	buf = kmalloc(size, GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN);
 	if (!buf && size > PAGE_SIZE)
 		buf = vmalloc(size);
 	return buf;
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath.patch
mm-utilc-add-kstrimdup.patch
sysctl-terminate-strings-also-on-r.patch
sysctl-terminate-strings-also-on-r-fix.patch
linux-next.patch
lib-show_mem-this-patch-adds-cma-reserved-infromation.patch
lib-show_mem-this-patch-adds-cma-reserved-infromation-fix.patch

