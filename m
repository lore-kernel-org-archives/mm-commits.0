Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 021C3C433B4
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 01:35:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D924A616ED
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 01:35:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbhEKBgm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 May 2021 21:36:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:60774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230369AbhEKBgm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 10 May 2021 21:36:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 364106162E;
        Tue, 11 May 2021 01:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620696936;
        bh=xWO7IBEt9z3ieycxGDEMsiaTa2Wr+cVcJrsflfzJ6KM=;
        h=Date:From:To:Subject:From;
        b=U2vB7+OhL9hSC4UOW9g41qzKWKrpHFkjyY+c/PME5FaEdIdfAKJwWZTeuQCfY6Xr1
         J3a2KwnKf3Hbd8AAsnRl7KaOj+LI0hPH8pJH3FsgFD5cf2i5rLQ71Iha2VnPbmYlXg
         9A39QYIZI53cgs1/hFhdBMvyTbp1DaYNVaz4YSDs=
Date:   Mon, 10 May 2021 18:35:34 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, ast@kernel.org, bhe@redhat.com,
        bp@alien8.de, catalin.marinas@arm.com, dyoung@redhat.com,
        evgreen@chromium.org, hsinyi@chromium.org, jeyu@kernel.org,
        jolsa@kernel.org, khlebnikov@yandex-team.ru,
        linux@rasmusvillemoes.dk, mingo@redhat.com,
        mm-commits@vger.kernel.org, pmladek@suse.com, rostedt@goodmis.org,
        sashal@kernel.org, sergey.senozhatsky@gmail.com,
        swboyd@chromium.org, tglx@linutronix.de, vgoyal@redhat.com,
        will@kernel.org, willy@infradead.org
Subject:  + buildid-fix-kernel-doc-notation.patch added to -mm tree
Message-ID: <20210511013534.ogvY3usWY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: buildid: fix kernel-doc notation
has been added to the -mm tree.  Its filename is
     buildid-fix-kernel-doc-notation.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/buildid-fix-kernel-doc-notation.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/buildid-fix-kernel-doc-notation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Boyd <swboyd@chromium.org>
Subject: buildid: fix kernel-doc notation

Kernel doc should use "Return:" instead of "Returns" to properly reflect
the return values.

Link: https://lkml.kernel.org/r/20210511003845.2429846-13-swboyd@chromium.org
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Jessica Yu <jeyu@kernel.org>
Cc: Evan Green <evgreen@chromium.org>
Cc: Hsin-Yi Wang <hsinyi@chromium.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/buildid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/buildid.c~buildid-fix-kernel-doc-notation
+++ a/lib/buildid.c
@@ -121,7 +121,7 @@ static int get_build_id_64(const void *p
  * @build_id: buffer to store build id, at least BUILD_ID_SIZE long
  * @size:     returns actual build id size in case of success
  *
- * Returns 0 on success, otherwise error (< 0).
+ * Return: 0 on success, -EINVAL otherwise
  */
 int build_id_parse(struct vm_area_struct *vma, unsigned char *build_id,
 		   __u32 *size)
_

Patches currently in -mm which might be from swboyd@chromium.org are

buildid-only-consider-gnu-notes-for-build-id-parsing.patch
buildid-add-api-to-parse-build-id-out-of-buffer.patch
buildid-stash-away-kernels-build-id-on-init.patch
dump_stack-add-vmlinux-build-id-to-stack-traces.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces.patch
arm64-stacktrace-use-%psb-for-backtrace-printing.patch
x86-dumpstack-use-%psb-%pbb-for-backtrace-printing.patch
scripts-decode_stacktracesh-support-debuginfod.patch
scripts-decode_stacktracesh-silence-stderr-messages-from-addr2line-nm.patch
scripts-decode_stacktracesh-indicate-auto-can-be-used-for-base-path.patch
buildid-mark-some-arguments-const.patch
buildid-fix-kernel-doc-notation.patch
kdump-use-vmlinux_build_id-to-simplify.patch

