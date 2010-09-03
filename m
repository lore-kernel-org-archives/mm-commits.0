From: akpm@linux-foundation.org
Subject: + kfifo-fix-scatterlist-usage.patch added to -mm tree
Date: Fri, 03 Sep 2010 16:36:45 -0700
Message-ID: <201009032336.o83NajYC019205@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35128 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753458Ab0ICXhF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Sep 2010 19:37:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: iws@ovro.caltech.edu, stefani@seibold.net


The patch titled
     kfifo: fix scatterlist usage
has been added to the -mm tree.  Its filename is
     kfifo-fix-scatterlist-usage.patch

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
Subject: kfifo: fix scatterlist usage
From: "Ira W. Snyder" <iws@ovro.caltech.edu>

The kfifo_dma family of functions use sg_mark_end() on the last element in
their scatterlist.  This forces use of a fresh scatterlist for each DMA
operation, which makes recycling a single scatterlist impossible.

Change the behavior of the kfifo_dma functions to match the usage of the
dma_map_sg function.  This means that users must respect the returned
nents value.  The sample code is updated to reflect the change.

This bug is trivial to cause: call kfifo_dma_in_prepare() such that it
prepares a scatterlist with a single entry comprising the whole fifo. 
This is the case when you map the entirety of a newly created empty fifo. 
This causes the setup_sgl() function to mark the first scatterlist entry
as the end of the chain, no matter what comes after it.

Afterwards, add and remove some data from the fifo such that another call
to kfifo_dma_in_prepare() will create two scatterlist entries.  It returns
nents=2.  However, due to the previous sg_mark_end() call, sg_is_last()
will now return true for the first scatterlist element.  This causes the
sample code to print a single scatterlist element when it should print
two.

By removing the call to sg_mark_end(), we make the API as similar as
possible to the DMA mapping API.  All users are required to respect the
returned nents.

Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
Cc: Stefani Seibold <stefani@seibold.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kfifo.c              |    2 --
 samples/kfifo/dma-example.c |   17 +++++++++--------
 2 files changed, 9 insertions(+), 10 deletions(-)

diff -puN kernel/kfifo.c~kfifo-fix-scatterlist-usage kernel/kfifo.c
--- a/kernel/kfifo.c~kfifo-fix-scatterlist-usage
+++ a/kernel/kfifo.c
@@ -365,8 +365,6 @@ static unsigned int setup_sgl(struct __k
 	n = setup_sgl_buf(sgl, fifo->data + off, nents, l);
 	n += setup_sgl_buf(sgl + n, fifo->data, nents - n, len - l);
 
-	if (n)
-		sg_mark_end(sgl + n - 1);
 	return n;
 }
 
diff -puN samples/kfifo/dma-example.c~kfifo-fix-scatterlist-usage samples/kfifo/dma-example.c
--- a/samples/kfifo/dma-example.c~kfifo-fix-scatterlist-usage
+++ a/samples/kfifo/dma-example.c
@@ -24,6 +24,7 @@ static int __init example_init(void)
 {
 	int			i;
 	unsigned int		ret;
+	unsigned int		nents;
 	struct scatterlist	sg[10];
 
 	printk(KERN_INFO "DMA fifo test start\n");
@@ -61,9 +62,9 @@ static int __init example_init(void)
 	 * byte at the beginning, after the kfifo_skip().
 	 */
 	sg_init_table(sg, ARRAY_SIZE(sg));
-	ret = kfifo_dma_in_prepare(&fifo, sg, ARRAY_SIZE(sg), FIFO_SIZE);
-	printk(KERN_INFO "DMA sgl entries: %d\n", ret);
-	if (!ret) {
+	nents = kfifo_dma_in_prepare(&fifo, sg, ARRAY_SIZE(sg), FIFO_SIZE);
+	printk(KERN_INFO "DMA sgl entries: %d\n", nents);
+	if (!nents) {
 		/* fifo is full and no sgl was created */
 		printk(KERN_WARNING "error kfifo_dma_in_prepare\n");
 		return -EIO;
@@ -71,7 +72,7 @@ static int __init example_init(void)
 
 	/* receive data */
 	printk(KERN_INFO "scatterlist for receive:\n");
-	for (i = 0; i < ARRAY_SIZE(sg); i++) {
+	for (i = 0; i < nents; i++) {
 		printk(KERN_INFO
 		"sg[%d] -> "
 		"page_link 0x%.8lx offset 0x%.8x length 0x%.8x\n",
@@ -91,16 +92,16 @@ static int __init example_init(void)
 	kfifo_dma_in_finish(&fifo, ret);
 
 	/* Prepare to transmit data, example: 8 bytes */
-	ret = kfifo_dma_out_prepare(&fifo, sg, ARRAY_SIZE(sg), 8);
-	printk(KERN_INFO "DMA sgl entries: %d\n", ret);
-	if (!ret) {
+	nents = kfifo_dma_out_prepare(&fifo, sg, ARRAY_SIZE(sg), 8);
+	printk(KERN_INFO "DMA sgl entries: %d\n", nents);
+	if (!nents) {
 		/* no data was available and no sgl was created */
 		printk(KERN_WARNING "error kfifo_dma_out_prepare\n");
 		return -EIO;
 	}
 
 	printk(KERN_INFO "scatterlist for transmit:\n");
-	for (i = 0; i < ARRAY_SIZE(sg); i++) {
+	for (i = 0; i < nents; i++) {
 		printk(KERN_INFO
 		"sg[%d] -> "
 		"page_link 0x%.8lx offset 0x%.8x length 0x%.8x\n",
_

Patches currently in -mm which might be from iws@ovro.caltech.edu are

linux-next.patch
kfifo-fix-scatterlist-usage.patch

