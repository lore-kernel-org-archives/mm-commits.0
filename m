Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B846DC433B4
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:04:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9934A613C2
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:04:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234098AbhEGBFx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:05:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:46642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230384AbhEGBFx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:05:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79479610F7;
        Fri,  7 May 2021 01:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349494;
        bh=f7Hd1DRypLlz4MxwRNdIsYuf1gSg7jpbLf3oI6yZ0kM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=0YyzVo9uPF5H7vjAEa6XbvanP7Y3QVsDmjawkI2/Uir+LWbsizBUOmXQbSa+NaYpZ
         aV8JTsopFc1Z7yYQ7aydc2zrC99D+/Stf3qgJ1Fhr/XLQRvGZDQjivN1Mi5iXbxp11
         gkXZyQS1m8QWcsm3Oc9gVsTaZ2YNH/M1NbCnGFJ8=
Date:   Thu, 06 May 2021 18:04:54 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, johannes.berg@intel.com,
        linux-mm@kvack.org, maskray@google.com, mm-commits@vger.kernel.org,
        nathan@kernel.org, ndesaulniers@google.com, oberpar@linux.ibm.com,
        psodagud@quicinc.com, torvalds@linux-foundation.org
Subject:  [patch 55/91] gcov: clang: drop support for clang-10 and
 older
Message-ID: <20210507010454.2_kZyIPsW%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>
Subject: gcov: clang: drop support for clang-10 and older

LLVM changed the expected function signatures for llvm_gcda_start_file()
and llvm_gcda_emit_function() in the clang-11 release.  Drop the older
implementations and require folks to upgrade their compiler if they're
interested in GCOV support.

Link: https://reviews.llvm.org/rGcdd683b516d147925212724b09ec6fb792a40041
Link: https://reviews.llvm.org/rG13a633b438b6500ecad9e4f936ebadf3411d0f44
Link: https://lkml.kernel.org/r/20210312224132.3413602-3-ndesaulniers@google.com
Link: https://lkml.kernel.org/r/20210413183113.2977432-1-ndesaulniers@google.com
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Suggested-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Fangrui Song <maskray@google.com>
Cc: Prasad Sodagudi <psodagud@quicinc.com>
Cc: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/gcov/Kconfig |    1 
 kernel/gcov/clang.c |  103 ------------------------------------------
 2 files changed, 1 insertion(+), 103 deletions(-)

--- a/kernel/gcov/clang.c~gcov-clang-drop-support-for-clang-10-and-older
+++ a/kernel/gcov/clang.c
@@ -69,16 +69,10 @@ struct gcov_fn_info {
 
 	u32 ident;
 	u32 checksum;
-#if CONFIG_CLANG_VERSION < 110000
-	u8 use_extra_checksum;
-#endif
 	u32 cfg_checksum;
 
 	u32 num_counters;
 	u64 *counters;
-#if CONFIG_CLANG_VERSION < 110000
-	const char *function_name;
-#endif
 };
 
 static struct gcov_info *current_info;
@@ -108,16 +102,6 @@ void llvm_gcov_init(llvm_gcov_callback w
 }
 EXPORT_SYMBOL(llvm_gcov_init);
 
