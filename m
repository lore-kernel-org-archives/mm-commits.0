From: akpm@linux-foundation.org
Subject: [patch 043/126] mm/sparse.c: fix typo in
 online_mem_sections
Date: Fri, 08 Sep 2017 16:13:15 -0700
Message-ID: <20170908231315.S-nLQ5w2p%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52080 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757173AbdIHXNR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Sep 2017 19:13:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, khandual@linux.vnet.ibm.com, mhocko@suse.com, mm-commits@vger.kernel.org, stable@vger.kernel.org, torvalds@linux-foundation.org, vbabka@suse.cz

From: Michal Hocko <mhocko@suse.com>
Subject: mm/sparse.c: fix typo in online_mem_sections

online_mem_sections() accidentally marks online only the first section in
the given range.  This is a typo which hasn't been noticed because I
haven't tested large 2GB blocks previously.  All users of
pfn_to_online_page would get confused on the the rest of the pfn range in
the block.

All we need to fix this is to use iterator (pfn) rather than start_pfn.

Link: http://lkml.kernel.org/r/20170904112210.3401-1-mhocko@kernel.org
Fixes: 2d070eab2e82 ("mm: consider zone which is not fully populated to have holes")
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/sparse.c~mm-sparse-fix-typo-in-online_mem_sections mm/sparse.c
--- a/mm/sparse.c~mm-sparse-fix-typo-in-online_mem_sections
+++ a/mm/sparse.c
@@ -626,7 +626,7 @@ void online_mem_sections(unsigned long s
 	unsigned long pfn;
 
 	for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
-		unsigned long section_nr = pfn_to_section_nr(start_pfn);
+		unsigned long section_nr = pfn_to_section_nr(pfn);
 		struct mem_section *ms;
 
 		/* onlining code should never touch invalid ranges */
_
