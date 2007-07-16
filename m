From: akpm@linux-foundation.org
Subject: - oom-stop-allocating-user-memory-if-tif_memdie-is-set.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:49:22 -0700
Message-ID: <200707162049.l6GKnMJo001155@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45982 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756370AbXGPVTG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:19:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: solo@google.com, mm-commits@vger.kernel.org


The patch titled
     oom: stop allocating user memory if TIF_MEMDIE is set
has been removed from the -mm tree.  Its filename was
     oom-stop-allocating-user-memory-if-tif_memdie-is-set.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: oom: stop allocating user memory if TIF_MEMDIE is set
From: Ethan Solomita <solo@google.com>

get_user_pages() can try to allocate a nearly unlimited amount of memory on
behalf of a user process, even if that process has been OOM killed.  The
OOM kill occurs upon return to user space via a SIGKILL, but
get_user_pages() will try allocate all its memory before returning.  Change
get_user_pages() to check for TIF_MEMDIE, and if set then return
immediately.

Signed-off-by: Ethan Solomita <solo@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN mm/memory.c~oom-stop-allocating-user-memory-if-tif_memdie-is-set mm/memory.c
--- a/mm/memory.c~oom-stop-allocating-user-memory-if-tif_memdie-is-set
+++ a/mm/memory.c
@@ -1055,6 +1055,14 @@ int get_user_pages(struct task_struct *t
 		do {
 			struct page *page;
 
+			/*
+			 * If tsk is ooming, cut off its access to large memory
+			 * allocations. It has a pending SIGKILL, but it can't
+			 * be processed until returning to user space.
+			 */
+			if (unlikely(test_tsk_thread_flag(tsk, TIF_MEMDIE)))
+				return -ENOMEM;
+
 			if (write)
 				foll_flags |= FOLL_WRITE;
 
_

Patches currently in -mm which might be from solo@google.com are

origin.patch
