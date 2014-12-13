From: akpm@linux-foundation.org
Subject: [folded-merged]
 fs-seq_file-fallback-to-vmalloc-instead-of-oom-kill-processes-fix.patch
 removed from -mm tree
Date: Fri, 12 Dec 2014 16:41:46 -0800
Message-ID: <548b8b4a.drrGAa+wvg5JEJbj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38383 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbaLMAlr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 12 Dec 2014 19:41:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs-seq_file-fallback-to-vmalloc-instead-of-oom-kill-processes-fix
has been removed from the -mm tree.  Its filename was
     fs-seq_file-fallback-to-vmalloc-instead-of-oom-kill-processes-fix.patch

This patch was dropped because it was folded into fs-seq_file-fallback-to-vmalloc-instead-of-oom-kill-processes.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-seq_file-fallback-to-vmalloc-instead-of-oom-kill-processes-fix

add comment

Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN fs/seq_file.c~fs-seq_file-fallback-to-vmalloc-instead-of-oom-kill-processes-fix fs/seq_file.c
--- a/fs/seq_file.c~fs-seq_file-fallback-to-vmalloc-instead-of-oom-kill-processes-fix
+++ a/fs/seq_file.c
@@ -36,6 +36,10 @@ static void *seq_buf_alloc(unsigned long
 {
 	void *buf;
 
+	/*
+	 * __GFP_NORETRY to avoid oom-killings with high-order allocations -
+	 * it's better to fall back to vmalloc() than to kill things.
+	 */
 	buf = kmalloc(size, GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN);
 	if (!buf && size > PAGE_SIZE)
 		buf = vmalloc(size);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-mincore-add-hwpoison-page-handle.patch
include-linux-kmemleakh-needs-slabh.patch
mm-page_owner-keep-track-of-page-owners.patch
fs-seq_file-fallback-to-vmalloc-instead-of-oom-kill-processes.patch
oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2-fix.patch
mm-memcontrol-fix-defined-but-not-used-compiler-warning-fix.patch
zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix-2.patch
zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix.patch
mm-zsmalloc-support-allocating-obj-with-size-of-zs_max_alloc_size-fix.patch
mm-zsmalloc-avoid-duplicate-assignment-of-prev_class-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix-fix.patch
ipc-msg-increase-msgmni-remove-scaling-checkpatch-fixes.patch
mm-cma-make-kmemleak-ignore-cma-regions.patch

