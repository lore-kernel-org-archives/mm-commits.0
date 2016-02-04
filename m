From: akpm@linux-foundation.org
Subject: + mm-memblock-remove-unnecessary-memblock_type-variable.patch
 added to -mm tree
Date: Thu, 04 Feb 2016 11:30:23 -0800
Message-ID: <56b3a6cf.OT5GUrmfEqoX/Irh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44537 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbcBDTaX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Feb 2016 14:30:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kuleshovmail@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock.c: remove unnecessary memblock_type variable
has been added to the -mm tree.  Its filename is
     mm-memblock-remove-unnecessary-memblock_type-variable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memblock-remove-unnecessary-memblock_type-variable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memblock-remove-unnecessary-memblock_type-variable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: mm/memblock.c: remove unnecessary memblock_type variable

We define struct memblock_type *type in the memblock_add_region() and
memblock_reserve_region() functions only for passing it to the
memlock_add_range() and memblock_reserve_range() functions.  Let's remove
these variables and will pass a type directly.

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN mm/memblock.c~mm-memblock-remove-unnecessary-memblock_type-variable mm/memblock.c
--- a/mm/memblock.c~mm-memblock-remove-unnecessary-memblock_type-variable
+++ a/mm/memblock.c
@@ -612,14 +612,12 @@ static int __init_memblock memblock_add_
 						int nid,
 						unsigned long flags)
 {
-	struct memblock_type *type = &memblock.memory;
-
 	memblock_dbg("memblock_add: [%#016llx-%#016llx] flags %#02lx %pF\n",
 		     (unsigned long long)base,
 		     (unsigned long long)base + size - 1,
 		     flags, (void *)_RET_IP_);
 
-	return memblock_add_range(type, base, size, nid, flags);
+	return memblock_add_range(&memblock.memory, base, size, nid, flags);
 }
 
 int __init_memblock memblock_add(phys_addr_t base, phys_addr_t size)
@@ -740,14 +738,12 @@ static int __init_memblock memblock_rese
 						   int nid,
 						   unsigned long flags)
 {
-	struct memblock_type *type = &memblock.reserved;
