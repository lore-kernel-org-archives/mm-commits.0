Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18399C43460
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:04:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB52D610F7
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:04:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234097AbhEGBFv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:05:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:46568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230384AbhEGBFu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:05:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 645F161289;
        Fri,  7 May 2021 01:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349491;
        bh=aRfkhS6Ve5ejvbbwrSS0l5EzB7qePCAjymWgIrZAoo0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=z2w+MxHtb3VqAssw682trmSH8GLgu5ykAnlAnunwnlYIHMNxirHVdjE/iTOeGSZ04
         tko0g5ma14gK4bm0vjyMxnHZeJT5jJ8YgHKWP/PZPKrZCgbwfhEnAEPh/C66xd9DCg
         NGMU+r1E8IJqu6Hq9VB8qcU2rWGgF7ST1ujushEU=
Date:   Thu, 06 May 2021 18:04:51 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, johannes.berg@intel.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        ndesaulniers@google.com, oberpar@linux.ibm.com,
        torvalds@linux-foundation.org
Subject:  [patch 54/91] gcov: use kvmalloc()
Message-ID: <20210507010451.SImBP81EA%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>
Subject: gcov: use kvmalloc()

Using vmalloc() in gcov is really quite wasteful, many of the objects
allocated are really small (e.g.  I've seen 24 bytes.) Use kvmalloc() to
automatically pick the better of kmalloc() or vmalloc() depending on the
size.

[johannes.berg@intel.com: fix clang-11+ build]
  Link: https://lkml.kernel.org/r/20210412214210.6e1ecca9cdc5.I24459763acf0591d5e6b31c7e3a59890d802f79c@changeid
Link: https://lkml.kernel.org/r/20210315235453.799e7a9d627d.I741d0db096c6f312910f7f1bcdfde0fda20801a4@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Cc: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/gcov/clang.c   |   12 ++++++------
 kernel/gcov/fs.c      |    6 +++---
 kernel/gcov/gcc_4_7.c |    6 +++---
 3 files changed, 12 insertions(+), 12 deletions(-)

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
@@ -333,8 +333,8 @@ void gcov_info_add(struct gcov_info *dst
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
@@ -344,7 +344,7 @@ static struct gcov_fn_info *gcov_fn_info
 		goto err_name;
 
 	cv_size = fn->num_counters * sizeof(fn->counters[0]);
-	fn_dup->counters = vmalloc(cv_size);
+	fn_dup->counters = kvmalloc(cv_size, GFP_KERNEL);
 	if (!fn_dup->counters)
 		goto err_counters;
 	memcpy(fn_dup->counters, fn->counters, cv_size);
@@ -368,7 +368,7 @@ static struct gcov_fn_info *gcov_fn_info
 	INIT_LIST_HEAD(&fn_dup->head);
 
 	cv_size = fn->num_counters * sizeof(fn->counters[0]);
-	fn_dup->counters = vmalloc(cv_size);
+	fn_dup->counters = kvmalloc(cv_size, GFP_KERNEL);
 	if (!fn_dup->counters) {
 		kfree(fn_dup);
 		return NULL;
@@ -439,7 +439,7 @@ void gcov_info_free(struct gcov_info *in
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
