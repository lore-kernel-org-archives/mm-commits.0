From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 19/32] mm/vmalloc.c: fix a warning while make
 xmldocs
Date: Thu, 25 Jun 2020 20:30:13 -0700
Message-ID: <20200626033013.D6C0fBR1l%akpm@linux-foundation.org>
References: <20200625202807.b630829d6fa55388148bee7d@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728333AbgFZDaO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Jun 2020 23:30:14 -0400
In-Reply-To: <20200625202807.b630829d6fa55388148bee7d@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, standby24x7@gmail.com, torvalds@linux-foundation.org

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
