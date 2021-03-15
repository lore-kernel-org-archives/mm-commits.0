Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FB44C433E6
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 23:04:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0CC064F5F
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 23:04:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232565AbhCOXDa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Mar 2021 19:03:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:46380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232496AbhCOXDX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Mar 2021 19:03:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08AA764F51;
        Mon, 15 Mar 2021 23:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615849403;
        bh=0rrlnV66FrhRNLlsBwE0/mjZXA3jD9c1wXNw25fvzK0=;
        h=Date:From:To:Subject:From;
        b=WRI15Ibv+WsagpOdFQ8cG1uaMN9ATzOVZi+lOCc/fT27appkqQol00HzWQSolORTZ
         VFr29nTgy+KeCJR147MMTaE1oYWkTwkbscOTjHIXWaJSWY3PY7kMAhjqx6vxARxtkh
         pr/R7lbFqG0zDtWQG/iL/ONlXHvO8rdh35wZY/0Q=
Date:   Mon, 15 Mar 2021 16:03:22 -0700
From:   akpm@linux-foundation.org
To:     johannes.berg@intel.com, mm-commits@vger.kernel.org,
        oberpar@linux.ibm.com
Subject:  + gcov-combine-common-code.patch added to -mm tree
Message-ID: <20210315230322.CQSsmPlqg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: gcov: combine common code
has been added to the -mm tree.  Its filename is
     gcov-combine-common-code.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/gcov-combine-common-code.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/gcov-combine-common-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Berg <johannes.berg@intel.com>
Subject: gcov: combine common code

There's a lot of duplicated code between gcc and clang implementations,
move it over to fs.c to simplify the code, there's no reason to believe
that for small data like this one would not just implement the simple
convert_to_gcda() function.

Link: https://lkml.kernel.org/r/20210315235453.e3fbb86e99a0.I08a3ee6dbe47ea3e8024956083f162884a958e40@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Cc: Peter Oberparleiter <oberpar@linux.ibm.com>
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
@@ -360,71 +359,6 @@ void gcov_info_free(struct gcov_info *in
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
@@ -432,7 +366,7 @@ static size_t store_gcov_u64(void *buffe
  *
  * Returns the number of bytes that were/would have been stored into the buffer.
  */
-static size_t convert_to_gcda(char *buffer, struct gcov_info *info)
+size_t convert_to_gcda(char *buffer, struct gcov_info *info)
 {
 	struct gcov_fn_info *fi_ptr;
 	size_t pos = 0;
@@ -464,102 +398,3 @@ static size_t convert_to_gcda(char *buff
 
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

Patches currently in -mm which might be from johannes.berg@intel.com are

gcov-combine-common-code.patch
gcov-simplify-buffer-allocation.patch
gcov-use-kvmalloc.patch
gdb-lx-symbols-store-the-abspath.patch

