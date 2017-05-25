From: akpm@linux-foundation.org
Subject: + tile-provide-default-ioremap-declaration.patch added to -mm
 tree
Date: Thu, 25 May 2017 15:41:16 -0700
Message-ID: <59275d8c.0Ul6IjJMV0wvoctN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44388 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030373AbdEYWlR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2017 18:41:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: logang@deltatee.com, cmetcalf@mellanox.com, hannes@cmpxchg.org, mgorman@techsingularity.net, mhocko@suse.com, sbates@raithlin.com, vbabka@suse.cz, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: tile: provide default ioremap declaration
has been added to the -mm tree.  Its filename is
     tile-provide-default-ioremap-declaration.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tile-provide-default-ioremap-declaration.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tile-provide-default-ioremap-declaration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

tile-provide-default-ioremap-declaration.patch

