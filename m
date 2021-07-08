Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0896CC07E95
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 01:09:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0F0E61CED
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 01:09:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbhGHBM3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jul 2021 21:12:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:52742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230155AbhGHBM3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 7 Jul 2021 21:12:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7832C61CDF;
        Thu,  8 Jul 2021 01:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625706587;
        bh=qTKYbr18vxXpyXQBmTQB3JBEcarc4fvCVIuLll2V8Fc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=DUcprKhCYiyA/2Q2jfsumMADmrhA7Hp70i+fAMqVGbKu9WNqOzTtDuI6x3mT2kzNS
         YiDaJpjql+FBQYsDyTY+6iR9qiSlwb50y0n9199+OCtS0Sw4vsT5oYxVc+qOWSzx9r
         JaahXVGG+xwUzGWxgfpq/lhMYeEbTkReUXl36550=
Date:   Wed, 07 Jul 2021 18:09:46 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        ast@kernel.org, bhe@redhat.com, bp@alien8.de,
        catalin.marinas@arm.com, dyoung@redhat.com, evgreen@chromium.org,
        hsinyi@chromium.org, jeyu@kernel.org, jolsa@kernel.org,
        khlebnikov@yandex-team.ru, linux-mm@kvack.org,
        linux@rasmusvillemoes.dk, mingo@redhat.com,
        mm-commits@vger.kernel.org, pmladek@suse.com, rostedt@goodmis.org,
        sashal@kernel.org, sergey.senozhatsky@gmail.com,
        swboyd@chromium.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, vgoyal@redhat.com, will@kernel.org,
        willy@infradead.org
Subject:  [patch 42/54] buildid: fix kernel-doc notation
Message-ID: <20210708010946.BGdnV49-z%akpm@linux-foundation.org>
In-Reply-To: <20210707175950.eceddb86c6c555555d4730e2@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
