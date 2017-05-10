From: akpm@linux-foundation.org
Subject: + mm-nobootmem-return-0-when-start_pfn-equals-end_pfn.patch added to -mm tree
Date: Wed, 10 May 2017 15:17:48 -0700
Message-ID: <5913918c.2XpjSh94+RKOdYUi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40704 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753420AbdEJWRt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 10 May 2017 18:17:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard.weiyang@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/nobootmem.c: return 0 when start_pfn equals end_pfn
has been added to the -mm tree.  Its filename is
     mm-nobootmem-return-0-when-start_pfn-equals-end_pfn.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-nobootmem-return-0-when-start_pfn-equals-end_pfn.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-nobootmem-return-0-when-start_pfn-equals-end_pfn.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/nobootmem.c: return 0 when start_pfn equals end_pfn

When start_pfn equals end_pfn, __free_pages_memory() has no effect and
__free_memory_core() will finally return (end_pfn - start_pfn) = 0.

This patch returns 0 directly when start_pfn equals end_pfn.

Link: http://lkml.kernel.org/r/20170502131115.6650-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nobootmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/nobootmem.c~mm-nobootmem-return-0-when-start_pfn-equals-end_pfn mm/nobootmem.c
--- a/mm/nobootmem.c~mm-nobootmem-return-0-when-start_pfn-equals-end_pfn
+++ a/mm/nobootmem.c
@@ -118,7 +118,7 @@ static unsigned long __init __free_memor
 	unsigned long end_pfn = min_t(unsigned long,
 				      PFN_DOWN(end), max_low_pfn);
 
-	if (start_pfn > end_pfn)
+	if (start_pfn >= end_pfn)
 		return 0;
 
 	__free_pages_memory(start_pfn, end_pfn);
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-slub-remove-a-redundant-assignment-in-___slab_alloc.patch
mm-slub-reset-cpu_slabs-pointer-in-deactivate_slab.patch
mm-slub-pack-red_left_pad-with-another-int-to-save-a-word.patch
mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial.patch
mm-slub-wrap-kmem_cache-cpu_partial-in-config-config_slub_cpu_partial.patch
mm-nobootmem-return-0-when-start_pfn-equals-end_pfn.patch
mm-page_alloc-return-0-in-case-this-node-has-no-page-within-the-zone.patch

