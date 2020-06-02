From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 050/128] mm/filemap.c: remove misleading comment
Date: Mon, 01 Jun 2020 21:48:12 -0700
Message-ID: <20200602044812.GTUDQxeSg%akpm@linux-foundation.org>
References: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725986AbgFBEsO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 00:48:14 -0400
In-Reply-To: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, william.kucharski@oracle.com, willy@infradead.org

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
