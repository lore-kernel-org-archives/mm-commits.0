From: akpm@linux-foundation.org
Subject: + hugetlb-remove-unused-variable-warning.patch added to -mm tree
Date: Sat, 26 Jul 2008 12:39:28 -0700
Message-ID: <200807261939.m6QJdSg3016064@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36200 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751866AbYGZTja (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 15:39:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: righi.andrea@gmail.com


The patch titled
     hugetlb: remove unused variable warning
has been added to the -mm tree.  Its filename is
     hugetlb-remove-unused-variable-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: remove unused variable warning
From: Andrea Righi <righi.andrea@gmail.com>

Remove the following warning when CONFIG_HUGETLB_PAGE is not set:

	ipc/shm.c: In function `shm_get_stat':
	ipc/shm.c:565: warning: unused variable `h'

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
+        return 1;
+}
 #endif
 
 #endif /* _LINUX_HUGETLB_H */
_

Patches currently in -mm which might be from righi.andrea@gmail.com are

origin.patch
task-io-accounting-correctly-account-threads-io-statistics.patch
hugetlb-remove-unused-variable-warning.patch

