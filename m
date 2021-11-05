Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12239C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:46:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F067C6128E
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:46:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233804AbhKEUtY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:49:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:44508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233786AbhKEUtX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:49:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6489E61357;
        Fri,  5 Nov 2021 20:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145204;
        bh=VOIunbdNmcWFyd8uMrc34AqP7A1NbkwVd0pIGYCJJ68=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=CewqAxPoSvYQeZUHf6wlrx+cKYxokwBTievw36dDmD6V3VDuTz+Nm4mVr90k1JREx
         G+sTCB6NTqrYe/PWrJCDC8quwpnFkrZpdgPKI4g/befAfUJH8uV8d1ohrB5xasEP13
         xowvOYU4qcfkxp+nJ/ve7P7/dw14hTUJYD478dM4=
Date:   Fri, 05 Nov 2021 13:46:42 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, amit@kernel.org,
        benh@kernel.crashing.org, brendanhiggins@google.com,
        corbet@lwn.net, david@redhat.com, dwmw@amazon.com,
        elver@google.com, foersleo@amazon.de, gthelen@google.com,
        Jonathan.Cameron@huawei.com, linux-mm@kvack.org, markubo@amazon.de,
        mm-commits@vger.kernel.org, rientjes@google.com,
        shakeelb@google.com, shuah@kernel.org, sj@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 230/262] mm/damon/dbgfs: allow users to set
 initial monitoring target regions
Message-ID: <20211105204642.8cBaVVOlp%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/dbgfs: allow users to set initial monitoring target regions

Patch series "DAMON: Support Physical Memory Address Space Monitoring:.

DAMON currently supports only virtual address spaces monitoring.  It can
be easily extended for various use cases and address spaces by configuring
its monitoring primitives layer to use appropriate primitives
implementations, though.  This patchset implements monitoring primitives
for the physical address space monitoring using the structure.

The first 3 patches allow the user space users manually set the monitoring
regions.  The 1st patch implements the feature in the 'damon-dbgfs'. 
Then, patches for adding a unit tests (the 2nd patch) and updating the
documentation (the 3rd patch) follow.

Following 4 patches implement the physical address space monitoring
primitives.  The 4th patch makes some primitive functions for the virtual
address spaces primitives reusable.  The 5th patch implements the physical
address space monitoring primitives.  The 6th patch links the primitives
to the 'damon-dbgfs'.  Finally, 7th patch documents this new features.


This patch (of 7):

Some 'damon-dbgfs' users would want to monitor only a part of the entire
virtual memory address space.  The program interface users in the kernel
space could use '->before_start()' callback or set the regions inside the
context struct as they want, but 'damon-dbgfs' users cannot.

For the reason, this commit introduces a new debugfs file called
'init_region'.  'damon-dbgfs' users can specify which initial monitoring
target address regions they want by writing special input to the file. 
The input should describe each region in each line in the below form:

    <pid> <start address> <end address>

Note that the regions will be updated to cover entire memory mapped
regions after a 'regions update interval' is passed.  If you want the
regions to not be updated after the initial setting, you could set the
interval as a very long time, say, a few decades.

Link: https://lkml.kernel.org/r/20211012205711.29216-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20211012205711.29216-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Amit Shah <amit@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Woodhouse <dwmw@amazon.com>
Cc: Marco Elver <elver@google.com>
Cc: Leonard Foerster <foersleo@amazon.de>
Cc: Greg Thelen <gthelen@google.com>
Cc: Markus Boehme <markubo@amazon.de>
Cc: David Rienjes <rientjes@google.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/dbgfs.c |  156 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 154 insertions(+), 2 deletions(-)

--- a/mm/damon/dbgfs.c~mm-damon-dbgfs-allow-users-to-set-initial-monitoring-target-regions
+++ a/mm/damon/dbgfs.c
@@ -394,6 +394,152 @@ out:
 	return ret;
 }
 
