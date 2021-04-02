Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B49A7C433B4
	for <mm-commits@archiver.kernel.org>; Fri,  2 Apr 2021 00:09:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AE5661107
	for <mm-commits@archiver.kernel.org>; Fri,  2 Apr 2021 00:09:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234548AbhDBAJc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Apr 2021 20:09:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:56840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233677AbhDBAJb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 1 Apr 2021 20:09:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B58C6610D1;
        Fri,  2 Apr 2021 00:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617322171;
        bh=7FZFcOjQQaJlhn9wUssP6X9sHaiQFrh7Xht4SR9ZVbs=;
        h=Date:From:To:Subject:From;
        b=RGGHXlirgjUSlJ5/ZmukfMXrEUtyA6xDj28eZhN1JjzOJKOHNdNDS6GPmsYBbFYFv
         AAQiJoA+pq2NQkrXCKCfB5Oo+NaXJvGshy/SEi2V2XlFyeaUUTLh2ME4KcULnd8AD5
         oaj6/gPdDTH5zfZgAxi0n6XHze3aRkKCr9lk1foM=
Date:   Thu, 01 Apr 2021 17:09:31 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, slyfox@gentoo.org, willy@infradead.org
Subject:  + mm-page_owner-use-kstrtobool-to-parse-bool-option.patch
 added to -mm tree
Message-ID: <20210402000931.AgJxd7nUW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_owner: use kstrtobool() to parse bool option
has been added to the -mm tree.  Its filename is
     mm-page_owner-use-kstrtobool-to-parse-bool-option.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_owner-use-kstrtobool-to-parse-bool-option.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_owner-use-kstrtobool-to-parse-bool-option.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergei Trofimovich <slyfox@gentoo.org>
Subject: mm: page_owner: use kstrtobool() to parse bool option

I tried to use page_owner=1 for a while noticed too late it had no effect
as opposed to similar init_on_alloc=1 (these work).

Let's make them consistent.

The change decreses binary size slightly:
   text    data     bss     dec     hex filename
  12408     321      17   12746    31ca mm/page_owner.o.before
  12320     321      17   12658    3172 mm/page_owner.o.after

Link: https://lkml.kernel.org/r/20210401210909.3532086-1-slyfox@gentoo.org
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/mm/page_owner.c~mm-page_owner-use-kstrtobool-to-parse-bool-option
+++ a/mm/page_owner.c
@@ -42,13 +42,7 @@ static void init_early_allocated_pages(v
 
 static int __init early_page_owner_param(char *buf)
 {
-	if (!buf)
-		return -EINVAL;
-
-	if (strcmp(buf, "on") == 0)
-		page_owner_enabled = true;
-
-	return 0;
+	return kstrtobool(buf, &page_owner_enabled);
 }
 early_param("page_owner", early_page_owner_param);
 
_

Patches currently in -mm which might be from slyfox@gentoo.org are

ia64-fix-user_stack_pointer-for-ptrace.patch
ia64-drop-unused-ia64_fw_emu-ifdef.patch
ia64-simplify-code-flow-around-swiotlb-init.patch
ia64-fix-efi_debug-build.patch
ia64-mca-always-make-ia64_mca_debug-an-expression.patch
mm-page_owner-fetch-backtrace-only-for-tracked-pages.patch
mm-page_owner-use-kstrtobool-to-parse-bool-option.patch
mm-page_alloc-ignore-init_on_free=1-for-debug_pagealloc=1.patch

