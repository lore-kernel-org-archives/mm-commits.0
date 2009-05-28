From: akpm@linux-foundation.org
Subject: + dma-mapping-mark-dma_sync_single-and-dma_sync_sg-as-deprecated.patch added to -mm tree
Date: Wed, 27 May 2009 22:37:22 -0700
Message-ID: <200905280537.n4S5bMJF000863@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59771 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750870AbZE1Fhg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 May 2009 01:37:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, davem@davemloft.net, mingo@elte.hu


The patch titled
     dma-mapping: mark dma_sync_single and dma_sync_sg as deprecated
has been added to the -mm tree.  Its filename is
     dma-mapping-mark-dma_sync_single-and-dma_sync_sg-as-deprecated.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dma-mapping: mark dma_sync_single and dma_sync_sg as deprecated
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

dma_sync_single() and dma_sync_sg() have been described as "Backwards
compat, remove in 2.7.x" for a long time (since 2.6.5).

This marks dma_sync_single() and dma_sync_sg() as deprecated so the users
get notified before removing them.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/dma-mapping.h |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff -puN include/linux/dma-mapping.h~dma-mapping-mark-dma_sync_single-and-dma_sync_sg-as-deprecated include/linux/dma-mapping.h
--- a/include/linux/dma-mapping.h~dma-mapping-mark-dma_sync_single-and-dma_sync_sg-as-deprecated
+++ a/include/linux/dma-mapping.h
@@ -109,9 +109,20 @@ static inline int is_buffer_dma_capable(
 #include <asm-generic/dma-mapping-broken.h>
 #endif
 
-/* Backwards compat, remove in 2.7.x */
-#define dma_sync_single		dma_sync_single_for_cpu
-#define dma_sync_sg		dma_sync_sg_for_cpu
+/* for backwards compatibility, removed soon */
+static inline void __deprecated dma_sync_single(struct device *dev,
+						dma_addr_t addr, size_t size,
+						enum dma_data_direction dir)
+{
+	dma_sync_single_for_cpu(dev, addr, size, dir);
+}
+
+static inline void __deprecated dma_sync_sg(struct device *dev,
+					    struct scatterlist *sg, int nelems,
+					    enum dma_data_direction dir)
+{
+	dma_sync_sg_for_cpu(dev, sg, nelems, dir);
+}
 
 static inline u64 dma_get_mask(struct device *dev)
 {
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

linux-next.patch
vino-replace-dma_sync_single-with-dma_sync_single_for_cpu.patch
ib-mthca-replace-dma_sync_single-with-dma_sync_single_for_cpu.patch
net-replace-dma_sync_single-with-dma_sync_single_for_cpu.patch
sg_io-dont-perform-unneeded-copy-in-compat-code.patch
usb-replace-dma_sync_single-and-dma_sync_sg-with-dma_sync_single_for_cpu-and-dma_sync_sg_for_cpu.patch
dma-mapping-mark-dma_nbits_mask-as-deprecated.patch
dma-mapping-mark-dma_sync_single-and-dma_sync_sg-as-deprecated.patch

