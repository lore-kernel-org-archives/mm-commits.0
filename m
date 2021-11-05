Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2E38C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:47:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97AC661056
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:47:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233814AbhKEUtv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:49:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:45014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233527AbhKEUtu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:49:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 641F36056B;
        Fri,  5 Nov 2021 20:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145230;
        bh=BTrcbZ1I8eoCCI4Xw4uQdbdDJW5qGKGFPbszge1bsac=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=a/T3lkjZycItE1lZQgrzsWQrO+MwLoOLnAyiD3vmWnyKaOdqiqDbjvM5L52Zgbe6S
         OY6H8baqG/f+JaU/pdXGYlmNfzACgLhT+pSPyU4NfJ8hEyKJNgYbX2mXfjZV1YcG7O
         uMPkbVK2Ra+TBlqwj7DqnX5lA38bSryYT/Ch7uKQ=
Date:   Fri, 05 Nov 2021 13:47:09 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rongwei.wang@linux.alibaba.com,
        sj@kernel.org, torvalds@linux-foundation.org
Subject:  [patch 238/262] mm/damon/dbgfs: remove unnecessary
 variables
Message-ID: <20211105204709.sPppLLlKi%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Rongwei Wang <rongwei.wang@linux.alibaba.com>
Subject: mm/damon/dbgfs: remove unnecessary variables

In some functions, it's unnecessary to declare 'err' and 'ret' variables
at the same time.  This patch mainly to simplify the issue of such
declarations by reusing one variable.

Link: https://lkml.kernel.org/r/20211014073014.35754-1-sj@kernel.org
Signed-off-by: Rongwei Wang <rongwei.wang@linux.alibaba.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/dbgfs.c |   66 +++++++++++++++++++++------------------------
 1 file changed, 31 insertions(+), 35 deletions(-)

