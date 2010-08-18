From: akpm@linux-foundation.org
Subject: + kfifo-add-explicit-error-checking-in-all-the-examples.patch added to -mm tree
Date: Wed, 18 Aug 2010 11:54:17 -0700
Message-ID: <201008181854.o7IIsHL9006101@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41314 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753744Ab0HRSzI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Aug 2010 14:55:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arighi@develer.com, stefani@seibold.net


The patch titled
     kfifo: add explicit error checking in all the examples
has been added to the -mm tree.  Its filename is
     kfifo-add-explicit-error-checking-in-all-the-examples.patch

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
Subject: kfifo: add explicit error checking in all the examples
From: Andrea Righi <arighi@develer.com>

Provide a check in all the kfifo examples to validate the correct
execution of each testcase.

Signed-off-by: Andrea Righi <arighi@develer.com>
Acked-by: Stefani Seibold <stefani@seibold.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/kfifo/bytestream-example.c |    7 +
 samples/kfifo/dma-example.c        |  110 ++++++++++++++++-----------
 samples/kfifo/inttype-example.c    |   43 ++++++++--
 samples/kfifo/record-example.c     |   39 ++++++++-
 4 files changed, 146 insertions(+), 53 deletions(-)

diff -puN samples/kfifo/bytestream-example.c~kfifo-add-explicit-error-checking-in-all-the-examples samples/kfifo/bytestream-example.c
--- a/samples/kfifo/bytestream-example.c~kfifo-add-explicit-error-checking-in-all-the-examples
+++ a/samples/kfifo/bytestream-example.c
@@ -44,7 +44,7 @@ static struct kfifo test;
 static DECLARE_KFIFO(test, unsigned char, FIFO_SIZE);
 #endif
 
