Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72B6EC432BE
	for <mm-commits@archiver.kernel.org>; Fri,  6 Aug 2021 00:42:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CC9461184
	for <mm-commits@archiver.kernel.org>; Fri,  6 Aug 2021 00:42:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241358AbhHFAmh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Aug 2021 20:42:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:49050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243060AbhHFAmb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 5 Aug 2021 20:42:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4A0B61181;
        Fri,  6 Aug 2021 00:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628210536;
        bh=pkpqnXbFGczEaSKY6uywNdE3kkxX7JdCYb2sl4XC/jE=;
        h=Date:From:To:Subject:From;
        b=WTwXCJLSspelz2yDu0bu4XDKRbkEJrg6e3DjKae4WMkRMIGyShv1Sw8EDeLuV5gs4
         reWG/eEgUUKryYQRY8uWvYg9lbYo2YlY27QK+ywf8mE9kf/rJwDAPOGaLX2+FpnHF3
         2z2SnEbN1O6ni8wzEs9PMH1/veB3p12wWDqwm92E=
Date:   Thu, 05 Aug 2021 17:42:15 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com, vbabka@suse.cz,
        sieberf@amazon.com, shuah@kernel.org, shakeelb@google.com,
        rostedt@goodmis.org, rientjes@google.com, riel@surriel.com,
        peterz@infradead.org, namhyung@kernel.org, mingo@redhat.com,
        minchan@kernel.org, mheyne@amazon.de, mgorman@suse.de,
        markubo@amazon.de, Jonathan.Cameron@huawei.com, joe@perches.com,
        gthelen@google.com, greg@kroah.com, foersleo@amazon.de,
        fan.du@intel.com, elver@google.com, dwmw@amazon.com,
        david@redhat.com, corbet@lwn.net, brendanhiggins@google.com,
        benh@kernel.crashing.org, amit@kernel.org,
        alexander.shishkin@linux.intel.com, sjpark@amazon.de
Subject:  + mm-damon-dbgfs-support-multiple-contexts.patch added to
 -mm tree
Message-ID: <20210806004215.9_11R%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/dbgfs: support multiple contexts
has been added to the -mm tree.  Its filename is
     mm-damon-dbgfs-support-multiple-contexts.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-dbgfs-support-multiple-contexts.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-dbgfs-support-multiple-contexts.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: SeongJae Park <sjpark@amazon.de>
Subject: mm/damon/dbgfs: support multiple contexts

In some use cases, users would want to run multiple monitoring context. 
For example, if a user wants a high precision monitoring and dedicating
multiple CPUs for the job is ok, because DAMON creates one monitoring
thread per one context, the user can split the monitoring target regions
into multiple small regions and create one context for each region.  Or,
someone might want to simultaneously monitor different address spaces,
e.g., both virtual address space and physical address space.

The DAMON's API allows such usage, but 'damon-dbgfs' does not.  Therefore,
only kernel space DAMON users can do multiple contexts monitoring.

This commit allows the user space DAMON users to use multiple contexts
monitoring by introducing two new 'damon-dbgfs' debugfs files,
'mk_context' and 'rm_context'.  Users can create a new monitoring context
by writing the desired name of the new context to 'mk_context'.  Then, a
new directory with the name and having the files for setting of the
context ('attrs', 'target_ids' and 'record') will be created under the
debugfs directory.  Writing the name of the context to remove to
'rm_context' will remove the related context and directory.

Link: https://lkml.kernel.org/r/20210716081449.22187-10-sj38.park@gmail.com
Signed-off-by: SeongJae Park <sjpark@amazon.de>
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
Cc: Leonard Foerster <foersleo@amazon.de>
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

 mm/damon/dbgfs.c |  195 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 193 insertions(+), 2 deletions(-)

--- a/mm/damon/dbgfs.c~mm-damon-dbgfs-support-multiple-contexts
+++ a/mm/damon/dbgfs.c
@@ -18,6 +18,7 @@
 static struct damon_ctx **dbgfs_ctxs;
 static int dbgfs_nr_ctxs;
 static struct dentry **dbgfs_dirs;
