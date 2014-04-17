From: akpm@linux-foundation.org
Subject: + slab-document-kmalloc_order.patch added to -mm tree
Date: Thu, 17 Apr 2014 14:21:54 -0700
Message-ID: <535045f2.ZnRTJxb374z+UyFB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60392 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbaDQVVz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Apr 2014 17:21:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, penberg@kernel.org, cl@linux.com, vdavydov@parallels.com

Subject: + slab-document-kmalloc_order.patch added to -mm tree
To: vdavydov@parallels.com,cl@linux.com,penberg@kernel.org
From: akpm@linux-foundation.org
Date: Thu, 17 Apr 2014 14:21:54 -0700


The patch titled
     Subject: slab: document kmalloc_order
has been added to the -mm tree.  Its filename is
     slab-document-kmalloc_order.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slab-document-kmalloc_order.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slab-document-kmalloc_order.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: slab: document kmalloc_order

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN mm/slab_common.c~slab-document-kmalloc_order mm/slab_common.c
--- a/mm/slab_common.c~slab-document-kmalloc_order
+++ a/mm/slab_common.c
@@ -573,6 +573,11 @@ void __init create_kmalloc_caches(unsign
 }
 #endif /* !CONFIG_SLOB */
 
+/*
+ * To avoid unnecessary overhead, we pass through large allocation requests
+ * directly to the page allocator. We use __GFP_COMP, because we will need to
+ * know the allocation order to free the pages properly in kfree.
+ */
 void *kmalloc_order(size_t size, gfp_t flags, unsigned int order)
 {
 	void *ret;
_

Patches currently in -mm which might be from vdavydov@parallels.com are

slb-charge-slabs-to-kmemcg-explicitly.patch
mm-get-rid-of-__gfp_kmemcg.patch
mm-get-rid-of-__gfp_kmemcg-fix.patch
slab-document-kmalloc_order.patch

