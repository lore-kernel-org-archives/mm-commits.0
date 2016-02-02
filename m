From: akpm@linux-foundation.org
Subject: + memblock-dont-mark-memblock_phys_mem_size-as-__init.patch added to -mm tree
Date: Mon, 01 Feb 2016 21:34:51 -0800
Message-ID: <56b03ffb.QQFWERcZJnMil5fh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53981 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbcBBFex (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Feb 2016 00:34:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@gibson.dropbear.id.au, mm-commits@vger.kernel.org


The patch titled
     Subject: memblock: don't mark memblock_phys_mem_size() as __init
has been added to the -mm tree.  Its filename is
     memblock-dont-mark-memblock_phys_mem_size-as-__init.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memblock-dont-mark-memblock_phys_mem_size-as-__init.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memblock-dont-mark-memblock_phys_mem_size-as-__init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Gibson <david@gibson.dropbear.id.au>
Subject: memblock: don't mark memblock_phys_mem_size() as __init

At the moment memblock_phys_mem_size() is marked as __init, and so is
discarded after boot.  This is different from most of the memblock
functions which are marked __init_memblock, and are only discarded after
boot if memory hotplug is not configured.

To allow for upcoming code which will need memblock_phys_mem_size() in the
hotplug path, change it from __init to __init_memblock.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memblock.c~memblock-dont-mark-memblock_phys_mem_size-as-__init mm/memblock.c
--- a/mm/memblock.c~memblock-dont-mark-memblock_phys_mem_size-as-__init
+++ a/mm/memblock.c
@@ -1448,7 +1448,7 @@ void __init __memblock_free_late(phys_ad
  * Remaining API functions
  */
 
-phys_addr_t __init memblock_phys_mem_size(void)
+phys_addr_t __init_memblock memblock_phys_mem_size(void)
 {
 	return memblock.memory.total_size;
 }
_

Patches currently in -mm which might be from david@gibson.dropbear.id.au are

memblock-dont-mark-memblock_phys_mem_size-as-__init.patch

