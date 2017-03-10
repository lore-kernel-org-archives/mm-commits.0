From: akpm@linux-foundation.org
Subject: [patch 18/26] mm/memblock.c: fix memblock_next_valid_pfn()
Date: Thu, 09 Mar 2017 16:17:17 -0800
Message-ID: <58c1f08d.vRhWUry7JVBm1TmH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51406 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754515AbdCJART (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Mar 2017 19:17:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, takahiro.akashi@linaro.org, paul.burton@imgtec.com

From: AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: mm/memblock.c: fix memblock_next_valid_pfn()

Obviously, we should not access memblock.memory.regions[right] if 'right'
is outside of [0..memblock.memory.cnt>.

Fixes: b92df1de5d28 ("mm: page_alloc: skip over regions of invalid pfns where possible")
Link: http://lkml.kernel.org/r/20170303023745.9104-1-takahiro.akashi@linaro.org
Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: Paul Burton <paul.burton@imgtec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/memblock.c~memblock-fix-memblock_next_valid_pfn mm/memblock.c
--- a/mm/memblock.c~memblock-fix-memblock_next_valid_pfn
+++ a/mm/memblock.c
@@ -1118,7 +1118,10 @@ unsigned long __init_memblock memblock_n
 		}
 	} while (left < right);
 
-	return min(PHYS_PFN(type->regions[right].base), max_pfn);
+	if (right == type->cnt)
+		return max_pfn;
+	else
+		return min(PHYS_PFN(type->regions[right].base), max_pfn);
 }
 
 /**
_
