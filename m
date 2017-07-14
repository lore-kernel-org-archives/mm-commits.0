From: akpm@linux-foundation.org
Subject: [patch 12/13] kmod: add test driver to stress test the module
 loader
Date: Fri, 14 Jul 2017 14:50:08 -0700
Message-ID: <59693c90.P6z9twsKyw2mNCvv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55830 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751135AbdGNVuJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jul 2017 17:50:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mcgrof@kernel.org, gregkh@linuxfoundation.org, jeyu@redhat.com, mmarek@suse.com, pmladek@suse.com, rusty@rustcorp.com.au, shuah@kernel.org

From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: kmod: add test driver to stress test the module loader

This adds a new stress test driver for kmod: the kernel module loader. 
The new stress test driver, test_kmod, is only enabled as a module right
now.  It should be possible to load this as built-in and load tests early
(refer to the force_init_test module parameter), however since a lot of
test can get a system out of memory fast we leave this disabled for now.

Using a system with 1024 MiB of RAM can *easily* get your kernel OOM fast
with this test driver.

The test_kmod driver exposes API knobs for us to fine tune simple
request_module() and get_fs_type() calls.  Since these API calls only
allow each one parameter a test driver for these is rather simple.  Other
factors that can help out test driver though are the number of calls we
issue and knowing current limitations of each.  This exposes configuration
as much as possible through userspace to be able to build tests directly
from userspace.

Since it allows multiple misc devices its will eventually (once we add a
knob to let us create new devices at will) also be possible to perform
more tests in parallel, provided you have enough memory.

We only enable tests we know work as of right now.

Demo screenshots:

 # tools/testing/selftests/kmod/kmod.sh
kmod_test_0001_driver: OK! - loading kmod test
kmod_test_0001_driver: OK! - Return value: 256 (MODULE_NOT_FOUND), expected MODULE_NOT_FOUND
kmod_test_0001_fs: OK! - loading kmod test
kmod_test_0001_fs: OK! - Return value: -22 (-EINVAL), expected -EINVAL
kmod_test_0002_driver: OK! - loading kmod test
kmod_test_0002_driver: OK! - Return value: 256 (MODULE_NOT_FOUND), expected MODULE_NOT_FOUND
kmod_test_0002_fs: OK! - loading kmod test
kmod_test_0002_fs: OK! - Return value: -22 (-EINVAL), expected -EINVAL
kmod_test_0003: OK! - loading kmod test
kmod_test_0003: OK! - Return value: 0 (SUCCESS), expected SUCCESS
kmod_test_0004: OK! - loading kmod test
kmod_test_0004: OK! - Return value: 0 (SUCCESS), expected SUCCESS
kmod_test_0005: OK! - loading kmod test
kmod_test_0005: OK! - Return value: 0 (SUCCESS), expected SUCCESS
kmod_test_0006: OK! - loading kmod test
kmod_test_0006: OK! - Return value: 0 (SUCCESS), expected SUCCESS
kmod_test_0005: OK! - loading kmod test
kmod_test_0005: OK! - Return value: 0 (SUCCESS), expected SUCCESS
kmod_test_0006: OK! - loading kmod test
kmod_test_0006: OK! - Return value: 0 (SUCCESS), expected SUCCESS
XXX: add test restult for 0007
Test completed

You can also request for specific tests:

 # tools/testing/selftests/kmod/kmod.sh -t 0001
kmod_test_0001_driver: OK! - loading kmod test
kmod_test_0001_driver: OK! - Return value: 256 (MODULE_NOT_FOUND), expected MODULE_NOT_FOUND
kmod_test_0001_fs: OK! - loading kmod test
kmod_test_0001_fs: OK! - Return value: -22 (-EINVAL), expected -EINVAL
Test completed

Lastly, the current available number of tests:

 # tools/testing/selftests/kmod/kmod.sh --help
Usage: tools/testing/selftests/kmod/kmod.sh [ -t <4-number-digit> ]
Valid tests: 0001-0009

0001 - Simple test - 1 thread  for empty string
0002 - Simple test - 1 thread  for modules/filesystems that do not exist
0003 - Simple test - 1 thread  for get_fs_type() only
0004 - Simple test - 2 threads for get_fs_type() only
0005 - multithreaded tests with default setup - request_module() only
0006 - multithreaded tests with default setup - get_fs_type() only
0007 - multithreaded tests with default setup test request_module() and get_fs_type()
0008 - multithreaded - push kmod_concurrent over max_modprobes for request_module()
0009 - multithreaded - push kmod_concurrent over max_modprobes for get_fs_type()

The following test cases currently fail, as such they are not currently
enabled by default:

 # tools/testing/selftests/kmod/kmod.sh -t 0008
 # tools/testing/selftests/kmod/kmod.sh -t 0009

To be sure to run them as intended please unload both of the modules:

  o test_module
  o xfs

And ensure they are not loaded on your system prior to testing them.  If
you use these paritions for your rootfs you can change the default test
driver used for get_fs_type() by exporting it into your environment.  For
example of other test defaults you can override refer to kmod.sh
allow_user_defaults().

Behind the scenes this is how we fine tune at a test case prior to
hitting a trigger to run it:

cat /sys/devices/virtual/misc/test_kmod0/config
echo -n "2" > /sys/devices/virtual/misc/test_kmod0/config_test_case
echo -n "ext4" > /sys/devices/virtual/misc/test_kmod0/config_test_fs
echo -n "80" > /sys/devices/virtual/misc/test_kmod0/config_num_threads
cat /sys/devices/virtual/misc/test_kmod0/config
echo -n "1" > /sys/devices/virtual/misc/test_kmod0/config_num_threads

Finally to trigger:

echo -n "1" > /sys/devices/virtual/misc/test_kmod0/trigger_config

The kmod.sh script uses the above constructs to build different test cases.

A bit of interpretation of the current failures follows, first two
premises:

a) When request_module() is used userspace figures out an optimized
   version of module order for us.  Once it finds the modules it needs, as
   per depmod symbol dep map, it will finit_module() the respective
   modules which are needed for the original request_module() request.

b) We have an optimization in place whereby if a kernel uses
   request_module() on a module already loaded we never bother userspace
   as the module already is loaded.  This is all handled by kernel/kmod.c.

A few things to consider to help identify root causes of issues:

0) kmod 19 has a broken heuristic for modules being assumed to be
   built-in to your kernel and will return 0 even though request_module()
   failed.  Upgrade to a newer version of kmod.

1) A get_fs_type() call for "xfs" will request_module() for "fs-xfs",
   not for "xfs".  The optimization in kernel described in b) fails to
   catch if we have a lot of consecutive get_fs_type() calls.  The reason
   is the optimization in place does not look for aliases.  This means two
   consecutive get_fs_type() calls will bump kmod_concurrent, whereas
   request_module() will not.

This one explanation why test case 0009 fails at least once for
get_fs_type().

2) If a module fails to load --- for whatever reason (kmod_concurrent
   limit reached, file not yet present due to rootfs switch, out of
   memory) we have a period of time during which module request for the
   same name either with request_module() or get_fs_type() will *also*
   fail to load even if the file for the module is ready.

This explains why *multiple* NULLs are possible on test 0009.

3) finit_module() consumes quite a bit of memory.

4) Filesystems typically also have more dependent modules than other
   modules, its important to note though that even though a get_fs_type()
   call does not incur additional kmod_concurrent bumps, since userspace
   loads dependencies it finds it needs via finit_module_fd(), it *will*
   take much more memory to load a module with a lot of dependencies.

Because of 3) and 4) we will easily run into out of memory failures with
certain tests.  For instance test 0006 fails on qemu with 1024 MiB of RAM.
It panics a box after reaping all userspace processes and still not
having enough memory to reap.

[arnd@arndb.de: add dependencies for test module]
  Link: http://lkml.kernel.org/r/20170630154834.3689272-1-arnd@arndb.de
Link: http://lkml.kernel.org/r/20170628223155.26472-3-mcgrof@kernel.org
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
Cc: Jessica Yu <jeyu@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michal Marek <mmarek@suse.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                           |    2 
 lib/Kconfig.debug                     |   27 
 lib/Makefile                          |    1 
 lib/test_kmod.c                       | 1246 ++++++++++++++++++++++++
 tools/testing/selftests/kmod/Makefile |   11 
 tools/testing/selftests/kmod/config   |    7 
 tools/testing/selftests/kmod/kmod.sh  |  635 ++++++++++++
 7 files changed, 1929 insertions(+)

diff -puN MAINTAINERS~kmod-add-test-driver-to-stress-test-the-module-loader MAINTAINERS
--- a/MAINTAINERS~kmod-add-test-driver-to-stress-test-the-module-loader
+++ a/MAINTAINERS
@@ -7560,6 +7560,8 @@ L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	kernel/kmod.c
 F:	include/linux/kmod.h
+F:	lib/test_kmod.c
+F:	tools/testing/selftests/kmod/
 
 KPROBES
 M:	Ananth N Mavinakayanahalli <ananth@linux.vnet.ibm.com>
