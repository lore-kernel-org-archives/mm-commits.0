From: akpm@linux-foundation.org
Subject: [folded] aio-dont-zero-out-the-pages-array-inside-struct-dio-fix.patch removed from -mm tree
Date: Tue, 15 Dec 2009 16:37:46 -0800
Message-ID: <200912160037.nBG0bkwq023853@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32918 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750907AbZLPAjD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 19:39:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jmoyer@redhat.com, zach.brown@oracle.com, mm-commits@vger.kernel.org


The patch titled
     aio-dont-zero-out-the-pages-array-inside-struct-dio-fix
has been removed from the -mm tree.  Its filename was
     aio-dont-zero-out-the-pages-array-inside-struct-dio-fix.patch

This patch was dropped because it was folded into aio-dont-zero-out-the-pages-array-inside-struct-dio.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: aio-dont-zero-out-the-pages-array-inside-struct-dio-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Zach Brown <zach.brown@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/direct-io.c~aio-dont-zero-out-the-pages-array-inside-struct-dio-fix fs/direct-io.c
--- a/fs/direct-io.c~aio-dont-zero-out-the-pages-array-inside-struct-dio-fix
+++ a/fs/direct-io.c
@@ -130,6 +130,12 @@ struct dio {
 	unsigned head;			/* next page to process */
 	unsigned tail;			/* last valid page + 1 */
 	int page_errors;		/* errno from get_user_pages() */
+
+	/*
+	 * pages[] (and any fields placed after it) are not zeroed out at
+	 * allocation time.  Don't add new fields after pages[] unless you
+	 * wish that they not be zeroed.
+	 */
 	struct page *pages[DIO_PAGES];	/* page buffer */
 };
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect.patch
ext2-avoid-warn-messages-when-failing-to-write-to-the-superblock.patch
memcg-coalesce-charging-via-percpu-storage.patch
memcg-code-cleanrm-unused-variable-in-mem_cgroup_resize_limit.patch
ipc-remove-unreachable-code-in-semc.patch
fs-cache-avoid-maybe-used-uninitialised-warning-on-variable.patch
aio-dont-zero-out-the-pages-array-inside-struct-dio.patch
aio-dont-zero-out-the-pages-array-inside-struct-dio-fix.patch
direct-io-cleanup-blockdev_direct_io-locking-checkpatch-fixes.patch

