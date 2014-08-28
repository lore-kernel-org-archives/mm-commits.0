From: akpm@linux-foundation.org
Subject: + sh-get_user_pages_fast-must-flush-cache-the-way.patch added to
 -mm tree
Date: Thu, 28 Aug 2014 15:05:26 -0700
Message-ID: <53ffa7a6.r2t9pD0VXGmps/LR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f73.google.com ([209.85.219.73]:60912 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbaH1WeM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Aug 2014 18:34:12 -0400
Received: by mail-oa0-f73.google.com with SMTP id g18so415854oah.2
        for <mm-commits@vger.kernel.org>; Thu, 28 Aug 2014 15:34:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stsp@list.ru, geert+renesas@glider.be, kdasu.kdev@gmail.com, stsp@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     Subject: sh: get_user_pages_fast() must flush cache
has been added to the -mm tree.  Its filename is
     sh-get_user_pages_fast-must-flush-cache-the-way.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sh-get_user_pages_fast-must-flush-cache-the-way.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sh-get_user_pages_fast-must-flush-cache-the-way.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

sh-get_user_pages_fast-must-flush-cache-the-way.patch

