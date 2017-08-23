From: akpm@linux-foundation.org
Subject: + mm-reversed-logic-in-memblock_discard.patch added to -mm tree
Date: Wed, 23 Aug 2017 14:58:22 -0700
Message-ID: <599dfa7e.ObzMGoWDwO7pTJ3D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44092 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750715AbdHWV6X (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Aug 2017 17:58:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pasha.tatashin@oracle.com, mhocko@kernel.org, terraluna977@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock.c: reversed logic in memblock_discard()
has been added to the -mm tree.  Its filename is
     mm-reversed-logic-in-memblock_discard.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-reversed-logic-in-memblock_discard.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-reversed-logic-in-memblock_discard.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pavel Tatashin <pasha.tatashin@oracle.com>
Subject: mm/memblock.c: reversed logic in memblock_discard()

In recently introduced memblock_discard() there is a reversed logic bug. 
Memory is freed of static array instead of dynamically allocated one.

Link: http://lkml.kernel.org/r/1503511441-95478-2-git-send-email-pasha.tatashin@oracle.com
Fixes: 3010f876500f ("mm: discard memblock data later")
Signed-off-by: Pavel Tatashin <pasha.tatashin@oracle.com>
Reported-by: Woody Suwalski <terraluna977@gmail.com>
Tested-by: Woody Suwalski <terraluna977@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memblock.c~mm-reversed-logic-in-memblock_discard mm/memblock.c
--- a/mm/memblock.c~mm-reversed-logic-in-memblock_discard
+++ a/mm/memblock.c
@@ -299,7 +299,7 @@ void __init memblock_discard(void)
 		__memblock_free_late(addr, size);
 	}
 
-	if (memblock.memory.regions == memblock_memory_init_regions) {
+	if (memblock.memory.regions != memblock_memory_init_regions) {
 		addr = __pa(memblock.memory.regions);
 		size = PAGE_ALIGN(sizeof(struct memblock_region) *
 				  memblock.memory.max);
_

Patches currently in -mm which might be from pasha.tatashin@oracle.com are

mm-reversed-logic-in-memblock_discard.patch
sparc64-ng4-memset-32-bits-overflow.patch

