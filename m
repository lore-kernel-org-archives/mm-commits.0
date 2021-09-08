Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F6A5C433FE
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:56:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CDE461100
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:56:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347371AbhIHC6E (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:58:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:55148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234389AbhIHC6B (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:58:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B77B61131;
        Wed,  8 Sep 2021 02:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069814;
        bh=lBi52PXgAcsLGusVvIqux0Tu8qzFp5WQbdz5C3gwF/w=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=2XM/xe0i1uEVvv7Dsi+YC9NJbhZ/PdQ0r77UssTyonzLASmrnkrqjYcCtRDteB/zN
         ZhuFpQ8uGm8lulz5cvzGWRYYOaCY37aHLJhcmP86Brg5yruP7r75iOEJFSnlGPgctU
         NwgFPFQVPffd9GIf9ayaCl5/TMpGRPBWjHjyXvFg=
Date:   Tue, 07 Sep 2021 19:56:53 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alexander.shishkin@linux.intel.com,
        amit@kernel.org, benh@kernel.crashing.org,
        brendanhiggins@google.com, corbet@lwn.net, david@redhat.com,
        dwmw@amazon.com, elver@google.com, fan.du@intel.com,
        foersleo@amazon.de, greg@kroah.com, gthelen@google.com,
        joe@perches.com, Jonathan.Cameron@huawei.com, linux-mm@kvack.org,
        markubo@amazon.de, mgorman@suse.de, mheyne@amazon.de,
        minchan@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org,
        namhyung@kernel.org, peterz@infradead.org, riel@surriel.com,
        rientjes@google.com, rostedt@goodmis.org, shakeelb@google.com,
        shuah@kernel.org, sieberf@amazon.com, sjpark@amazon.de,
        torvalds@linux-foundation.org, vbabka@suse.cz,
        vdavydov.dev@gmail.com
Subject:  [patch 069/147] mm/damon: implement a debugfs-based user
 space interface
Message-ID: <20210908025653.p441_s1xD%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: SeongJae Park <sjpark@amazon.de>
Subject: mm/damon: implement a debugfs-based user space interface

DAMON is designed to be used by kernel space code such as the memory
management subsystems, and therefore it provides only kernel space API. 
That said, letting the user space control DAMON could provide some
benefits to them.  For example, it will allow user space to analyze their
specific workloads and make their own special optimizations.

For such cases, this commit implements a simple DAMON application kernel
module, namely 'damon-dbgfs', which merely wraps the DAMON api and exports
those to the user space via the debugfs.

'damon-dbgfs' exports three files, ``attrs``, ``target_ids``, and
``monitor_on`` under its debugfs directory, ``<debugfs>/damon/``.

Attributes
----------

Users can read and write the ``sampling interval``, ``aggregation
interval``, ``regions update interval``, and min/max number of monitoring
target regions by reading from and writing to the ``attrs`` file.  For
example, below commands set those values to 5 ms, 100 ms, 1,000 ms, 10,
1000 and check it again::

    # cd <debugfs>/damon
    # echo 5000 100000 1000000 10 1000 > attrs
    # cat attrs
    5000 100000 1000000 10 1000

Target IDs
----------

Some types of address spaces supports multiple monitoring target.  For
example, the virtual memory address spaces monitoring can have multiple
processes as the monitoring targets.  Users can set the targets by writing
relevant id values of the targets to, and get the ids of the current
targets by reading from the ``target_ids`` file.  In case of the virtual
address spaces monitoring, the values should be pids of the monitoring
target processes.  For example, below commands set processes having pids
42 and 4242 as the monitoring targets and check it again::

    # cd <debugfs>/damon
    # echo 42 4242 > target_ids
    # cat target_ids
    42 4242

Note that setting the target ids doesn't start the monitoring.

Turning On/Off
--------------

Setting the files as described above doesn't incur effect unless you
explicitly start the monitoring.  You can start, stop, and check the
current status of the monitoring by writing to and reading from the
``monitor_on`` file.  Writing ``on`` to the file starts the monitoring of
the targets with the attributes.  Writing ``off`` to the file stops those.
DAMON also stops if every targets are invalidated (in case of the virtual
memory monitoring, target processes are invalidated when terminated). 
Below example commands turn on, off, and check the status of DAMON::

    # cd <debugfs>/damon
    # echo on > monitor_on
    # echo off > monitor_on
    # cat monitor_on
    off

Please note that you cannot write to the above-mentioned debugfs files
while the monitoring is turned on.  If you write to the files while DAMON
is running, an error code such as ``-EBUSY`` will be returned.

[akpm@linux-foundation.org: remove unneeded "alloc failed" printks]
[akpm@linux-foundation.org: replace macro with static inline]
Link: https://lkml.kernel.org/r/20210716081449.22187-8-sj38.park@gmail.com
Signed-off-by: SeongJae Park <sjpark@amazon.de>
Reviewed-by: Leonard Foerster <foersleo@amazon.de>
Reviewed-by: Fernand Sieber <sieberf@amazon.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Amit Shah <amit@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: David Woodhouse <dwmw@amazon.com>
Cc: Fan Du <fan.du@intel.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joe Perches <joe@perches.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Marco Elver <elver@google.com>
Cc: Markus Boehme <markubo@amazon.de>
Cc: Maximilian Heyne <mheyne@amazon.de>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    3 
 mm/damon/Kconfig      |    9 
 mm/damon/Makefile     |    1 
 mm/damon/core.c       |   47 ++++
 mm/damon/dbgfs.c      |  397 ++++++++++++++++++++++++++++++++++++++++
 5 files changed, 457 insertions(+)

--- a/include/linux/damon.h~mm-damon-implement-a-debugfs-based-user-space-interface
+++ a/include/linux/damon.h
@@ -240,9 +240,12 @@ unsigned int damon_nr_regions(struct dam
 
 struct damon_ctx *damon_new_ctx(void);
 void damon_destroy_ctx(struct damon_ctx *ctx);
+int damon_set_targets(struct damon_ctx *ctx,
+		unsigned long *ids, ssize_t nr_ids);
 int damon_set_attrs(struct damon_ctx *ctx, unsigned long sample_int,
 		unsigned long aggr_int, unsigned long primitive_upd_int,
 		unsigned long min_nr_reg, unsigned long max_nr_reg);
+int damon_nr_running_ctxs(void);
 
 int damon_start(struct damon_ctx **ctxs, int nr_ctxs);
 int damon_stop(struct damon_ctx **ctxs, int nr_ctxs);
--- a/mm/damon/core.c~mm-damon-implement-a-debugfs-based-user-space-interface
+++ a/mm/damon/core.c
@@ -172,6 +172,39 @@ void damon_destroy_ctx(struct damon_ctx
 }
 
 /**
+ * damon_set_targets() - Set monitoring targets.
+ * @ctx:	monitoring context
+ * @ids:	array of target ids
+ * @nr_ids:	number of entries in @ids
+ *
+ * This function should not be called while the kdamond is running.
+ *
+ * Return: 0 on success, negative error code otherwise.
+ */
+int damon_set_targets(struct damon_ctx *ctx,
+		      unsigned long *ids, ssize_t nr_ids)
+{
+	ssize_t i;
+	struct damon_target *t, *next;
+
+	damon_destroy_targets(ctx);
+
+	for (i = 0; i < nr_ids; i++) {
+		t = damon_new_target(ids[i]);
+		if (!t) {
+			pr_err("Failed to alloc damon_target\n");
+			/* The caller should do cleanup of the ids itself */
+			damon_for_each_target_safe(t, next, ctx)
+				damon_destroy_target(t);
+			return -ENOMEM;
+		}
+		damon_add_target(ctx, t);
+	}
+
+	return 0;
+}
+
+/**
  * damon_set_attrs() - Set attributes for the monitoring.
  * @ctx:		monitoring context
  * @sample_int:		time interval between samplings
@@ -209,6 +242,20 @@ int damon_set_attrs(struct damon_ctx *ct
 	return 0;
 }
 
+/**
+ * damon_nr_running_ctxs() - Return number of currently running contexts.
+ */
+int damon_nr_running_ctxs(void)
+{
+	int nr_ctxs;
+
+	mutex_lock(&damon_lock);
+	nr_ctxs = nr_running_ctxs;
+	mutex_unlock(&damon_lock);
+
+	return nr_ctxs;
+}
+
 /* Returns the size upper limit for each monitoring region */
 static unsigned long damon_region_sz_limit(struct damon_ctx *ctx)
 {
--- /dev/null
+++ a/mm/damon/dbgfs.c
@@ -0,0 +1,397 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * DAMON Debugfs Interface
+ *
+ * Author: SeongJae Park <sjpark@amazon.de>
+ */
+
+#define pr_fmt(fmt) "damon-dbgfs: " fmt
+
+#include <linux/damon.h>
+#include <linux/debugfs.h>
+#include <linux/file.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/page_idle.h>
+#include <linux/slab.h>
+
+static struct damon_ctx **dbgfs_ctxs;
+static int dbgfs_nr_ctxs;
+static struct dentry **dbgfs_dirs;
+
+/*
+ * Returns non-empty string on success, negative error code otherwise.
+ */
+static char *user_input_str(const char __user *buf, size_t count, loff_t *ppos)
+{
+	char *kbuf;
+	ssize_t ret;
+
+	/* We do not accept continuous write */
+	if (*ppos)
+		return ERR_PTR(-EINVAL);
+
+	kbuf = kmalloc(count + 1, GFP_KERNEL);
+	if (!kbuf)
+		return ERR_PTR(-ENOMEM);
+
+	ret = simple_write_to_buffer(kbuf, count + 1, ppos, buf, count);
+	if (ret != count) {
+		kfree(kbuf);
+		return ERR_PTR(-EIO);
+	}
+	kbuf[ret] = '\0';
+
+	return kbuf;
+}
+
+static ssize_t dbgfs_attrs_read(struct file *file,
+		char __user *buf, size_t count, loff_t *ppos)
+{
+	struct damon_ctx *ctx = file->private_data;
+	char kbuf[128];
+	int ret;
+
+	mutex_lock(&ctx->kdamond_lock);
+	ret = scnprintf(kbuf, ARRAY_SIZE(kbuf), "%lu %lu %lu %lu %lu\n",
+			ctx->sample_interval, ctx->aggr_interval,
+			ctx->primitive_update_interval, ctx->min_nr_regions,
+			ctx->max_nr_regions);
+	mutex_unlock(&ctx->kdamond_lock);
+
+	return simple_read_from_buffer(buf, count, ppos, kbuf, ret);
+}
+
+static ssize_t dbgfs_attrs_write(struct file *file,
+		const char __user *buf, size_t count, loff_t *ppos)
+{
+	struct damon_ctx *ctx = file->private_data;
+	unsigned long s, a, r, minr, maxr;
+	char *kbuf;
+	ssize_t ret = count;
+	int err;
+
+	kbuf = user_input_str(buf, count, ppos);
+	if (IS_ERR(kbuf))
+		return PTR_ERR(kbuf);
+
+	if (sscanf(kbuf, "%lu %lu %lu %lu %lu",
+				&s, &a, &r, &minr, &maxr) != 5) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	mutex_lock(&ctx->kdamond_lock);
+	if (ctx->kdamond) {
+		ret = -EBUSY;
+		goto unlock_out;
+	}
+
+	err = damon_set_attrs(ctx, s, a, r, minr, maxr);
+	if (err)
+		ret = err;
+unlock_out:
+	mutex_unlock(&ctx->kdamond_lock);
+out:
+	kfree(kbuf);
+	return ret;
+}
+
+static inline bool targetid_is_pid(const struct damon_ctx *ctx)
+{
+	return ctx->primitive.target_valid == damon_va_target_valid;
+}
+
+static ssize_t sprint_target_ids(struct damon_ctx *ctx, char *buf, ssize_t len)
+{
+	struct damon_target *t;
+	unsigned long id;
+	int written = 0;
+	int rc;
+
+	damon_for_each_target(t, ctx) {
+		id = t->id;
+		if (targetid_is_pid(ctx))
+			/* Show pid numbers to debugfs users */
+			id = (unsigned long)pid_vnr((struct pid *)id);
+
+		rc = scnprintf(&buf[written], len - written, "%lu ", id);
+		if (!rc)
+			return -ENOMEM;
+		written += rc;
+	}
+	if (written)
+		written -= 1;
+	written += scnprintf(&buf[written], len - written, "\n");
+	return written;
+}
+
+static ssize_t dbgfs_target_ids_read(struct file *file,
+		char __user *buf, size_t count, loff_t *ppos)
+{
+	struct damon_ctx *ctx = file->private_data;
+	ssize_t len;
+	char ids_buf[320];
+
+	mutex_lock(&ctx->kdamond_lock);
+	len = sprint_target_ids(ctx, ids_buf, 320);
+	mutex_unlock(&ctx->kdamond_lock);
+	if (len < 0)
+		return len;
+
+	return simple_read_from_buffer(buf, count, ppos, ids_buf, len);
+}
+
+/*
+ * Converts a string into an array of unsigned long integers
+ *
+ * Returns an array of unsigned long integers if the conversion success, or
+ * NULL otherwise.
+ */
+static unsigned long *str_to_target_ids(const char *str, ssize_t len,
+					ssize_t *nr_ids)
+{
+	unsigned long *ids;
+	const int max_nr_ids = 32;
+	unsigned long id;
+	int pos = 0, parsed, ret;
+
+	*nr_ids = 0;
+	ids = kmalloc_array(max_nr_ids, sizeof(id), GFP_KERNEL);
+	if (!ids)
+		return NULL;
+	while (*nr_ids < max_nr_ids && pos < len) {
+		ret = sscanf(&str[pos], "%lu%n", &id, &parsed);
+		pos += parsed;
+		if (ret != 1)
+			break;
+		ids[*nr_ids] = id;
+		*nr_ids += 1;
+	}
+
+	return ids;
+}
+
+static void dbgfs_put_pids(unsigned long *ids, int nr_ids)
+{
+	int i;
+
+	for (i = 0; i < nr_ids; i++)
+		put_pid((struct pid *)ids[i]);
+}
+
+static ssize_t dbgfs_target_ids_write(struct file *file,
+		const char __user *buf, size_t count, loff_t *ppos)
+{
+	struct damon_ctx *ctx = file->private_data;
+	char *kbuf, *nrs;
+	unsigned long *targets;
+	ssize_t nr_targets;
+	ssize_t ret = count;
+	int i;
+	int err;
+
+	kbuf = user_input_str(buf, count, ppos);
+	if (IS_ERR(kbuf))
+		return PTR_ERR(kbuf);
+
+	nrs = kbuf;
+
+	targets = str_to_target_ids(nrs, ret, &nr_targets);
+	if (!targets) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	if (targetid_is_pid(ctx)) {
+		for (i = 0; i < nr_targets; i++) {
+			targets[i] = (unsigned long)find_get_pid(
+					(int)targets[i]);
+			if (!targets[i]) {
+				dbgfs_put_pids(targets, i);
+				ret = -EINVAL;
+				goto free_targets_out;
+			}
+		}
+	}
+
+	mutex_lock(&ctx->kdamond_lock);
+	if (ctx->kdamond) {
+		if (targetid_is_pid(ctx))
+			dbgfs_put_pids(targets, nr_targets);
+		ret = -EBUSY;
+		goto unlock_out;
+	}
+
+	err = damon_set_targets(ctx, targets, nr_targets);
+	if (err) {
+		if (targetid_is_pid(ctx))
+			dbgfs_put_pids(targets, nr_targets);
+		ret = err;
+	}
+
+unlock_out:
+	mutex_unlock(&ctx->kdamond_lock);
+free_targets_out:
+	kfree(targets);
+out:
+	kfree(kbuf);
+	return ret;
+}
+
+static int damon_dbgfs_open(struct inode *inode, struct file *file)
+{
+	file->private_data = inode->i_private;
+
+	return nonseekable_open(inode, file);
+}
+
+static const struct file_operations attrs_fops = {
+	.open = damon_dbgfs_open,
+	.read = dbgfs_attrs_read,
+	.write = dbgfs_attrs_write,
+};
+
+static const struct file_operations target_ids_fops = {
+	.open = damon_dbgfs_open,
+	.read = dbgfs_target_ids_read,
+	.write = dbgfs_target_ids_write,
+};
+
+static void dbgfs_fill_ctx_dir(struct dentry *dir, struct damon_ctx *ctx)
+{
+	const char * const file_names[] = {"attrs", "target_ids"};
+	const struct file_operations *fops[] = {&attrs_fops, &target_ids_fops};
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(file_names); i++)
+		debugfs_create_file(file_names[i], 0600, dir, ctx, fops[i]);
+}
+
+static int dbgfs_before_terminate(struct damon_ctx *ctx)
+{
+	struct damon_target *t, *next;
+
+	if (!targetid_is_pid(ctx))
+		return 0;
+
+	damon_for_each_target_safe(t, next, ctx) {
+		put_pid((struct pid *)t->id);
+		damon_destroy_target(t);
+	}
+	return 0;
+}
+
+static struct damon_ctx *dbgfs_new_ctx(void)
+{
+	struct damon_ctx *ctx;
+
+	ctx = damon_new_ctx();
+	if (!ctx)
+		return NULL;
+
+	damon_va_set_primitives(ctx);
+	ctx->callback.before_terminate = dbgfs_before_terminate;
+	return ctx;
+}
+
+static ssize_t dbgfs_monitor_on_read(struct file *file,
+		char __user *buf, size_t count, loff_t *ppos)
+{
+	char monitor_on_buf[5];
+	bool monitor_on = damon_nr_running_ctxs() != 0;
+	int len;
+
+	len = scnprintf(monitor_on_buf, 5, monitor_on ? "on\n" : "off\n");
+
+	return simple_read_from_buffer(buf, count, ppos, monitor_on_buf, len);
+}
+
+static ssize_t dbgfs_monitor_on_write(struct file *file,
+		const char __user *buf, size_t count, loff_t *ppos)
+{
+	ssize_t ret = count;
+	char *kbuf;
+	int err;
+
+	kbuf = user_input_str(buf, count, ppos);
+	if (IS_ERR(kbuf))
+		return PTR_ERR(kbuf);
+
+	/* Remove white space */
+	if (sscanf(kbuf, "%s", kbuf) != 1) {
+		kfree(kbuf);
+		return -EINVAL;
+	}
+
+	if (!strncmp(kbuf, "on", count))
+		err = damon_start(dbgfs_ctxs, dbgfs_nr_ctxs);
+	else if (!strncmp(kbuf, "off", count))
+		err = damon_stop(dbgfs_ctxs, dbgfs_nr_ctxs);
+	else
+		err = -EINVAL;
+
+	if (err)
+		ret = err;
+	kfree(kbuf);
+	return ret;
+}
+
+static const struct file_operations monitor_on_fops = {
+	.read = dbgfs_monitor_on_read,
+	.write = dbgfs_monitor_on_write,
+};
+
+static int __init __damon_dbgfs_init(void)
+{
+	struct dentry *dbgfs_root;
+	const char * const file_names[] = {"monitor_on"};
+	const struct file_operations *fops[] = {&monitor_on_fops};
+	int i;
+
+	dbgfs_root = debugfs_create_dir("damon", NULL);
+
+	for (i = 0; i < ARRAY_SIZE(file_names); i++)
+		debugfs_create_file(file_names[i], 0600, dbgfs_root, NULL,
+				fops[i]);
+	dbgfs_fill_ctx_dir(dbgfs_root, dbgfs_ctxs[0]);
+
+	dbgfs_dirs = kmalloc_array(1, sizeof(dbgfs_root), GFP_KERNEL);
+	if (!dbgfs_dirs) {
+		debugfs_remove(dbgfs_root);
+		return -ENOMEM;
+	}
+	dbgfs_dirs[0] = dbgfs_root;
+
+	return 0;
+}
+
+/*
+ * Functions for the initialization
+ */
+
+static int __init damon_dbgfs_init(void)
+{
+	int rc;
+
+	dbgfs_ctxs = kmalloc(sizeof(*dbgfs_ctxs), GFP_KERNEL);
+	if (!dbgfs_ctxs)
+		return -ENOMEM;
+	dbgfs_ctxs[0] = dbgfs_new_ctx();
+	if (!dbgfs_ctxs[0]) {
+		kfree(dbgfs_ctxs);
+		return -ENOMEM;
+	}
+	dbgfs_nr_ctxs = 1;
+
+	rc = __damon_dbgfs_init();
+	if (rc) {
+		kfree(dbgfs_ctxs[0]);
+		kfree(dbgfs_ctxs);
+		pr_err("%s: dbgfs init failed\n", __func__);
+	}
+
+	return rc;
+}
+
+module_init(damon_dbgfs_init);
--- a/mm/damon/Kconfig~mm-damon-implement-a-debugfs-based-user-space-interface
+++ a/mm/damon/Kconfig
@@ -20,4 +20,13 @@ config DAMON_VADDR
 	  This builds the default data access monitoring primitives for DAMON
 	  that works for virtual address spaces.
 
+config DAMON_DBGFS
+	bool "DAMON debugfs interface"
+	depends on DAMON_VADDR && DEBUG_FS
+	help
+	  This builds the debugfs interface for DAMON.  The user space admins
+	  can use the interface for arbitrary data access monitoring.
+
+	  If unsure, say N.
+
 endmenu
--- a/mm/damon/Makefile~mm-damon-implement-a-debugfs-based-user-space-interface
+++ a/mm/damon/Makefile
@@ -2,3 +2,4 @@
 
 obj-$(CONFIG_DAMON)		:= core.o
 obj-$(CONFIG_DAMON_VADDR)	+= vaddr.o
+obj-$(CONFIG_DAMON_DBGFS)	+= dbgfs.o
_
