Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98A42C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:42:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233955AbiCYWo1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233985AbiCYWoI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:44:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA18320A957
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:42:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54F3B614DE
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:42:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB9BC340ED;
        Fri, 25 Mar 2022 22:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248151;
        bh=frksoghwuXgZr8Zl3u3Or1Z7fuqsDQCj00lfARqVf9M=;
        h=Date:To:From:Subject:From;
        b=mBCe0D9Uz2ZLUluwdpUVz1gJRJu9MBsTQDMrSq2IQGl7yoOClpmiX29k8EVvAk/Lt
         0AeUyVqPHkr9+H9COD8GgHP4km3xx0rSdybVrAAQJcnUMOeMz6Zghm0QhcPHu9eWpR
         vh1bz4jnxiLvku/VxsZJennEKXd6wOSGosupYcnY=
Date:   Fri, 25 Mar 2022 15:42:31 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        vincenzo.frascino@arm.com, ryabinin.a.a@gmail.com, pcc@google.com,
        mark.rutland@arm.com, glider@google.com, eugenis@google.com,
        elver@google.com, dvyukov@google.com, catalin.marinas@arm.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kasan-add-kasanvmalloc-command-line-flag.patch removed from -mm tree
Message-Id: <20220325224231.AFB9BC340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: add kasan.vmalloc command line flag
has been removed from the -mm tree.  Its filename was
     kasan-add-kasanvmalloc-command-line-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: add kasan.vmalloc command line flag

Allow disabling vmalloc() tagging for HW_TAGS KASAN via a kasan.vmalloc
command line switch.

This is a fail-safe switch intended for production systems that enable
HW_TAGS KASAN.  In case vmalloc() tagging ends up having an issue not
detected during testing but that manifests in production, kasan.vmalloc
allows to turn vmalloc() tagging off while leaving page_alloc/slab tagging
on.

Link: https://lkml.kernel.org/r/904f6d4dfa94870cc5fc2660809e093fd0d27c3b.1643047180.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Acked-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/hw_tags.c |   45 ++++++++++++++++++++++++++++++++++++++++++-
 mm/kasan/kasan.h   |    6 +++++
 2 files changed, 50 insertions(+), 1 deletion(-)

--- a/mm/kasan/hw_tags.c~kasan-add-kasanvmalloc-command-line-flag
+++ a/mm/kasan/hw_tags.c
@@ -32,6 +32,12 @@ enum kasan_arg_mode {
 	KASAN_ARG_MODE_ASYMM,
 };
 
+enum kasan_arg_vmalloc {
+	KASAN_ARG_VMALLOC_DEFAULT,
+	KASAN_ARG_VMALLOC_OFF,
+	KASAN_ARG_VMALLOC_ON,
+};
+
 enum kasan_arg_stacktrace {
 	KASAN_ARG_STACKTRACE_DEFAULT,
 	KASAN_ARG_STACKTRACE_OFF,
@@ -40,6 +46,7 @@ enum kasan_arg_stacktrace {
 
 static enum kasan_arg kasan_arg __ro_after_init;
 static enum kasan_arg_mode kasan_arg_mode __ro_after_init;
+static enum kasan_arg_vmalloc kasan_arg_vmalloc __initdata;
 static enum kasan_arg_stacktrace kasan_arg_stacktrace __initdata;
 
 /*
@@ -56,6 +63,9 @@ EXPORT_SYMBOL(kasan_flag_enabled);
 enum kasan_mode kasan_mode __ro_after_init;
 EXPORT_SYMBOL_GPL(kasan_mode);
 
+/* Whether to enable vmalloc tagging. */
+DEFINE_STATIC_KEY_TRUE(kasan_flag_vmalloc);
+
 /* Whether to collect alloc/free stack traces. */
 DEFINE_STATIC_KEY_TRUE(kasan_flag_stacktrace);
 
@@ -95,6 +105,23 @@ static int __init early_kasan_mode(char
 }
 early_param("kasan.mode", early_kasan_mode);
 
+/* kasan.vmalloc=off/on */
+static int __init early_kasan_flag_vmalloc(char *arg)
+{
+	if (!arg)
+		return -EINVAL;
+
+	if (!strcmp(arg, "off"))
+		kasan_arg_vmalloc = KASAN_ARG_VMALLOC_OFF;
+	else if (!strcmp(arg, "on"))
+		kasan_arg_vmalloc = KASAN_ARG_VMALLOC_ON;
+	else
+		return -EINVAL;
+
+	return 0;
+}
+early_param("kasan.vmalloc", early_kasan_flag_vmalloc);
+
 /* kasan.stacktrace=off/on */
 static int __init early_kasan_flag_stacktrace(char *arg)
 {
@@ -179,6 +206,18 @@ void __init kasan_init_hw_tags(void)
 		break;
 	}
 
+	switch (kasan_arg_vmalloc) {
+	case KASAN_ARG_VMALLOC_DEFAULT:
+		/* Default is specified by kasan_flag_vmalloc definition. */
+		break;
+	case KASAN_ARG_VMALLOC_OFF:
+		static_branch_disable(&kasan_flag_vmalloc);
+		break;
+	case KASAN_ARG_VMALLOC_ON:
+		static_branch_enable(&kasan_flag_vmalloc);
+		break;
+	}
+
 	switch (kasan_arg_stacktrace) {
 	case KASAN_ARG_STACKTRACE_DEFAULT:
 		/* Default is specified by kasan_flag_stacktrace definition. */
@@ -194,8 +233,9 @@ void __init kasan_init_hw_tags(void)
 	/* KASAN is now initialized, enable it. */
 	static_branch_enable(&kasan_flag_enabled);
 
-	pr_info("KernelAddressSanitizer initialized (hw-tags, mode=%s, stacktrace=%s)\n",
+	pr_info("KernelAddressSanitizer initialized (hw-tags, mode=%s, vmalloc=%s, stacktrace=%s)\n",
 		kasan_mode_info(),
+		kasan_vmalloc_enabled() ? "on" : "off",
 		kasan_stack_collection_enabled() ? "on" : "off");
 }
 
@@ -228,6 +268,9 @@ void *__kasan_unpoison_vmalloc(const voi
 	u8 tag;
 	unsigned long redzone_start, redzone_size;
 
+	if (!kasan_vmalloc_enabled())
+		return (void *)start;
+
 	if (!is_vmalloc_or_module_addr(start))
 		return (void *)start;
 
--- a/mm/kasan/kasan.h~kasan-add-kasanvmalloc-command-line-flag
+++ a/mm/kasan/kasan.h
@@ -12,6 +12,7 @@
 #include <linux/static_key.h>
 #include "../slab.h"
 
+DECLARE_STATIC_KEY_TRUE(kasan_flag_vmalloc);
 DECLARE_STATIC_KEY_TRUE(kasan_flag_stacktrace);
 
 enum kasan_mode {
@@ -22,6 +23,11 @@ enum kasan_mode {
 
 extern enum kasan_mode kasan_mode __ro_after_init;
 
+static inline bool kasan_vmalloc_enabled(void)
+{
+	return static_branch_likely(&kasan_flag_vmalloc);
+}
+
 static inline bool kasan_stack_collection_enabled(void)
 {
 	return static_branch_unlikely(&kasan_flag_stacktrace);
_

Patches currently in -mm which might be from andreyknvl@google.com are

stacktrace-add-interface-based-on-shadow-call-stack.patch
arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks.patch
arm64-implement-stack_trace_save_shadow.patch
kasan-use-stack_trace_save_shadow.patch

