Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ECD4C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:49:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 493956103C
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:49:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234461AbhKKCv6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:51:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:56060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234391AbhKKCvv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:51:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B75B26103C;
        Thu, 11 Nov 2021 02:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598943;
        bh=+s3SxzT/STKlfdp9aHWEBjNOlGTjnIka/OiXhsbfcw4=;
        h=Date:From:To:Subject:From;
        b=oam1x0cv+U/QD2ssNPsFssi5b2wRXpdefPWFcFvS+yWoLxb9aOYqGZd9wKbrKjlZn
         5JbvWsRYN1gPh86CpNIrZXe1Bm6IX99nH6h2am+p5K3CTljI6A6cMFmvRXPOT3bZIu
         gXImDpEAJVFpma/rS5BQpL3TS4G+AqhqHxBA3jgg=
Date:   Wed, 10 Nov 2021 18:49:02 -0800
From:   akpm@linux-foundation.org
To:     amit@kernel.org, benh@kernel.crashing.org, corbet@lwn.net,
        david@redhat.com, dwmw@amazon.com, elver@google.com,
        foersleo@amazon.de, gthelen@google.com,
        Jonathan.Cameron@huawei.com, markubo@amazon.de,
        mm-commits@vger.kernel.org, rientjes@google.com,
        shakeelb@google.com, shuah@kernel.org, sj@kernel.org
Subject:  [merged]
 mm-damon-dbgfs-support-damon-based-operation-schemes.patch removed from -mm
 tree
Message-ID: <20211111024902.Z7VGlYGcR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/dbgfs: support DAMON-based Operation Schemes
has been removed from the -mm tree.  Its filename was
     mm-damon-dbgfs-support-damon-based-operation-schemes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/dbgfs: support DAMON-based Operation Schemes

This commit makes 'damon-dbgfs' to support the data access monitoring
oriented memory management schemes.  Users can read and update the schemes
using ``<debugfs>/damon/schemes`` file.  The format is::

    <min/max size> <min/max access frequency> <min/max age> <action>

Link: https://lkml.kernel.org/r/20211001125604.29660-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Amit Shah <amit@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rienjes <rientjes@google.com>
Cc: David Woodhouse <dwmw@amazon.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Leonard Foerster <foersleo@amazon.de>
Cc: Marco Elver <elver@google.com>
Cc: Markus Boehme <markubo@amazon.de>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/dbgfs.c |  165 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 162 insertions(+), 3 deletions(-)

--- a/mm/damon/dbgfs.c~mm-damon-dbgfs-support-damon-based-operation-schemes
+++ a/mm/damon/dbgfs.c
@@ -98,6 +98,159 @@ out:
 	return ret;
 }
 
