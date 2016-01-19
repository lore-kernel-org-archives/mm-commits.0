From: akpm@linux-foundation.org
Subject: + mm-avoid-uninitialized-variable-in-tracepoint.patch added to
 -mm tree
Date: Tue, 19 Jan 2016 14:38:17 -0800
Message-ID: <569ebad9.o/fU6zROatGyMZB2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52471 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932702AbcASWiS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 17:38:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, ebru.akagunduz@gmail.com, kirill.shutemov@linux.intel.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: avoid uninitialized variable in tracepoint
has been added to the -mm tree.  Its filename is
     mm-avoid-uninitialized-variable-in-tracepoint.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-avoid-uninitialized-variable-in-tracepoint.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-avoid-uninitialized-variable-in-tracepoint.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm: avoid uninitialized variable in tracepoint

A newly added tracepoint in the hugepage code uses a variable in the error
handling that is not initialized at that point:

include/trace/events/huge_memory.h:81:230: error: 'isolated' may be used uninitialized in this function [-Werror=maybe-uninitialized]

The result is relatively harmless, as the trace data will in rare cases
contain incorrect data.

This works around the problem by adding an explicit initialization.

Fixes: 7d2eba0557c1 ("mm: add tracepoint for scanning pages")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Cc: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/huge_memory.c~mm-avoid-uninitialized-variable-in-tracepoint mm/huge_memory.c
--- a/mm/huge_memory.c~mm-avoid-uninitialized-variable-in-tracepoint
+++ a/mm/huge_memory.c
@@ -2324,7 +2324,7 @@ static void collapse_huge_page(struct mm
 	pgtable_t pgtable;
 	struct page *new_page;
 	spinlock_t *pmd_ptl, *pte_ptl;
-	int isolated, result = 0;
+	int isolated = 0, result = 0;
 	unsigned long hstart, hend;
 	struct mem_cgroup *memcg;
 	unsigned long mmun_start;	/* For mmu_notifiers */
_

Patches currently in -mm which might be from arnd@arndb.de are

mm-avoid-uninitialized-variable-in-tracepoint.patch
printk-nmi-generic-solution-for-safe-printk-in-nmi-v4-fix.patch
memstick-use-sector_div-instead-of-do_div.patch
mm-memcontrol-introduce-config_memcg_legacy_kmem-fix.patch
mm-memcontrol-clean-up-alloc-online-offline-free-functions-fix-2.patch

