From: akpm@linux-foundation.org
Subject: - nommu-add-ioremap_page_range.patch removed from -mm tree
Date: Tue, 15 May 2007 11:07:01 -0700
Message-ID: <200705151807.l4FI70Q2014136@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49842 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755102AbXEOSHP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 14:07:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lethal@linux-sh.org, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     nommu: add ioremap_page_range()
has been removed from the -mm tree.  Its filename was
     nommu-add-ioremap_page_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 8 insertions(+)

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

origin.patch
git-sh.patch
git-sh64.patch
slab-allocators-drop-support-for-destructors.patch