+static ssize_t sprint_schemes(struct damon_ctx *c, char *buf, ssize_t len)
+{
+	struct damos *s;
+	int written = 0;
+	int rc;
+
+	damon_for_each_scheme(s, c) {
+		rc = scnprintf(&buf[written], len - written,
+				"%lu %lu %u %u %u %u %d\n",
+				s->min_sz_region, s->max_sz_region,
+				s->min_nr_accesses, s->max_nr_accesses,
+				s->min_age_region, s->max_age_region,
+				s->action);
+		if (!rc)
+			return -ENOMEM;
+
+		written += rc;
+	}
+	return written;
+}
+
+static ssize_t dbgfs_schemes_read(struct file *file, char __user *buf,
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
+	len = sprint_schemes(ctx, kbuf, count);
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
+static void free_schemes_arr(struct damos **schemes, ssize_t nr_schemes)
+{
+	ssize_t i;
+
+	for (i = 0; i < nr_schemes; i++)
+		kfree(schemes[i]);
+	kfree(schemes);
+}
+
+static bool damos_action_valid(int action)
+{
+	switch (action) {
+	case DAMOS_WILLNEED:
+	case DAMOS_COLD:
+	case DAMOS_PAGEOUT:
+	case DAMOS_HUGEPAGE:
+	case DAMOS_NOHUGEPAGE:
+		return true;
+	default:
+		return false;
+	}
+}
+
+/*
+ * Converts a string into an array of struct damos pointers
+ *
+ * Returns an array of struct damos pointers that converted if the conversion
+ * success, or NULL otherwise.
+ */
+static struct damos **str_to_schemes(const char *str, ssize_t len,
+				ssize_t *nr_schemes)
+{
+	struct damos *scheme, **schemes;
+	const int max_nr_schemes = 256;
+	int pos = 0, parsed, ret;
+	unsigned long min_sz, max_sz;
+	unsigned int min_nr_a, max_nr_a, min_age, max_age;
+	unsigned int action;
+
+	schemes = kmalloc_array(max_nr_schemes, sizeof(scheme),
+			GFP_KERNEL);
+	if (!schemes)
+		return NULL;
+
+	*nr_schemes = 0;
+	while (pos < len && *nr_schemes < max_nr_schemes) {
+		ret = sscanf(&str[pos], "%lu %lu %u %u %u %u %u%n",
+				&min_sz, &max_sz, &min_nr_a, &max_nr_a,
+				&min_age, &max_age, &action, &parsed);
+		if (ret != 7)
+			break;
+		if (!damos_action_valid(action)) {
+			pr_err("wrong action %d\n", action);
+			goto fail;
+		}
+
+		pos += parsed;
+		scheme = damon_new_scheme(min_sz, max_sz, min_nr_a, max_nr_a,
+				min_age, max_age, action);
+		if (!scheme)
+			goto fail;
+
+		schemes[*nr_schemes] = scheme;
+		*nr_schemes += 1;
+	}
+	return schemes;
+fail:
+	free_schemes_arr(schemes, *nr_schemes);
+	return NULL;
+}
+
+static ssize_t dbgfs_schemes_write(struct file *file, const char __user *buf,
+		size_t count, loff_t *ppos)
+{
+	struct damon_ctx *ctx = file->private_data;
+	char *kbuf;
+	struct damos **schemes;
+	ssize_t nr_schemes = 0, ret = count;
+	int err;
+
+	kbuf = user_input_str(buf, count, ppos);
+	if (IS_ERR(kbuf))
+		return PTR_ERR(kbuf);
+
+	schemes = str_to_schemes(kbuf, ret, &nr_schemes);
+	if (!schemes) {
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
+	err = damon_set_schemes(ctx, schemes, nr_schemes);
+	if (err)
+		ret = err;
+	else
+		nr_schemes = 0;
+unlock_out:
+	mutex_unlock(&ctx->kdamond_lock);
+	free_schemes_arr(schemes, nr_schemes);
+out:
+	kfree(kbuf);
+	return ret;
+}
+
 static inline bool targetid_is_pid(const struct damon_ctx *ctx)
 {
 	return ctx->primitive.target_valid == damon_va_target_valid;
@@ -279,6 +432,12 @@ static const struct file_operations attr
 	.write = dbgfs_attrs_write,
 };
 
+static const struct file_operations schemes_fops = {
+	.open = damon_dbgfs_open,
+	.read = dbgfs_schemes_read,
+	.write = dbgfs_schemes_write,
+};
+
 static const struct file_operations target_ids_fops = {
 	.open = damon_dbgfs_open,
 	.read = dbgfs_target_ids_read,
@@ -292,10 +451,10 @@ static const struct file_operations kdam
 
 static void dbgfs_fill_ctx_dir(struct dentry *dir, struct damon_ctx *ctx)
 {
-	const char * const file_names[] = {"attrs", "target_ids",
+	const char * const file_names[] = {"attrs", "schemes", "target_ids",
 		"kdamond_pid"};
-	const struct file_operations *fops[] = {&attrs_fops, &target_ids_fops,
-		&kdamond_pid_fops};
+	const struct file_operations *fops[] = {&attrs_fops, &schemes_fops,
+		&target_ids_fops, &kdamond_pid_fops};
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(file_names); i++)
_

Patches currently in -mm which might be from sj@kernel.org are


