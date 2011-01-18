From: akpm@linux-foundation.org
Subject: [merged] thp-add-pagetranscompound.patch removed from -mm tree
Date: Tue, 18 Jan 2011 12:30:14 -0800
Message-ID: <201101182030.p0IKUEKi003544@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37268 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753364Ab1ARUnd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Jan 2011 15:43:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     thp: add PageTransCompound
has been removed from the -mm tree.  Its filename was
     thp-add-pagetranscompound.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: add PageTransCompound
From: Andrea Arcangeli <aarcange@redhat.com>

Remove branches when CONFIG_TRANSPARENT_HUGEPAGE=n.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN include/linux/page-flags.h~thp-add-pagetranscompound include/linux/page-flags.h
--- a/include/linux/page-flags.h~thp-add-pagetranscompound
+++ a/include/linux/page-flags.h
@@ -429,6 +429,11 @@ static inline int PageTransCompound(stru
 	return PageCompound(page);
 }
 
+static inline int PageTransCompound(struct page *page)
+{
+	return PageCompound(page);
+}
+
 #else
 
 static inline int PageTransHuge(struct page *page)
@@ -440,6 +445,11 @@ static inline int PageTransCompound(stru
 {
 	return 0;
 }
+
+static inline int PageTransCompound(struct page *page)
+{
+	return 0;
+}
 #endif
 
 #ifdef CONFIG_MMU
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
linux-next.patch

