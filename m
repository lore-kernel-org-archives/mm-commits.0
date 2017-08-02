From: akpm@linux-foundation.org
Subject: [patch 15/16] mm: allow page_cache_get_speculative in interrupt
 context
Date: Wed, 02 Aug 2017 13:32:27 -0700
Message-ID: <598236db.YiwdnPDzYQ4tGRF8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46308 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752349AbdHBUc3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2017 16:32:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kan.liang@intel.com, axboe@fb.com, kirill.shutemov@linux.intel.com, mingo@kernel.org, npiggin@gmail.com, viro@zeniv.linux.org.uk, ying.huang@intel.com

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
