Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D3A3C433B4
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:04:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61582613C8
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:04:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233978AbhEGBFo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:05:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:46416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230384AbhEGBFo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:05:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8515C610F7;
        Fri,  7 May 2021 01:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349485;
        bh=t0youfz5dN1dJzK53nP2vk/OOOo8hSXhHIt1NxgMb9k=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=MzEnnXJgA+h0B2fC5u+xya/8EhHV1pU6G/OKczoN6VCNJFVD8sQ3c+Y6skO/3y5Yf
         7kGM4cxzplF8DlXT1ihm15X0c+Puuz3lGWBcRw/Vci+irypEsdA2JHnxynlJPbJQOl
         9PzGI5etyoeSZPWYZzOmNfUhA9IGyF06OvFrT++Q=
Date:   Thu, 06 May 2021 18:04:45 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, johannes.berg@intel.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        oberpar@linux.ibm.com, torvalds@linux-foundation.org
Subject:  [patch 52/91] gcov: combine common code
Message-ID: <20210507010445.W3GlTQ1dI%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>
Subject: gcov: combine common code

There's a lot of duplicated code between gcc and clang implementations,
move it over to fs.c to simplify the code, there's no reason to believe
that for small data like this one would not just implement the simple
convert_to_gcda() function.

Link: https://lkml.kernel.org/r/20210315235453.e3fbb86e99a0.I08a3ee6dbe47ea3e8024956083f162884a958e40@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Acked-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/gcov/base.c    |   49 +++++++++++
 kernel/gcov/clang.c   |  167 ----------------------------------------
 kernel/gcov/fs.c      |  116 +++++++++++++++++++++++++++
 kernel/gcov/gcc_4_7.c |  167 ----------------------------------------
 kernel/gcov/gcov.h    |   14 ---
 5 files changed, 171 insertions(+), 342 deletions(-)

--- a/kernel/gcov/base.c~gcov-combine-common-code
+++ a/kernel/gcov/base.c
@@ -49,6 +49,55 @@ void gcov_enable_events(void)
 	mutex_unlock(&gcov_lock);
 }
 
