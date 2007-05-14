From: akpm@linux-foundation.org
Subject: + nommu-add-ioremap_page_range.patch added to -mm tree
Date: Mon, 14 May 2007 11:52:26 -0700
Message-ID: <200705141852.l4EIqQOO023466@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58984 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753689AbXENSxB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 May 2007 14:53:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lethal@linux-sh.org, dhowells@redhat.com


The patch titled
     nommu: add ioremap_page_range()
has been added to the -mm tree.  Its filename is
     nommu-add-ioremap_page_range.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: nommu: add ioremap_page_range()
From: Paul Mundt <lethal@linux-sh.org>

lib/ioremap.c is presently only built in if CONFIG_MMU is set.  While this
is reasonable, platforms that support both CONFIG_MMU=y or n need to be
able to call in to this regardless.

As none of the current nommu platforms do anything special with ioremap(),
we assume that it's always successful.

This fixes the SH-4 build with CONFIG_MMU=n.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/io.h |    8 ++++++++
 1 files changed, 8 insertions(+)

diff -puN include/linux/io.h~nommu-add-ioremap_page_range include/linux/io.h
--- a/include/linux/io.h~nommu-add-ioremap_page_range
+++ a/include/linux/io.h
@@ -27,8 +27,16 @@ struct device;
 void __iowrite32_copy(void __iomem *to, const void *from, size_t count);
 void __iowrite64_copy(void __iomem *to, const void *from, size_t count);
 
+#ifdef CONFIG_MMU
 int ioremap_page_range(unsigned long addr, unsigned long end,
 		       unsigned long phys_addr, pgprot_t prot);
+#else
+static inline int ioremap_page_range(unsigned long addr, unsigned long end,
+				     unsigned long phys_addr, pgprot_t prot)
+{
+	return 0;
+}
+#endif
 
 /*
  * Managed iomap interface
_

Patches currently in -mm which might be from lethal@linux-sh.org are

nommu-add-ioremap_page_range.patch
git-infiniband.patch
git-sh.patch
round_up-macro-cleanup-in-arch-sh64-kernel-pci_sh5c.patch
slab-allocators-drop-support-for-destructors.patch
