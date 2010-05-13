From: akpm@linux-foundation.org
Subject: + kfifo-add-example-files-to-the-kernel-sample-directory.patch added to -mm tree
Date: Thu, 13 May 2010 14:35:31 -0700
Message-ID: <201005132135.o4DLZWNB021637@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60224 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755874Ab0EMVgP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 May 2010 17:36:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stefani@seibold.net, greg@kroah.com


The patch titled
     kfifo: add example files to the kernel sample directory
has been added to the -mm tree.  Its filename is
     kfifo-add-example-files-to-the-kernel-sample-directory.patch

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
Subject: kfifo: add example files to the kernel sample directory
From: Stefani Seibold <stefani@seibold.net>

Add four examples to the kernel sample directory.

It shows how to handle:
- a byte stream fifo
- a integer type fifo
- a dynamic record sized fifo
- the fifo DMA functions

Signed-off-by: Stefani Seibold <stefani@seibold.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/Kconfig                    |   10 +
 samples/Makefile                   |    2 
 samples/kfifo/Makefile             |    1 
 samples/kfifo/bytestream-example.c |  163 ++++++++++++++++++++++++++
 samples/kfifo/dma-example.c        |  115 ++++++++++++++++++
 samples/kfifo/inttype-example.c    |  157 +++++++++++++++++++++++++
 samples/kfifo/record-example.c     |  167 +++++++++++++++++++++++++++
 7 files changed, 614 insertions(+), 1 deletion(-)

diff -puN samples/Kconfig~kfifo-add-example-files-to-the-kernel-sample-directory samples/Kconfig
--- a/samples/Kconfig~kfifo-add-example-files-to-the-kernel-sample-directory
+++ a/samples/Kconfig
@@ -44,4 +44,14 @@ config SAMPLE_HW_BREAKPOINT
 	help
 	  This builds kernel hardware breakpoint example modules.
 
+config SAMPLE_KFIFO
+	tristate "Build kfifo examples -- loadable modules only"
+	depends on m
+	help
+	  This config option will allow you to build a number of
+	  different kfifo sample modules showing how to use the
+	  generic kfifo API.
+
+	  If in doubt, say "N" here.
+
 endif # SAMPLES
diff -puN samples/Makefile~kfifo-add-example-files-to-the-kernel-sample-directory samples/Makefile
--- a/samples/Makefile~kfifo-add-example-files-to-the-kernel-sample-directory
+++ a/samples/Makefile
@@ -1,4 +1,4 @@
 # Makefile for Linux samples code
 
 obj-$(CONFIG_SAMPLES)	+= kobject/ kprobes/ tracepoints/ trace_events/ \
