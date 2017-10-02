From: akpm@linux-foundation.org
Subject: + of-provide-of_n_addrsize_cells-wrappers-for-config_of.patch
 added to -mm tree
Date: Mon, 02 Oct 2017 15:57:33 -0700
Message-ID: <59d2c45d.nqZjEIlDxsp9SNRc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45108 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751181AbdJBW5e (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 2 Oct 2017 18:57:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, ben.dooks@codethink.co.uk, bhelgaas@google.com, damm@opensource.se, frank.rowand@sony.com, geert+renesas@glider.be, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/of.h: provide of_n_{addr,size}_cells wrappers for !CONFIG_OF
has been added to the -mm tree.  Its filename is
     of-provide-of_n_addrsize_cells-wrappers-for-config_of.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/of-provide-of_n_addrsize_cells-wrappers-for-config_of.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/of-provide-of_n_addrsize_cells-wrappers-for-config_of.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: include/linux/of.h: provide of_n_{addr,size}_cells wrappers for !CONFIG_OF

The pci-rcar driver is enabled for compile tests, and this has shown that
the driver cannot build without CONFIG_OF, following the inclusion of
f8f2fe7355fb "PCI: rcar: Use new OF interrupt mapping when possible":

drivers/pci/host/pcie-rcar.c: In function 'pci_dma_range_parser_init':
drivers/pci/host/pcie-rcar.c:1039:2: error: implicit declaration of function 'of_n_addr_cells' [-Werror=implicit-function-declaration]
  parser->pna = of_n_addr_cells(node);
  ^

As pointed out by Ben Dooks and Geert Uytterhoeven, this is actually
supposed to build fine, which we can achieve if we make the declaration of
of_irq_parse_and_map_pci conditional on CONFIG_OF and provide an empty
inline function otherwise, as we do for a lot of other of interfaces.

This lets us build the rcar_pci driver again without CONFIG_OF for build
testing.  All platforms using this driver select OF, so this doesn't
change anything for the users.

Link: http://lkml.kernel.org/r/20170911200805.3363318-1-arnd@arndb.de
Fixes: c25da4778803 ("PCI: rcar: Add Renesas R-Car PCIe driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Frank Rowand <frank.rowand@sony.com>
Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Magnus Damm <damm@opensource.se>
Cc: Ben Dooks <ben.dooks@codethink.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/of.h |    3 +++
 1 file changed, 3 insertions(+)

diff -puN include/linux/of.h~of-provide-of_n_addrsize_cells-wrappers-for-config_of include/linux/of.h
--- a/include/linux/of.h~of-provide-of_n_addrsize_cells-wrappers-for-config_of
+++ a/include/linux/of.h
@@ -734,6 +734,9 @@ static inline struct device_node *of_get
 	return NULL;
 }
 
+static inline int of_n_addr_cells(struct device_node *np) { return 0; }
+static inline int of_n_size_cells(struct device_node *np) { return 0; }
+
 static inline int of_property_read_u64(const struct device_node *np,
 				       const char *propname, u64 *out_value)
 {
_

Patches currently in -mm which might be from arnd@arndb.de are

mm-meminit-mark-init_reserved_page-as-__meminit.patch
of-provide-of_n_addrsize_cells-wrappers-for-config_of.patch
iopoll-avoid-wint-in-bool-context-warning.patch
pcmcia-badge4-avoid-unused-function-warning.patch

