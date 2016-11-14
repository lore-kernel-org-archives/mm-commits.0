From: akpm@linux-foundation.org
Subject: [merged]
 mm-frontswap-make-sure-allocated-frontswap-map-is-assigned.patch removed
 from -mm tree
Date: Mon, 14 Nov 2016 12:02:30 -0800
Message-ID: <582a1856.q923LiKn1cI5Df59%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37860 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933969AbcKNUCb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Nov 2016 15:02:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, boris.ostrovsky@oracle.com, borntraeger@de.ibm.com, david.vrabel@citrix.com, jgross@suse.com, kirill.shutemov@linux.intel.com, konrad.wilk@oracle.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, frontswap: make sure allocated frontswap map is assigned
has been removed from the -mm tree.  Its filename was
     mm-frontswap-make-sure-allocated-frontswap-map-is-assigned.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, frontswap: make sure allocated frontswap map is assigned

Christian Borntraeger reports:

with commit 8ea1d2a1985a7ae096e ("mm, frontswap: convert frontswap_enabled
to static key") kmemleak complains about a memory leak in swapon

unreferenced object 0x3e09ba56000 (size 32112640):
  comm "swapon", pid 7852, jiffies 4294968787 (age 1490.770s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000003a2504>] __vmalloc_node_range+0x194/0x2d8
    [<00000000003a2918>] vzalloc+0x58/0x68
    [<00000000003b0af0>] SyS_swapon+0xd60/0x12f8
    [<0000000000a3dc2e>] system_call+0xd6/0x270
    [<ffffffffffffffff>] 0xffffffffffffffff

Turns out kmemleak is right. We now allocate the frontswap map depending on the
kernel config (and no longer on the enablement)

swapfile.c:
[...]
      if (IS_ENABLED(CONFIG_FRONTSWAP))
                frontswap_map = vzalloc(BITS_TO_LONGS(maxpages) * sizeof(long));

but later on this is passed along
--> enable_swap_info(p, prio, swap_map, cluster_info, frontswap_map);

and ignored if frontswap is disabled
--> frontswap_init(p->type, frontswap_map);
static inline void frontswap_init(unsigned type, unsigned long *map)
{
        if (frontswap_enabled())
                __frontswap_init(type, map);
}

Thing is, that frontswap map is never freed.

===

The leakage is relatively not that bad, because swapon is an infrequent
and privileged operation.  However, if the first frontswap backend is
registered after a swap type has been already enabled, it will WARN_ON in
frontswap_register_ops() and frontswap will not be available for the swap
type.

Fix this by making sure the map is assigned by frontswap_init() as long as
CONFIG_FRONTSWAP is enabled.

Fixes: 8ea1d2a1985a ("mm, frontswap: convert frontswap_enabled to static key")
Link: http://lkml.kernel.org/r/20161026134220.2566-1-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/frontswap.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN include/linux/frontswap.h~mm-frontswap-make-sure-allocated-frontswap-map-is-assigned include/linux/frontswap.h
--- a/include/linux/frontswap.h~mm-frontswap-make-sure-allocated-frontswap-map-is-assigned
+++ a/include/linux/frontswap.h
@@ -106,8 +106,9 @@ static inline void frontswap_invalidate_
 
 static inline void frontswap_init(unsigned type, unsigned long *map)
 {
-	if (frontswap_enabled())
-		__frontswap_init(type, map);
+#ifdef CONFIG_FRONTSWAP
+	__frontswap_init(type, map);
+#endif
 }
 
 #endif /* _LINUX_FRONTSWAP_H */
_

Patches currently in -mm which might be from vbabka@suse.cz are