diff -puN lib/Kconfig.debug~kmod-add-test-driver-to-stress-test-the-module-loader lib/Kconfig.debug
--- a/lib/Kconfig.debug~kmod-add-test-driver-to-stress-test-the-module-loader
+++ a/lib/Kconfig.debug
@@ -1847,6 +1847,33 @@ config BUG_ON_DATA_CORRUPTION
 
 	  If unsure, say N.
 
+config TEST_KMOD
+	tristate "kmod stress tester"
+	default n
+	depends on m
+	depends on BLOCK && (64BIT || LBDAF)	  # for XFS, BTRFS
+	depends on NETDEVICES && NET_CORE && INET # for TUN
+	select TEST_LKM
+	select XFS_FS
+	select TUN
+	select BTRFS_FS
+	help
+	  Test the kernel's module loading mechanism: kmod. kmod implements
+	  support to load modules using the Linux kernel's usermode helper.
+	  This test provides a series of tests against kmod.
+
+	  Although technically you can either build test_kmod as a module or
+	  into the kernel we disallow building it into the kernel since
+	  it stress tests request_module() and this will very likely cause
+	  some issues by taking over precious threads available from other
+	  module load requests, ultimately this could be fatal.
+
+	  To run tests run:
+
+	  tools/testing/selftests/kmod/kmod.sh --help
+
+	  If unsure, say N.
+
 source "samples/Kconfig"
 
 source "lib/Kconfig.kgdb"
diff -puN lib/Makefile~kmod-add-test-driver-to-stress-test-the-module-loader lib/Makefile
--- a/lib/Makefile~kmod-add-test-driver-to-stress-test-the-module-loader
+++ a/lib/Makefile
@@ -61,6 +61,7 @@ obj-$(CONFIG_TEST_PRINTF) += test_printf
 obj-$(CONFIG_TEST_BITMAP) += test_bitmap.o
 obj-$(CONFIG_TEST_UUID) += test_uuid.o
 obj-$(CONFIG_TEST_PARMAN) += test_parman.o
+obj-$(CONFIG_TEST_KMOD) += test_kmod.o
 
 ifeq ($(CONFIG_DEBUG_KOBJECT),y)
 CFLAGS_kobject.o += -DDEBUG
