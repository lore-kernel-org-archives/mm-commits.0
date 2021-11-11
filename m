Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3012DC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:49:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A4536135E
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:49:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234468AbhKKCwD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:52:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:56224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234456AbhKKCwD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:52:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9996D60F26;
        Thu, 11 Nov 2021 02:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598955;
        bh=DgDvSgufWr4Z/Ki/hXvRWlrk4OWJRXKm+JNoH9hOJXA=;
        h=Date:From:To:Subject:From;
        b=mVlLmQuuLAW0ErniH9zXQs2PbJaYexzCBpbf79h/S/1+3uhZJ8XOYvUGSLVby+la3
         FPPryHNHOscMqlTkIp6O6tuLAnBqpCcdjwB5hFCkJDvjXHLk3o1eGVfURKbBffUm8W
         FCB6Tz244hJY3qiLqjnBsiQlDn6PNzw3ql/aXmQU=
Date:   Wed, 10 Nov 2021 18:49:14 -0800
From:   akpm@linux-foundation.org
To:     amit@kernel.org, benh@kernel.crashing.org,
        brendanhiggins@google.com, corbet@lwn.net, david@redhat.com,
        dwmw@amazon.com, elver@google.com, foersleo@amazon.de,
        gthelen@google.com, Jonathan.Cameron@huawei.com, markubo@amazon.de,
        mm-commits@vger.kernel.org, rientjes@google.com,
        shakeelb@google.com, shuah@kernel.org, sj@kernel.org
Subject:  [merged]
 mm-damon-dbgfs-allow-users-to-set-initial-monitoring-target-regions.patch
 removed from -mm tree
Message-ID: <20211111024914.gNizZFT2z%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/dbgfs: allow users to set initial monitoring target regions
has been removed from the -mm tree.  Its filename was
     mm-damon-dbgfs-allow-users-to-set-initial-monitoring-target-regions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from sj@kernel.org are


