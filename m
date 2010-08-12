From: akpm@linux-foundation.org
Subject: + kfifo-add-explicit-error-checking-in-byte-stream-example.patch added to -mm tree
Date: Thu, 12 Aug 2010 15:35:28 -0700
Message-ID: <201008122235.o7CMZSXF016592@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36435 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754518Ab0HLWft (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Aug 2010 18:35:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arighi@develer.com, greg@kroah.com, stefani@seibold.net


The patch titled
     kfifo: add explicit error checking in byte stream example
has been added to the -mm tree.  Its filename is
     kfifo-add-explicit-error-checking-in-byte-stream-example.patch

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
Subject: kfifo: add explicit error checking in byte stream example
From: Andrea Righi <arighi@develer.com>

Provide a static array of expected items that kfifo should contain at the
end of the test to validate it.

Signed-off-by: Andrea Righi <arighi@develer.com>
Cc: Stefani Seibold <stefani@seibold.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/kfifo/bytestream-example.c |   33 ++++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 6 deletions(-)

diff -puN samples/kfifo/bytestream-example.c~kfifo-add-explicit-error-checking-in-byte-stream-example samples/kfifo/bytestream-example.c
--- a/samples/kfifo/bytestream-example.c~kfifo-add-explicit-error-checking-in-byte-stream-example
+++ a/samples/kfifo/bytestream-example.c
@@ -44,10 +44,17 @@ static struct kfifo test;
 static DECLARE_KFIFO(test, unsigned char, FIFO_SIZE);
 #endif
 
+static unsigned char expected_result[FIFO_SIZE] = {
+	 3,  4,  5,  6,  7,  8,  9,  0,
+	 1, 20, 21, 22, 23, 24, 25, 26,
+	27, 28, 29, 30, 31, 32, 33, 34,
+	35, 36, 37, 38, 39, 40, 41, 42,
+};
+
 static int __init testfunc(void)
 {
 	unsigned char	buf[6];
-	unsigned char	i;
+	unsigned char	i, j;
 	unsigned int	ret;
 
 	printk(KERN_INFO "byte stream fifo test start\n");
@@ -83,10 +90,19 @@ static int __init testfunc(void)
 
 	printk(KERN_INFO "queue len: %u\n", kfifo_len(&test));
 
-	/* print out all values in the fifo */
-	while (kfifo_get(&test, &i))
-		printk("%d ", i);
-	printk("\n");
+	/* check the correctness of all values in the fifo */
+	j = 0;
+	while (kfifo_get(&test, &i)) {
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
@@ -142,7 +158,12 @@ static int __init example_init(void)
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

origin.patch
kfifo-implement-missing-__kfifo_skip_r.patch
kfifo-add-kfifo_skip-testcase.patch
kfifo-add-explicit-error-checking-in-byte-stream-example.patch