diff -puN /dev/null lib/test_kmod.c
--- /dev/null
+++ a/lib/test_kmod.c
@@ -0,0 +1,1246 @@
+/*
+ * kmod stress test driver
+ *
+ * Copyright (C) 2017 Luis R. Rodriguez <mcgrof@kernel.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or at your option any
+ * later version; or, when distributed separately from the Linux kernel or
+ * when incorporated into other software packages, subject to the following
+ * license:
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of copyleft-next (version 0.3.1 or later) as published
+ * at http://copyleft-next.org/.
+ */
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+/*
+ * This driver provides an interface to trigger and test the kernel's
+ * module loader through a series of configurations and a few triggers.
+ * To test this driver use the following script as root:
+ *
+ * tools/testing/selftests/kmod/kmod.sh --help
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/kmod.h>
+#include <linux/printk.h>
+#include <linux/kthread.h>
+#include <linux/sched.h>
+#include <linux/fs.h>
+#include <linux/miscdevice.h>
+#include <linux/vmalloc.h>
+#include <linux/slab.h>
+#include <linux/device.h>
+
+#define TEST_START_NUM_THREADS	50
+#define TEST_START_DRIVER	"test_module"
+#define TEST_START_TEST_FS	"xfs"
+#define TEST_START_TEST_CASE	TEST_KMOD_DRIVER
+
+
+static bool force_init_test = false;
+module_param(force_init_test, bool_enable_only, 0644);
+MODULE_PARM_DESC(force_init_test,
+		 "Force kicking a test immediately after driver loads");
+
+/*
+ * For device allocation / registration
+ */
+static DEFINE_MUTEX(reg_dev_mutex);
+static LIST_HEAD(reg_test_devs);
+
+/*
+ * num_test_devs actually represents the *next* ID of the next
+ * device we will allow to create.
+ */
+static int num_test_devs;
+
+/**
+ * enum kmod_test_case - linker table test case
+ *
+ * If you add a  test case, please be sure to review if you need to se
+ * @need_mod_put for your tests case.
+ *
+ * @TEST_KMOD_DRIVER: stress tests request_module()
+ * @TEST_KMOD_FS_TYPE: stress tests get_fs_type()
+ */
+enum kmod_test_case {
+	__TEST_KMOD_INVALID = 0,
+
+	TEST_KMOD_DRIVER,
+	TEST_KMOD_FS_TYPE,
+
+	__TEST_KMOD_MAX,
+};
+
+struct test_config {
+	char *test_driver;
+	char *test_fs;
+	unsigned int num_threads;
+	enum kmod_test_case test_case;
+	int test_result;
+};
+
+struct kmod_test_device;
+
+/**
+ * kmod_test_device_info - thread info
+ *
+ * @ret_sync: return value if request_module() is used, sync request for
+ * 	@TEST_KMOD_DRIVER
+ * @fs_sync: return value of get_fs_type() for @TEST_KMOD_FS_TYPE
+ * @thread_idx: thread ID
+ * @test_dev: test device test is being performed under
+ * @need_mod_put: Some tests (get_fs_type() is one) requires putting the module
+ *	(module_put(fs_sync->owner)) when done, otherwise you will not be able
+ *	to unload the respective modules and re-test. We use this to keep
+ *	accounting of when we need this and to help out in case we need to
+ *	error out and deal with module_put() on error.
+ */
+struct kmod_test_device_info {
+	int ret_sync;
+	struct file_system_type *fs_sync;
+	struct task_struct *task_sync;
+	unsigned int thread_idx;
+	struct kmod_test_device *test_dev;
+	bool need_mod_put;
+};
+
+/**
+ * kmod_test_device - test device to help test kmod
+ *
+ * @dev_idx: unique ID for test device
+ * @config: configuration for the test
+ * @misc_dev: we use a misc device under the hood
+ * @dev: pointer to misc_dev's own struct device
+ * @config_mutex: protects configuration of test
+ * @trigger_mutex: the test trigger can only be fired once at a time
+ * @thread_lock: protects @done count, and the @info per each thread
+ * @done: number of threads which have completed or failed
+ * @test_is_oom: when we run out of memory, use this to halt moving forward
+ * @kthreads_done: completion used to signal when all work is done
+ * @list: needed to be part of the reg_test_devs
+ * @info: array of info for each thread
+ */
+struct kmod_test_device {
+	int dev_idx;
+	struct test_config config;
+	struct miscdevice misc_dev;
+	struct device *dev;
+	struct mutex config_mutex;
+	struct mutex trigger_mutex;
+	struct mutex thread_mutex;
+
+	unsigned int done;
+
+	bool test_is_oom;
+	struct completion kthreads_done;
+	struct list_head list;
+
+	struct kmod_test_device_info *info;
+};
+
+static const char *test_case_str(enum kmod_test_case test_case)
+{
+	switch (test_case) {
+	case TEST_KMOD_DRIVER:
+		return "TEST_KMOD_DRIVER";
+	case TEST_KMOD_FS_TYPE:
+		return "TEST_KMOD_FS_TYPE";
+	default:
+		return "invalid";
+	}
+}
+
+static struct miscdevice *dev_to_misc_dev(struct device *dev)
+{
+	return dev_get_drvdata(dev);
+}
+
+static struct kmod_test_device *misc_dev_to_test_dev(struct miscdevice *misc_dev)
+{
+	return container_of(misc_dev, struct kmod_test_device, misc_dev);
+}
+
+static struct kmod_test_device *dev_to_test_dev(struct device *dev)
+{
+	struct miscdevice *misc_dev;
+
+	misc_dev = dev_to_misc_dev(dev);
+
+	return misc_dev_to_test_dev(misc_dev);
+}
+
+/* Must run with thread_mutex held */
+static void kmod_test_done_check(struct kmod_test_device *test_dev,
+				 unsigned int idx)
+{
+	struct test_config *config = &test_dev->config;
+
+	test_dev->done++;
+	dev_dbg(test_dev->dev, "Done thread count: %u\n", test_dev->done);
+
+	if (test_dev->done == config->num_threads) {
+		dev_info(test_dev->dev, "Done: %u threads have all run now\n",
+			 test_dev->done);
+		dev_info(test_dev->dev, "Last thread to run: %u\n", idx);
+		complete(&test_dev->kthreads_done);
+	}
+}
+
+static void test_kmod_put_module(struct kmod_test_device_info *info)
+{
+	struct kmod_test_device *test_dev = info->test_dev;
+	struct test_config *config = &test_dev->config;
+
+	if (!info->need_mod_put)
+		return;
+
+	switch (config->test_case) {
+	case TEST_KMOD_DRIVER:
+		break;
+	case TEST_KMOD_FS_TYPE:
+		if (info && info->fs_sync && info->fs_sync->owner)
+			module_put(info->fs_sync->owner);
+		break;
+	default:
+		BUG();
+	}
+
+	info->need_mod_put = true;
+}
+
+static int run_request(void *data)
+{
+	struct kmod_test_device_info *info = data;
+	struct kmod_test_device *test_dev = info->test_dev;
+	struct test_config *config = &test_dev->config;
+
+	switch (config->test_case) {
+	case TEST_KMOD_DRIVER:
+		info->ret_sync = request_module("%s", config->test_driver);
+		break;
+	case TEST_KMOD_FS_TYPE:
+		info->fs_sync = get_fs_type(config->test_fs);
+		info->need_mod_put = true;
+		break;
+	default:
+		/* __trigger_config_run() already checked for test sanity */
+		BUG();
+		return -EINVAL;
+	}
+
+	dev_dbg(test_dev->dev, "Ran thread %u\n", info->thread_idx);
+
+	test_kmod_put_module(info);
+
+	mutex_lock(&test_dev->thread_mutex);
+	info->task_sync = NULL;
+	kmod_test_done_check(test_dev, info->thread_idx);
+	mutex_unlock(&test_dev->thread_mutex);
+
+	return 0;
+}
+
+static int tally_work_test(struct kmod_test_device_info *info)
+{
+	struct kmod_test_device *test_dev = info->test_dev;
+	struct test_config *config = &test_dev->config;
+	int err_ret = 0;
+
+	switch (config->test_case) {
+	case TEST_KMOD_DRIVER:
+		/*
+		 * Only capture errors, if one is found that's
+		 * enough, for now.
+		 */
+		if (info->ret_sync != 0)
+			err_ret = info->ret_sync;
+		dev_info(test_dev->dev,
+			 "Sync thread %d return status: %d\n",
+			 info->thread_idx, info->ret_sync);
+		break;
+	case TEST_KMOD_FS_TYPE:
+		/* For now we make this simple */
+		if (!info->fs_sync)
+			err_ret = -EINVAL;
+		dev_info(test_dev->dev, "Sync thread %u fs: %s\n",
+			 info->thread_idx, info->fs_sync ? config->test_fs :
+			 "NULL");
+		break;
+	default:
+		BUG();
+	}
+
+	return err_ret;
+}
+
+/*
+ * XXX: add result option to display if all errors did not match.
+ * For now we just keep any error code if one was found.
+ *
+ * If this ran it means *all* tasks were created fine and we
+ * are now just collecting results.
+ *
+ * Only propagate errors, do not override with a subsequent sucess case.
+ */
+static void tally_up_work(struct kmod_test_device *test_dev)
+{
+	struct test_config *config = &test_dev->config;
+	struct kmod_test_device_info *info;
+	unsigned int idx;
+	int err_ret = 0;
+	int ret = 0;
+
+	mutex_lock(&test_dev->thread_mutex);
+
+	dev_info(test_dev->dev, "Results:\n");
+
+	for (idx=0; idx < config->num_threads; idx++) {
+		info = &test_dev->info[idx];
+		ret = tally_work_test(info);
+		if (ret)
+			err_ret = ret;
+	}
+
+	/*
+	 * Note: request_module() returns 256 for a module not found even
+	 * though modprobe itself returns 1.
+	 */
+	config->test_result = err_ret;
+
+	mutex_unlock(&test_dev->thread_mutex);
+}
+
+static int try_one_request(struct kmod_test_device *test_dev, unsigned int idx)
+{
+	struct kmod_test_device_info *info = &test_dev->info[idx];
+	int fail_ret = -ENOMEM;
+
+	mutex_lock(&test_dev->thread_mutex);
+
+	info->thread_idx = idx;
+	info->test_dev = test_dev;
+	info->task_sync = kthread_run(run_request, info, "%s-%u",
+				      KBUILD_MODNAME, idx);
+
+	if (!info->task_sync || IS_ERR(info->task_sync)) {
+		test_dev->test_is_oom = true;
+		dev_err(test_dev->dev, "Setting up thread %u failed\n", idx);
+		info->task_sync = NULL;
+		goto err_out;
+	} else
+		dev_dbg(test_dev->dev, "Kicked off thread %u\n", idx);
+
+	mutex_unlock(&test_dev->thread_mutex);
+
+	return 0;
+
+err_out:
+	info->ret_sync = fail_ret;
+	mutex_unlock(&test_dev->thread_mutex);
+
+	return fail_ret;
+}
+
+static void test_dev_kmod_stop_tests(struct kmod_test_device *test_dev)
+{
+	struct test_config *config = &test_dev->config;
+	struct kmod_test_device_info *info;
+	unsigned int i;
+
+	dev_info(test_dev->dev, "Ending request_module() tests\n");
+
+	mutex_lock(&test_dev->thread_mutex);
+
+	for (i=0; i < config->num_threads; i++) {
+		info = &test_dev->info[i];
+		if (info->task_sync && !IS_ERR(info->task_sync)) {
+			dev_info(test_dev->dev,
+				 "Stopping still-running thread %i\n", i);
+			kthread_stop(info->task_sync);
+		}
+
+		/*
+		 * info->task_sync is well protected, it can only be
+		 * NULL or a pointer to a struct. If its NULL we either
+		 * never ran, or we did and we completed the work. Completed
+		 * tasks *always* put the module for us. This is a sanity
+		 * check -- just in case.
+		 */
+		if (info->task_sync && info->need_mod_put)
+			test_kmod_put_module(info);
+	}
+
+	mutex_unlock(&test_dev->thread_mutex);
+}
+
+/*
+ * Only wait *iff* we did not run into any errors during all of our thread
+ * set up. If run into any issues we stop threads and just bail out with
+ * an error to the trigger. This also means we don't need any tally work
+ * for any threads which fail.
+ */
+static int try_requests(struct kmod_test_device *test_dev)
+{
+	struct test_config *config = &test_dev->config;
+	unsigned int idx;
+	int ret;
+	bool any_error = false;
+
+	for (idx=0; idx < config->num_threads; idx++) {
+		if (test_dev->test_is_oom) {
+			any_error = true;
+			break;
+		}
+
+		ret = try_one_request(test_dev, idx);
+		if (ret) {
+			any_error = true;
+			break;
+		}
+	}
+
+	if (!any_error) {
+		test_dev->test_is_oom = false;
+		dev_info(test_dev->dev,
+			 "No errors were found while initializing threads\n");
+		wait_for_completion(&test_dev->kthreads_done);
+		tally_up_work(test_dev);
+	} else {
+		test_dev->test_is_oom = true;
+		dev_info(test_dev->dev,
+			 "At least one thread failed to start, stop all work\n");
+		test_dev_kmod_stop_tests(test_dev);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static int run_test_driver(struct kmod_test_device *test_dev)
+{
+	struct test_config *config = &test_dev->config;
+
+	dev_info(test_dev->dev, "Test case: %s (%u)\n",
+		 test_case_str(config->test_case),
+		 config->test_case);
+	dev_info(test_dev->dev, "Test driver to load: %s\n",
+		 config->test_driver);
+	dev_info(test_dev->dev, "Number of threads to run: %u\n",
+		 config->num_threads);
+	dev_info(test_dev->dev, "Thread IDs will range from 0 - %u\n",
+		 config->num_threads - 1);
+
+	return try_requests(test_dev);
+}
+
+static int run_test_fs_type(struct kmod_test_device *test_dev)
+{
+	struct test_config *config = &test_dev->config;
+
+	dev_info(test_dev->dev, "Test case: %s (%u)\n",
+		 test_case_str(config->test_case),
+		 config->test_case);
+	dev_info(test_dev->dev, "Test filesystem to load: %s\n",
+		 config->test_fs);
+	dev_info(test_dev->dev, "Number of threads to run: %u\n",
+		 config->num_threads);
+	dev_info(test_dev->dev, "Thread IDs will range from 0 - %u\n",
+		 config->num_threads - 1);
+
+	return try_requests(test_dev);
+}
+
+static ssize_t config_show(struct device *dev,
+			   struct device_attribute *attr,
+			   char *buf)
+{
+	struct kmod_test_device *test_dev = dev_to_test_dev(dev);
+	struct test_config *config = &test_dev->config;
+	int len = 0;
+
+	mutex_lock(&test_dev->config_mutex);
+
+	len += snprintf(buf, PAGE_SIZE,
+			"Custom trigger configuration for: %s\n",
+			dev_name(dev));
+
+	len += snprintf(buf+len, PAGE_SIZE - len,
+			"Number of threads:\t%u\n",
+			config->num_threads);
+
+	len += snprintf(buf+len, PAGE_SIZE - len,
+			"Test_case:\t%s (%u)\n",
+			test_case_str(config->test_case),
+			config->test_case);
+
+	if (config->test_driver)
+		len += snprintf(buf+len, PAGE_SIZE - len,
+				"driver:\t%s\n",
+				config->test_driver);
+	else
+		len += snprintf(buf+len, PAGE_SIZE - len,
+				"driver:\tEMTPY\n");
+
+	if (config->test_fs)
+		len += snprintf(buf+len, PAGE_SIZE - len,
+				"fs:\t%s\n",
+				config->test_fs);
+	else
+		len += snprintf(buf+len, PAGE_SIZE - len,
+				"fs:\tEMTPY\n");
+
+	mutex_unlock(&test_dev->config_mutex);
+
+	return len;
+}
+static DEVICE_ATTR_RO(config);
+
+/*
+ * This ensures we don't allow kicking threads through if our configuration
+ * is faulty.
+ */
+static int __trigger_config_run(struct kmod_test_device *test_dev)
+{
+	struct test_config *config = &test_dev->config;
+
+	test_dev->done = 0;
+
+	switch (config->test_case) {
+	case TEST_KMOD_DRIVER:
+		return run_test_driver(test_dev);
+	case TEST_KMOD_FS_TYPE:
+		return run_test_fs_type(test_dev);
+	default:
+		dev_warn(test_dev->dev,
+			 "Invalid test case requested: %u\n",
+			 config->test_case);
+		return -EINVAL;
+	}
+}
+
+static int trigger_config_run(struct kmod_test_device *test_dev)
+{
+	struct test_config *config = &test_dev->config;
+	int ret;
+
+	mutex_lock(&test_dev->trigger_mutex);
+	mutex_lock(&test_dev->config_mutex);
+
+	ret = __trigger_config_run(test_dev);
+	if (ret < 0)
+		goto out;
+	dev_info(test_dev->dev, "General test result: %d\n",
+		 config->test_result);
+
+	/*
+	 * We must return 0 after a trigger even unless something went
+	 * wrong with the setup of the test. If the test setup went fine
+	 * then userspace must just check the result of config->test_result.
+	 * One issue with relying on the return from a call in the kernel
+	 * is if the kernel returns a possitive value using this trigger
+	 * will not return the value to userspace, it would be lost.
+	 *
+	 * By not relying on capturing the return value of tests we are using
+	 * through the trigger it also us to run tests with set -e and only
+	 * fail when something went wrong with the driver upon trigger
+	 * requests.
+	 */
+	ret = 0;
+
+out:
+	mutex_unlock(&test_dev->config_mutex);
+	mutex_unlock(&test_dev->trigger_mutex);
+
+	return ret;
+}
+
+static ssize_t
+trigger_config_store(struct device *dev,
+		     struct device_attribute *attr,
+		     const char *buf, size_t count)
+{
+	struct kmod_test_device *test_dev = dev_to_test_dev(dev);
+	int ret;
+
+	if (test_dev->test_is_oom)
+		return -ENOMEM;
+
+	/* For all intents and purposes we don't care what userspace
+	 * sent this trigger, we care only that we were triggered.
+	 * We treat the return value only for caputuring issues with
+	 * the test setup. At this point all the test variables should
+	 * have been allocated so typically this should never fail.
+	 */
+	ret = trigger_config_run(test_dev);
+	if (unlikely(ret < 0))
+		goto out;
+
+	/*
+	 * Note: any return > 0 will be treated as success
+	 * and the error value will not be available to userspace.
+	 * Do not rely on trying to send to userspace a test value
+	 * return value as possitive return errors will be lost.
+	 */
+	if (WARN_ON(ret > 0))
+		return -EINVAL;
+
+	ret = count;
+out:
+	return ret;
+}
+static DEVICE_ATTR_WO(trigger_config);
+
+/*
+ * XXX: move to kstrncpy() once merged.
+ *
+ * Users should use kfree_const() when freeing these.
+ */
+static int __kstrncpy(char **dst, const char *name, size_t count, gfp_t gfp)
+{
+	*dst = kstrndup(name, count, gfp);
+	if (!*dst)
+		return -ENOSPC;
+	return count;
+}
+
+static int config_copy_test_driver_name(struct test_config *config,
+				    const char *name,
+				    size_t count)
+{
+	return __kstrncpy(&config->test_driver, name, count, GFP_KERNEL);
+}
+
+
+static int config_copy_test_fs(struct test_config *config, const char *name,
+			       size_t count)
+{
+	return __kstrncpy(&config->test_fs, name, count, GFP_KERNEL);
+}
+
+static void __kmod_config_free(struct test_config *config)
+{
+	if (!config)
+		return;
+
+	kfree_const(config->test_driver);
+	config->test_driver = NULL;
+
+	kfree_const(config->test_fs);
+	config->test_driver = NULL;
+}
+
+static void kmod_config_free(struct kmod_test_device *test_dev)
+{
+	struct test_config *config;
+
+	if (!test_dev)
+		return;
+
+	config = &test_dev->config;
+
+	mutex_lock(&test_dev->config_mutex);
+	__kmod_config_free(config);
+	mutex_unlock(&test_dev->config_mutex);
+}
+
+static ssize_t config_test_driver_store(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t count)
+{
+	struct kmod_test_device *test_dev = dev_to_test_dev(dev);
+	struct test_config *config = &test_dev->config;
+	int copied;
+
+	mutex_lock(&test_dev->config_mutex);
+
+	kfree_const(config->test_driver);
+	config->test_driver = NULL;
+
+	copied = config_copy_test_driver_name(config, buf, count);
+	mutex_unlock(&test_dev->config_mutex);
+
+	return copied;
+}
+
+/*
+ * As per sysfs_kf_seq_show() the buf is max PAGE_SIZE.
+ */
+static ssize_t config_test_show_str(struct mutex *config_mutex,
+				    char *dst,
+				    char *src)
+{
+	int len;
+
+	mutex_lock(config_mutex);
+	len = snprintf(dst, PAGE_SIZE, "%s\n", src);
+	mutex_unlock(config_mutex);
+
+	return len;
+}
+
+static ssize_t config_test_driver_show(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	struct kmod_test_device *test_dev = dev_to_test_dev(dev);
+	struct test_config *config = &test_dev->config;
+
+	return config_test_show_str(&test_dev->config_mutex, buf,
+				    config->test_driver);
+}
+static DEVICE_ATTR(config_test_driver, 0644, config_test_driver_show,
+		   config_test_driver_store);
+
+static ssize_t config_test_fs_store(struct device *dev,
+				    struct device_attribute *attr,
+				    const char *buf, size_t count)
+{
+	struct kmod_test_device *test_dev = dev_to_test_dev(dev);
+	struct test_config *config = &test_dev->config;
+	int copied;
+
+	mutex_lock(&test_dev->config_mutex);
+
+	kfree_const(config->test_fs);
+	config->test_fs = NULL;
+
+	copied = config_copy_test_fs(config, buf, count);
+	mutex_unlock(&test_dev->config_mutex);
+
+	return copied;
+}
+
+static ssize_t config_test_fs_show(struct device *dev,
+				   struct device_attribute *attr,
+				   char *buf)
+{
+	struct kmod_test_device *test_dev = dev_to_test_dev(dev);
+	struct test_config *config = &test_dev->config;
+
+	return config_test_show_str(&test_dev->config_mutex, buf,
+				    config->test_fs);
+}
+static DEVICE_ATTR(config_test_fs, 0644, config_test_fs_show,
+		   config_test_fs_store);
+
+static int trigger_config_run_type(struct kmod_test_device *test_dev,
+				   enum kmod_test_case test_case,
+				   const char *test_str)
+{
+	int copied = 0;
+	struct test_config *config = &test_dev->config;
+
+	mutex_lock(&test_dev->config_mutex);
+
+	switch (test_case) {
+	case TEST_KMOD_DRIVER:
+		kfree_const(config->test_driver);
+		config->test_driver = NULL;
+		copied = config_copy_test_driver_name(config, test_str,
+						      strlen(test_str));
+		break;
+	case TEST_KMOD_FS_TYPE:
+		break;
+		kfree_const(config->test_fs);
+		config->test_driver = NULL;
+		copied = config_copy_test_fs(config, test_str,
+					     strlen(test_str));
+	default:
+		mutex_unlock(&test_dev->config_mutex);
+		return -EINVAL;
+	}
+
+	config->test_case = test_case;
+
+	mutex_unlock(&test_dev->config_mutex);
+
+	if (copied <= 0 || copied != strlen(test_str)) {
+		test_dev->test_is_oom = true;
+		return -ENOMEM;
+	}
+
+	test_dev->test_is_oom = false;
+
+	return trigger_config_run(test_dev);
+}
+
+static void free_test_dev_info(struct kmod_test_device *test_dev)
+{
+	vfree(test_dev->info);
+	test_dev->info = NULL;
+}
+
+static int kmod_config_sync_info(struct kmod_test_device *test_dev)
+{
+	struct test_config *config = &test_dev->config;
+
+	free_test_dev_info(test_dev);
+	test_dev->info = vzalloc(config->num_threads *
+				 sizeof(struct kmod_test_device_info));
+	if (!test_dev->info) {
+		dev_err(test_dev->dev, "Cannot alloc test_dev info\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+/*
+ * Old kernels may not have this, if you want to port this code to
+ * test it on older kernels.
+ */
+#ifdef get_kmod_umh_limit
+static unsigned int kmod_init_test_thread_limit(void)
+{
+	return get_kmod_umh_limit();
+}
+#else
+static unsigned int kmod_init_test_thread_limit(void)
+{
+	return TEST_START_NUM_THREADS;
+}
+#endif
+
+static int __kmod_config_init(struct kmod_test_device *test_dev)
+{
+	struct test_config *config = &test_dev->config;
+	int ret = -ENOMEM, copied;
+
+	__kmod_config_free(config);
+
+	copied = config_copy_test_driver_name(config, TEST_START_DRIVER,
+					      strlen(TEST_START_DRIVER));
+	if (copied != strlen(TEST_START_DRIVER))
+		goto err_out;
+
+	copied = config_copy_test_fs(config, TEST_START_TEST_FS,
+				     strlen(TEST_START_TEST_FS));
+	if (copied != strlen(TEST_START_TEST_FS))
+		goto err_out;
+
+	config->num_threads = kmod_init_test_thread_limit();
+	config->test_result = 0;
+	config->test_case = TEST_START_TEST_CASE;
+
+	ret = kmod_config_sync_info(test_dev);
+	if (ret)
+		goto err_out;
+
+	test_dev->test_is_oom = false;
+
+	return 0;
+
+err_out:
+	test_dev->test_is_oom = true;
+	WARN_ON(test_dev->test_is_oom);
+
+	__kmod_config_free(config);
+
+	return ret;
+}
+
+static ssize_t reset_store(struct device *dev,
+			   struct device_attribute *attr,
+			   const char *buf, size_t count)
+{
+	struct kmod_test_device *test_dev = dev_to_test_dev(dev);
+	int ret;
+
+	mutex_lock(&test_dev->trigger_mutex);
+	mutex_lock(&test_dev->config_mutex);
+
+	ret = __kmod_config_init(test_dev);
+	if (ret < 0) {
+		ret = -ENOMEM;
+		dev_err(dev, "could not alloc settings for config trigger: %d\n",
+		       ret);
+		goto out;
+	}
+
+	dev_info(dev, "reset\n");
+	ret = count;
+
+out:
+	mutex_unlock(&test_dev->config_mutex);
+	mutex_unlock(&test_dev->trigger_mutex);
+
+	return ret;
+}
+static DEVICE_ATTR_WO(reset);
+
+static int test_dev_config_update_uint_sync(struct kmod_test_device *test_dev,
+					    const char *buf, size_t size,
+					    unsigned int *config,
+					    int (*test_sync)(struct kmod_test_device *test_dev))
+{
+	int ret;
+	long new;
+	unsigned int old_val;
+
+	ret = kstrtol(buf, 10, &new);
+	if (ret)
+		return ret;
+
+	if (new > UINT_MAX)
+		return -EINVAL;
+
+	mutex_lock(&test_dev->config_mutex);
+
+	old_val = *config;
+	*(unsigned int *)config = new;
+
+	ret = test_sync(test_dev);
+	if (ret) {
+		*(unsigned int *)config = old_val;
+
+		ret = test_sync(test_dev);
+		WARN_ON(ret);
+
+		mutex_unlock(&test_dev->config_mutex);
+		return -EINVAL;
+	}
+
+	mutex_unlock(&test_dev->config_mutex);
+	/* Always return full write size even if we didn't consume all */
+	return size;
+}
+
+static int test_dev_config_update_uint_range(struct kmod_test_device *test_dev,
+					     const char *buf, size_t size,
+					     unsigned int *config,
+					     unsigned int min,
+					     unsigned int max)
+{
+	int ret;
+	long new;
+
+	ret = kstrtol(buf, 10, &new);
+	if (ret)
+		return ret;
+
+	if (new < min || new >  max || new > UINT_MAX)
+		return -EINVAL;
+
+	mutex_lock(&test_dev->config_mutex);
+	*config = new;
+	mutex_unlock(&test_dev->config_mutex);
+
+	/* Always return full write size even if we didn't consume all */
+	return size;
+}
+
+static int test_dev_config_update_int(struct kmod_test_device *test_dev,
+				      const char *buf, size_t size,
+				      int *config)
+{
+	int ret;
+	long new;
+
+	ret = kstrtol(buf, 10, &new);
+	if (ret)
+		return ret;
+
+	if (new > INT_MAX || new < INT_MIN)
+		return -EINVAL;
+
+	mutex_lock(&test_dev->config_mutex);
+	*config = new;
+	mutex_unlock(&test_dev->config_mutex);
+	/* Always return full write size even if we didn't consume all */
+	return size;
+}
+
+static ssize_t test_dev_config_show_int(struct kmod_test_device *test_dev,
+					char *buf,
+					int config)
+{
+	int val;
+
+	mutex_lock(&test_dev->config_mutex);
+	val = config;
+	mutex_unlock(&test_dev->config_mutex);
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", val);
+}
+
+static ssize_t test_dev_config_show_uint(struct kmod_test_device *test_dev,
+					 char *buf,
+					 unsigned int config)
+{
+	unsigned int val;
+
+	mutex_lock(&test_dev->config_mutex);
+	val = config;
+	mutex_unlock(&test_dev->config_mutex);
+
+	return snprintf(buf, PAGE_SIZE, "%u\n", val);
+}
+
+static ssize_t test_result_store(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf, size_t count)
+{
+	struct kmod_test_device *test_dev = dev_to_test_dev(dev);
+	struct test_config *config = &test_dev->config;
+
+	return test_dev_config_update_int(test_dev, buf, count,
+					  &config->test_result);
+}
+
+static ssize_t config_num_threads_store(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t count)
+{
+	struct kmod_test_device *test_dev = dev_to_test_dev(dev);
+	struct test_config *config = &test_dev->config;
+
+	return test_dev_config_update_uint_sync(test_dev, buf, count,
+						&config->num_threads,
+						kmod_config_sync_info);
+}
+
+static ssize_t config_num_threads_show(struct device *dev,
+				       struct device_attribute *attr,
+				       char *buf)
+{
+	struct kmod_test_device *test_dev = dev_to_test_dev(dev);
+	struct test_config *config = &test_dev->config;
+
+	return test_dev_config_show_int(test_dev, buf, config->num_threads);
+}
+static DEVICE_ATTR(config_num_threads, 0644, config_num_threads_show,
+		   config_num_threads_store);
+
+static ssize_t config_test_case_store(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t count)
+{
+	struct kmod_test_device *test_dev = dev_to_test_dev(dev);
+	struct test_config *config = &test_dev->config;
+
+	return test_dev_config_update_uint_range(test_dev, buf, count,
+						 &config->test_case,
+						 __TEST_KMOD_INVALID + 1,
+						 __TEST_KMOD_MAX - 1);
+}
+
+static ssize_t config_test_case_show(struct device *dev,
+				     struct device_attribute *attr,
+				     char *buf)
+{
+	struct kmod_test_device *test_dev = dev_to_test_dev(dev);
+	struct test_config *config = &test_dev->config;
+
+	return test_dev_config_show_uint(test_dev, buf, config->test_case);
+}
+static DEVICE_ATTR(config_test_case, 0644, config_test_case_show,
+		   config_test_case_store);
+
+static ssize_t test_result_show(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	struct kmod_test_device *test_dev = dev_to_test_dev(dev);
+	struct test_config *config = &test_dev->config;
+
+	return test_dev_config_show_int(test_dev, buf, config->test_result);
+}
+static DEVICE_ATTR(test_result, 0644, test_result_show, test_result_store);
+
+#define TEST_KMOD_DEV_ATTR(name)		&dev_attr_##name.attr
+
+static struct attribute *test_dev_attrs[] = {
+	TEST_KMOD_DEV_ATTR(trigger_config),
+	TEST_KMOD_DEV_ATTR(config),
+	TEST_KMOD_DEV_ATTR(reset),
+
+	TEST_KMOD_DEV_ATTR(config_test_driver),
+	TEST_KMOD_DEV_ATTR(config_test_fs),
+	TEST_KMOD_DEV_ATTR(config_num_threads),
+	TEST_KMOD_DEV_ATTR(config_test_case),
+	TEST_KMOD_DEV_ATTR(test_result),
+
+	NULL,
+};
+
+ATTRIBUTE_GROUPS(test_dev);
+
+static int kmod_config_init(struct kmod_test_device *test_dev)
+{
+	int ret;
+
+	mutex_lock(&test_dev->config_mutex);
+	ret = __kmod_config_init(test_dev);
+	mutex_unlock(&test_dev->config_mutex);
+
+	return ret;
+}
+
+static struct kmod_test_device *alloc_test_dev_kmod(int idx)
+{
+	int ret;
+	struct kmod_test_device *test_dev;
+	struct miscdevice *misc_dev;
+
+	test_dev = vzalloc(sizeof(struct kmod_test_device));
+	if (!test_dev) {
+		pr_err("Cannot alloc test_dev\n");
+		goto err_out;
+	}
+
+	mutex_init(&test_dev->config_mutex);
+	mutex_init(&test_dev->trigger_mutex);
+	mutex_init(&test_dev->thread_mutex);
+
+	init_completion(&test_dev->kthreads_done);
+
+	ret = kmod_config_init(test_dev);
+	if (ret < 0) {
+		pr_err("Cannot alloc kmod_config_init()\n");
+		goto err_out_free;
+	}
+
+	test_dev->dev_idx = idx;
+	misc_dev = &test_dev->misc_dev;
+
+	misc_dev->minor = MISC_DYNAMIC_MINOR;
+	misc_dev->name = kasprintf(GFP_KERNEL, "test_kmod%d", idx);
+	if (!misc_dev->name) {
+		pr_err("Cannot alloc misc_dev->name\n");
+		goto err_out_free_config;
+	}
+	misc_dev->groups = test_dev_groups;
+
+	return test_dev;
+
+err_out_free_config:
+	free_test_dev_info(test_dev);
+	kmod_config_free(test_dev);
+err_out_free:
+	vfree(test_dev);
+	test_dev = NULL;
+err_out:
+	return NULL;
+}
+
+static void free_test_dev_kmod(struct kmod_test_device *test_dev)
+{
+	if (test_dev) {
+		kfree_const(test_dev->misc_dev.name);
+		test_dev->misc_dev.name = NULL;
+		free_test_dev_info(test_dev);
+		kmod_config_free(test_dev);
+		vfree(test_dev);
+		test_dev = NULL;
+	}
+}
+
+static struct kmod_test_device *register_test_dev_kmod(void)
+{
+	struct kmod_test_device *test_dev = NULL;
+	int ret;
+
+	mutex_unlock(&reg_dev_mutex);
+
+	/* int should suffice for number of devices, test for wrap */
+	if (unlikely(num_test_devs + 1) < 0) {
+		pr_err("reached limit of number of test devices\n");
+		goto out;
+	}
+
+	test_dev = alloc_test_dev_kmod(num_test_devs);
+	if (!test_dev)
+		goto out;
+
+	ret = misc_register(&test_dev->misc_dev);
+	if (ret) {
+		pr_err("could not register misc device: %d\n", ret);
+		free_test_dev_kmod(test_dev);
+		goto out;
+	}
+
+	test_dev->dev = test_dev->misc_dev.this_device;
+	list_add_tail(&test_dev->list, &reg_test_devs);
+	dev_info(test_dev->dev, "interface ready\n");
+
+	num_test_devs++;
+
+out:
+	mutex_unlock(&reg_dev_mutex);
+
+	return test_dev;
+
+}
+
+static int __init test_kmod_init(void)
+{
+	struct kmod_test_device *test_dev;
+	int ret;
+
+	test_dev = register_test_dev_kmod();
+	if (!test_dev) {
+		pr_err("Cannot add first test kmod device\n");
+		return -ENODEV;
+	}
+
+	/*
+	 * With some work we might be able to gracefully enable
+	 * testing with this driver built-in, for now this seems
+	 * rather risky. For those willing to try have at it,
+	 * and enable the below. Good luck! If that works, try
+	 * lowering the init level for more fun.
+	 */
+	if (force_init_test) {
+		ret = trigger_config_run_type(test_dev,
+					      TEST_KMOD_DRIVER, "tun");
+		if (WARN_ON(ret))
+			return ret;
+		ret = trigger_config_run_type(test_dev,
+					      TEST_KMOD_FS_TYPE, "btrfs");
+		if (WARN_ON(ret))
+			return ret;
+	}
+
+	return 0;
+}
+late_initcall(test_kmod_init);
+
+static
+void unregister_test_dev_kmod(struct kmod_test_device *test_dev)
+{
+	mutex_lock(&test_dev->trigger_mutex);
+	mutex_lock(&test_dev->config_mutex);
+
+	test_dev_kmod_stop_tests(test_dev);
+
+	dev_info(test_dev->dev, "removing interface\n");
+	misc_deregister(&test_dev->misc_dev);
+	kfree(&test_dev->misc_dev.name);
+
+	mutex_unlock(&test_dev->config_mutex);
+	mutex_unlock(&test_dev->trigger_mutex);
+
+	free_test_dev_kmod(test_dev);
+}
+
+static void __exit test_kmod_exit(void)
+{
+	struct kmod_test_device *test_dev, *tmp;
+
+	mutex_lock(&reg_dev_mutex);
+	list_for_each_entry_safe(test_dev, tmp, &reg_test_devs, list) {
+		list_del(&test_dev->list);
+		unregister_test_dev_kmod(test_dev);
+	}
+	mutex_unlock(&reg_dev_mutex);
+}
+module_exit(test_kmod_exit);
+
+MODULE_AUTHOR("Luis R. Rodriguez <mcgrof@kernel.org>");
+MODULE_LICENSE("GPL");
diff -puN /dev/null tools/testing/selftests/kmod/Makefile
--- /dev/null
+++ a/tools/testing/selftests/kmod/Makefile
@@ -0,0 +1,11 @@
+# Makefile for kmod loading selftests
+
+# No binaries, but make sure arg-less "make" doesn't trigger "run_tests"
+all:
+
+TEST_PROGS := kmod.sh
+
+include ../lib.mk
+
+# Nothing to clean up.
+clean:
diff -puN /dev/null tools/testing/selftests/kmod/config
--- /dev/null
+++ a/tools/testing/selftests/kmod/config
@@ -0,0 +1,7 @@
+CONFIG_TEST_KMOD=m
+CONFIG_TEST_LKM=m
+CONFIG_XFS_FS=m
+
+# For the module parameter force_init_test is used
+CONFIG_TUN=m
+CONFIG_BTRFS_FS=m
diff -puN /dev/null tools/testing/selftests/kmod/kmod.sh
--- /dev/null
+++ a/tools/testing/selftests/kmod/kmod.sh
@@ -0,0 +1,635 @@
+#!/bin/bash
+#
+# Copyright (C) 2017 Luis R. Rodriguez <mcgrof@kernel.org>
+#
+# This program is free software; you can redistribute it and/or modify it
+# under the terms of the GNU General Public License as published by the Free
+# Software Foundation; either version 2 of the License, or at your option any
+# later version; or, when distributed separately from the Linux kernel or
+# when incorporated into other software packages, subject to the following
+# license:
+#
+# This program is free software; you can redistribute it and/or modify it
+# under the terms of copyleft-next (version 0.3.1 or later) as published
+# at http://copyleft-next.org/.
+
+# This is a stress test script for kmod, the kernel module loader. It uses
+# test_kmod which exposes a series of knobs for the API for us so we can
+# tweak each test in userspace rather than in kernelspace.
+#
+# The way kmod works is it uses the kernel's usermode helper API to eventually
+# call /sbin/modprobe. It has a limit of the number of concurrent calls
+# possible. The kernel interface to load modules is request_module(), however
+# mount uses get_fs_type(). Both behave slightly differently, but the
+# differences are important enough to test each call separately. For this
+# reason test_kmod starts by providing tests for both calls.
+#
+# The test driver test_kmod assumes a series of defaults which you can
+# override by exporting to your environment prior running this script.
+# For instance this script assumes you do not have xfs loaded upon boot.
+# If this is false, export DEFAULT_KMOD_FS="ext4" prior to running this
+# script if the filesyste module you don't have loaded upon bootup
+# is ext4 instead. Refer to allow_user_defaults() for a list of user
+# override variables possible.
+#
+# You'll want at least 4 GiB of RAM to expect to run these tests
+# without running out of memory on them. For other requirements refer
+# to test_reqs()
+
+set -e
+
+TEST_NAME="kmod"
+TEST_DRIVER="test_${TEST_NAME}"
+TEST_DIR=$(dirname $0)
+
+# This represents
+#
+# TEST_ID:TEST_COUNT:ENABLED
+#
+# TEST_ID: is the test id number
+# TEST_COUNT: number of times we should run the test
+# ENABLED: 1 if enabled, 0 otherwise
+#
+# Once these are enabled please leave them as-is. Write your own test,
+# we have tons of space.
+ALL_TESTS="0001:3:1"
+ALL_TESTS="$ALL_TESTS 0002:3:1"
+ALL_TESTS="$ALL_TESTS 0003:1:1"
+ALL_TESTS="$ALL_TESTS 0004:1:1"
+ALL_TESTS="$ALL_TESTS 0005:10:1"
+ALL_TESTS="$ALL_TESTS 0006:10:1"
+ALL_TESTS="$ALL_TESTS 0007:5:1"
+
+# Disabled tests:
+#
+# 0008 x 150 -  multithreaded - push kmod_concurrent over max_modprobes for request_module()"
+# Current best-effort failure interpretation:
+# Enough module requests get loaded in place fast enough to reach over the
+# max_modprobes limit and trigger a failure -- before we're even able to
+# start processing pending requests.
+ALL_TESTS="$ALL_TESTS 0008:150:0"
+
+# 0009 x 150 - multithreaded - push kmod_concurrent over max_modprobes for get_fs_type()"
+# Current best-effort failure interpretation:
+#
+# get_fs_type() requests modules using aliases as such the optimization in
+# place today to look for already loaded modules will not take effect and
+# we end up requesting a new module to load, this bumps the kmod_concurrent,
+# and in certain circumstances can lead to pushing the kmod_concurrent over
+# the max_modprobe limit.
+#
+# This test fails much easier than test 0008 since the alias optimizations
+# are not in place.
+ALL_TESTS="$ALL_TESTS 0009:150:0"
+
+test_modprobe()
+{
+       if [ ! -d $DIR ]; then
+               echo "$0: $DIR not present" >&2
+               echo "You must have the following enabled in your kernel:" >&2
+               cat $TEST_DIR/config >&2
+               exit 1
+       fi
+}
+
+function allow_user_defaults()
+{
+	if [ -z $DEFAULT_KMOD_DRIVER ]; then
+		DEFAULT_KMOD_DRIVER="test_module"
+	fi
+
+	if [ -z $DEFAULT_KMOD_FS ]; then
+		DEFAULT_KMOD_FS="xfs"
+	fi
+
+	if [ -z $PROC_DIR ]; then
+		PROC_DIR="/proc/sys/kernel/"
+	fi
+
+	if [ -z $MODPROBE_LIMIT ]; then
+		MODPROBE_LIMIT=50
+	fi
+
+	if [ -z $DIR ]; then
+		DIR="/sys/devices/virtual/misc/${TEST_DRIVER}0/"
+	fi
+
+	if [ -z $DEFAULT_NUM_TESTS ]; then
+		DEFAULT_NUM_TESTS=150
+	fi
+
+	MODPROBE_LIMIT_FILE="${PROC_DIR}/kmod-limit"
+}
+
+test_reqs()
+{
+	if ! which modprobe 2> /dev/null > /dev/null; then
+		echo "$0: You need modprobe installed" >&2
+		exit 1
+	fi
+
+	if ! which kmod 2> /dev/null > /dev/null; then
+		echo "$0: You need kmod installed" >&2
+		exit 1
+	fi
+
+	# kmod 19 has a bad bug where it returns 0 when modprobe
+	# gets called *even* if the module was not loaded due to
+	# some bad heuristics. For details see:
+	#
+	# A work around is possible in-kernel but its rather
+	# complex.
+	KMOD_VERSION=$(kmod --version | awk '{print $3}')
+	if [[ $KMOD_VERSION  -le 19 ]]; then
+		echo "$0: You need at least kmod 20" >&2
+		echo "kmod <= 19 is buggy, for details see:" >&2
+		echo "http://git.kernel.org/cgit/utils/kernel/kmod/kmod.git/commit/libkmod/libkmod-module.c?id=fd44a98ae2eb5eb32161088954ab21e58e19dfc4" >&2
+		exit 1
+	fi
+
+	uid=$(id -u)
+	if [ $uid -ne 0 ]; then
+		echo $msg must be run as root >&2
+		exit 0
+	fi
+}
+
+function load_req_mod()
+{
+	trap "test_modprobe" EXIT
+
+	if [ ! -d $DIR ]; then
+		# Alanis: "Oh isn't it ironic?"
+		modprobe $TEST_DRIVER
+	fi
+}
+
+test_finish()
+{
+	echo "Test completed"
+}
+
+errno_name_to_val()
+{
+	case "$1" in
+	# kmod calls modprobe and upon of a module not found
+	# modprobe returns just 1... However in the kernel we
+	# *sometimes* see 256...
+	MODULE_NOT_FOUND)
+		echo 256;;
+	SUCCESS)
+		echo 0;;
+	-EPERM)
+		echo -1;;
+	-ENOENT)
+		echo -2;;
+	-EINVAL)
+		echo -22;;
+	-ERR_ANY)
+		echo -123456;;
+	*)
+		echo invalid;;
+	esac
+}
+
+errno_val_to_name()
+	case "$1" in
+	256)
+		echo MODULE_NOT_FOUND;;
+	0)
+		echo SUCCESS;;
+	-1)
+		echo -EPERM;;
+	-2)
+		echo -ENOENT;;
+	-22)
+		echo -EINVAL;;
+	-123456)
+		echo -ERR_ANY;;
+	*)
+		echo invalid;;
+	esac
+
+config_set_test_case_driver()
+{
+	if ! echo -n 1 >$DIR/config_test_case; then
+		echo "$0: Unable to set to test case to driver" >&2
+		exit 1
+	fi
+}
+
+config_set_test_case_fs()
+{
+	if ! echo -n 2 >$DIR/config_test_case; then
+		echo "$0: Unable to set to test case to fs" >&2
+		exit 1
+	fi
+}
+
+config_num_threads()
+{
+	if ! echo -n $1 >$DIR/config_num_threads; then
+		echo "$0: Unable to set to number of threads" >&2
+		exit 1
+	fi
+}
+
+config_get_modprobe_limit()
+{
+	if [[ -f ${MODPROBE_LIMIT_FILE} ]] ; then
+		MODPROBE_LIMIT=$(cat $MODPROBE_LIMIT_FILE)
+	fi
+	echo $MODPROBE_LIMIT
+}
+
+config_num_thread_limit_extra()
+{
+	MODPROBE_LIMIT=$(config_get_modprobe_limit)
+	let EXTRA_LIMIT=$MODPROBE_LIMIT+$1
+	config_num_threads $EXTRA_LIMIT
+}
+
+# For special characters use printf directly,
+# refer to kmod_test_0001
+config_set_driver()
+{
+	if ! echo -n $1 >$DIR/config_test_driver; then
+		echo "$0: Unable to set driver" >&2
+		exit 1
+	fi
+}
+
+config_set_fs()
+{
+	if ! echo -n $1 >$DIR/config_test_fs; then
+		echo "$0: Unable to set driver" >&2
+		exit 1
+	fi
+}
+
+config_get_driver()
+{
+	cat $DIR/config_test_driver
+}
+
+config_get_test_result()
+{
+	cat $DIR/test_result
+}
+
+config_reset()
+{
+	if ! echo -n "1" >"$DIR"/reset; then
+		echo "$0: reset shuld have worked" >&2
+		exit 1
+	fi
+}
+
+config_show_config()
+{
+	echo "----------------------------------------------------"
+	cat "$DIR"/config
+	echo "----------------------------------------------------"
+}
+
+config_trigger()
+{
+	if ! echo -n "1" >"$DIR"/trigger_config 2>/dev/null; then
+		echo "$1: FAIL - loading should have worked"
+		config_show_config
+		exit 1
+	fi
+	echo "$1: OK! - loading kmod test"
+}
+
+config_trigger_want_fail()
+{
+	if echo "1" > $DIR/trigger_config 2>/dev/null; then
+		echo "$1: FAIL - test case was expected to fail"
+		config_show_config
+		exit 1
+	fi
+	echo "$1: OK! - kmod test case failed as expected"
+}
+
+config_expect_result()
+{
+	RC=$(config_get_test_result)
+	RC_NAME=$(errno_val_to_name $RC)
+
+	ERRNO_NAME=$2
+	ERRNO=$(errno_name_to_val $ERRNO_NAME)
+
+	if [[ $ERRNO_NAME = "-ERR_ANY" ]]; then
+		if [[ $RC -ge 0 ]]; then
+			echo "$1: FAIL, test expects $ERRNO_NAME - got $RC_NAME ($RC)" >&2
+			config_show_config
+			exit 1
+		fi
+	elif [[ $RC != $ERRNO ]]; then
+		echo "$1: FAIL, test expects $ERRNO_NAME ($ERRNO) - got $RC_NAME ($RC)" >&2
+		config_show_config
+		exit 1
+	fi
+	echo "$1: OK! - Return value: $RC ($RC_NAME), expected $ERRNO_NAME"
+}
+
+kmod_defaults_driver()
+{
+	config_reset
+	modprobe -r $DEFAULT_KMOD_DRIVER
+	config_set_driver $DEFAULT_KMOD_DRIVER
+}
+
+kmod_defaults_fs()
+{
+	config_reset
+	modprobe -r $DEFAULT_KMOD_FS
+	config_set_fs $DEFAULT_KMOD_FS
+	config_set_test_case_fs
+}
+
+kmod_test_0001_driver()
+{
+	NAME='\000'
+
+	kmod_defaults_driver
+	config_num_threads 1
+	printf '\000' >"$DIR"/config_test_driver
+	config_trigger ${FUNCNAME[0]}
+	config_expect_result ${FUNCNAME[0]} MODULE_NOT_FOUND
+}
+
+kmod_test_0001_fs()
+{
+	NAME='\000'
+
+	kmod_defaults_fs
+	config_num_threads 1
+	printf '\000' >"$DIR"/config_test_fs
+	config_trigger ${FUNCNAME[0]}
+	config_expect_result ${FUNCNAME[0]} -EINVAL
+}
+
+kmod_test_0001()
+{
+	kmod_test_0001_driver
+	kmod_test_0001_fs
+}
+
+kmod_test_0002_driver()
+{
+	NAME="nope-$DEFAULT_KMOD_DRIVER"
+
+	kmod_defaults_driver
+	config_set_driver $NAME
+	config_num_threads 1
+	config_trigger ${FUNCNAME[0]}
+	config_expect_result ${FUNCNAME[0]} MODULE_NOT_FOUND
+}
+
+kmod_test_0002_fs()
+{
+	NAME="nope-$DEFAULT_KMOD_FS"
+
+	kmod_defaults_fs
+	config_set_fs $NAME
+	config_trigger ${FUNCNAME[0]}
+	config_expect_result ${FUNCNAME[0]} -EINVAL
+}
+
+kmod_test_0002()
+{
+	kmod_test_0002_driver
+	kmod_test_0002_fs
+}
+
+kmod_test_0003()
+{
+	kmod_defaults_fs
+	config_num_threads 1
+	config_trigger ${FUNCNAME[0]}
+	config_expect_result ${FUNCNAME[0]} SUCCESS
+}
+
+kmod_test_0004()
+{
+	kmod_defaults_fs
+	config_num_threads 2
+	config_trigger ${FUNCNAME[0]}
+	config_expect_result ${FUNCNAME[0]} SUCCESS
+}
+
+kmod_test_0005()
+{
+	kmod_defaults_driver
+	config_trigger ${FUNCNAME[0]}
+	config_expect_result ${FUNCNAME[0]} SUCCESS
+}
+
+kmod_test_0006()
+{
+	kmod_defaults_fs
+	config_trigger ${FUNCNAME[0]}
+	config_expect_result ${FUNCNAME[0]} SUCCESS
+}
+
+kmod_test_0007()
+{
+	kmod_test_0005
+	kmod_test_0006
+}
+
+kmod_test_0008()
+{
+	kmod_defaults_driver
+	MODPROBE_LIMIT=$(config_get_modprobe_limit)
+	let EXTRA=$MODPROBE_LIMIT/6
+	config_num_thread_limit_extra $EXTRA
+	config_trigger ${FUNCNAME[0]}
+	config_expect_result ${FUNCNAME[0]} SUCCESS
+}
+
+kmod_test_0009()
+{
+	kmod_defaults_fs
+	MODPROBE_LIMIT=$(config_get_modprobe_limit)
+	let EXTRA=$MODPROBE_LIMIT/4
+	config_num_thread_limit_extra $EXTRA
+	config_trigger ${FUNCNAME[0]}
+	config_expect_result ${FUNCNAME[0]} SUCCESS
+}
+
+list_tests()
+{
+	echo "Test ID list:"
+	echo
+	echo "TEST_ID x NUM_TEST"
+	echo "TEST_ID:   Test ID"
+	echo "NUM_TESTS: Number of recommended times to run the test"
+	echo
+	echo "0001 x $(get_test_count 0001) - Simple test - 1 thread  for empty string"
+	echo "0002 x $(get_test_count 0002) - Simple test - 1 thread  for modules/filesystems that do not exist"
+	echo "0003 x $(get_test_count 0003) - Simple test - 1 thread  for get_fs_type() only"
+	echo "0004 x $(get_test_count 0004) - Simple test - 2 threads for get_fs_type() only"
+	echo "0005 x $(get_test_count 0005) - multithreaded tests with default setup - request_module() only"
+	echo "0006 x $(get_test_count 0006) - multithreaded tests with default setup - get_fs_type() only"
+	echo "0007 x $(get_test_count 0007) - multithreaded tests with default setup test request_module() and get_fs_type()"
+	echo "0008 x $(get_test_count 0008) - multithreaded - push kmod_concurrent over max_modprobes for request_module()"
+	echo "0009 x $(get_test_count 0009) - multithreaded - push kmod_concurrent over max_modprobes for get_fs_type()"
+}
+
+usage()
+{
+	NUM_TESTS=$(grep -o ' ' <<<"$ALL_TESTS" | grep -c .)
+	let NUM_TESTS=$NUM_TESTS+1
+	MAX_TEST=$(printf "%04d\n" $NUM_TESTS)
+	echo "Usage: $0 [ -t <4-number-digit> ] | [ -w <4-number-digit> ] |"
+	echo "		 [ -s <4-number-digit> ] | [ -c <4-number-digit> <test- count>"
+	echo "           [ all ] [ -h | --help ] [ -l ]"
+	echo ""
+	echo "Valid tests: 0001-$MAX_TEST"
+	echo ""
+	echo "    all     Runs all tests (default)"
+	echo "    -t      Run test ID the number amount of times is recommended"
+	echo "    -w      Watch test ID run until it runs into an error"
+	echo "    -c      Run test ID once"
+	echo "    -s      Run test ID x test-count number of times"
+	echo "    -l      List all test ID list"
+	echo " -h|--help  Help"
+	echo
+	echo "If an error every occurs execution will immediately terminate."
+	echo "If you are adding a new test try using -w <test-ID> first to"
+	echo "make sure the test passes a series of tests."
+	echo
+	echo Example uses:
+	echo
+	echo "${TEST_NAME}.sh		-- executes all tests"
+	echo "${TEST_NAME}.sh -t 0008	-- Executes test ID 0008 number of times is recomended"
+	echo "${TEST_NAME}.sh -w 0008	-- Watch test ID 0008 run until an error occurs"
+	echo "${TEST_NAME}.sh -s 0008	-- Run test ID 0008 once"
+	echo "${TEST_NAME}.sh -c 0008 3	-- Run test ID 0008 three times"
+	echo
+	list_tests
+	exit 1
+}
+
+function test_num()
+{
+	re='^[0-9]+$'
+	if ! [[ $1 =~ $re ]]; then
+		usage
+	fi
+}
+
+function get_test_count()
+{
+	test_num $1
+	TEST_DATA=$(echo $ALL_TESTS | awk '{print $'$1'}')
+	LAST_TWO=${TEST_DATA#*:*}
+	echo ${LAST_TWO%:*}
+}
+
+function get_test_enabled()
+{
+	test_num $1
+	TEST_DATA=$(echo $ALL_TESTS | awk '{print $'$1'}')
+	echo ${TEST_DATA#*:*:}
+}
+
+function run_all_tests()
+{
+	for i in $ALL_TESTS ; do
+		TEST_ID=${i%:*:*}
+		ENABLED=$(get_test_enabled $TEST_ID)
+		TEST_COUNT=$(get_test_count $TEST_ID)
+		if [[ $ENABLED -eq "1" ]]; then
+			test_case $TEST_ID $TEST_COUNT
+		fi
+	done
+}
+
+function watch_log()
+{
+	if [ $# -ne 3 ]; then
+		clear
+	fi
+	date
+	echo "Running test: $2 - run #$1"
+}
+
+function watch_case()
+{
+	i=0
+	while [ 1 ]; do
+
+		if [ $# -eq 1 ]; then
+			test_num $1
+			watch_log $i ${TEST_NAME}_test_$1
+			${TEST_NAME}_test_$1
+		else
+			watch_log $i all
+			run_all_tests
+		fi
+		let i=$i+1
+	done
+}
+
+function test_case()
+{
+	NUM_TESTS=$DEFAULT_NUM_TESTS
+	if [ $# -eq 2 ]; then
+		NUM_TESTS=$2
+	fi
+
+	i=0
+	while [ $i -lt $NUM_TESTS ]; do
+		test_num $1
+		watch_log $i ${TEST_NAME}_test_$1 noclear
+		RUN_TEST=${TEST_NAME}_test_$1
+		$RUN_TEST
+		let i=$i+1
+	done
+}
+
+function parse_args()
+{
+	if [ $# -eq 0 ]; then
+		run_all_tests
+	else
+		if [[ "$1" = "all" ]]; then
+			run_all_tests
+		elif [[ "$1" = "-w" ]]; then
+			shift
+			watch_case $@
+		elif [[ "$1" = "-t" ]]; then
+			shift
+			test_num $1
+			test_case $1 $(get_test_count $1)
+		elif [[ "$1" = "-c" ]]; then
+			shift
+			test_num $1
+			test_num $2
+			test_case $1 $2
+		elif [[ "$1" = "-s" ]]; then
+			shift
+			test_case $1 1
+		elif [[ "$1" = "-l" ]]; then
+			list_tests
+		elif [[ "$1" = "-h" || "$1" = "--help" ]]; then
+			usage
+		else
+			usage
+		fi
+	fi
+}
+
+test_reqs
+allow_user_defaults
+load_req_mod
+
+trap "test_finish" EXIT
+
+parse_args $@
+
+exit 0
_