--- a/mm/damon/dbgfs.c~mm-damon-dbgfs-remove-unnecessary-variables
+++ a/mm/damon/dbgfs.c
@@ -69,8 +69,7 @@ static ssize_t dbgfs_attrs_write(struct
 	struct damon_ctx *ctx = file->private_data;
 	unsigned long s, a, r, minr, maxr;
 	char *kbuf;
-	ssize_t ret = count;
-	int err;
+	ssize_t ret;
 
 	kbuf = user_input_str(buf, count, ppos);
 	if (IS_ERR(kbuf))
@@ -88,9 +87,9 @@ static ssize_t dbgfs_attrs_write(struct
 		goto unlock_out;
 	}
 
-	err = damon_set_attrs(ctx, s, a, r, minr, maxr);
-	if (err)
-		ret = err;
+	ret = damon_set_attrs(ctx, s, a, r, minr, maxr);
+	if (!ret)
+		ret = count;
 unlock_out:
 	mutex_unlock(&ctx->kdamond_lock);
 out:
@@ -220,14 +219,13 @@ static ssize_t dbgfs_schemes_write(struc
 	struct damon_ctx *ctx = file->private_data;
 	char *kbuf;
 	struct damos **schemes;
-	ssize_t nr_schemes = 0, ret = count;
-	int err;
+	ssize_t nr_schemes = 0, ret;
 
 	kbuf = user_input_str(buf, count, ppos);
 	if (IS_ERR(kbuf))
 		return PTR_ERR(kbuf);
 
-	schemes = str_to_schemes(kbuf, ret, &nr_schemes);
+	schemes = str_to_schemes(kbuf, count, &nr_schemes);
 	if (!schemes) {
 		ret = -EINVAL;
 		goto out;
@@ -239,11 +237,12 @@ static ssize_t dbgfs_schemes_write(struc
 		goto unlock_out;
 	}
 
-	err = damon_set_schemes(ctx, schemes, nr_schemes);
-	if (err)
-		ret = err;
-	else
+	ret = damon_set_schemes(ctx, schemes, nr_schemes);
+	if (!ret) {
+		ret = count;
 		nr_schemes = 0;
+	}
+
 unlock_out:
 	mutex_unlock(&ctx->kdamond_lock);
 	free_schemes_arr(schemes, nr_schemes);
@@ -343,9 +342,8 @@ static ssize_t dbgfs_target_ids_write(st
 	char *kbuf, *nrs;
 	unsigned long *targets;
 	ssize_t nr_targets;
-	ssize_t ret = count;
+	ssize_t ret;
 	int i;
-	int err;
 
 	kbuf = user_input_str(buf, count, ppos);
 	if (IS_ERR(kbuf))
@@ -358,7 +356,7 @@ static ssize_t dbgfs_target_ids_write(st
 		scnprintf(kbuf, count, "42    ");
 	}
 
-	targets = str_to_target_ids(nrs, ret, &nr_targets);
+	targets = str_to_target_ids(nrs, count, &nr_targets);
 	if (!targets) {
 		ret = -ENOMEM;
 		goto out;
@@ -393,11 +391,12 @@ static ssize_t dbgfs_target_ids_write(st
 	else
 		damon_pa_set_primitives(ctx);
 
-	err = damon_set_targets(ctx, targets, nr_targets);
-	if (err) {
+	ret = damon_set_targets(ctx, targets, nr_targets);
+	if (ret) {
 		if (id_is_pid)
 			dbgfs_put_pids(targets, nr_targets);
-		ret = err;
+	} else {
+		ret = count;
 	}
 
 unlock_out:
@@ -715,8 +714,7 @@ static ssize_t dbgfs_mk_context_write(st
 {
 	char *kbuf;
 	char *ctx_name;
-	ssize_t ret = count;
-	int err;
+	ssize_t ret;
 
 	kbuf = user_input_str(buf, count, ppos);
 	if (IS_ERR(kbuf))
@@ -734,9 +732,9 @@ static ssize_t dbgfs_mk_context_write(st
 	}
 
 	mutex_lock(&damon_dbgfs_lock);
-	err = dbgfs_mk_context(ctx_name);
-	if (err)
-		ret = err;
+	ret = dbgfs_mk_context(ctx_name);
+	if (!ret)
+		ret = count;
 	mutex_unlock(&damon_dbgfs_lock);
 
 out:
@@ -805,8 +803,7 @@ static ssize_t dbgfs_rm_context_write(st
 		const char __user *buf, size_t count, loff_t *ppos)
 {
 	char *kbuf;
-	ssize_t ret = count;
-	int err;
+	ssize_t ret;
 	char *ctx_name;
 
 	kbuf = user_input_str(buf, count, ppos);
@@ -825,9 +822,9 @@ static ssize_t dbgfs_rm_context_write(st
 	}
 
 	mutex_lock(&damon_dbgfs_lock);
-	err = dbgfs_rm_context(ctx_name);
-	if (err)
-		ret = err;
+	ret = dbgfs_rm_context(ctx_name);
+	if (!ret)
+		ret = count;
 	mutex_unlock(&damon_dbgfs_lock);
 
 out:
@@ -851,9 +848,8 @@ static ssize_t dbgfs_monitor_on_read(str
 static ssize_t dbgfs_monitor_on_write(struct file *file,
 		const char __user *buf, size_t count, loff_t *ppos)
 {
-	ssize_t ret = count;
+	ssize_t ret;
 	char *kbuf;
-	int err;
 
 	kbuf = user_input_str(buf, count, ppos);
 	if (IS_ERR(kbuf))
@@ -866,14 +862,14 @@ static ssize_t dbgfs_monitor_on_write(st
 	}
 
 	if (!strncmp(kbuf, "on", count))
-		err = damon_start(dbgfs_ctxs, dbgfs_nr_ctxs);
+		ret = damon_start(dbgfs_ctxs, dbgfs_nr_ctxs);
 	else if (!strncmp(kbuf, "off", count))
-		err = damon_stop(dbgfs_ctxs, dbgfs_nr_ctxs);
+		ret = damon_stop(dbgfs_ctxs, dbgfs_nr_ctxs);
 	else
-		err = -EINVAL;
+		ret = -EINVAL;
 
-	if (err)
-		ret = err;
+	if (!ret)
+		ret = count;
 	kfree(kbuf);
 	return ret;
 }
_
