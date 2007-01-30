From: akpm@osdl.org
Subject: - fix-for-patch-ecdfc9787fe527491baefc22dce8b2dbd5b2908d.patch removed from -mm tree
Date: Tue, 30 Jan 2007 13:46:59 -0800
Message-ID: <200701302146.l0ULkx1H030146@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51893 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794AbXA3VrD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jan 2007 16:47:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nickpiggin@yahoo.com.au, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     Fix for patch ecdfc9787fe527491baefc22dce8b2dbd5b2908d
has been removed from the -mm tree.  Its filename was
     fix-for-patch-ecdfc9787fe527491baefc22dce8b2dbd5b2908d.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix for patch ecdfc9787fe527491baefc22dce8b2dbd5b2908d
From: Nick Piggin <nickpiggin@yahoo.com.au>

__set_page_dirty_buffers() | try_to_free_buffers()
---------------------------+---------------------------
                           | spin_lock(private_lock);
                           | drop_bufers()
                           | spin_unlock(private_lock);
spin_lock(private_lock)    |
!page_has_buffers()        |
spin_unlock(private_lock)  |
SetPageDirty()             |
                           | cancel_dirty_page()

                          oops!

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/buffer.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN fs/buffer.c~fix-for-patch-ecdfc9787fe527491baefc22dce8b2dbd5b2908d fs/buffer.c
--- a/fs/buffer.c~fix-for-patch-ecdfc9787fe527491baefc22dce8b2dbd5b2908d
+++ a/fs/buffer.c
@@ -2844,7 +2844,6 @@ int try_to_free_buffers(struct page *pag
 
 	spin_lock(&mapping->private_lock);
 	ret = drop_buffers(page, &buffers_to_free);
-	spin_unlock(&mapping->private_lock);
 
 	/*
 	 * If the filesystem writes its buffers by hand (eg ext3)
@@ -2855,9 +2854,14 @@ int try_to_free_buffers(struct page *pag
 	 * Also, during truncate, discard_buffer will have marked all
 	 * the page's buffers clean.  We discover that here and clean
 	 * the page also.
+	 *
+	 * private_lock must be held over this entire operation in order
+	 * to synchronise against __set_page_dirty_buffers and prevent the
+	 * dirty bit from being lost.
 	 */
 	if (ret)
 		cancel_dirty_page(page, PAGE_CACHE_SIZE);
+	spin_unlock(&mapping->private_lock);
 out:
 	if (buffers_to_free) {
 		struct buffer_head *bh = buffers_to_free;
_

Patches currently in -mm which might be from nickpiggin@yahoo.com.au are

origin.patch
fix-via-quirks.patch
mm-show-bounce-pages-in-oom-killer-output.patch
page_mkwrite-race-fix.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
kblockd-use-flush_work.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
sched2-sched-domain-sysctl.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