+static ssize_t sprint_init_regions(struct damon_ctx *c, char *buf, ssize_t len)
+{
+	struct damon_target *t;
+	struct damon_region *r;
+	int written = 0;
+	int rc;
+
+	damon_for_each_target(t, c) {
+		damon_for_each_region(r, t) {
+			rc = scnprintf(&buf[written], len - written,
+					"%lu %lu %lu\n",
+					t->id, r->ar.start, r->ar.end);
+			if (!rc)
+				return -ENOMEM;
+			written += rc;
+		}
+	}
+	return written;
+}
+
+static ssize_t dbgfs_init_regions_read(struct file *file, char __user *buf,
+		size_t count, loff_t *ppos)
+{
+	struct damon_ctx *ctx = file->private_data;
+	char *kbuf;
+	ssize_t len;
+
+	kbuf = kmalloc(count, GFP_KERNEL);
+	if (!kbuf)
+		return -ENOMEM;
+
+	mutex_lock(&ctx->kdamond_lock);
+	if (ctx->kdamond) {
+		mutex_unlock(&ctx->kdamond_lock);
+		len = -EBUSY;
+		goto out;
+	}
+
+	len = sprint_init_regions(ctx, kbuf, count);
+	mutex_unlock(&ctx->kdamond_lock);
+	if (len < 0)
+		goto out;
+	len = simple_read_from_buffer(buf, count, ppos, kbuf, len);
+
+out:
+	kfree(kbuf);
+	return len;
+}
+
+static int add_init_region(struct damon_ctx *c,
+			 unsigned long target_id, struct damon_addr_range *ar)
+{
+	struct damon_target *t;
+	struct damon_region *r, *prev;
+	unsigned long id;
+	int rc = -EINVAL;
+
+	if (ar->start >= ar->end)
+		return -EINVAL;
+
+	damon_for_each_target(t, c) {
+		id = t->id;
+		if (targetid_is_pid(c))
+			id = (unsigned long)pid_vnr((struct pid *)id);
+		if (id == target_id) {
+			r = damon_new_region(ar->start, ar->end);
+			if (!r)
+				return -ENOMEM;
+			damon_add_region(r, t);
+			if (damon_nr_regions(t) > 1) {
+				prev = damon_prev_region(r);
+				if (prev->ar.end > r->ar.start) {
+					damon_destroy_region(r, t);
+					return -EINVAL;
+				}
+			}
+			rc = 0;
+		}
+	}
+	return rc;
+}
+
+static int set_init_regions(struct damon_ctx *c, const char *str, ssize_t len)
+{
+	struct damon_target *t;
+	struct damon_region *r, *next;
+	int pos = 0, parsed, ret;
+	unsigned long target_id;
+	struct damon_addr_range ar;
+	int err;
+
+	damon_for_each_target(t, c) {
+		damon_for_each_region_safe(r, next, t)
+			damon_destroy_region(r, t);
+	}
+
+	while (pos < len) {
+		ret = sscanf(&str[pos], "%lu %lu %lu%n",
+				&target_id, &ar.start, &ar.end, &parsed);
+		if (ret != 3)
+			break;
+		err = add_init_region(c, target_id, &ar);
+		if (err)
+			goto fail;
+		pos += parsed;
+	}
+
+	return 0;
+
+fail:
+	damon_for_each_target(t, c) {
+		damon_for_each_region_safe(r, next, t)
+			damon_destroy_region(r, t);
+	}
+	return err;
+}
+
+static ssize_t dbgfs_init_regions_write(struct file *file,
+					  const char __user *buf, size_t count,
+					  loff_t *ppos)
+{
+	struct damon_ctx *ctx = file->private_data;
+	char *kbuf;
+	ssize_t ret = count;
+	int err;
+
+	kbuf = user_input_str(buf, count, ppos);
+	if (IS_ERR(kbuf))
+		return PTR_ERR(kbuf);
+
+	mutex_lock(&ctx->kdamond_lock);
+	if (ctx->kdamond) {
+		ret = -EBUSY;
+		goto unlock_out;
+	}
+
+	err = set_init_regions(ctx, kbuf, ret);
+	if (err)
+		ret = err;
+
+unlock_out:
+	mutex_unlock(&ctx->kdamond_lock);
+	kfree(kbuf);
+	return ret;
+}
+
 static ssize_t dbgfs_kdamond_pid_read(struct file *file,
 		char __user *buf, size_t count, loff_t *ppos)
 {
@@ -445,6 +591,12 @@ static const struct file_operations targ
 	.write = dbgfs_target_ids_write,
 };
 
+static const struct file_operations init_regions_fops = {
+	.open = damon_dbgfs_open,
+	.read = dbgfs_init_regions_read,
+	.write = dbgfs_init_regions_write,
+};
+
 static const struct file_operations kdamond_pid_fops = {
 	.open = damon_dbgfs_open,
 	.read = dbgfs_kdamond_pid_read,
@@ -453,9 +605,9 @@ static const struct file_operations kdam
 static void dbgfs_fill_ctx_dir(struct dentry *dir, struct damon_ctx *ctx)
 {
 	const char * const file_names[] = {"attrs", "schemes", "target_ids",
-		"kdamond_pid"};
+		"init_regions", "kdamond_pid"};
 	const struct file_operations *fops[] = {&attrs_fops, &schemes_fops,
-		&target_ids_fops, &kdamond_pid_fops};
+		&target_ids_fops, &init_regions_fops, &kdamond_pid_fops};
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(file_names); i++)
_
