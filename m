From: akpm@linux-foundation.org
Subject: + idr-reduce-the-number-of-max_idr_free.patch added to -mm tree
Date: Tue, 22 Apr 2014 12:44:54 -0700
Message-ID: <5356c6b6.WDn5xhJ3NUaGEXc0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48896 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017AbaDVToz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Apr 2014 15:44:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, laijs@cn.fujitsu.com

Subject: + idr-reduce-the-number-of-max_idr_free.patch added to -mm tree
To: laijs@cn.fujitsu.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 22 Apr 2014 12:44:54 -0700


The patch titled
     Subject: idr: reduce the number of MAX_IDR_FREE
has been added to the -mm tree.  Its filename is
     idr-reduce-the-number-of-max_idr_free.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/idr-reduce-the-number-of-max_idr_free.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/idr-reduce-the-number-of-max_idr_free.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: idr: reduce the number of MAX_IDR_FREE

Whe need to prepare MAX_IDR_FREE idr_layers for allocation.

But when idr is not empty, we need at most (MAX_IDR_LEVEL - 1) idr_layers
to build up and at most (MAX_IDR_LEVEL - 1) idr_layers to allocate down. 
When idr is empty we need at most MAX_IDR_LEVEL layers.

So max((MAX_IDR_LEVEL * 2 - 2), MAX_IDR_LEVEL) idr_layers is enough.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN lib/idr.c~idr-reduce-the-number-of-max_idr_free lib/idr.c
--- a/lib/idr.c~idr-reduce-the-number-of-max_idr_free
+++ a/lib/idr.c
@@ -38,8 +38,13 @@
 /* Leave the possibility of an incomplete final layer */
 #define MAX_IDR_LEVEL ((MAX_IDR_SHIFT + IDR_BITS - 1) / IDR_BITS)
 
-/* Number of id_layer structs to leave in free list */
-#define MAX_IDR_FREE (MAX_IDR_LEVEL * 2)
+/*
+ * Number of idr_layer structs to leave in free list.
+ * When idr is not empty, we need atmost (MAX_IDR_LEVEL - 1) idr_layers
+ * to build up and atmost (MAX_IDR_LEVEL - 1) idr_layers to allocate down.
+ * When idr is empty need atmost MAX_IDR_LEVEL layers.
+ */
+#define MAX_IDR_FREE max((MAX_IDR_LEVEL * 2 - 2), MAX_IDR_LEVEL)
 
 static struct kmem_cache *idr_layer_cache;
 static DEFINE_PER_CPU(struct idr_layer *, idr_preload_head);
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

mem-hotplug-implement-get-put_online_mems.patch
slab-get_online_mems-for-kmem_cache_createdestroyshrink.patch
idr-fix-overflow-bug-during-maximum-id-calculation-at-maximum-height.patch
idr-fix-unexpected-id-removal-when-idr_removeunallocated_id.patch
idr-fix-null-pointer-dereference-when-ida_removeunallocated_id.patch
idr-fix-idr_replaces-returned-error-code.patch
idr-dont-need-to-shink-the-free-list-when-idr_remove.patch
idr-reduce-the-unneeded-check-in-free_layer.patch
idr-proper-invalid-argument-handling.patch
idr-reduce-the-number-of-max_idr_free.patch
ida-in-place-ida-allocation.patch
idr-reorder-the-fields.patch
linux-next.patch