+static DEFINE_MUTEX(damon_dbgfs_lock);
 
 /*
  * Returns non-empty string on success, negative error code otherwise.
@@ -328,6 +329,186 @@ static struct damon_ctx *dbgfs_new_ctx(v
 	return ctx;
 }
 
+static void dbgfs_destroy_ctx(struct damon_ctx *ctx)
+{
+	damon_destroy_ctx(ctx);
+}
+
+/*
+ * Make a context of @name and create a debugfs directory for it.
+ *
+ * This function should be called while holding damon_dbgfs_lock.
+ *
+ * Returns 0 on success, negative error code otherwise.
+ */
+static int dbgfs_mk_context(char *name)
+{
+	struct dentry *root, **new_dirs, *new_dir;
+	struct damon_ctx **new_ctxs, *new_ctx;
+
+	if (damon_nr_running_ctxs())
+		return -EBUSY;
+
+	new_ctxs = krealloc(dbgfs_ctxs, sizeof(*dbgfs_ctxs) *
+			(dbgfs_nr_ctxs + 1), GFP_KERNEL);
+	if (!new_ctxs)
+		return -ENOMEM;
+	dbgfs_ctxs = new_ctxs;
+
+	new_dirs = krealloc(dbgfs_dirs, sizeof(*dbgfs_dirs) *
+			(dbgfs_nr_ctxs + 1), GFP_KERNEL);
+	if (!new_dirs)
+		return -ENOMEM;
+	dbgfs_dirs = new_dirs;
+
+	root = dbgfs_dirs[0];
+	if (!root)
+		return -ENOENT;
+
+	new_dir = debugfs_create_dir(name, root);
+	dbgfs_dirs[dbgfs_nr_ctxs] = new_dir;
+
+	new_ctx = dbgfs_new_ctx();
+	if (!new_ctx) {
+		debugfs_remove(new_dir);
+		dbgfs_dirs[dbgfs_nr_ctxs] = NULL;
+		return -ENOMEM;
+	}
+
+	dbgfs_ctxs[dbgfs_nr_ctxs] = new_ctx;
+	dbgfs_fill_ctx_dir(dbgfs_dirs[dbgfs_nr_ctxs],
+			dbgfs_ctxs[dbgfs_nr_ctxs]);
+	dbgfs_nr_ctxs++;
+
+	return 0;
+}
+
+static ssize_t dbgfs_mk_context_write(struct file *file,
+		const char __user *buf, size_t count, loff_t *ppos)
+{
+	char *kbuf;
+	char *ctx_name;
+	ssize_t ret = count;
+	int err;
+
+	kbuf = user_input_str(buf, count, ppos);
+	if (IS_ERR(kbuf))
+		return PTR_ERR(kbuf);
+	ctx_name = kmalloc(count + 1, GFP_KERNEL);
+	if (!ctx_name) {
+		kfree(kbuf);
+		return -ENOMEM;
+	}
+
+	/* Trim white space */
+	if (sscanf(kbuf, "%s", ctx_name) != 1) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	mutex_lock(&damon_dbgfs_lock);
+	err = dbgfs_mk_context(ctx_name);
+	if (err)
+		ret = err;
+	mutex_unlock(&damon_dbgfs_lock);
+
+out:
+	kfree(kbuf);
+	kfree(ctx_name);
+	return ret;
+}
+
+/*
+ * Remove a context of @name and its debugfs directory.
+ *
+ * This function should be called while holding damon_dbgfs_lock.
+ *
+ * Return 0 on success, negative error code otherwise.
+ */
+static int dbgfs_rm_context(char *name)
+{
+	struct dentry *root, *dir, **new_dirs;
+	struct damon_ctx **new_ctxs;
+	int i, j;
+
+	if (damon_nr_running_ctxs())
+		return -EBUSY;
+
+	root = dbgfs_dirs[0];
+	if (!root)
+		return -ENOENT;
+
+	dir = debugfs_lookup(name, root);
+	if (!dir)
+		return -ENOENT;
+
+	new_dirs = kmalloc_array(dbgfs_nr_ctxs - 1, sizeof(*dbgfs_dirs),
+			GFP_KERNEL);
+	if (!new_dirs)
+		return -ENOMEM;
+
+	new_ctxs = kmalloc_array(dbgfs_nr_ctxs - 1, sizeof(*dbgfs_ctxs),
+			GFP_KERNEL);
+	if (!new_ctxs) {
+		kfree(new_dirs);
+		return -ENOMEM;
+	}
+
+	for (i = 0, j = 0; i < dbgfs_nr_ctxs; i++) {
+		if (dbgfs_dirs[i] == dir) {
+			debugfs_remove(dbgfs_dirs[i]);
+			dbgfs_destroy_ctx(dbgfs_ctxs[i]);
+			continue;
+		}
+		new_dirs[j] = dbgfs_dirs[i];
+		new_ctxs[j++] = dbgfs_ctxs[i];
+	}
+
+	kfree(dbgfs_dirs);
+	kfree(dbgfs_ctxs);
+
+	dbgfs_dirs = new_dirs;
+	dbgfs_ctxs = new_ctxs;
+	dbgfs_nr_ctxs--;
+
+	return 0;
+}
+
+static ssize_t dbgfs_rm_context_write(struct file *file,
+		const char __user *buf, size_t count, loff_t *ppos)
+{
+	char *kbuf;
+	ssize_t ret = count;
+	int err;
+	char *ctx_name;
+
+	kbuf = user_input_str(buf, count, ppos);
+	if (IS_ERR(kbuf))
+		return PTR_ERR(kbuf);
+	ctx_name = kmalloc(count + 1, GFP_KERNEL);
+	if (!ctx_name) {
+		kfree(kbuf);
+		return -ENOMEM;
+	}
+
+	/* Trim white space */
+	if (sscanf(kbuf, "%s", ctx_name) != 1) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	mutex_lock(&damon_dbgfs_lock);
+	err = dbgfs_rm_context(ctx_name);
+	if (err)
+		ret = err;
+	mutex_unlock(&damon_dbgfs_lock);
+
+out:
+	kfree(kbuf);
+	kfree(ctx_name);
+	return ret;
+}
+
 static ssize_t dbgfs_monitor_on_read(struct file *file,
 		char __user *buf, size_t count, loff_t *ppos)
 {
@@ -370,6 +551,14 @@ static ssize_t dbgfs_monitor_on_write(st
 	return ret;
 }
 
+static const struct file_operations mk_contexts_fops = {
+	.write = dbgfs_mk_context_write,
+};
+
+static const struct file_operations rm_contexts_fops = {
+	.write = dbgfs_rm_context_write,
+};
+
 static const struct file_operations monitor_on_fops = {
 	.read = dbgfs_monitor_on_read,
 	.write = dbgfs_monitor_on_write,
@@ -378,8 +567,10 @@ static const struct file_operations moni
 static int __init __damon_dbgfs_init(void)
 {
 	struct dentry *dbgfs_root;
-	const char * const file_names[] = {"monitor_on"};
-	const struct file_operations *fops[] = {&monitor_on_fops};
+	const char * const file_names[] = {"mk_contexts", "rm_contexts",
+		"monitor_on"};
+	const struct file_operations *fops[] = {&mk_contexts_fops,
+		&rm_contexts_fops, &monitor_on_fops};
 	int i;
 
 	dbgfs_root = debugfs_create_dir("damon", NULL);
_

Patches currently in -mm which might be from sjpark@amazon.de are

mm-introduce-data-access-monitor-damon.patch
mm-damon-core-implement-region-based-sampling.patch
mm-damon-adaptively-adjust-regions.patch
mm-idle_page_tracking-make-pg_idle-reusable.patch
mm-damon-implement-primitives-for-the-virtual-memory-address-spaces.patch
mm-damon-add-a-tracepoint.patch
mm-damon-implement-a-debugfs-based-user-space-interface.patch
mm-damon-dbgfs-export-kdamond-pid-to-the-user-space.patch
mm-damon-dbgfs-support-multiple-contexts.patch
documentation-add-documents-for-damon.patch
mm-damon-add-kunit-tests.patch
mm-damon-add-user-space-selftests.patch
maintainers-update-for-damon.patch

