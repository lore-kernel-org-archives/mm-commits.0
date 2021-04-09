Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59FE3C433ED
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 04:55:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CEBB61165
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 04:55:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbhDIEz5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Apr 2021 00:55:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:49484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229613AbhDIEz5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Apr 2021 00:55:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27E5A60FF0;
        Fri,  9 Apr 2021 04:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617944145;
        bh=SaQRXCjUf/pj7XK5x06OvxXipN/ZtwZwlT5D7Vcs3LM=;
        h=Date:From:To:Subject:From;
        b=W6FOXxbLycoQZP8RJ4flV2icVNmpTVS+26zc/C6Jg81a88H1+sBpiTkBQjigBR6o9
         yNtWvxmFL58kUUhiNzNhbflL1MQvJHcZOUAZy4ktyq/PthDeVs7Qd75y8fWb+vpRML
         RaxndeGZ9FPCuO+47HzfmNFifXnIuXG/oVDRDAf4=
Date:   Thu, 08 Apr 2021 21:55:44 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, slyfox@gentoo.org, vbabka@suse.cz
Subject:  +
 mm-page_poison-print-page-info-when-corruption-is-caught-v2.patch added to
 -mm tree
Message-ID: <20210409045544.NuEJ85xEP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_poison-print-page-info-when-corruption-is-caught-v2
has been added to the -mm tree.  Its filename is
     mm-page_poison-print-page-info-when-corruption-is-caught-v2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_poison-print-page-info-when-corruption-is-caught-v2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_poison-print-page-info-when-corruption-is-caught-v2.patch

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
Subject: mm-page_poison-print-page-info-when-corruption-is-caught-v2

s/dump_page_owner/dump_page/, per Vlastimil

Link: https://lkml.kernel.org/r/20210407230800.1086854-1-slyfox@gentoo.org
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_poison.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_poison.c~mm-page_poison-print-page-info-when-corruption-is-caught-v2
+++ a/mm/page_poison.c
@@ -2,9 +2,9 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/mm.h>
+#include <linux/mmdebug.h>
 #include <linux/highmem.h>
 #include <linux/page_ext.h>
-#include <linux/page_owner.h>
 #include <linux/poison.h>
 #include <linux/ratelimit.h>
 #include <linux/kasan.h>
@@ -71,7 +71,7 @@ static void check_poison_mem(struct page
 	print_hex_dump(KERN_ERR, "", DUMP_PREFIX_ADDRESS, 16, 1, start,
 			end - start + 1, 1);
 	dump_stack();
-	dump_page_owner(page);
+	dump_page(page, "pagealloc: corrupted page details");
 }
 
 static void unpoison_page(struct page *page)
_

Patches currently in -mm which might be from slyfox@gentoo.org are

ia64-fix-user_stack_pointer-for-ptrace.patch
ia64-drop-unused-ia64_fw_emu-ifdef.patch
ia64-simplify-code-flow-around-swiotlb-init.patch
ia64-fix-efi_debug-build.patch
ia64-mca-always-make-ia64_mca_debug-an-expression.patch
ia64-drop-marked-broken-discontigmem-and-virtual_mem_map.patch
ia64-module-fix-symbolizer-crash-on-fdescr.patch
mm-page_owner-fetch-backtrace-only-for-tracked-pages.patch
mm-page_owner-use-kstrtobool-to-parse-bool-option.patch
mm-page_owner-detect-page_owner-recursion-via-task_struct.patch
mm-page_poison-print-page-owner-info-when-corruption-is-caught.patch
mm-page_poison-print-page-info-when-corruption-is-caught-v2.patch
mm-page_alloc-ignore-init_on_free=1-for-debug_pagealloc=1.patch

