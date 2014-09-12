From: akpm@linux-foundation.org
Subject: [merged] sh-get_user_pages_fast-must-flush-cache-the-way.patch
 removed from -mm tree
Date: Fri, 12 Sep 2014 13:13:02 -0700
Message-ID: <541353ce.HKTsm0ny2Ir877O/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54671 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567AbaILUND (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 12 Sep 2014 16:13:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stsp@list.ru, geert+renesas@glider.be, kdasu.kdev@gmail.com, stsp@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     Subject: sh: get_user_pages_fast() must flush cache
has been removed from the -mm tree.  Its filename was
     sh-get_user_pages_fast-must-flush-cache-the-way.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stas Sergeev <stsp@list.ru>
Subject: sh: get_user_pages_fast() must flush cache

This patch avoids fuse hangs on sh4 by flushing the cache on
get_user_pages_fast().  This is not necessary a good thing to do, but
get_user_pages() does this, so get_user_pages_fast() should too.

Please note the patch for mips arch that addresses the similar problem:
https://kernel.googlesource.com/pub/scm/linux/kernel/git/ralf/linux/+/linux-3.4.50%5E!/#F0
They basically simply disable get_user_pages_fast() at all, using a
fall-back to get_user_pages(). But my fix is different, it adds an
explicit cache flushes.

Signed-off-by: Stas Sergeev <stsp@users.sourceforge.net>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Kamal Dasu <kdasu.kdev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/mm/gup.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/sh/mm/gup.c~sh-get_user_pages_fast-must-flush-cache-the-way arch/sh/mm/gup.c
--- a/arch/sh/mm/gup.c~sh-get_user_pages_fast-must-flush-cache-the-way
+++ a/arch/sh/mm/gup.c
@@ -105,6 +105,8 @@ static noinline int gup_pte_range(pmd_t
 		VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
 		page = pte_page(pte);
 		get_page(page);
+		__flush_anon_page(page, addr);
+		flush_dcache_page(page);
 		pages[*nr] = page;
 		(*nr)++;
 
_

Patches currently in -mm which might be from stsp@list.ru are

origin.patch

