From: akpm@linux-foundation.org
Subject: - wait-for-page-writeback-when-directly-reclaiming-contiguous-areas-fix.patch removed from -mm tree
Date: Wed, 22 Aug 2007 13:24:11 -0700
Message-ID: <200708222024.l7MKOBKL002411@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37242 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763233AbXHVUYw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Aug 2007 16:24:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     synchronous lumpy: improve commentary on writeback wait
has been removed from the -mm tree.  Its filename was
     wait-for-page-writeback-when-directly-reclaiming-contiguous-areas-fix.patch

This patch was dropped because it was folded into wait-for-page-writeback-when-directly-reclaiming-contiguous-areas.patch

------------------------------------------------------
Subject: synchronous lumpy: improve commentary on writeback wait
From: Andy Whitcroft <apw@shadowen.org>

Improve code commentary on the initial writeback wait in synchronous
reclaim mode.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN mm/vmscan.c~wait-for-page-writeback-when-directly-reclaiming-contiguous-areas-fix mm/vmscan.c
--- a/mm/vmscan.c~wait-for-page-writeback-when-directly-reclaiming-contiguous-areas-fix
+++ a/mm/vmscan.c
@@ -479,6 +479,14 @@ static unsigned long shrink_page_list(st
 			(PageSwapCache(page) && (sc->gfp_mask & __GFP_IO));
 
 		if (PageWriteback(page)) {
+			/*
+			 * Synchronous reclaim is performed in two passes,
+			 * first an asynchronous pass over the list to
+			 * start parallel writeback, and a second synchronous
+			 * pass to wait for the IO to complete.  Wait here
+			 * for any page for which writeback has already
+			 * started.
+			 */
 			if (sync_writeback == PAGEOUT_IO_SYNC && may_enter_fs)
 				wait_on_page_writeback(page);
 			else
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static.patch
ensure-we-count-pages-transitioning-inactive-via-clear_active_flags.patch
wait-for-page-writeback-when-directly-reclaiming-contiguous-areas.patch
wait-for-page-writeback-when-directly-reclaiming-contiguous-areas-fix.patch
