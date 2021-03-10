Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AAA9C433DB
	for <mm-commits@archiver.kernel.org>; Wed, 10 Mar 2021 17:13:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D380764FD2
	for <mm-commits@archiver.kernel.org>; Wed, 10 Mar 2021 17:13:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbhCJRNC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Mar 2021 12:13:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:45902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230270AbhCJRMu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Mar 2021 12:12:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC82064F9A;
        Wed, 10 Mar 2021 17:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615396370;
        bh=eGMh4rBwZhMDLXuePGV9sFj2UfbeHNUaeGf2v20z0tc=;
        h=Date:From:To:Subject:From;
        b=JvN9dQnE8zVxm/7EAMR3FeTxEO1+qW51j62SCnpYH6jJYBVtdxVQsvGvko7e0IXS/
         9fDQnUPI8QA5ujSofBlSNWdScM7bwe/xjSwjtiQZFO5r7J+hQLBSkMWyi6hKxGHbBH
         Ga96uEqICMPJY2k0TuswyjBaQJqGBLQcHQ+KuNOs=
Date:   Wed, 10 Mar 2021 09:12:49 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        songmuchun@bytedance.com
Subject:  +
 =?US-ASCII?Q?mm-memory=5Fhotplug-factor-out-bootmem-core-functions-to-boo?=
 =?US-ASCII?Q?tmem=5Finfoc-fix.patch?= added to -mm tree
Message-ID: <20210310171249.308-VJZFi%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memory_hotplug-factor-out-bootmem-core-functions-to-bootmem_infoc-fix
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-factor-out-bootmem-core-functions-to-bootmem_infoc-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-factor-out-bootmem-core-functions-to-bootmem_infoc-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-factor-out-bootmem-core-functions-to-bootmem_infoc-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: mm-memory_hotplug-factor-out-bootmem-core-functions-to-bootmem_infoc-fix

arch/sparc/mm/init_64.c needs bootmem_info.h

Link: https://lkml.kernel.org/r/20210310145514.3f3743fe@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/mm/init_64.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/sparc/mm/init_64.c~mm-memory_hotplug-factor-out-bootmem-core-functions-to-bootmem_infoc-fix
+++ a/arch/sparc/mm/init_64.c
@@ -27,6 +27,7 @@
 #include <linux/percpu.h>
 #include <linux/mmzone.h>
 #include <linux/gfp.h>
+#include <linux/bootmem_info.h>
 
 #include <asm/head.h>
 #include <asm/page.h>
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

mm-memory_hotplug-factor-out-bootmem-core-functions-to-bootmem_infoc-fix.patch

