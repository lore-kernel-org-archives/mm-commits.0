Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2A5DC433E0
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 22:00:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DFC864F4D
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 22:00:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbhCOV73 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Mar 2021 17:59:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:32840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231475AbhCOV7L (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Mar 2021 17:59:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1F9664DF4;
        Mon, 15 Mar 2021 21:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615845551;
        bh=lGJvI6NrY/f9Wj1pR79j9vjRVFYXSYWm6xTql5jULgM=;
        h=Date:From:To:Subject:From;
        b=SU7+eDITqRWDaCsrrINzJGLhgeJdZKuEp3PitJzPDvxJzNd2wTf7dyc4KNArbcO3z
         pD5+WK0nnjMS2zptLcEqqHkQT2cj7Kes3zFzgyLMC+V5cAsIF+1FRwiZpnx992RrH7
         f3gXPbCXvIRcTouevWoR9bG3exzgRk3JhllRD7fk=
Date:   Mon, 15 Mar 2021 14:59:10 -0700
From:   akpm@linux-foundation.org
To:     maskray@google.com, mm-commits@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, oberpar@linux.ibm.com,
        psodagud@quicinc.com
Subject:  + gcov-clang-drop-support-for-clang-10-and-older.patch
 added to -mm tree
Message-ID: <20210315215910.9-1QObtG0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: gcov: clang: drop support for clang-10 and older
has been added to the -mm tree.  Its filename is
     gcov-clang-drop-support-for-clang-10-and-older.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/gcov-clang-drop-support-for-clang-10-and-older.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/gcov-clang-drop-support-for-clang-10-and-older.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nick Desaulniers <ndesaulniers@google.com>
Subject: gcov: clang: drop support for clang-10 and older

LLVM changed the expected function signatures for llvm_gcda_start_file()
and llvm_gcda_emit_function() in the clang-11 release.  Drop the older
implementations and require folks to upgrade their compiler if they're
interested in GCOV support.

Link: https://reviews.llvm.org/rGcdd683b516d147925212724b09ec6fb792a40041
Link: https://reviews.llvm.org/rG13a633b438b6500ecad9e4f936ebadf3411d0f44
Link: https://lkml.kernel.org/r/20210312224132.3413602-3-ndesaulniers@google.com
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Suggested-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Cc: Fangrui Song <maskray@google.com>
Cc: Prasad Sodagudi <psodagud@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/gcov/Kconfig |    1 
 kernel/gcov/clang.c |   85 ------------------------------------------
 2 files changed, 1 insertion(+), 85 deletions(-)

--- a/kernel/gcov/clang.c~gcov-clang-drop-support-for-clang-10-and-older
+++ a/kernel/gcov/clang.c
@@ -75,9 +75,6 @@ struct gcov_fn_info {
 
 	u32 num_counters;
 	u64 *counters;
-#if CONFIG_CLANG_VERSION < 110000
-	const char *function_name;
-#endif
 };
 
 static struct gcov_info *current_info;
@@ -107,16 +104,6 @@ void llvm_gcov_init(llvm_gcov_callback w
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
@@ -124,29 +111,7 @@ void llvm_gcda_start_file(const char *or
 	current_info->checksum = checksum;
 }
 EXPORT_SYMBOL(llvm_gcda_start_file);
-#endif
-
-#if CONFIG_CLANG_VERSION < 110000
-void llvm_gcda_emit_function(u32 ident, const char *function_name,
-		u32 func_checksum, u8 use_extra_checksum, u32 cfg_checksum)
-{
-	struct gcov_fn_info *info = kzalloc(sizeof(*info), GFP_KERNEL);
-
-	if (!info)
-		return;
 
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
-EXPORT_SYMBOL(llvm_gcda_emit_function);
-#else
 void llvm_gcda_emit_function(u32 ident, u32 func_checksum,
 		u8 use_extra_checksum, u32 cfg_checksum)
 {
@@ -163,7 +128,6 @@ void llvm_gcda_emit_function(u32 ident,
 	list_add_tail(&info->head, &current_info->functions);
 }
 EXPORT_SYMBOL(llvm_gcda_emit_function);
-#endif
 
 void llvm_gcda_emit_arcs(u32 num_counters, u64 *counters)
 {
@@ -326,7 +290,6 @@ void gcov_info_add(struct gcov_info *dst
 	}
 }
 
-#if CONFIG_CLANG_VERSION < 110000
 static struct gcov_fn_info *gcov_fn_info_dup(struct gcov_fn_info *fn)
 {
 	size_t cv_size; /* counter values size */
@@ -335,47 +298,15 @@ static struct gcov_fn_info *gcov_fn_info
 	if (!fn_dup)
 		return NULL;
 	INIT_LIST_HEAD(&fn_dup->head);
-
-	fn_dup->function_name = kstrdup(fn->function_name, GFP_KERNEL);
-	if (!fn_dup->function_name)
-		goto err_name;
-
-	cv_size = fn->num_counters * sizeof(fn->counters[0]);
-	fn_dup->counters = vmalloc(cv_size);
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
-static struct gcov_fn_info *gcov_fn_info_dup(struct gcov_fn_info *fn)
-{
-	size_t cv_size; /* counter values size */
-	struct gcov_fn_info *fn_dup = kmemdup(fn, sizeof(*fn),
-			GFP_KERNEL);
-	if (!fn_dup)
-		return NULL;
-	INIT_LIST_HEAD(&fn_dup->head);
-
 	cv_size = fn->num_counters * sizeof(fn->counters[0]);
 	fn_dup->counters = vmalloc(cv_size);
 	if (!fn_dup->counters) {
 		kfree(fn_dup);
 		return NULL;
 	}
-
 	memcpy(fn_dup->counters, fn->counters, cv_size);
-
 	return fn_dup;
 }
-#endif
 
 /**
  * gcov_info_dup - duplicate profiling data set
@@ -416,21 +347,6 @@ err:
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
@@ -443,7 +359,6 @@ void gcov_info_free(struct gcov_info *in
 	kfree(info->filename);
 	kfree(info);
 }
-#endif
 
 #define ITER_STRIDE	PAGE_SIZE
 
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

Patches currently in -mm which might be from ndesaulniers@google.com are

gcov-fix-clang-11-support.patch
gcov-clang-drop-support-for-clang-10-and-older.patch

