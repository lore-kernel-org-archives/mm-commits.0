Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AB41C433DB
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 23:04:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5745664F5C
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 23:04:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232474AbhCOXEC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Mar 2021 19:04:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:46412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232528AbhCOXD3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Mar 2021 19:03:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E61CE64E07;
        Mon, 15 Mar 2021 23:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615849409;
        bh=tO7nNICmccs5yb+KOp67GDUhHv3wDUTJlLks1ekxtuw=;
        h=Date:From:To:Subject:From;
        b=iIAAWS9AMD/DmRD6rEtThEz2mwsw1WgCAZzDrIMDBceENNA01bWPgD7y8NR8uTBOH
         dXaQAiLFZoeY5eFr5HVbzm208oOa82rfkuVVKG+eNdtIIkuHTH7ATn4DbBYFQHBTSo
         ZKSBaQbYlQgoKH9UekYGNGp9PQnUPdbYx5XXpRQ8=
Date:   Mon, 15 Mar 2021 16:03:28 -0700
From:   akpm@linux-foundation.org
To:     johannes.berg@intel.com, mm-commits@vger.kernel.org,
        oberpar@linux.ibm.com
Subject:  + gcov-use-kvmalloc.patch added to -mm tree
Message-ID: <20210315230328.EcGm9_w-F%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: gcov: use kvmalloc()
has been added to the -mm tree.  Its filename is
     gcov-use-kvmalloc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/gcov-use-kvmalloc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/gcov-use-kvmalloc.patch

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
Subject: gcov: use kvmalloc()

Using vmalloc() in gcov is really quite wasteful, many of the objects
allocated are really small (e.g.  I've seen 24 bytes.) Use kvmalloc() to
automatically pick the better of kmalloc() or vmalloc() depending on the
size.

Link: https://lkml.kernel.org/r/20210315235453.799e7a9d627d.I741d0db096c6f312910f7f1bcdfde0fda20801a4@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Cc: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/gcov/clang.c   |   10 +++++-----
 kernel/gcov/fs.c      |    6 +++---
 kernel/gcov/gcc_4_7.c |    6 +++---
 3 files changed, 11 insertions(+), 11 deletions(-)

--- a/kernel/gcov/clang.c~gcov-use-kvmalloc
+++ a/kernel/gcov/clang.c
@@ -49,7 +49,7 @@
 #include <linux/printk.h>
 #include <linux/ratelimit.h>
 #include <linux/slab.h>
-#include <linux/vmalloc.h>
+#include <linux/mm.h>
 #include "gcov.h"
 
 typedef void (*llvm_gcov_callback)(void);
@@ -292,13 +292,13 @@ void gcov_info_add(struct gcov_info *dst
 static struct gcov_fn_info *gcov_fn_info_dup(struct gcov_fn_info *fn)
 {
 	size_t cv_size; /* counter values size */
-	struct gcov_fn_info *fn_dup = kmemdup(fn, sizeof(*fn),
-			GFP_KERNEL);
+	struct gcov_fn_info *fn_dup = kmemdup(fn, sizeof(*fn), GFP_KERNEL);
+
 	if (!fn_dup)
 		return NULL;
 	INIT_LIST_HEAD(&fn_dup->head);
 	cv_size = fn->num_counters * sizeof(fn->counters[0]);
-	fn_dup->counters = vmalloc(cv_size);
+	fn_dup->counters = kvmalloc(cv_size, GFP_KERNEL);
 	if (!fn_dup->counters) {
 		kfree(fn_dup);
 		return NULL;
@@ -351,7 +351,7 @@ void gcov_info_free(struct gcov_info *in
 	struct gcov_fn_info *fn, *tmp;
 
 	list_for_each_entry_safe(fn, tmp, &info->functions, head) {
-		vfree(fn->counters);
+		kvfree(fn->counters);
 		list_del(&fn->head);
 		kfree(fn);
 	}
--- a/kernel/gcov/fs.c~gcov-use-kvmalloc
+++ a/kernel/gcov/fs.c
@@ -26,7 +26,7 @@
 #include <linux/slab.h>
 #include <linux/mutex.h>
 #include <linux/seq_file.h>
-#include <linux/vmalloc.h>
+#include <linux/mm.h>
 #include "gcov.h"
 
 /**
@@ -116,7 +116,7 @@ static struct gcov_iterator *gcov_iter_n
 	/* Dry-run to get the actual buffer size. */
 	size = convert_to_gcda(NULL, info);
 
-	iter = vmalloc(struct_size(iter, buffer, size));
+	iter = kvmalloc(struct_size(iter, buffer, size), GFP_KERNEL);
 	if (!iter)
 		return NULL;
 
@@ -134,7 +134,7 @@ static struct gcov_iterator *gcov_iter_n
  */
 static void gcov_iter_free(struct gcov_iterator *iter)
 {
-	vfree(iter);
+	kvfree(iter);
 }
 
 /**
--- a/kernel/gcov/gcc_4_7.c~gcov-use-kvmalloc
+++ a/kernel/gcov/gcc_4_7.c
@@ -15,7 +15,7 @@
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/string.h>
-#include <linux/vmalloc.h>
+#include <linux/mm.h>
 #include "gcov.h"
 
 #if (__GNUC__ >= 10)
@@ -309,7 +309,7 @@ struct gcov_info *gcov_info_dup(struct g
 
 			cv_size = sizeof(gcov_type) * sci_ptr->num;
 
-			dci_ptr->values = vmalloc(cv_size);
+			dci_ptr->values = kvmalloc(cv_size, GFP_KERNEL);
 
 			if (!dci_ptr->values)
 				goto err_free;
@@ -351,7 +351,7 @@ void gcov_info_free(struct gcov_info *in
 		ci_ptr = info->functions[fi_idx]->ctrs;
 
 		for (ct_idx = 0; ct_idx < active; ct_idx++, ci_ptr++)
-			vfree(ci_ptr->values);
+			kvfree(ci_ptr->values);
 
 		kfree(info->functions[fi_idx]);
 	}
_

Patches currently in -mm which might be from johannes.berg@intel.com are

gcov-combine-common-code.patch
gcov-simplify-buffer-allocation.patch
gcov-use-kvmalloc.patch
gdb-lx-symbols-store-the-abspath.patch

