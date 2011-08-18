From: akpm@linux-foundation.org
Subject: + m68k-fix-__page_to_pfn-for-a-const-struct-page-argument.patch added to -mm tree
Date: Thu, 18 Aug 2011 14:19:05 -0700
Message-ID: <201108182119.p7ILJ5VX028207@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38727 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753989Ab1HRVTM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Aug 2011 17:19:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ian.campbell@citrix.com, geert@linux-m68k.org


The patch titled
     m68k: fix __page_to_pfn for a const struct page argument
has been added to the -mm tree.  Its filename is
     m68k-fix-__page_to_pfn-for-a-const-struct-page-argument.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m68k: fix __page_to_pfn for a const struct page argument
From: Ian Campbell <ian.campbell@citrix.com>

Fixes fallout due to the removal of the cast in
mm-fix-__page_to_pfn-for-a-const-struct-page-argument.patch

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/include/asm/page_mm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/m68k/include/asm/page_mm.h~m68k-fix-__page_to_pfn-for-a-const-struct-page-argument arch/m68k/include/asm/page_mm.h
--- a/arch/m68k/include/asm/page_mm.h~m68k-fix-__page_to_pfn-for-a-const-struct-page-argument
+++ a/arch/m68k/include/asm/page_mm.h
@@ -162,7 +162,7 @@ static inline __attribute_const__ int __
 	pgdat->node_mem_map + (__pfn - pgdat->node_start_pfn);		\
 })
 #define page_to_pfn(_page) ({						\
-	struct page *__p = (_page);					\
+	const struct page *__p = (_page);				\
 	struct pglist_data *pgdat;					\
 	pgdat = &pg_data_map[page_to_nid(__p)];				\
 	((__p) - pgdat->node_mem_map) + pgdat->node_start_pfn;		\
_

Patches currently in -mm which might be from ian.campbell@citrix.com are

origin.patch
m68k-fix-__page_to_pfn-for-a-const-struct-page-argument.patch

