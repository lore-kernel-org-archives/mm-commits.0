Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D66C8C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:42:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233984AbiCYWo3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233981AbiCYWoF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:44:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C13120A951
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:42:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3703061502
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:42:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B4B7C004DD;
        Fri, 25 Mar 2022 22:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248149;
        bh=nsMI5+dhTwRT9hmPrKnVPI8E0uN8xWdAxsfJS9EeScQ=;
        h=Date:To:From:Subject:From;
        b=wy9g7rcz805D8kpvOsMm6n3cz1PmOIcPlb1Aad/KLrZ8kvw6oAjW2OQ1tmERSqrdF
         K3QnYNGuJOpT5eLDEpiRyqXFr5spkb4TXG+skMKvebZEXuIlmZs82IANms3EMoazxe
         PvrZ7mgBHAO3lXGyJVSTk5hNWANMsyu1Yt5xSXHs=
Date:   Fri, 25 Mar 2022 15:42:28 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        vincenzo.frascino@arm.com, ryabinin.a.a@gmail.com, pcc@google.com,
        mark.rutland@arm.com, glider@google.com, eugenis@google.com,
        elver@google.com, dvyukov@google.com, catalin.marinas@arm.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kasan-mark-kasan_arg_stacktrace-as-__initdata.patch removed from -mm tree
Message-Id: <20220325224229.8B4B7C004DD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: mark kasan_arg_stacktrace as __initdata
has been removed from the -mm tree.  Its filename was
     kasan-mark-kasan_arg_stacktrace-as-__initdata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: mark kasan_arg_stacktrace as __initdata

As kasan_arg_stacktrace is only used in __init functions, mark it as
__initdata instead of __ro_after_init to allow it be freed after boot.

The other enums for KASAN args are used in kasan_init_hw_tags_cpu(), which
is not marked as __init as a CPU can be hot-plugged after boot.  Clarify
this in a comment.

Link: https://lkml.kernel.org/r/7fa090865614f8e0c6c1265508efb1d429afaa50.1643047180.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Suggested-by: Marco Elver <elver@google.com>
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

 mm/kasan/hw_tags.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/kasan/hw_tags.c~kasan-mark-kasan_arg_stacktrace-as-__initdata
+++ a/mm/kasan/hw_tags.c
@@ -40,7 +40,7 @@ enum kasan_arg_stacktrace {
 
 static enum kasan_arg kasan_arg __ro_after_init;
 static enum kasan_arg_mode kasan_arg_mode __ro_after_init;
-static enum kasan_arg_stacktrace kasan_arg_stacktrace __ro_after_init;
+static enum kasan_arg_stacktrace kasan_arg_stacktrace __initdata;
 
 /* Whether KASAN is enabled at all. */
 DEFINE_STATIC_KEY_FALSE(kasan_flag_enabled);
@@ -116,7 +116,10 @@ static inline const char *kasan_mode_inf
 		return "sync";
 }
 
-/* kasan_init_hw_tags_cpu() is called for each CPU. */
+/*
+ * kasan_init_hw_tags_cpu() is called for each CPU.
+ * Not marked as __init as a CPU can be hot-plugged after boot.
+ */
 void kasan_init_hw_tags_cpu(void)
 {
 	/*
_

Patches currently in -mm which might be from andreyknvl@google.com are

stacktrace-add-interface-based-on-shadow-call-stack.patch
arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks.patch
arm64-implement-stack_trace_save_shadow.patch
kasan-use-stack_trace_save_shadow.patch

