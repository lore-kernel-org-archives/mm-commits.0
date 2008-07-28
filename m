From: akpm@linux-foundation.org
Subject: - hugetlb-remove-unused-variable-warning.patch removed from -mm tree
Date: Mon, 28 Jul 2008 14:10:54 -0700
Message-ID: <200807282110.m6SLAsTf027609@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45946 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760981AbYG1VLa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jul 2008 17:11:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: righi.andrea@gmail.com, mm-commits@vger.kernel.org


The patch titled
     hugetlb: remove unused variable warning
has been removed from the -mm tree.  Its filename was
     hugetlb-remove-unused-variable-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: remove unused variable warning
From: Andrea Righi <righi.andrea@gmail.com>

Remove the following warning when CONFIG_HUGETLB_PAGE is not set:

	ipc/shm.c: In function `shm_get_stat':
	ipc/shm.c:565: warning: unused variable `h'

[akpm@linux-foundation.org: use tabs, not spaces]
Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN include/linux/hugetlb.h~hugetlb-remove-unused-variable-warning include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlb-remove-unused-variable-warning
+++ a/include/linux/hugetlb.h
@@ -273,7 +273,10 @@ struct hstate {};
 #define huge_page_mask(h) PAGE_MASK
 #define huge_page_order(h) 0
 #define huge_page_shift(h) PAGE_SHIFT
-#define pages_per_huge_page(h) 1
+static inline unsigned int pages_per_huge_page(struct hstate *h)
+{
+	return 1;
+}
 #endif
 
 #endif /* _LINUX_HUGETLB_H */
_

Patches currently in -mm which might be from righi.andrea@gmail.com are

origin.patch