-			   hw_breakpoint/
+			   hw_breakpoint/ kfifo/
diff -puN /dev/null samples/kfifo/Makefile
--- /dev/null
+++ a/samples/kfifo/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_SAMPLE_KFIFO) += bytestream-example.o dma-example.o inttype-example.o record-example.o
diff -puN /dev/null samples/kfifo/bytestream-example.c
--- /dev/null
+++ a/samples/kfifo/bytestream-example.c
@@ -0,0 +1,163 @@
+/*
+ * Sample kfifo byte stream implementation
+ *
+ * Copyright (C) 2010 Stefani Seibold <stefani@seibold.net>
+ *
+ * Released under the GPL version 2 only.
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/proc_fs.h>
+#include <linux/mutex.h>
+#include <linux/kfifo.h>
+
+/*
+ * This module shows how to create a byte stream fifo.
+ */
+
+/* fifo size in elements (bytes) */
+#define FIFO_SIZE	32
+
+/* name of the proc entry */
+#define	PROC_FIFO	"bytestream-fifo"
+
+/* lock for procfs read access */
+static DEFINE_MUTEX(read_lock);
+
+/* lock for procfs write access */
+static DEFINE_MUTEX(write_lock);
+
+/*
+ * define DYNAMIC in this example for a dynamically allocated fifo.
+ *
+ * Otherwise the fifo storage will be a part of the fifo structure.
+ */
+#if 0
+#define DYNAMIC
+#endif
+
+#ifdef DYNAMIC
+static struct kfifo test;
+#else
+static DECLARE_KFIFO(test, unsigned char, FIFO_SIZE);
+#endif
+
+static int __init testfunc(void)
+{
+	unsigned char	buf[6];
+	unsigned char	i;
+	unsigned int	ret;
+
+	printk(KERN_INFO "byte stream fifo test start\n");
+
+	/* put string into the fifo */
+	kfifo_in(&test, "hello", 5);
+
+	/* put values into the fifo */
+	for (i = 0; i != 10; i++)
+		kfifo_put(&test, &i);
+
+	/* show the number of used elements */
+	printk(KERN_INFO "fifo len: %u\n", kfifo_len(&test));
+
+	/* get max of 5 bytes from the fifo */
+	i = kfifo_out(&test, buf, 5);
+	printk(KERN_INFO "buf: %.*s\n", i, buf);
+
+	/* get max of 2 elements from the fifo */
+	ret = kfifo_out(&test, buf, 2);
+	printk(KERN_INFO "ret: %d\n", ret);
+	/* and put it back to the end of the fifo */
+	ret = kfifo_in(&test, buf, ret);
+	printk(KERN_INFO "ret: %d\n", ret);
+
+	/* put values into the fifo until is full */
+	for (i = 20; kfifo_put(&test, &i); i++)
+		;
+
+	printk(KERN_INFO "queue len: %u\n", kfifo_len(&test));
+
+	/* print out all values in the fifo */
+	while (kfifo_get(&test, &i))
+		printk("%d ", i);
+	printk("\n");
+
+	return 0;
+}
+
+static ssize_t fifo_write(struct file *file, const char __user *buf,
+						size_t count, loff_t *ppos)
+{
+	int ret;
+	unsigned int copied;
+
+	if (mutex_lock_interruptible(&write_lock))
+		return -ERESTARTSYS;
+
+	ret = kfifo_from_user(&test, buf, count, &copied);
+
+	mutex_unlock(&write_lock);
+
+	return ret ? ret : copied;
+}
+
+static ssize_t fifo_read(struct file *file, char __user *buf,
+						size_t count, loff_t *ppos)
+{
+	int ret;
+	unsigned int copied;
+
+	if (mutex_lock_interruptible(&read_lock))
+		return -ERESTARTSYS;
+
+	ret = kfifo_to_user(&test, buf, count, &copied);
+
+	mutex_unlock(&read_lock);
+
+	return ret ? ret : copied;
+}
+
+static const struct file_operations fifo_fops = {
+	.owner		= THIS_MODULE,
+	.read		= fifo_read,
+	.write		= fifo_write,
+};
+
+static int __init example_init(void)
+{
+#ifdef DYNAMIC
+	int ret;
+
+	ret = kfifo_alloc(&test, FIFO_SIZE, GFP_KERNEL);
+	if (ret) {
+		printk(KERN_ERR "error kfifo_alloc\n");
+		return ret;
+	}
+#else
+	INIT_KFIFO(test);
+#endif
+	testfunc();
+
+	if (proc_create(PROC_FIFO, 0, NULL, &fifo_fops) == NULL) {
+#ifdef DYNAMIC
+		kfifo_free(&test);
+#endif
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+static void __exit example_exit(void)
+{
+	remove_proc_entry(PROC_FIFO, NULL);
+#ifdef DYNAMIC
+	kfifo_free(&test);
+#endif
+}
+
+module_init(example_init);
+module_exit(example_exit);
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Stefani Seibold <stefani@seibold.net>");
diff -puN /dev/null samples/kfifo/dma-example.c
--- /dev/null
+++ a/samples/kfifo/dma-example.c
@@ -0,0 +1,115 @@
+/*
+ * Sample fifo dma implementation
+ *
+ * Copyright (C) 2010 Stefani Seibold <stefani@seibold.net>
+ *
+ * Released under the GPL version 2 only.
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/kfifo.h>
+
+/*
+ * This module shows how to handle fifo dma operations.
+ */
+
+/* fifo size in elements (bytes) */
+#define FIFO_SIZE	32
+
+static struct kfifo fifo;
+
+static int __init example_init(void)
+{
+	int 			i;
+	unsigned int 		ret;
+	struct scatterlist	sg[10];
+
+	printk(KERN_INFO "DMA fifo test start\n");
+
+	if (kfifo_alloc(&fifo, FIFO_SIZE, GFP_KERNEL)) {
+		printk(KERN_ERR "error kfifo_alloc\n");
+		return 1;
+	}
+
+	printk(KERN_INFO "queue size: %u\n", kfifo_size(&fifo));
+
+	kfifo_in(&fifo, "test", 4);
+
+	for (i = 0; i != 9; i++)
+		kfifo_put(&fifo, &i);
+
+	/* kick away first byte */
+	ret = kfifo_get(&fifo, &i);
+
+	printk(KERN_INFO "queue len: %u\n", kfifo_len(&fifo));
+
+	ret = kfifo_dma_in_prepare(&fifo, sg, ARRAY_SIZE(sg), FIFO_SIZE);
+	printk(KERN_INFO "DMA sgl entries: %d\n", ret);
+
+	/* if 0 was returned, fifo is full and no sgl was created */
+	if (ret) {
+		printk(KERN_INFO "scatterlist for receive:\n");
+		for (i = 0; i < ARRAY_SIZE(sg); i++) {
+			printk(KERN_INFO
+			"sg[%d] -> "
+			"page_link 0x%.8lx offset 0x%.8x length 0x%.8x\n",
+				i, sg[i].page_link, sg[i].offset, sg[i].length);
+
+			if (sg_is_last(&sg[i]))
+				break;
+		}
+
+		/* but here your code to setup and exectute the dma operation */
+		/* ... */
+
+		/* example: zero bytes received */
+		ret = 0;
+
+		/* finish the dma operation and update the received data */
+		kfifo_dma_in_finish(&fifo, ret);
+	}
+
+	ret = kfifo_dma_out_prepare(&fifo, sg, ARRAY_SIZE(sg), 8);
+	printk(KERN_INFO "DMA sgl entries: %d\n", ret);
+
+	/* if 0 was returned, no data was available and no sgl was created */
+	if (ret) {
+		printk(KERN_INFO "scatterlist for transmit:\n");
+		for (i = 0; i < ARRAY_SIZE(sg); i++) {
+			printk(KERN_INFO
+			"sg[%d] -> "
+			"page_link 0x%.8lx offset 0x%.8x length 0x%.8x\n",
+				i, sg[i].page_link, sg[i].offset, sg[i].length);
+
+			if (sg_is_last(&sg[i]))
+				break;
+		}
+
+		/* but here your code to setup and exectute the dma operation */
+		/* ... */
+
+		/* example: 5 bytes transmitted */
+		ret = 5;
+
+		/* finish the dma operation and update the transmitted data */
+		kfifo_dma_out_finish(&fifo, ret);
+	}
+
+	printk(KERN_INFO "queue len: %u\n", kfifo_len(&fifo));
+
+	return 0;
+}
+
+static void __exit example_exit(void)
+{
+#ifdef DYNAMIC
+	kfifo_free(&test);
+#endif
+}
+
+module_init(example_init);
+module_exit(example_exit);
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Stefani Seibold <stefani@seibold.net>");
diff -puN /dev/null samples/kfifo/inttype-example.c
--- /dev/null
+++ a/samples/kfifo/inttype-example.c
@@ -0,0 +1,157 @@
+/*
+ * Sample kfifo int type implementation
+ *
+ * Copyright (C) 2010 Stefani Seibold <stefani@seibold.net>
+ *
+ * Released under the GPL version 2 only.
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/proc_fs.h>
+#include <linux/mutex.h>
+#include <linux/kfifo.h>
+
+/*
+ * This module shows how to create a int type fifo.
+ */
+
+/* fifo size in elements (ints) */
+#define FIFO_SIZE	32
+
+/* name of the proc entry */
+#define	PROC_FIFO	"int-fifo"
+
+/* lock for procfs read access */
+static DEFINE_MUTEX(read_lock);
+
+/* lock for procfs write access */
+static DEFINE_MUTEX(write_lock);
+
+/*
+ * define DYNAMIC in this example for a dynamically allocated fifo.
+ *
+ * Otherwise the fifo storage will be a part of the fifo structure.
+ */
+#if 0
+#define DYNAMIC
+#endif
+
+#ifdef DYNAMIC
+static DECLARE_KFIFO_PTR(test, int);
+#else
+static DEFINE_KFIFO(test, int, FIFO_SIZE);
+#endif
+
+static int __init testfunc(void)
+{
+	int		buf[6];
+	int		i;
+	unsigned int	ret;
+
+	printk(KERN_INFO "int fifo test start\n");
+
+	/* put values into the fifo */
+	for (i = 0; i != 10; i++)
+		kfifo_put(&test, &i);
+
+	/* show the number of used elements */
+	printk(KERN_INFO "fifo len: %u\n", kfifo_len(&test));
+
+	/* get max of 2 elements from the fifo */
+	ret = kfifo_out(&test, buf, 2);
+	printk(KERN_INFO "ret: %d\n", ret);
+	/* and put it back to the end of the fifo */
+	ret = kfifo_in(&test, buf, ret);
+	printk(KERN_INFO "ret: %d\n", ret);
+
+	for (i = 20; i != 30; i++)
+		kfifo_put(&test, &i);
+
+	printk(KERN_INFO "queue len: %u\n", kfifo_len(&test));
+
+	/* show the first value without removing from the fifo */
+	if (kfifo_peek(&test, &i))
+		printk(KERN_INFO "%d\n", i);
+
+	/* print out all values in the fifo */
+	while (kfifo_get(&test, &i))
+		printk("%d ", i);
+	printk("\n");
+
+	return 0;
+}
+
+static ssize_t fifo_write(struct file *file, const char __user *buf,
+						size_t count, loff_t *ppos)
+{
+	int ret;
+	unsigned int copied;
+
+	if (mutex_lock_interruptible(&write_lock))
+		return -ERESTARTSYS;
+
+	ret = kfifo_from_user(&test, buf, count, &copied);
+
+	mutex_unlock(&write_lock);
+
+	return ret ? ret : copied;
+}
+
+static ssize_t fifo_read(struct file *file, char __user *buf,
+						size_t count, loff_t *ppos)
+{
+	int ret;
+	unsigned int copied;
+
+	if (mutex_lock_interruptible(&read_lock))
+		return -ERESTARTSYS;
+
+	ret = kfifo_to_user(&test, buf, count, &copied);
+
+	mutex_unlock(&read_lock);
+
+	return ret ? ret : copied;
+}
+
+static const struct file_operations fifo_fops = {
+	.owner		= THIS_MODULE,
+	.read		= fifo_read,
+	.write		= fifo_write,
+};
+
+static int __init example_init(void)
+{
+#ifdef DYNAMIC
+	int ret;
+
+	ret = kfifo_alloc(&test, FIFO_SIZE, GFP_KERNEL);
+	if (ret) {
+		printk(KERN_ERR "error kfifo_alloc\n");
+		return ret;
+	}
+#endif
+	testfunc();
+
+	if (proc_create(PROC_FIFO, 0, NULL, &fifo_fops) == NULL) {
+#ifdef DYNAMIC
+		kfifo_free(&test);
+#endif
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+static void __exit example_exit(void)
+{
+	remove_proc_entry(PROC_FIFO, NULL);
+#ifdef DYNAMIC
+	kfifo_free(&test);
+#endif
+}
+
+module_init(example_init);
+module_exit(example_exit);
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Stefani Seibold <stefani@seibold.net>");
diff -puN /dev/null samples/kfifo/record-example.c
--- /dev/null
+++ a/samples/kfifo/record-example.c
@@ -0,0 +1,167 @@
+/*
+ * Sample dynamic sized record fifo implementation
+ *
+ * Copyright (C) 2010 Stefani Seibold <stefani@seibold.net>
+ *
+ * Released under the GPL version 2 only.
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/proc_fs.h>
+#include <linux/mutex.h>
+#include <linux/kfifo.h>
+
+/*
+ * This module shows how to create a variable sized record fifo.
+ */
+
+/* fifo size in elements (bytes) */
+#define FIFO_SIZE	128
+
+/* name of the proc entry */
+#define	PROC_FIFO	"record-fifo"
+
+/* lock for procfs read access */
+static DEFINE_MUTEX(read_lock);
+
+/* lock for procfs write access */
+static DEFINE_MUTEX(write_lock);
+
+/*
+ * define DYNAMIC in this example for a dynamically allocated fifo.
+ *
+ * Otherwise the fifo storage will be a part of the fifo structure.
+ */
+#if 0
+#define DYNAMIC
+#endif
+
+/*
+ * struct kfifo_rec_ptr_1 and  STRUCT_KFIFO_REC_1 can handle records of a
+ * length between 0 and 255 bytes.
+ *
+ * struct kfifo_rec_ptr_2 and  STRUCT_KFIFO_REC_2 can handle records of a
+ * length between 0 and 65535 bytes.
+ */
+
+#ifdef DYNAMIC
+struct kfifo_rec_ptr_1 test;
+
+#else
+typedef STRUCT_KFIFO_REC_1(FIFO_SIZE) mytest;
+
+static mytest test;
+#endif
+
+static int __init testfunc(void)
+{
+	char		buf[100];
+	unsigned int	i;
+	unsigned int	ret;
+	struct { unsigned char buf[6]; } hello = { "hello" };
+
+	printk(KERN_INFO "record fifo test start\n");
+
+	kfifo_in(&test, &hello, sizeof(hello));
+
+	/* show the size of the next record in the fifo */
+	printk(KERN_INFO "fifo peek len: %u\n", kfifo_peek_len(&test));
+
+	/* put in variable length data */
+	for (i = 0; i < 10; i++) {
+		memset(buf, 'a' + i, i + 1);
+		kfifo_in(&test, buf, i + 1);
+	}
+
+	printk(KERN_INFO "fifo len: %u\n", kfifo_len(&test));
+
+	/* show the first record without removing from the fifo */
+	ret = kfifo_out_peek(&test, buf, sizeof(buf));
+	if (ret)
+		printk(KERN_INFO "%.*s\n", ret, buf);
+
+	/* print out all records in the fifo */
+	while (!kfifo_is_empty(&test)) {
+		ret = kfifo_out(&test, buf, sizeof(buf));
+		printk(KERN_INFO "%.*s\n", ret, buf);
+	}
+
+	return 0;
+}
+
+static ssize_t fifo_write(struct file *file, const char __user *buf,
+						size_t count, loff_t *ppos)
+{
+	int ret;
+	unsigned int copied;
+
+	if (mutex_lock_interruptible(&write_lock))
+		return -ERESTARTSYS;
+
+	ret = kfifo_from_user(&test, buf, count, &copied);
+
+	mutex_unlock(&write_lock);
+
+	return ret ? ret : copied;
+}
+
+static ssize_t fifo_read(struct file *file, char __user *buf,
+						size_t count, loff_t *ppos)
+{
+	int ret;
+	unsigned int copied;
+
+	if (mutex_lock_interruptible(&read_lock))
+		return -ERESTARTSYS;
+
+	ret = kfifo_to_user(&test, buf, count, &copied);
+
+	mutex_unlock(&read_lock);
+
+	return ret ? ret : copied;
+}
+
+static const struct file_operations fifo_fops = {
+	.owner		= THIS_MODULE,
+	.read		= fifo_read,
+	.write		= fifo_write,
+};
+
+static int __init example_init(void)
+{
+#ifdef DYNAMIC
+	int ret;
+
+	ret = kfifo_alloc(&test, FIFO_SIZE, GFP_KERNEL);
+	if (ret) {
+		printk(KERN_ERR "error kfifo_alloc\n");
+		return ret;
+	}
+#else
+	INIT_KFIFO(test);
+#endif
+	testfunc();
+
+	if (proc_create(PROC_FIFO, 0, NULL, &fifo_fops) == NULL) {
+#ifdef DYNAMIC
+		kfifo_free(&test);
+#endif
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+static void __exit example_exit(void)
+{
+	remove_proc_entry(PROC_FIFO, NULL);
+#ifdef DYNAMIC
+	kfifo_free(&test);
+#endif
+}
+
+module_init(example_init);
+module_exit(example_exit);
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Stefani Seibold <stefani@seibold.net>");
_

Patches currently in -mm which might be from stefani@seibold.net are

origin.patch
linux-next.patch
kfifo-kfifo_is_fullempty-should-return-bools-not-ints.patch
kfifo-fix-kfifo-miss-use-of-nozamic.patch
kfifo-add-the-new-generic-kfifo-api.patch
kfifo-replace-the-old-non-generic-api.patch
kfifo-add-example-files-to-the-kernel-sample-directory.patch

