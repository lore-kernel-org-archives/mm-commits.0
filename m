From: akpm@linux-foundation.org
Subject: +
 memblock-memhotplug-fix-wrong-type-in-memblock_find_in_range_node.patch
 added to -mm tree
Date: Tue, 12 Aug 2014 15:02:08 -0700
Message-ID: <53ea8ee0.8aFNMkd9kLwf12fJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f74.google.com ([209.85.218.74]:58282 "EHLO
	mail-oi0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbaHLWCJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 18:02:09 -0400
Received: by mail-oi0-f74.google.com with SMTP id a141so1955952oig.5
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 15:02:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tangchen@cn.fujitsu.com, qiuxishi@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memblock, memhotplug: Fix wrong type in memblock_find_in_range_node().
has been added to the -mm tree.  Its filename is
     memblock-memhotplug-fix-wrong-type-in-memblock_find_in_range_node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memblock-memhotplug-fix-wrong-type-in-memblock_find_in_range_node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memblock-memhotplug-fix-wrong-type-in-memblock_find_in_range_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: memblock, memhotplug: Fix wrong type in memblock_find_in_range_node().

In memblock_find_in_range_node(), we defined ret as int.  But it should be
phys_addr_t because it is used to store the return value from
__memblock_find_range_bottom_up().

The bug has not been triggered because when allocating low memory near the
kernel end, the "int ret" won't turn out to be negative.  When we started
to allocate memory on other nodes, and the "int ret" could be minus.  Then
the kernel will panic.

A simple way to reproduce this: comment out the following code in numa_init(),

        memblock_set_bottom_up(false);

and the kernel won't boot.

Reported-by: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/memblock.c~memblock-memhotplug-fix-wrong-type-in-memblock_find_in_range_node mm/memblock.c
--- a/mm/memblock.c~memblock-memhotplug-fix-wrong-type-in-memblock_find_in_range_node
+++ a/mm/memblock.c
@@ -192,8 +192,7 @@ phys_addr_t __init_memblock memblock_fin
 					phys_addr_t align, phys_addr_t start,
 					phys_addr_t end, int nid)
 {
-	int ret;
-	phys_addr_t kernel_end;
+	phys_addr_t kernel_end, ret;
 
 	/* pump up @end */
 	if (end == MEMBLOCK_ALLOC_ACCESSIBLE)
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

origin.patch
memblock-memhotplug-fix-wrong-type-in-memblock_find_in_range_node.patch
x86mem-hotplug-pass-sync_global_pgds-a-correct-argument-in-remove_pagetable.patch
x86mem-hotplug-modify-pgd-entry-when-removing-memory.patch
linux-next.patch

