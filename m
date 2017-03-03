From: akpm@linux-foundation.org
Subject: + memblock-fix-memblock_next_valid_pfn.patch added to -mm tree
Date: Fri, 03 Mar 2017 14:21:55 -0800
Message-ID: <58b9ec83.lDWR5gZU7DtDi9Dn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53550 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752296AbdCCWV4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2017 17:21:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: takahiro.akashi@linaro.org, paul.burton@imgtec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock.c: fix memblock_next_valid_pfn()
has been added to the -mm tree.  Its filename is
     memblock-fix-memblock_next_valid_pfn.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memblock-fix-memblock_next_valid_pfn.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memblock-fix-memblock_next_valid_pfn.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from takahiro.akashi@linaro.org are

memblock-fix-memblock_next_valid_pfn.patch

