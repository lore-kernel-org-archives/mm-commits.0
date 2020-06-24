From: akpm@linux-foundation.org
Subject: + mm-fix-a-warning-while-make-xmldocs.patch added to -mm
 tree
Date: Wed, 24 Jun 2020 15:47:25 -0700
Message-ID: <20200624224725.Y1IhQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388711AbgFXWr0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Jun 2020 18:47:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org, standby24x7@gmail.com


The patch titled
     Subject: mm/vmalloc.c: fix a warning while make xmldocs
has been added to the -mm tree.  Its filename is
     mm-fix-a-warning-while-make-xmldocs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-a-warning-while-make-xmldocs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-a-warning-while-make-xmldocs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Masanari Iida <standby24x7@gmail.com>
Subject: mm/vmalloc.c: fix a warning while make xmldocs

This patch fixes following warning while "make xmldocs"

./mm/vmalloc.c:1877: warning: Excess function parameter
'prot' description in 'vm_map_ram'

This warning started since a patch was merged in 5.8-rc1.
Link: http://lkml.kernel.org/r/20200622152850.140871-1-standby24x7@gmail.com
Fixes: d4efd79a81ab ("mm: remove the prot argument from vm_map_ram")

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/vmalloc.c~mm-fix-a-warning-while-make-xmldocs
+++ a/mm/vmalloc.c
@@ -1862,7 +1862,6 @@ EXPORT_SYMBOL(vm_unmap_ram);
  * @pages: an array of pointers to the pages to be mapped
  * @count: number of pages
  * @node: prefer to allocate data structures on this node
- * @prot: memory protection to use. PAGE_KERNEL for regular RAM
  *
  * If you use this function for less than VMAP_MAX_ALLOC pages, it could be
  * faster than vmap so it's good.  But if you mix long-life and short-life
_

Patches currently in -mm which might be from standby24x7@gmail.com are

mm-fix-a-warning-while-make-xmldocs.patch
