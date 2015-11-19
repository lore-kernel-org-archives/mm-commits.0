From: akpm@linux-foundation.org
Subject: + lib-iomap_copy-add-__ioread32_copy.patch added to -mm tree
Date: Thu, 19 Nov 2015 12:12:14 -0800
Message-ID: <564e2d1e.+7s488zqxpwp0rUO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48700 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161183AbbKSUMP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Nov 2015 15:12:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sboyd@codeaurora.org, bjorn.andersson@sonymobile.com, dhowells@redhat.com, hauke@hauke-m.de, paul@pwsan.com, zajec5@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/iomap_copy.c: add __ioread32_copy()
has been added to the -mm tree.  Its filename is
     lib-iomap_copy-add-__ioread32_copy.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-iomap_copy-add-__ioread32_copy.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-iomap_copy-add-__ioread32_copy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Boyd <sboyd@codeaurora.org>
Subject: lib/iomap_copy.c: add __ioread32_copy()

Some drivers need to read data out of iomem areas 32-bits at a
time. Add an API to do this.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: <zajec5@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/io.h |    1 +
 lib/iomap_copy.c   |   21 +++++++++++++++++++++
 2 files changed, 22 insertions(+)

diff -puN include/linux/io.h~lib-iomap_copy-add-__ioread32_copy include/linux/io.h
--- a/include/linux/io.h~lib-iomap_copy-add-__ioread32_copy
+++ a/include/linux/io.h
@@ -29,6 +29,7 @@ struct device;
 struct resource;
 
 __visible void __iowrite32_copy(void __iomem *to, const void *from, size_t count);
+void __ioread32_copy(void *to, const void __iomem *from, size_t count);
 void __iowrite64_copy(void __iomem *to, const void *from, size_t count);
 
 #ifdef CONFIG_MMU
diff -puN lib/iomap_copy.c~lib-iomap_copy-add-__ioread32_copy lib/iomap_copy.c
--- a/lib/iomap_copy.c~lib-iomap_copy-add-__ioread32_copy
+++ a/lib/iomap_copy.c
@@ -42,6 +42,27 @@ void __attribute__((weak)) __iowrite32_c
 EXPORT_SYMBOL_GPL(__iowrite32_copy);
 
 /**
+ * __ioread32_copy - copy data from MMIO space, in 32-bit units
+ * @to: destination (must be 32-bit aligned)
+ * @from: source, in MMIO space (must be 32-bit aligned)
+ * @count: number of 32-bit quantities to copy
+ *
+ * Copy data from MMIO space to kernel space, in units of 32 bits at a
+ * time.  Order of access is not guaranteed, nor is a memory barrier
+ * performed afterwards.
+ */
+void __ioread32_copy(void *to, const void __iomem *from, size_t count)
+{
+	u32 *dst = to;
+	const u32 __iomem *src = from;
+	const u32 __iomem *end = src + count;
+
+	while (src < end)
+		*dst++ = __raw_readl(src++);
+}
+EXPORT_SYMBOL_GPL(__ioread32_copy);
+
+/**
  * __iowrite64_copy - copy data to MMIO space, in 64-bit or 32-bit units
  * @to: destination, in MMIO space (must be 64-bit aligned)
  * @from: source (must be 64-bit aligned)
_

Patches currently in -mm which might be from sboyd@codeaurora.org are

frv-io-accept-const-void-pointers-for-readbwl.patch
lib-iomap_copy-add-__ioread32_copy.patch
soc-qcom-smd-use-__ioread32_copy-instead-of-open-coding-it.patch
firmware-bcm47xx_nvram-use-__ioread32_copy-instead-of-open-coding.patch

