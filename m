From: akpm@linux-foundation.org
Subject: [merged] tile-provide-default-ioremap-declaration.patch
 removed from -mm tree
Date: Fri, 07 Jul 2017 12:07:13 -0700
Message-ID: <20170707190713.DUPqI26RT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60554 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751438AbdGGTHO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2017 15:07:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cmetcalf@mellanox.com, hannes@cmpxchg.org, logang@deltatee.com, mgorman@techsingularity.net, mhocko@suse.com, mm-commits@vger.kernel.org, sbates@raithlin.com, vbabka@suse.cz, viro@ZenIV.linux.org.uk


The patch titled
     Subject: tile: provide default ioremap declaration
has been removed from the -mm tree.  Its filename was
     tile-provide-default-ioremap-declaration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Logan Gunthorpe <logang@deltatee.com>
Subject: tile: provide default ioremap declaration

Add a default ioremap function which was not provided in all
circumstances.  (Only when CONFIG_PCI and CONFIG_TILEGX was set).

I have designs to use them in scatterlist.c where they'd likely never be
called with this architecture, but it is needed to compile.  Thus, if the
function is ever hit it returns NULL.

Link: http://lkml.kernel.org/r/1495726904-27380-1-git-send-email-logang@deltatee.com
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Stephen Bates <sbates@raithlin.com>
Cc: Chris Metcalf <cmetcalf@mellanox.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/tile/mm/pgtable.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN arch/tile/mm/pgtable.c~tile-provide-default-ioremap-declaration arch/tile/mm/pgtable.c
--- a/arch/tile/mm/pgtable.c~tile-provide-default-ioremap-declaration
+++ a/arch/tile/mm/pgtable.c
@@ -503,6 +503,17 @@ void __iomem *ioremap_prot(resource_size
 }
 EXPORT_SYMBOL(ioremap_prot);
 
+#if !defined(CONFIG_PCI) || !defined(CONFIG_TILEGX)
+/* ioremap is conditionally declared in pci_gx.c */
+
+void __iomem *ioremap(resource_size_t phys_addr, unsigned long size)
+{
+	return NULL;
+}
+EXPORT_SYMBOL(ioremap);
+
+#endif
+
 /* Unmap an MMIO VA mapping. */
 void iounmap(volatile void __iomem *addr_in)
 {
_

Patches currently in -mm which might be from logang@deltatee.com are

kfifo-cleanup-example-to-not-use-page_link.patch

