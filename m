Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6014DC433B4
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:22:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 380C361445
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:22:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbhD3FXK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:23:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:37094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229482AbhD3FXJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:23:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B26BB61423;
        Fri, 30 Apr 2021 05:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619760141;
        bh=z+kWqmXzY1LbIsmy90BVUnLaARD7uF5Hr/8ONSCth3E=;
        h=Date:From:To:Subject:From;
        b=0qSEDZp0F3uk3CWoQ8twUzBQHxPeGyjJGDuyPCfv5jMpK9jWLNOwiAhVrWTr62ah8
         eOM7Y5WXaUosKhY5Qk6hWLL5hJVTsHwGjQq/K9ATXbYSTCQuKvdgVRPg3qwr22I8mk
         ENTpez4+VpW0vbtb4uvuezG5rOwFWImJEALUW9gg=
Date:   Thu, 29 Apr 2021 22:22:21 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, slyfox@gentoo.org, vbabka@suse.cz
Subject:  [folded-merged]
 mm-page_poison-print-page-info-when-corruption-is-caught-v2.patch removed
 from -mm tree
Message-ID: <20210430052221.hVDabqUBx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_poison-print-page-info-when-corruption-is-caught-v2
has been removed from the -mm tree.  Its filename was
     mm-page_poison-print-page-info-when-corruption-is-caught-v2.patch

This patch was dropped because it was folded into mm-page_poison-print-page-owner-info-when-corruption-is-caught.patch

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
mm-page_alloc-ignore-init_on_free=1-for-debug_pagealloc=1.patch

