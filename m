From: akpm@linux-foundation.org
Subject: + dmaengine-dmatest-add-a-maximum-number-of-test-iterations.patch added to -mm tree
Date: Mon, 20 Jul 2009 22:59:43 -0700
Message-ID: <200907210559.n6L5xh3i027554@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33781 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752261AbZGUF7u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Jul 2009 01:59:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nicolas.ferre@atmel.com, dan.j.williams@intel.com, haavard.skinnemoen@atmel.com, maciej.sosnowski@intel.com


The patch titled
     dmaengine: dmatest: add a maximum number of test iterations
has been added to the -mm tree.  Its filename is
     dmaengine-dmatest-add-a-maximum-number-of-test-iterations.patch

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
Subject: dmaengine: dmatest: add a maximum number of test iterations
From: Nicolas Ferre <nicolas.ferre@atmel.com>

The dmatest usually waits for the killing of its kthreads to stop running
tests.  This patch adds a parameter that sets a maximum number of test
iterations.

This feature is quite interesting for debugging when you set a lot of
traces in your dmaengine controller driver.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/dmatest.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff -puN drivers/dma/dmatest.c~dmaengine-dmatest-add-a-maximum-number-of-test-iterations drivers/dma/dmatest.c
--- a/drivers/dma/dmatest.c~dmaengine-dmatest-add-a-maximum-number-of-test-iterations
+++ a/drivers/dma/dmatest.c
@@ -38,6 +38,11 @@ module_param(max_channels, uint, S_IRUGO
 MODULE_PARM_DESC(max_channels,
 		"Maximum number of channels to use (default: all)");
 
+static unsigned int iteration_nbr = 0;
+module_param(iteration_nbr, uint, S_IRUGO);
+MODULE_PARM_DESC(iteration_nbr,
+		"Iteration number before stopping test (default: infinite)");
+
 static unsigned int xor_sources = 3;
 module_param(xor_sources, uint, S_IRUGO);
 MODULE_PARM_DESC(xor_sources,
@@ -270,7 +275,8 @@ static int dmatest_func(void *data)
 
 	flags = DMA_CTRL_ACK | DMA_COMPL_SKIP_DEST_UNMAP | DMA_PREP_INTERRUPT;
 
-	while (!kthread_should_stop()) {
+	while (!kthread_should_stop()
+	       && !(iteration_nbr && total_tests >= iteration_nbr)) {
 		struct dma_device *dev = chan->device;
 		struct dma_async_tx_descriptor *tx = NULL;
 		dma_addr_t dma_srcs[src_cnt];
@@ -416,6 +422,13 @@ err_srcbuf:
 err_srcs:
 	pr_notice("%s: terminating after %u tests, %u failures (status %d)\n",
 			thread_name, total_tests, failed_tests, ret);
+
+	if (iteration_nbr > 0)
+		while (!kthread_should_stop()) {
+			DECLARE_WAIT_QUEUE_HEAD(wait_dmatest_exit);
+			interruptible_sleep_on(&wait_dmatest_exit);
+		}
+
 	return ret;
 }
 
_

Patches currently in -mm which might be from nicolas.ferre@atmel.com are

linux-next.patch
dmaengine-dmatest-add-a-maximum-number-of-test-iterations.patch
dmaengine-dmatest-correct-thread_count-while-using-multiple-thread-per-channel.patch

