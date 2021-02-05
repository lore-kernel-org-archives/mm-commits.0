Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4D0AC433DB
	for <mm-commits@archiver.kernel.org>; Fri,  5 Feb 2021 02:34:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9EA464FB5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Feb 2021 02:34:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbhBECeX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 4 Feb 2021 21:34:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:46198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230288AbhBECdr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Feb 2021 21:33:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 871A164FC1;
        Fri,  5 Feb 2021 02:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612492377;
        bh=beQ3/1zevh7lPSJRVoCrVNFkCmjnCfrcg89gZm/o5fY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=SMdUG3V/XVzY0huktVWtDQ5KqK2rqy9XO84/+xgCPsSirh3WMna4kXumDdxNxinFb
         hQ/rWAEVG6rOpD8T2nv1Drq7JGjAuTrT7eC0nlXIpSEQ5QwhuGLoabt81SIK49LAQw
         895dDC/GvXXR3aNMBAE3HZr2X8Oc7Ri4VDJIb2o4=
Date:   Thu, 04 Feb 2021 18:32:57 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, keescook@chromium.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, torvalds@linux-foundation.org
Subject:  [patch 16/18] ubsan: implement
 __ubsan_handle_alignment_assumption
Message-ID: <20210205023257.NJnJdyyZk%akpm@linux-foundation.org>
In-Reply-To: <20210204183135.e123f0d6027529f2cf500cf2@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>
Subject: ubsan: implement __ubsan_handle_alignment_assumption

When building ARCH=mips 32r2el_defconfig with CONFIG_UBSAN_ALIGNMENT:

ld.lld: error: undefined symbol: __ubsan_handle_alignment_assumption
>>> referenced by slab.h:557 (include/linux/slab.h:557)
>>>               main.o:(do_initcalls) in archive init/built-in.a
>>> referenced by slab.h:448 (include/linux/slab.h:448)
>>>               do_mounts_rd.o:(rd_load_image) in archive init/built-in.a
>>> referenced by slab.h:448 (include/linux/slab.h:448)
>>>               do_mounts_rd.o:(identify_ramdisk_image) in archive init/built-in.a
>>> referenced 1579 more times

Implement this for the kernel based on LLVM's
handleAlignmentAssumptionImpl because the kernel is not linked against
the compiler runtime.

Link: https://github.com/ClangBuiltLinux/linux/issues/1245
Link: https://github.com/llvm/llvm-project/blob/llvmorg-11.0.1/compiler-rt/lib/ubsan/ubsan_handlers.cpp#L151-L190
Link: https://lkml.kernel.org/r/20210127224451.2587372-1-nathan@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ubsan.c |   31 +++++++++++++++++++++++++++++++
 lib/ubsan.h |    6 ++++++
 2 files changed, 37 insertions(+)

--- a/lib/ubsan.c~ubsan-implement-__ubsan_handle_alignment_assumption
+++ a/lib/ubsan.c
@@ -427,3 +427,34 @@ void __ubsan_handle_load_invalid_value(v
 	ubsan_epilogue();
 }
 EXPORT_SYMBOL(__ubsan_handle_load_invalid_value);
+
+void __ubsan_handle_alignment_assumption(void *_data, unsigned long ptr,
+					 unsigned long align,
+					 unsigned long offset);
+void __ubsan_handle_alignment_assumption(void *_data, unsigned long ptr,
+					 unsigned long align,
+					 unsigned long offset)
+{
+	struct alignment_assumption_data *data = _data;
+	unsigned long real_ptr;
+
+	if (suppress_report(&data->location))
+		return;
+
+	ubsan_prologue(&data->location, "alignment-assumption");
+
+	if (offset)
+		pr_err("assumption of %lu byte alignment (with offset of %lu byte) for pointer of type %s failed",
+		       align, offset, data->type->type_name);
+	else
+		pr_err("assumption of %lu byte alignment for pointer of type %s failed",
+		       align, data->type->type_name);
+
+	real_ptr = ptr - offset;
+	pr_err("%saddress is %lu aligned, misalignment offset is %lu bytes",
+	       offset ? "offset " : "", BIT(real_ptr ? __ffs(real_ptr) : 0),
+	       real_ptr & (align - 1));
+
+	ubsan_epilogue();
+}
+EXPORT_SYMBOL(__ubsan_handle_alignment_assumption);
--- a/lib/ubsan.h~ubsan-implement-__ubsan_handle_alignment_assumption
+++ a/lib/ubsan.h
@@ -78,6 +78,12 @@ struct invalid_value_data {
 	struct type_descriptor *type;
 };
 
+struct alignment_assumption_data {
+	struct source_location location;
+	struct source_location assumption_location;
+	struct type_descriptor *type;
+};
+
 #if defined(CONFIG_ARCH_SUPPORTS_INT128)
 typedef __int128 s_max;
 typedef unsigned __int128 u_max;
_
