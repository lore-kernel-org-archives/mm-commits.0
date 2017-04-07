From: akpm@linux-foundation.org
Subject: [patch 06/10] mm, thp: fix setting of defer+madvise thp defrag
 mode
Date: Fri, 07 Apr 2017 16:04:54 -0700
Message-ID: <58e81b16.0akq0xhtnqW0w3XQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37254 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755135AbdDGXEz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Apr 2017 19:04:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, rientjes@google.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, mhocko@suse.com, vbabka@suse.cz

From: David Rientjes <rientjes@google.com>
Subject: mm, thp: fix setting of defer+madvise thp defrag mode

Setting thp defrag mode of "defer+madvise" actually sets "defer" in the
kernel due to the name similarity and the out-of-order way the string is
checked in defrag_store().

Check the string in the correct order so that
TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG is set appropriately for
"defer+madvise".

Fixes: 21440d7eb904 ("mm, thp: add new defer+madvise defrag option")
Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1704051814420.137626@chino.kir.corp.google.com
Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/huge_memory.c~mm-thp-fix-setting-of-defermadvise-thp-defrag-mode mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-fix-setting-of-defermadvise-thp-defrag-mode
+++ a/mm/huge_memory.c
@@ -240,18 +240,18 @@ static ssize_t defrag_store(struct kobje
 		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG, &transparent_hugepage_flags);
 		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG, &transparent_hugepage_flags);
 		set_bit(TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG, &transparent_hugepage_flags);
-	} else if (!memcmp("defer", buf,
-		    min(sizeof("defer")-1, count))) {
-		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG, &transparent_hugepage_flags);
-		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG, &transparent_hugepage_flags);
-		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG, &transparent_hugepage_flags);
-		set_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_FLAG, &transparent_hugepage_flags);
 	} else if (!memcmp("defer+madvise", buf,
 		    min(sizeof("defer+madvise")-1, count))) {
 		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG, &transparent_hugepage_flags);
 		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_FLAG, &transparent_hugepage_flags);
 		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG, &transparent_hugepage_flags);
 		set_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG, &transparent_hugepage_flags);
+	} else if (!memcmp("defer", buf,
+		    min(sizeof("defer")-1, count))) {
+		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG, &transparent_hugepage_flags);
+		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG, &transparent_hugepage_flags);
+		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG, &transparent_hugepage_flags);
+		set_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_FLAG, &transparent_hugepage_flags);
 	} else if (!memcmp("madvise", buf,
 			   min(sizeof("madvise")-1, count))) {
 		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG, &transparent_hugepage_flags);
_
