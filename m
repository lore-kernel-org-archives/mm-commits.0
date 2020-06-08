From: akpm@linux-foundation.org
Subject: [merged]
 xarrayh-correct-return-code-for-xa_store_bhirq.patch removed from -mm tree
Date: Mon, 08 Jun 2020 15:31:41 -0700
Message-ID: <20200608223141.jB-u2WIEC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726740AbgFHWbm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 18:31:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: manfred@colorfullife.com, mm-commits@vger.kernel.org, willy@infradead.org


The patch titled
     Subject: xarray.h: correct return code documentation for xa_store_{bh,irq}()
has been removed from the -mm tree.  Its filename was
     xarrayh-correct-return-code-for-xa_store_bhirq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Manfred Spraul <manfred@colorfullife.com>
Subject: xarray.h: correct return code documentation for xa_store_{bh,irq}()

__xa_store() and xa_store() document that the functions can fail, and that
the return code can be an xa_err() encoded error code.

xa_store_bh() and xa_store_irq() do not document that the functions can
fail and that they can also return xa_err() encoded error codes.

Thus: Update the documentation.

Link: http://lkml.kernel.org/r/20200430111424.16634-1-manfred@colorfullife.com
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/xarray.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/xarray.h~xarrayh-correct-return-code-for-xa_store_bhirq
+++ a/include/linux/xarray.h
@@ -576,7 +576,7 @@ void __xa_clear_mark(struct xarray *, un
  *
  * Context: Any context.  Takes and releases the xa_lock while
  * disabling softirqs.
- * Return: The entry which used to be at this index.
+ * Return: The old entry at this index or xa_err() if an error happened.
  */
 static inline void *xa_store_bh(struct xarray *xa, unsigned long index,
 		void *entry, gfp_t gfp)
@@ -602,7 +602,7 @@ static inline void *xa_store_bh(struct x
  *
  * Context: Process context.  Takes and releases the xa_lock while
  * disabling interrupts.
- * Return: The entry which used to be at this index.
+ * Return: The old entry at this index or xa_err() if an error happened.
  */
 static inline void *xa_store_irq(struct xarray *xa, unsigned long index,
 		void *entry, gfp_t gfp)
_

Patches currently in -mm which might be from manfred@colorfullife.com are
