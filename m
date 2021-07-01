Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7949BC11F69
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:56:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63A6561483
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:56:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238564AbhGAB7D (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:59:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:48894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238565AbhGAB66 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:58:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1F126146D;
        Thu,  1 Jul 2021 01:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104588;
        bh=/ls2NnoC8Zx5fW4dsg+rZbYGyeQEYYiYj9cexnSdSKc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ZNBeHY1LKTJJYLJy5zKt5765d2VZdCG2u01LZep8P9e/GVBWTKYlnQOGFuDdn2DiN
         m2MZtnMrEIFC+33rlOMka5C8pDJk77fO4r5WbnR+cSs+3HKP6nBxW5i+C9XsbKfPJT
         Vd5i1o6E4OxZh+8f9hLYm3kALgV+tjrs+5XJwEik=
Date:   Wed, 30 Jun 2021 18:56:28 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     ahalaney@redhat.com, akpm@linux-foundation.org, bp@suse.de,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rostedt@goodmis.org, torvalds@linux-foundation.org
Subject:  [patch 176/192] init: print out unknown kernel parameters
Message-ID: <20210701015628.vk9Y1Fqho%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrew Halaney <ahalaney@redhat.com>
Subject: init: print out unknown kernel parameters

It is easy to foobar setting a kernel parameter on the command line
without realizing it, there's not much output that you can use to assess
what the kernel did with that parameter by default.

Make it a little more explicit which parameters on the command line
_looked_ like a valid parameter for the kernel, but did not match anything
and ultimately got tossed to init.  This is very similar to the unknown
parameter message received when loading a module.

This assumes the parameters are processed in a normal fashion, some
parameters (dyndbg= for example) don't register their parameter with the
rest of the kernel's parameters, and therefore always show up in this list
(and are also given to init - like the rest of this list).

Another example is BOOT_IMAGE= is highlighted as an offender, which it
technically is, but is passed by LILO and GRUB so most systems will see
that complaint.

An example output where "foobared" and "unrecognized" are intentionally
invalid parameters:

  Kernel command line: BOOT_IMAGE=/boot/vmlinuz-5.12-dirty debug log_buf_len=4M foobared unrecognized=foo
  Unknown command line parameters: foobared BOOT_IMAGE=/boot/vmlinuz-5.12-dirty unrecognized=foo

Link: https://lkml.kernel.org/r/20210511211009.42259-1-ahalaney@redhat.com
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Suggested-by: Borislav Petkov <bp@suse.de>
Acked-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

--- a/init/main.c~init-print-out-unknown-kernel-parameters
+++ a/init/main.c
@@ -872,6 +872,47 @@ void __init __weak arch_call_rest_init(v
 	rest_init();
 }
 
+static void __init print_unknown_bootoptions(void)
+{
+	char *unknown_options;
+	char *end;
+	const char *const *p;
+	size_t len;
+
+	if (panic_later || (!argv_init[1] && !envp_init[2]))
+		return;
+
+	/*
+	 * Determine how many options we have to print out, plus a space
+	 * before each
+	 */
+	len = 1; /* null terminator */
+	for (p = &argv_init[1]; *p; p++) {
+		len++;
+		len += strlen(*p);
+	}
+	for (p = &envp_init[2]; *p; p++) {
+		len++;
+		len += strlen(*p);
+	}
+
+	unknown_options = memblock_alloc(len, SMP_CACHE_BYTES);
+	if (!unknown_options) {
+		pr_err("%s: Failed to allocate %zu bytes\n",
+			__func__, len);
+		return;
+	}
+	end = unknown_options;
+
+	for (p = &argv_init[1]; *p; p++)
+		end += sprintf(end, " %s", *p);
+	for (p = &envp_init[2]; *p; p++)
+		end += sprintf(end, " %s", *p);
+
+	pr_notice("Unknown command line parameters:%s\n", unknown_options);
+	memblock_free(__pa(unknown_options), len);
+}
+
 asmlinkage __visible void __init __no_sanitize_address start_kernel(void)
 {
 	char *command_line;
@@ -913,6 +954,7 @@ asmlinkage __visible void __init __no_sa
 				  static_command_line, __start___param,
 				  __stop___param - __start___param,
 				  -1, -1, NULL, &unknown_bootoption);
+	print_unknown_bootoptions();
 	if (!IS_ERR_OR_NULL(after_dashes))
 		parse_args("Setting init args", after_dashes, NULL, 0, -1, -1,
 			   NULL, set_init_arg);
_