+/**
+ * store_gcov_u32 - store 32 bit number in gcov format to buffer
+ * @buffer: target buffer or NULL
+ * @off: offset into the buffer
+ * @v: value to be stored
+ *
+ * Number format defined by gcc: numbers are recorded in the 32 bit
+ * unsigned binary form of the endianness of the machine generating the
+ * file. Returns the number of bytes stored. If @buffer is %NULL, doesn't
+ * store anything.
+ */
+size_t store_gcov_u32(void *buffer, size_t off, u32 v)
+{
+	u32 *data;
+
+	if (buffer) {
+		data = buffer + off;
+		*data = v;
+	}
+
+	return sizeof(*data);
+}
+
+/**
+ * store_gcov_u64 - store 64 bit number in gcov format to buffer
+ * @buffer: target buffer or NULL
+ * @off: offset into the buffer
+ * @v: value to be stored
+ *
+ * Number format defined by gcc: numbers are recorded in the 32 bit
+ * unsigned binary form of the endianness of the machine generating the
+ * file. 64 bit numbers are stored as two 32 bit numbers, the low part
+ * first. Returns the number of bytes stored. If @buffer is %NULL, doesn't store
+ * anything.
+ */
+size_t store_gcov_u64(void *buffer, size_t off, u64 v)
+{
+	u32 *data;
+
+	if (buffer) {
+		data = buffer + off;
+
+		data[0] = (v & 0xffffffffUL);
+		data[1] = (v >> 32);
+	}
+
+	return sizeof(*data) * 2;
+}
+
 #ifdef CONFIG_MODULES
 /* Update list and generate events when modules are unloaded. */
 static int gcov_module_notifier(struct notifier_block *nb, unsigned long event,
--- a/kernel/gcov/clang.c~gcov-combine-common-code
+++ a/kernel/gcov/clang.c
@@ -48,7 +48,6 @@
 #include <linux/list.h>
 #include <linux/printk.h>
 #include <linux/ratelimit.h>
-#include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include "gcov.h"
@@ -449,71 +448,6 @@ void gcov_info_free(struct gcov_info *in
 }
 #endif
 
-#define ITER_STRIDE	PAGE_SIZE
-
-/**
- * struct gcov_iterator - specifies current file position in logical records
- * @info: associated profiling data
- * @buffer: buffer containing file data
- * @size: size of buffer
- * @pos: current position in file
- */
-struct gcov_iterator {
-	struct gcov_info *info;
-	void *buffer;
-	size_t size;
-	loff_t pos;
-};
-
-/**
- * store_gcov_u32 - store 32 bit number in gcov format to buffer
- * @buffer: target buffer or NULL
- * @off: offset into the buffer
- * @v: value to be stored
- *
- * Number format defined by gcc: numbers are recorded in the 32 bit
- * unsigned binary form of the endianness of the machine generating the
- * file. Returns the number of bytes stored. If @buffer is %NULL, doesn't
- * store anything.
- */
-static size_t store_gcov_u32(void *buffer, size_t off, u32 v)
-{
-	u32 *data;
-
-	if (buffer) {
-		data = buffer + off;
-		*data = v;
-	}
-
-	return sizeof(*data);
-}
-
-/**
- * store_gcov_u64 - store 64 bit number in gcov format to buffer
- * @buffer: target buffer or NULL
- * @off: offset into the buffer
- * @v: value to be stored
- *
- * Number format defined by gcc: numbers are recorded in the 32 bit
- * unsigned binary form of the endianness of the machine generating the
- * file. 64 bit numbers are stored as two 32 bit numbers, the low part
- * first. Returns the number of bytes stored. If @buffer is %NULL, doesn't store
- * anything.
- */
-static size_t store_gcov_u64(void *buffer, size_t off, u64 v)
-{
-	u32 *data;
-
-	if (buffer) {
-		data = buffer + off;
-
-		data[0] = (v & 0xffffffffUL);
-		data[1] = (v >> 32);
-	}
-
-	return sizeof(*data) * 2;
-}
-
 /**
  * convert_to_gcda - convert profiling data set to gcda file format
  * @buffer: the buffer to store file data or %NULL if no data should be stored
@@ -521,7 +455,7 @@ static size_t store_gcov_u64(void *buffe
  *
  * Returns the number of bytes that were/would have been stored into the buffer.
  */
-static size_t convert_to_gcda(char *buffer, struct gcov_info *info)
+size_t convert_to_gcda(char *buffer, struct gcov_info *info)
 {
 	struct gcov_fn_info *fi_ptr;
 	size_t pos = 0;
@@ -558,102 +492,3 @@ static size_t convert_to_gcda(char *buff
 
 	return pos;
 }
-
-/**
- * gcov_iter_new - allocate and initialize profiling data iterator
- * @info: profiling data set to be iterated
- *
- * Return file iterator on success, %NULL otherwise.
- */
-struct gcov_iterator *gcov_iter_new(struct gcov_info *info)
-{
-	struct gcov_iterator *iter;
-
-	iter = kzalloc(sizeof(struct gcov_iterator), GFP_KERNEL);
-	if (!iter)
-		goto err_free;
-
-	iter->info = info;
-	/* Dry-run to get the actual buffer size. */
-	iter->size = convert_to_gcda(NULL, info);
-	iter->buffer = vmalloc(iter->size);
-	if (!iter->buffer)
-		goto err_free;
-
-	convert_to_gcda(iter->buffer, info);
-
-	return iter;
-
-err_free:
-	kfree(iter);
-	return NULL;
-}
-
-
-/**
- * gcov_iter_get_info - return profiling data set for given file iterator
- * @iter: file iterator
- */
-void gcov_iter_free(struct gcov_iterator *iter)
-{
-	vfree(iter->buffer);
-	kfree(iter);
-}
-
-/**
- * gcov_iter_get_info - return profiling data set for given file iterator
- * @iter: file iterator
- */
-struct gcov_info *gcov_iter_get_info(struct gcov_iterator *iter)
-{
-	return iter->info;
-}
-
-/**
- * gcov_iter_start - reset file iterator to starting position
- * @iter: file iterator
- */
-void gcov_iter_start(struct gcov_iterator *iter)
-{
-	iter->pos = 0;
-}
-
-/**
- * gcov_iter_next - advance file iterator to next logical record
- * @iter: file iterator
- *
- * Return zero if new position is valid, non-zero if iterator has reached end.
- */
-int gcov_iter_next(struct gcov_iterator *iter)
-{
-	if (iter->pos < iter->size)
-		iter->pos += ITER_STRIDE;
-
-	if (iter->pos >= iter->size)
-		return -EINVAL;
-
-	return 0;
-}
-
-/**
- * gcov_iter_write - write data for current pos to seq_file
- * @iter: file iterator
- * @seq: seq_file handle
- *
- * Return zero on success, non-zero otherwise.
- */
-int gcov_iter_write(struct gcov_iterator *iter, struct seq_file *seq)
-{
-	size_t len;
-
-	if (iter->pos >= iter->size)
-		return -EINVAL;
-
-	len = ITER_STRIDE;
-	if (iter->pos + len > iter->size)
-		len = iter->size - iter->pos;
-
-	seq_write(seq, iter->buffer + iter->pos, len);
-
-	return 0;
-}
--- a/kernel/gcov/fs.c~gcov-combine-common-code
+++ a/kernel/gcov/fs.c
@@ -26,6 +26,7 @@
 #include <linux/slab.h>
 #include <linux/mutex.h>
 #include <linux/seq_file.h>
+#include <linux/vmalloc.h>
 #include "gcov.h"
 
 /**
@@ -85,6 +86,121 @@ static int __init gcov_persist_setup(cha
 }
 __setup("gcov_persist=", gcov_persist_setup);
 
+#define ITER_STRIDE	PAGE_SIZE
+
+/**
+ * struct gcov_iterator - specifies current file position in logical records
+ * @info: associated profiling data
+ * @buffer: buffer containing file data
+ * @size: size of buffer
+ * @pos: current position in file
+ */
+struct gcov_iterator {
+	struct gcov_info *info;
+	void *buffer;
+	size_t size;
+	loff_t pos;
+};
+
+/**
+ * gcov_iter_new - allocate and initialize profiling data iterator
+ * @info: profiling data set to be iterated
+ *
+ * Return file iterator on success, %NULL otherwise.
+ */
+static struct gcov_iterator *gcov_iter_new(struct gcov_info *info)
+{
+	struct gcov_iterator *iter;
+
+	iter = kzalloc(sizeof(struct gcov_iterator), GFP_KERNEL);
+	if (!iter)
+		goto err_free;
+
+	iter->info = info;
+	/* Dry-run to get the actual buffer size. */
+	iter->size = convert_to_gcda(NULL, info);
+	iter->buffer = vmalloc(iter->size);
+	if (!iter->buffer)
+		goto err_free;
+
+	convert_to_gcda(iter->buffer, info);
+
+	return iter;
+
+err_free:
+	kfree(iter);
+	return NULL;
+}
+
+
+/**
+ * gcov_iter_free - free iterator data
+ * @iter: file iterator
+ */
+static void gcov_iter_free(struct gcov_iterator *iter)
+{
+	vfree(iter->buffer);
+	kfree(iter);
+}
+
+/**
+ * gcov_iter_get_info - return profiling data set for given file iterator
+ * @iter: file iterator
+ */
+static struct gcov_info *gcov_iter_get_info(struct gcov_iterator *iter)
+{
+	return iter->info;
+}
+
+/**
+ * gcov_iter_start - reset file iterator to starting position
+ * @iter: file iterator
+ */
+static void gcov_iter_start(struct gcov_iterator *iter)
+{
+	iter->pos = 0;
+}
+
+/**
+ * gcov_iter_next - advance file iterator to next logical record
+ * @iter: file iterator
+ *
+ * Return zero if new position is valid, non-zero if iterator has reached end.
+ */
+static int gcov_iter_next(struct gcov_iterator *iter)
+{
+	if (iter->pos < iter->size)
+		iter->pos += ITER_STRIDE;
+
+	if (iter->pos >= iter->size)
+		return -EINVAL;
+
+	return 0;
+}
+
+/**
+ * gcov_iter_write - write data for current pos to seq_file
+ * @iter: file iterator
+ * @seq: seq_file handle
+ *
+ * Return zero on success, non-zero otherwise.
+ */
+static int gcov_iter_write(struct gcov_iterator *iter, struct seq_file *seq)
+{
+	size_t len;
+
+	if (iter->pos >= iter->size)
+		return -EINVAL;
+
+	len = ITER_STRIDE;
+	if (iter->pos + len > iter->size)
+		len = iter->size - iter->pos;
+
+	seq_write(seq, iter->buffer + iter->pos, len);
+
+	return 0;
+}
+
 /*
  * seq_file.start() implementation for gcov data files. Note that the
  * gcov_iterator interface is designed to be more restrictive than seq_file
--- a/kernel/gcov/gcc_4_7.c~gcov-combine-common-code
+++ a/kernel/gcov/gcc_4_7.c
@@ -15,7 +15,6 @@
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/string.h>
-#include <linux/seq_file.h>
 #include <linux/vmalloc.h>
 #include "gcov.h"
 
@@ -363,71 +362,6 @@ free_info:
 	kfree(info);
 }
 
-#define ITER_STRIDE	PAGE_SIZE
-
-/**
- * struct gcov_iterator - specifies current file position in logical records
- * @info: associated profiling data
- * @buffer: buffer containing file data
- * @size: size of buffer
- * @pos: current position in file
- */
-struct gcov_iterator {
-	struct gcov_info *info;
-	void *buffer;
-	size_t size;
-	loff_t pos;
-};
-
-/**
- * store_gcov_u32 - store 32 bit number in gcov format to buffer
- * @buffer: target buffer or NULL
- * @off: offset into the buffer
- * @v: value to be stored
- *
- * Number format defined by gcc: numbers are recorded in the 32 bit
- * unsigned binary form of the endianness of the machine generating the
- * file. Returns the number of bytes stored. If @buffer is %NULL, doesn't
- * store anything.
- */
-static size_t store_gcov_u32(void *buffer, size_t off, u32 v)
-{
-	u32 *data;
-
-	if (buffer) {
-		data = buffer + off;
-		*data = v;
-	}
-
-	return sizeof(*data);
-}
-
-/**
- * store_gcov_u64 - store 64 bit number in gcov format to buffer
- * @buffer: target buffer or NULL
- * @off: offset into the buffer
- * @v: value to be stored
- *
- * Number format defined by gcc: numbers are recorded in the 32 bit
- * unsigned binary form of the endianness of the machine generating the
- * file. 64 bit numbers are stored as two 32 bit numbers, the low part
- * first. Returns the number of bytes stored. If @buffer is %NULL, doesn't store
- * anything.
- */
-static size_t store_gcov_u64(void *buffer, size_t off, u64 v)
-{
-	u32 *data;
-
-	if (buffer) {
-		data = buffer + off;
-
-		data[0] = (v & 0xffffffffUL);
-		data[1] = (v >> 32);
-	}
-
-	return sizeof(*data) * 2;
-}
-
 /**
  * convert_to_gcda - convert profiling data set to gcda file format
  * @buffer: the buffer to store file data or %NULL if no data should be stored
@@ -435,7 +369,7 @@ static size_t store_gcov_u64(void *buffe
  *
  * Returns the number of bytes that were/would have been stored into the buffer.
  */
-static size_t convert_to_gcda(char *buffer, struct gcov_info *info)
+size_t convert_to_gcda(char *buffer, struct gcov_info *info)
 {
 	struct gcov_fn_info *fi_ptr;
 	struct gcov_ctr_info *ci_ptr;
@@ -481,102 +415,3 @@ static size_t convert_to_gcda(char *buff
 
 	return pos;
 }
-
-/**
- * gcov_iter_new - allocate and initialize profiling data iterator
- * @info: profiling data set to be iterated
- *
- * Return file iterator on success, %NULL otherwise.
- */
-struct gcov_iterator *gcov_iter_new(struct gcov_info *info)
-{
-	struct gcov_iterator *iter;
-
-	iter = kzalloc(sizeof(struct gcov_iterator), GFP_KERNEL);
-	if (!iter)
-		goto err_free;
-
-	iter->info = info;
-	/* Dry-run to get the actual buffer size. */
-	iter->size = convert_to_gcda(NULL, info);
-	iter->buffer = vmalloc(iter->size);
-	if (!iter->buffer)
-		goto err_free;
-
-	convert_to_gcda(iter->buffer, info);
-
-	return iter;
-
-err_free:
-	kfree(iter);
-	return NULL;
-}
-
-
-/**
- * gcov_iter_get_info - return profiling data set for given file iterator
- * @iter: file iterator
- */
-void gcov_iter_free(struct gcov_iterator *iter)
-{
-	vfree(iter->buffer);
-	kfree(iter);
-}
-
-/**
- * gcov_iter_get_info - return profiling data set for given file iterator
- * @iter: file iterator
- */
-struct gcov_info *gcov_iter_get_info(struct gcov_iterator *iter)
-{
-	return iter->info;
-}
-
-/**
- * gcov_iter_start - reset file iterator to starting position
- * @iter: file iterator
- */
-void gcov_iter_start(struct gcov_iterator *iter)
-{
-	iter->pos = 0;
-}
-
-/**
- * gcov_iter_next - advance file iterator to next logical record
- * @iter: file iterator
- *
- * Return zero if new position is valid, non-zero if iterator has reached end.
- */
-int gcov_iter_next(struct gcov_iterator *iter)
-{
-	if (iter->pos < iter->size)
-		iter->pos += ITER_STRIDE;
-
-	if (iter->pos >= iter->size)
-		return -EINVAL;
-
-	return 0;
-}
-
-/**
- * gcov_iter_write - write data for current pos to seq_file
- * @iter: file iterator
- * @seq: seq_file handle
- *
- * Return zero on success, non-zero otherwise.
- */
-int gcov_iter_write(struct gcov_iterator *iter, struct seq_file *seq)
-{
-	size_t len;
-
-	if (iter->pos >= iter->size)
-		return -EINVAL;
-
-	len = ITER_STRIDE;
-	if (iter->pos + len > iter->size)
-		len = iter->size - iter->pos;
-
-	seq_write(seq, iter->buffer + iter->pos, len);
-
-	return 0;
-}
--- a/kernel/gcov/gcov.h~gcov-combine-common-code
+++ a/kernel/gcov/gcov.h
@@ -48,6 +48,7 @@ struct gcov_info *gcov_info_next(struct
 void gcov_info_link(struct gcov_info *info);
 void gcov_info_unlink(struct gcov_info *prev, struct gcov_info *info);
 bool gcov_info_within_module(struct gcov_info *info, struct module *mod);
+size_t convert_to_gcda(char *buffer, struct gcov_info *info);
 
 /* Base interface. */
 enum gcov_action {
@@ -58,16 +59,9 @@ enum gcov_action {
 void gcov_event(enum gcov_action action, struct gcov_info *info);
 void gcov_enable_events(void);
 
-/* Iterator control. */
-struct seq_file;
-struct gcov_iterator;
-
-struct gcov_iterator *gcov_iter_new(struct gcov_info *info);
-void gcov_iter_free(struct gcov_iterator *iter);
-void gcov_iter_start(struct gcov_iterator *iter);
-int gcov_iter_next(struct gcov_iterator *iter);
-int gcov_iter_write(struct gcov_iterator *iter, struct seq_file *seq);
-struct gcov_info *gcov_iter_get_info(struct gcov_iterator *iter);
+/* writing helpers */
+size_t store_gcov_u32(void *buffer, size_t off, u32 v);
+size_t store_gcov_u64(void *buffer, size_t off, u64 v);
 
 /* gcov_info control. */
 void gcov_info_reset(struct gcov_info *info);
_
