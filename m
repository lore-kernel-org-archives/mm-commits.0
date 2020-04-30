From: akpm@linux-foundation.org
Subject: + xarrayh-correct-return-code-for-xa_store_bhirq.patch
 added to -mm tree
Date: Thu, 30 Apr 2020 15:08:11 -0700
Message-ID: <20200430220811.6U1jlM0yz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726960AbgD3WIM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 30 Apr 2020 18:08:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: manfred@colorfullife.com, mm-commits@vger.kernel.org, willy@infradead.org


The patch titled
     Subject: xarray.h: correct return code documentation for xa_store_{bh,irq}()
has been added to the -mm tree.  Its filename is
     xarrayh-correct-return-code-for-xa_store_bhirq.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/xarrayh-correct-return-code-for-xa_store_bhirq.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/xarrayh-correct-return-code-for-xa_store_bhirq.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

xarrayh-correct-return-code-for-xa_store_bhirq.patch
