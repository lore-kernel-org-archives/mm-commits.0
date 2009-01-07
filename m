From: akpm@linux-foundation.org
Subject: - samples-mark-static__init__exit-for-initexit-functions.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:15:33 -0800
Message-ID: <200901072215.n07MFX00015376@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55595 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752598AbZAGWPr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:15:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qhfeng.kernel@gmail.com, gregkh@suse.de, mathieu.desnoyers@polymtl.ca, mm-commits@vger.kernel.org


The patch titled
     samples: mark {static|__init|__exit} for {init|exit} functions
has been removed from the -mm tree.  Its filename was
     samples-mark-static__init__exit-for-initexit-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: samples: mark {static|__init|__exit} for {init|exit} functions
From: Qinghuang Feng <qhfeng.kernel@gmail.com>

None of these (init|exit) functions is called from other functions which
is outside the kernel module mechanism or kernel itself, so mark them as
{static|__init|__exit}.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/firmware_class/firmware_sample_driver.c |    2 +-
 samples/kobject/kobject-example.c               |    4 ++--
 samples/kobject/kset-example.c                  |    4 ++--
 samples/markers/marker-example.c                |    4 ++--
 samples/tracepoints/tracepoint-probe-sample.c   |    4 ++--
 samples/tracepoints/tracepoint-probe-sample2.c  |    4 ++--
 samples/tracepoints/tracepoint-sample.c         |    4 ++--
 7 files changed, 13 insertions(+), 13 deletions(-)

diff -puN samples/firmware_class/firmware_sample_driver.c~samples-mark-static__init__exit-for-initexit-functions samples/firmware_class/firmware_sample_driver.c
--- a/samples/firmware_class/firmware_sample_driver.c~samples-mark-static__init__exit-for-initexit-functions
+++ a/samples/firmware_class/firmware_sample_driver.c
@@ -100,7 +100,7 @@ static void sample_probe_async(void)
 		       " request_firmware_nowait failed\n");
 }
 
-static int sample_init(void)
+static int __init sample_init(void)
 {
 	device_initialize(&ghost_device);
 	/* since there is no real hardware insertion I just call the
diff -puN samples/kobject/kobject-example.c~samples-mark-static__init__exit-for-initexit-functions samples/kobject/kobject-example.c
--- a/samples/kobject/kobject-example.c~samples-mark-static__init__exit-for-initexit-functions
+++ a/samples/kobject/kobject-example.c
@@ -101,7 +101,7 @@ static struct attribute_group attr_group
 
 static struct kobject *example_kobj;
 
-static int example_init(void)
+static int __init example_init(void)
 {
 	int retval;
 
@@ -126,7 +126,7 @@ static int example_init(void)
 	return retval;
 }
 
-static void example_exit(void)
+static void __exit example_exit(void)
 {
 	kobject_put(example_kobj);
 }
diff -puN samples/kobject/kset-example.c~samples-mark-static__init__exit-for-initexit-functions samples/kobject/kset-example.c
--- a/samples/kobject/kset-example.c~samples-mark-static__init__exit-for-initexit-functions
+++ a/samples/kobject/kset-example.c
@@ -229,7 +229,7 @@ static void destroy_foo_obj(struct foo_o
 	kobject_put(&foo->kobj);
 }
 
-static int example_init(void)
+static int __init example_init(void)
 {
 	/*
 	 * Create a kset with the name of "kset_example",
@@ -264,7 +264,7 @@ foo_error:
 	return -EINVAL;
 }
 
-static void example_exit(void)
+static void __exit example_exit(void)
 {
 	destroy_foo_obj(baz_obj);
 	destroy_foo_obj(bar_obj);
diff -puN samples/markers/marker-example.c~samples-mark-static__init__exit-for-initexit-functions samples/markers/marker-example.c
--- a/samples/markers/marker-example.c~samples-mark-static__init__exit-for-initexit-functions
+++ a/samples/markers/marker-example.c
@@ -30,7 +30,7 @@ static struct file_operations mark_ops =
 	.open = my_open,
 };
 
-static int example_init(void)
+static int __init example_init(void)
 {
 	printk(KERN_ALERT "example init\n");
 	pentry_example = proc_create("marker-example", 0444, NULL, &mark_ops);
@@ -39,7 +39,7 @@ static int example_init(void)
 	return 0;
 }
 
-static void example_exit(void)
+static void __exit example_exit(void)
 {
 	printk(KERN_ALERT "example exit\n");
 	remove_proc_entry("marker-example", NULL);
diff -puN samples/tracepoints/tracepoint-probe-sample.c~samples-mark-static__init__exit-for-initexit-functions samples/tracepoints/tracepoint-probe-sample.c
--- a/samples/tracepoints/tracepoint-probe-sample.c~samples-mark-static__init__exit-for-initexit-functions
+++ a/samples/tracepoints/tracepoint-probe-sample.c
@@ -28,7 +28,7 @@ static void probe_subsys_eventb(void)
 	printk(KERN_INFO "Event B is encountered\n");
 }
 
-int __init tp_sample_trace_init(void)
+static int __init tp_sample_trace_init(void)
 {
 	int ret;
 
@@ -42,7 +42,7 @@ int __init tp_sample_trace_init(void)
 
 module_init(tp_sample_trace_init);
 
-void __exit tp_sample_trace_exit(void)
+static void __exit tp_sample_trace_exit(void)
 {
 	unregister_trace_subsys_eventb(probe_subsys_eventb);
 	unregister_trace_subsys_event(probe_subsys_event);
diff -puN samples/tracepoints/tracepoint-probe-sample2.c~samples-mark-static__init__exit-for-initexit-functions samples/tracepoints/tracepoint-probe-sample2.c
--- a/samples/tracepoints/tracepoint-probe-sample2.c~samples-mark-static__init__exit-for-initexit-functions
+++ a/samples/tracepoints/tracepoint-probe-sample2.c
@@ -18,7 +18,7 @@ static void probe_subsys_event(struct in
 		inode->i_ino);
 }
 
-int __init tp_sample_trace_init(void)
+static int __init tp_sample_trace_init(void)
 {
 	int ret;
 
@@ -30,7 +30,7 @@ int __init tp_sample_trace_init(void)
 
 module_init(tp_sample_trace_init);
 
-void __exit tp_sample_trace_exit(void)
+static void __exit tp_sample_trace_exit(void)
 {
 	unregister_trace_subsys_event(probe_subsys_event);
 	tracepoint_synchronize_unregister();
diff -puN samples/tracepoints/tracepoint-sample.c~samples-mark-static__init__exit-for-initexit-functions samples/tracepoints/tracepoint-sample.c
--- a/samples/tracepoints/tracepoint-sample.c~samples-mark-static__init__exit-for-initexit-functions
+++ a/samples/tracepoints/tracepoint-sample.c
@@ -32,7 +32,7 @@ static struct file_operations mark_ops =
 	.open = my_open,
 };
 
-static int example_init(void)
+static int __init example_init(void)
 {
 	printk(KERN_ALERT "example init\n");
 	pentry_example = proc_create("tracepoint-example", 0444, NULL,
@@ -42,7 +42,7 @@ static int example_init(void)
 	return 0;
 }
 
-static void example_exit(void)
+static void __exit example_exit(void)
 {
 	printk(KERN_ALERT "example exit\n");
 	remove_proc_entry("tracepoint-example", NULL);
_

Patches currently in -mm which might be from qhfeng.kernel@gmail.com are

origin.patch
linux-next.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch
ext2-fix-ext2_splice_branch-comments.patch

