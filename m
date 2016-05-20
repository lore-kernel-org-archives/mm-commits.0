From: akpm@linux-foundation.org
Subject: [patch 030/162] mm: tighten fault_in_pages_writeable()
Date: Fri, 20 May 2016 16:57:53 -0700
Message-ID: <573fa481.FVzkGuwsYuTpof8e%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52289 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbcETX5y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 19:57:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, edumazet@google.com, viro@zeniv.linux.org.uk

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