-static unsigned char expected_result[FIFO_SIZE] = {
+static const unsigned char expected_result[FIFO_SIZE] = {
 	 3,  4,  5,  6,  7,  8,  9,  0,
 	 1, 20, 21, 22, 23, 24, 25, 26,
 	27, 28, 29, 30, 31, 32, 33, 34,
@@ -90,9 +90,14 @@ static int __init testfunc(void)
 
 	printk(KERN_INFO "queue len: %u\n", kfifo_len(&test));
 
+	/* show the first value without removing from the fifo */
+	if (kfifo_peek(&test, &i))
+		printk(KERN_INFO "%d\n", i);
+
 	/* check the correctness of all values in the fifo */
 	j = 0;
 	while (kfifo_get(&test, &i)) {
+		printk(KERN_INFO "item = %d\n", i);
 		if (i != expected_result[j++]) {
 			printk(KERN_WARNING "value mismatch: test failed\n");
 			return -EIO;
diff -puN samples/kfifo/dma-example.c~kfifo-add-explicit-error-checking-in-all-the-examples samples/kfifo/dma-example.c
--- a/samples/kfifo/dma-example.c~kfifo-add-explicit-error-checking-in-all-the-examples
+++ a/samples/kfifo/dma-example.c
@@ -29,8 +29,8 @@ static int __init example_init(void)
 	printk(KERN_INFO "DMA fifo test start\n");
 
 	if (kfifo_alloc(&fifo, FIFO_SIZE, GFP_KERNEL)) {
-		printk(KERN_ERR "error kfifo_alloc\n");
-		return 1;
+		printk(KERN_WARNING "error kfifo_alloc\n");
+		return -ENOMEM;
 	}
 
 	printk(KERN_INFO "queue size: %u\n", kfifo_size(&fifo));
@@ -41,65 +41,93 @@ static int __init example_init(void)
 		kfifo_put(&fifo, &i);
 
 	/* kick away first byte */
-	ret = kfifo_get(&fifo, &i);
+	kfifo_skip(&fifo);
 
 	printk(KERN_INFO "queue len: %u\n", kfifo_len(&fifo));
 
+	/*
+	 * Configure the kfifo buffer to receive data from DMA input.
+	 *
+	 *  .--------------------------------------.
+	 *  | 0 | 1 | 2 | ... | 12 | 13 | ... | 31 |
+	 *  |---|------------------|---------------|
+	 *   \_/ \________________/ \_____________/
+	 *    \          \                  \
+	 *     \          \_allocated data   \
+	 *      \_*free space*                \_*free space*
+	 *
+	 * We need two different SG entries: one for the free space area at the
+	 * end of the kfifo buffer (19 bytes) and another for the first free
+	 * byte at the beginning, after the kfifo_skip().
+	 */
 	sg_init_table(sg, ARRAY_SIZE(sg));
 	ret = kfifo_dma_in_prepare(&fifo, sg, ARRAY_SIZE(sg), FIFO_SIZE);
 	printk(KERN_INFO "DMA sgl entries: %d\n", ret);
+	if (!ret) {
+		/* fifo is full and no sgl was created */
+		printk(KERN_WARNING "error kfifo_dma_in_prepare\n");
+		return -EIO;
+	}
 
-	/* if 0 was returned, fifo is full and no sgl was created */
-	if (ret) {
-		printk(KERN_INFO "scatterlist for receive:\n");
-		for (i = 0; i < ARRAY_SIZE(sg); i++) {
-			printk(KERN_INFO
-			"sg[%d] -> "
-			"page_link 0x%.8lx offset 0x%.8x length 0x%.8x\n",
-				i, sg[i].page_link, sg[i].offset, sg[i].length);
-
-			if (sg_is_last(&sg[i]))
-				break;
-		}
+	/* receive data */
+	printk(KERN_INFO "scatterlist for receive:\n");
+	for (i = 0; i < ARRAY_SIZE(sg); i++) {
+		printk(KERN_INFO
+		"sg[%d] -> "
+		"page_link 0x%.8lx offset 0x%.8x length 0x%.8x\n",
+			i, sg[i].page_link, sg[i].offset, sg[i].length);
 
-		/* but here your code to setup and exectute the dma operation */
-		/* ... */
+		if (sg_is_last(&sg[i]))
+			break;
+	}
 
-		/* example: zero bytes received */
-		ret = 0;
+	/* put here your code to setup and exectute the dma operation */
+	/* ... */
 
-		/* finish the dma operation and update the received data */
-		kfifo_dma_in_finish(&fifo, ret);
-	}
+	/* example: zero bytes received */
+	ret = 0;
 
+	/* finish the dma operation and update the received data */
+	kfifo_dma_in_finish(&fifo, ret);
+
+	/* Prepare to transmit data, example: 8 bytes */
 	ret = kfifo_dma_out_prepare(&fifo, sg, ARRAY_SIZE(sg), 8);
 	printk(KERN_INFO "DMA sgl entries: %d\n", ret);
+	if (!ret) {
+		/* no data was available and no sgl was created */
+		printk(KERN_WARNING "error kfifo_dma_out_prepare\n");
+		return -EIO;
+	}
 
-	/* if 0 was returned, no data was available and no sgl was created */
-	if (ret) {
-		printk(KERN_INFO "scatterlist for transmit:\n");
-		for (i = 0; i < ARRAY_SIZE(sg); i++) {
-			printk(KERN_INFO
-			"sg[%d] -> "
-			"page_link 0x%.8lx offset 0x%.8x length 0x%.8x\n",
-				i, sg[i].page_link, sg[i].offset, sg[i].length);
-
-			if (sg_is_last(&sg[i]))
-				break;
-		}
+	printk(KERN_INFO "scatterlist for transmit:\n");
+	for (i = 0; i < ARRAY_SIZE(sg); i++) {
+		printk(KERN_INFO
+		"sg[%d] -> "
+		"page_link 0x%.8lx offset 0x%.8x length 0x%.8x\n",
+			i, sg[i].page_link, sg[i].offset, sg[i].length);
 
-		/* but here your code to setup and exectute the dma operation */
-		/* ... */
+		if (sg_is_last(&sg[i]))
+			break;
+	}
 
-		/* example: 5 bytes transmitted */
-		ret = 5;
+	/* put here your code to setup and exectute the dma operation */
+	/* ... */
 
-		/* finish the dma operation and update the transmitted data */
-		kfifo_dma_out_finish(&fifo, ret);
-	}
+	/* example: 5 bytes transmitted */
+	ret = 5;
+
+	/* finish the dma operation and update the transmitted data */
+	kfifo_dma_out_finish(&fifo, ret);
 
+	ret = kfifo_len(&fifo);
 	printk(KERN_INFO "queue len: %u\n", kfifo_len(&fifo));
 
+	if (ret != 7) {
+		printk(KERN_WARNING "size mismatch: test failed");
+		return -EIO;
+	}
+	printk(KERN_INFO "test passed\n");
+
 	return 0;
 }
 
diff -puN samples/kfifo/inttype-example.c~kfifo-add-explicit-error-checking-in-all-the-examples samples/kfifo/inttype-example.c
--- a/samples/kfifo/inttype-example.c~kfifo-add-explicit-error-checking-in-all-the-examples
+++ a/samples/kfifo/inttype-example.c
@@ -44,10 +44,17 @@ static DECLARE_KFIFO_PTR(test, int);
 static DEFINE_KFIFO(test, int, FIFO_SIZE);
 #endif
 
+static const int expected_result[FIFO_SIZE] = {
+	 3,  4,  5,  6,  7,  8,  9,  0,
+	 1, 20, 21, 22, 23, 24, 25, 26,
+	27, 28, 29, 30, 31, 32, 33, 34,
+	35, 36, 37, 38, 39, 40, 41, 42,
+};
+
 static int __init testfunc(void)
 {
 	int		buf[6];
-	int		i;
+	int		i, j;
 	unsigned int	ret;
 
 	printk(KERN_INFO "int fifo test start\n");
@@ -66,8 +73,13 @@ static int __init testfunc(void)
 	ret = kfifo_in(&test, buf, ret);
 	printk(KERN_INFO "ret: %d\n", ret);
 
-	for (i = 20; i != 30; i++)
-		kfifo_put(&test, &i);
+	/* skip first element of the fifo */
+	printk(KERN_INFO "skip 1st element\n");
+	kfifo_skip(&test);
+
+	/* put values into the fifo until is full */
+	for (i = 20; kfifo_put(&test, &i); i++)
+		;
 
 	printk(KERN_INFO "queue len: %u\n", kfifo_len(&test));
 
@@ -75,10 +87,20 @@ static int __init testfunc(void)
 	if (kfifo_peek(&test, &i))
 		printk(KERN_INFO "%d\n", i);
 
-	/* print out all values in the fifo */
-	while (kfifo_get(&test, &i))
-		printk("%d ", i);
-	printk("\n");
+	/* check the correctness of all values in the fifo */
+	j = 0;
+	while (kfifo_get(&test, &i)) {
+		printk(KERN_INFO "item = %d\n", i);
+		if (i != expected_result[j++]) {
+			printk(KERN_WARNING "value mismatch: test failed\n");
+			return -EIO;
+		}
+	}
+	if (j != ARRAY_SIZE(expected_result)) {
+		printk(KERN_WARNING "size mismatch: test failed\n");
+		return -EIO;
+	}
+	printk(KERN_INFO "test passed\n");
 
 	return 0;
 }
@@ -132,7 +154,12 @@ static int __init example_init(void)
 		return ret;
 	}
 #endif
-	testfunc();
+	if (testfunc() < 0) {
+#ifdef DYNAMIC
+		kfifo_free(&test);
+#endif
+		return -EIO;
+	}
 
 	if (proc_create(PROC_FIFO, 0, NULL, &fifo_fops) == NULL) {
 #ifdef DYNAMIC
diff -puN samples/kfifo/record-example.c~kfifo-add-explicit-error-checking-in-all-the-examples samples/kfifo/record-example.c
--- a/samples/kfifo/record-example.c~kfifo-add-explicit-error-checking-in-all-the-examples
+++ a/samples/kfifo/record-example.c
@@ -55,6 +55,19 @@ typedef STRUCT_KFIFO_REC_1(FIFO_SIZE) my
 static mytest test;
 #endif
 
+static const char *expected_result[] = {
+	"a",
+	"bb",
+	"ccc",
+	"dddd",
+	"eeeee",
+	"ffffff",
+	"ggggggg",
+	"hhhhhhhh",
+	"iiiiiiiii",
+	"jjjjjjjjjj",
+};
+
 static int __init testfunc(void)
 {
 	char		buf[100];
@@ -75,6 +88,10 @@ static int __init testfunc(void)
 		kfifo_in(&test, buf, i + 1);
 	}
 
+	/* skip first element of the fifo */
+	printk(KERN_INFO "skip 1st element\n");
+	kfifo_skip(&test);
+
 	printk(KERN_INFO "fifo len: %u\n", kfifo_len(&test));
 
 	/* show the first record without removing from the fifo */
@@ -82,11 +99,22 @@ static int __init testfunc(void)
 	if (ret)
 		printk(KERN_INFO "%.*s\n", ret, buf);
 
-	/* print out all records in the fifo */
+	/* check the correctness of all values in the fifo */
+	i = 0;
 	while (!kfifo_is_empty(&test)) {
 		ret = kfifo_out(&test, buf, sizeof(buf));
-		printk(KERN_INFO "%.*s\n", ret, buf);
+		buf[ret] = '\0';
+		printk(KERN_INFO "item = %.*s\n", ret, buf);
+		if (strcmp(buf, expected_result[i++])) {
+			printk(KERN_WARNING "value mismatch: test failed\n");
+			return -EIO;
+		}
+	}
+	if (i != ARRAY_SIZE(expected_result)) {
+		printk(KERN_WARNING "size mismatch: test failed\n");
+		return -EIO;
 	}
+	printk(KERN_INFO "test passed\n");
 
 	return 0;
 }
@@ -142,7 +170,12 @@ static int __init example_init(void)
 #else
 	INIT_KFIFO(test);
 #endif
-	testfunc();
+	if (testfunc() < 0) {
+#ifdef DYNAMIC
+		kfifo_free(&test);
+#endif
+		return -EIO;
+	}
 
 	if (proc_create(PROC_FIFO, 0, NULL, &fifo_fops) == NULL) {
 #ifdef DYNAMIC
_

Patches currently in -mm which might be from arighi@develer.com are

kfifo-implement-missing-__kfifo_skip_r.patch
kfifo-add-kfifo_skip-testcase.patch
kfifo-add-explicit-error-checking-in-byte-stream-example.patch
kfifo-fix-kernel-bug-in-dma-example.patch
kfifo-fix-a-memory-leak-in-dma-example.patch
kfifo-add-explicit-error-checking-in-all-the-examples.patch

