From: akpm@linux-foundation.org
Subject: +
 mm-memblockc-trivial-code-refine-in-memblock_is_region_memory.patch added
 to -mm tree
Date: Mon, 09 Jan 2017 15:01:45 -0800
Message-ID: <58741659.6aK9sOPt+aM9ZAwS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44604 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754352AbdAIXAS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jan 2017 18:00:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard.weiyang@gmail.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock.c: trivial code refine in memblock_is_region_memory()
has been added to the -mm tree.  Its filename is
     mm-memblockc-trivial-code-refine-in-memblock_is_region_memory.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memblockc-trivial-code-refine-in-memblock_is_region_memory.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memblockc-trivial-code-refine-in-memblock_is_region_memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/memblock.c: trivial code refine in memblock_is_region_memory()

memblock_is_region_memory() invoke memblock_search() to see whether the
base address is in the memory region. If it fails, idx would be -1. Then,
it returns 0.

If the memblock_search() returns a valid index, it means the base address
is guaranteed to be in the range memblock.memory.regions[idx]. Because of
this, it is not necessary to check the base again.

This patch removes the check on "base".

Link: http://lkml.kernel.org/r/1482363033-24754-2-git-send-email-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/memblock.c~mm-memblockc-trivial-code-refine-in-memblock_is_region_memory mm/memblock.c
--- a/mm/memblock.c~mm-memblockc-trivial-code-refine-in-memblock_is_region_memory
+++ a/mm/memblock.c
@@ -1640,8 +1640,7 @@ int __init_memblock memblock_is_region_m
 
 	if (idx == -1)
 		return 0;
-	return memblock.memory.regions[idx].base <= base &&
-		(memblock.memory.regions[idx].base +
+	return (memblock.memory.regions[idx].base +
 		 memblock.memory.regions[idx].size) >= end;
 }
 
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-memblockc-trivial-code-refine-in-memblock_is_region_memory.patch
mm-memblockc-check-return-value-of-memblock_reserve-in-memblock_virt_alloc_internal.patch

