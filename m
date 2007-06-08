From: akpm@linux-foundation.org
Subject: + oom-stop-allocating-user-memory-if-tif_memdie-is-set.patch added to -mm tree
Date: Thu, 07 Jun 2007 18:23:01 -0700
Message-ID: <200706080123.l581N1vD014801@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33787 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966840AbXFHBXo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jun 2007 21:23:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: solo@google.com


The patch titled
     oom: stop allocating user memory if TIF_MEMDIE is set
has been added to the -mm tree.  Its filename is
     oom-stop-allocating-user-memory-if-tif_memdie-is-set.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 8 insertions(+)

diff -puN mm/memory.c~oom-stop-allocating-user-memory-if-tif_memdie-is-set mm/memory.c
--- a/mm/memory.c~oom-stop-allocating-user-memory-if-tif_memdie-is-set
+++ a/mm/memory.c
@@ -1056,6 +1056,14 @@ int get_user_pages(struct task_struct *t
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

oom-stop-allocating-user-memory-if-tif_memdie-is-set.patch
