From: akpm@linux-foundation.org
Subject: +
 mm-memblockc-name-the-local-variable-of-memblock_type-as-type.patch added
 to -mm tree
Date: Wed, 18 Feb 2015 12:57:56 -0800
Message-ID: <54e4fcd4.wXh+E1ybss0zXnan%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47504 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbbBRU55 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 15:57:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock.c: rename local variable of memblock_type to `type'
has been added to the -mm tree.  Its filename is
     mm-memblockc-name-the-local-variable-of-memblock_type-as-type.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memblockc-name-the-local-variable-of-memblock_type-as-type.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memblockc-name-the-local-variable-of-memblock_type-as-type.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/memblock.c: rename local variable of memblock_type to `type'

A small cleanup.  Seems in e3239ff9 ("memblock: Rename memblock_region to
memblock_type and memblock_property to memblock_region") this one was
missed.

Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memblock.c~mm-memblockc-name-the-local-variable-of-memblock_type-as-type mm/memblock.c
--- a/mm/memblock.c~mm-memblockc-name-the-local-variable-of-memblock_type-as-type
+++ a/mm/memblock.c
@@ -699,14 +699,14 @@ static int __init_memblock memblock_rese
 						   int nid,
 						   unsigned long flags)
 {
-	struct memblock_type *_rgn = &memblock.reserved;
+	struct memblock_type *type = &memblock.reserved;
 
 	memblock_dbg("memblock_reserve: [%#016llx-%#016llx] flags %#02lx %pF\n",
 		     (unsigned long long)base,
 		     (unsigned long long)base + size - 1,
 		     flags, (void *)_RET_IP_);
 
-	return memblock_add_range(_rgn, base, size, nid, flags);
+	return memblock_add_range(type, base, size, nid, flags);
 }
 
 int __init_memblock memblock_reserve(phys_addr_t base, phys_addr_t size)
_

Patches currently in -mm which might be from bhe@redhat.com are

origin.patch
mm-memblockc-name-the-local-variable-of-memblock_type-as-type.patch