-#if CONFIG_CLANG_VERSION < 110000
-void llvm_gcda_start_file(const char *orig_filename, const char version[4],
-		u32 checksum)
-{
-	current_info->filename = orig_filename;
-	memcpy(&current_info->version, version, sizeof(current_info->version));
-	current_info->checksum = checksum;
-}
-EXPORT_SYMBOL(llvm_gcda_start_file);
-#else
 void llvm_gcda_start_file(const char *orig_filename, u32 version, u32 checksum)
 {
 	current_info->filename = orig_filename;
@@ -125,28 +109,7 @@ void llvm_gcda_start_file(const char *or
 	current_info->checksum = checksum;
 }
 EXPORT_SYMBOL(llvm_gcda_start_file);
-#endif
 
-#if CONFIG_CLANG_VERSION < 110000
-void llvm_gcda_emit_function(u32 ident, const char *function_name,
-		u32 func_checksum, u8 use_extra_checksum, u32 cfg_checksum)
-{
-	struct gcov_fn_info *info = kzalloc(sizeof(*info), GFP_KERNEL);
-
-	if (!info)
-		return;
-
-	INIT_LIST_HEAD(&info->head);
-	info->ident = ident;
-	info->checksum = func_checksum;
-	info->use_extra_checksum = use_extra_checksum;
-	info->cfg_checksum = cfg_checksum;
-	if (function_name)
-		info->function_name = kstrdup(function_name, GFP_KERNEL);
-
-	list_add_tail(&info->head, &current_info->functions);
-}
-#else
 void llvm_gcda_emit_function(u32 ident, u32 func_checksum, u32 cfg_checksum)
 {
 	struct gcov_fn_info *info = kzalloc(sizeof(*info), GFP_KERNEL);
@@ -160,7 +123,6 @@ void llvm_gcda_emit_function(u32 ident,
 	info->cfg_checksum = cfg_checksum;
 	list_add_tail(&info->head, &current_info->functions);
 }
-#endif
 EXPORT_SYMBOL(llvm_gcda_emit_function);
 
 void llvm_gcda_emit_arcs(u32 num_counters, u64 *counters)
@@ -291,16 +253,8 @@ int gcov_info_is_compatible(struct gcov_
 		!list_is_last(&fn_ptr2->head, &info2->functions)) {
 		if (fn_ptr1->checksum != fn_ptr2->checksum)
 			return false;
-#if CONFIG_CLANG_VERSION < 110000
-		if (fn_ptr1->use_extra_checksum != fn_ptr2->use_extra_checksum)
-			return false;
-		if (fn_ptr1->use_extra_checksum &&
-			fn_ptr1->cfg_checksum != fn_ptr2->cfg_checksum)
-			return false;
-#else
 		if (fn_ptr1->cfg_checksum != fn_ptr2->cfg_checksum)
 			return false;
-#endif
 		fn_ptr1 = list_next_entry(fn_ptr1, head);
 		fn_ptr2 = list_next_entry(fn_ptr2, head);
 	}
@@ -329,35 +283,6 @@ void gcov_info_add(struct gcov_info *dst
 	}
 }
 
-#if CONFIG_CLANG_VERSION < 110000
-static struct gcov_fn_info *gcov_fn_info_dup(struct gcov_fn_info *fn)
-{
-	size_t cv_size; /* counter values size */
-	struct gcov_fn_info *fn_dup = kmemdup(fn, sizeof(*fn), GFP_KERNEL);
-
-	if (!fn_dup)
-		return NULL;
-	INIT_LIST_HEAD(&fn_dup->head);
-
-	fn_dup->function_name = kstrdup(fn->function_name, GFP_KERNEL);
-	if (!fn_dup->function_name)
-		goto err_name;
-
-	cv_size = fn->num_counters * sizeof(fn->counters[0]);
-	fn_dup->counters = kvmalloc(cv_size, GFP_KERNEL);
-	if (!fn_dup->counters)
-		goto err_counters;
-	memcpy(fn_dup->counters, fn->counters, cv_size);
-
-	return fn_dup;
-
-err_counters:
-	kfree(fn_dup->function_name);
-err_name:
-	kfree(fn_dup);
-	return NULL;
-}
-#else
 static struct gcov_fn_info *gcov_fn_info_dup(struct gcov_fn_info *fn)
 {
 	size_t cv_size; /* counter values size */
@@ -378,7 +303,6 @@ static struct gcov_fn_info *gcov_fn_info
 
 	return fn_dup;
 }
-#endif
 
 /**
  * gcov_info_dup - duplicate profiling data set
@@ -419,21 +343,6 @@ err:
  * gcov_info_free - release memory for profiling data set duplicate
  * @info: profiling data set duplicate to free
  */
-#if CONFIG_CLANG_VERSION < 110000
-void gcov_info_free(struct gcov_info *info)
-{
-	struct gcov_fn_info *fn, *tmp;
-
-	list_for_each_entry_safe(fn, tmp, &info->functions, head) {
-		kfree(fn->function_name);
-		vfree(fn->counters);
-		list_del(&fn->head);
-		kfree(fn);
-	}
-	kfree(info->filename);
-	kfree(info);
-}
-#else
 void gcov_info_free(struct gcov_info *info)
 {
 	struct gcov_fn_info *fn, *tmp;
@@ -446,7 +355,6 @@ void gcov_info_free(struct gcov_info *in
 	kfree(info->filename);
 	kfree(info);
 }
-#endif
 
 /**
  * convert_to_gcda - convert profiling data set to gcda file format
@@ -469,21 +377,10 @@ size_t convert_to_gcda(char *buffer, str
 		u32 i;
 
 		pos += store_gcov_u32(buffer, pos, GCOV_TAG_FUNCTION);
-#if CONFIG_CLANG_VERSION < 110000
-		pos += store_gcov_u32(buffer, pos,
-			fi_ptr->use_extra_checksum ? 3 : 2);
-#else
 		pos += store_gcov_u32(buffer, pos, 3);
-#endif
 		pos += store_gcov_u32(buffer, pos, fi_ptr->ident);
 		pos += store_gcov_u32(buffer, pos, fi_ptr->checksum);
-#if CONFIG_CLANG_VERSION < 110000
-		if (fi_ptr->use_extra_checksum)
-			pos += store_gcov_u32(buffer, pos, fi_ptr->cfg_checksum);
-#else
 		pos += store_gcov_u32(buffer, pos, fi_ptr->cfg_checksum);
-#endif
-
 		pos += store_gcov_u32(buffer, pos, GCOV_TAG_COUNTER_BASE);
 		pos += store_gcov_u32(buffer, pos, fi_ptr->num_counters * 2);
 		for (i = 0; i < fi_ptr->num_counters; i++)
--- a/kernel/gcov/Kconfig~gcov-clang-drop-support-for-clang-10-and-older
+++ a/kernel/gcov/Kconfig
@@ -4,6 +4,7 @@ menu "GCOV-based kernel profiling"
 config GCOV_KERNEL
 	bool "Enable gcov-based kernel profiling"
 	depends on DEBUG_FS
+	depends on !CC_IS_CLANG || CLANG_VERSION >= 110000
 	select CONSTRUCTORS
 	default n
 	help
_
