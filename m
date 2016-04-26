From: akpm@linux-foundation.org
Subject: + mm-tighten-fault_in_pages_writeable.patch added to -mm tree
Date: Tue, 26 Apr 2016 16:58:36 -0700
Message-ID: <572000ac.3U0H7pGBsYSgkXni%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54595 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbcDZX6m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Apr 2016 19:58:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edumazet@google.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: tighten fault_in_pages_writeable()
has been added to the -mm tree.  Its filename is
     mm-tighten-fault_in_pages_writeable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-tighten-fault_in_pages_writeable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-tighten-fault_in_pages_writeable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric Dumazet <edumazet@google.com>
Subject: mm: tighten fault_in_pages_writeable()

copy_page_to_iter_iovec() is currently the only user of
fault_in_pages_writeable(), and it definitely can use fragments from high
order pages.

Make sure fault_in_pages_writeable() is only touching two adjacent pages
at most, as claimed.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |   24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff -puN include/linux/pagemap.h~mm-tighten-fault_in_pages_writeable include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-tighten-fault_in_pages_writeable
+++ a/include/linux/pagemap.h
@@ -518,33 +518,27 @@ void page_endio(struct page *page, int r
 extern void add_page_wait_queue(struct page *page, wait_queue_t *waiter);
 
 /*
- * Fault a userspace page into pagetables.  Return non-zero on a fault.
- *
- * This assumes that two userspace pages are always sufficient.
+ * Fault one or two userspace pages into pagetables.
+ * Return -EINVAL if more than two pages would be needed.
+ * Return non-zero on a fault.
  */
 static inline int fault_in_pages_writeable(char __user *uaddr, int size)
 {
-	int ret;
+	int span, ret;
 
 	if (unlikely(size == 0))
 		return 0;
 
+	span = offset_in_page(uaddr) + size;
+	if (span > 2 * PAGE_SIZE)
+		return -EINVAL;
 	/*
 	 * Writing zeroes into userspace here is OK, because we know that if
 	 * the zero gets there, we'll be overwriting it.
 	 */
 	ret = __put_user(0, uaddr);
-	if (ret == 0) {
-		char __user *end = uaddr + size - 1;
