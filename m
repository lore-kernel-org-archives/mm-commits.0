From: akpm@linux-foundation.org
Subject: [merged]
 mm-allow-page_cache_get_speculative-in-interrupt-context.patch removed from
 -mm tree
Date: Fri, 04 Aug 2017 14:18:51 -0700
Message-ID: <20170804211851.s82EPprXi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51944 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751312AbdHDVSw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Aug 2017 17:18:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axboe@fb.com, kan.liang@intel.com, kirill.shutemov@linux.intel.com, mingo@kernel.org, mm-commits@vger.kernel.org, npiggin@gmail.com, viro@zeniv.linux.org.uk, ying.huang@intel.com


The patch titled
     Subject: mm: allow page_cache_get_speculative in interrupt context
has been removed from the -mm tree.  Its filename was
     mm-allow-page_cache_get_speculative-in-interrupt-context.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kan Liang <kan.liang@intel.com>
Subject: mm: allow page_cache_get_speculative in interrupt context

Kernel panic when calling the IRQ-safe __get_user_pages_fast in NMI
handler.

The bug was introduced by 2947ba054a4d ("x86/mm/gup: Switch GUP to the
generic get_user_page_fast() implementation").

The original x86 __get_user_page_fast used plain get_page() or
page_ref_add().  However, the generic __get_user_page_fast uses
page_cache_get_speculative(), which has VM_BUG_ON(in_interrupt()).

There is no reason to prevent page_cache_get_speculative from using in
interrupt context.  According to the author, putting a BUG_ON there is
just because the code is not verifying correctness of interrupt races.  I
did some tests in interrupt context.  There is no issue found.  Removing
VM_BUG_ON(in_interrupt()) for page_cache_get_speculative().

Link: http://lkml.kernel.org/r/1501609146-59730-1-git-send-email-kan.liang@intel.com
Fixes: 2947ba054a4d ("x86/mm/gup: Switch GUP to the generic get_user_page_fast() implementation")
Signed-off-by: Kan Liang <kan.liang@intel.com>
Cc: Jens Axboe <axboe@fb.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Ying Huang <ying.huang@intel.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN include/linux/pagemap.h~mm-allow-page_cache_get_speculative-in-interrupt-context include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-allow-page_cache_get_speculative-in-interrupt-context
+++ a/include/linux/pagemap.h
@@ -163,8 +163,6 @@ void release_pages(struct page **pages,
  */
 static inline int page_cache_get_speculative(struct page *page)
 {
-	VM_BUG_ON(in_interrupt());
