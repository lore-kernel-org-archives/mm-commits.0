From: akpm@linux-foundation.org
Subject: [merged] mm-remove-misleading-comment.patch removed from
 -mm tree
Date: Tue, 02 Jun 2020 14:39:44 -0700
Message-ID: <20200602213944.DPp2-hicW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726420AbgFBVjo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 17:39:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, william.kucharski@oracle.com, willy@infradead.org


The patch titled
     Subject: mm/filemap.c: remove misleading comment
has been removed from the -mm tree.  Its filename was
     mm-remove-misleading-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/filemap.c: remove misleading comment

We no longer return 0 here and the comment doesn't tell us anything that
we don't already know (SIGBUS is a pretty good indicator that things
didn't work out).

Link: http://lkml.kernel.org/r/20200529123243.20640-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/filemap.c~mm-remove-misleading-comment
+++ a/mm/filemap.c
@@ -2566,7 +2566,6 @@ page_not_uptodate:
 	if (!error || error == AOP_TRUNCATED_PAGE)
 		goto retry_find;
 
-	/* Things didn't work out. Return zero to tell the mm layer so. */
 	shrink_readahead_size_eio(ra);
 	return VM_FAULT_SIGBUS;
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-simplify-calling-a-compound-page-destructor.patch
ipc-convert-ipcs_idr-to-xarray.patch
ipc-convert-ipcs_idr-to-xarray-update.patch
