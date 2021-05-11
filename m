Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71499C43460
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 21:40:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 458B96191A
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 21:40:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbhEKVlj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 May 2021 17:41:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:52346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229637AbhEKVlj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 May 2021 17:41:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED10D6186A;
        Tue, 11 May 2021 21:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620769231;
        bh=PF0UxSuC0EIGWUJLGw5USlEXp81e23yYehm70MBVb1o=;
        h=Date:From:To:Subject:From;
        b=RY2KXl2pg18gy2dCFSdPXf4iWxKB/BnPRK8esoYp05mGoyNjmyWJe393ul5aYhQR9
         FolYzBSdo8oNNNIO+OlCemHOSSWXCJ3PRC3tsWfmTk7v+mugds5RNwrnCqNBcsvmOB
         wCOJ6JxJI0g7+Mu5sPO/fC8bb2SCTa32eQY7hHVE=
Date:   Tue, 11 May 2021 14:40:30 -0700
From:   akpm@linux-foundation.org
To:     ahalaney@redhat.com, bp@suse.de, mm-commits@vger.kernel.org,
        rostedt@goodmis.org
Subject:  + init-print-out-unknown-kernel-parameters.patch added to
 -mm tree
Message-ID: <20210511214030.BlHUS6AG9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: init: print out unknown kernel parameters
has been added to the -mm tree.  Its filename is
     init-print-out-unknown-kernel-parameters.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/init-print-out-unknown-kernel-parameters.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/init-print-out-unknown-kernel-parameters.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from ahalaney@redhat.com are

init-print-out-unknown-kernel-parameters.patch

