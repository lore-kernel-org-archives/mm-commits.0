Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3503FC54EBE
	for <mm-commits@archiver.kernel.org>; Thu, 12 Jan 2023 22:37:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbjALWhx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Jan 2023 17:37:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235985AbjALWhv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jan 2023 17:37:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CA4A58F87
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2023 14:37:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCCF5621B9
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2023 22:37:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C6D5C433D2;
        Thu, 12 Jan 2023 22:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673563069;
        bh=wUYaczB0bkD2jQUEgpQnJqCK3DNVLPX1xiPbtPrRIIw=;
        h=Date:To:From:Subject:From;
        b=VAwO73Cq/bVPdXPJF/lEYFoBdfkh6zdrJS8AC+mgHPyaEtMluoec6djNeGmUy9jOF
         55GsMJN5Vl+1f5afOyCNxgJygd89wkhrO7INHOcxITp1qiyxDRe2tMHC4KmjF2W1eT
         6ecOxpNhLCPqV7wGVPRO8bW8hV3E6QQcFlB4+dzQ=
Date:   Thu, 12 Jan 2023 14:37:48 -0800
To:     mm-commits@vger.kernel.org, lkp@intel.com,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-make-zspage-chain-size-configurable-fix.patch added to mm-unstable branch
Message-Id: <20230112223749.3C6D5C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: turn chain size config option into UL constant
has been added to the -mm mm-unstable branch.  Its filename is
     zsmalloc-make-zspage-chain-size-configurable-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-make-zspage-chain-size-configurable-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zsmalloc: turn chain size config option into UL constant
Date: Thu, 12 Jan 2023 16:14:43 +0900

This fixes

>> mm/zsmalloc.c:122:59: warning: right shift count >= width of type [-Wshift-count-overflow]

and

>> mm/zsmalloc.c:224:28: error: variably modified 'size_class' at file scope
     224 |         struct size_class *size_class[ZS_SIZE_CLASSES];

Link: https://lkml.kernel.org/r/20230112071443.1933880-1-senozhatsky@chromium.org
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/mm/zsmalloc.c~zsmalloc-make-zspage-chain-size-configurable-fix
+++ a/mm/zsmalloc.c
@@ -133,9 +133,12 @@
 #define MAGIC_VAL_BITS	8
 
 #define MAX(a, b) ((a) >= (b) ? (a) : (b))
+
+#define ZS_MAX_PAGES_PER_ZSPAGE	(_AC(CONFIG_ZSMALLOC_CHAIN_SIZE, UL))
+
 /* ZS_MIN_ALLOC_SIZE must be multiple of ZS_ALIGN */
 #define ZS_MIN_ALLOC_SIZE \
-	MAX(32, (CONFIG_ZSMALLOC_CHAIN_SIZE << PAGE_SHIFT >> OBJ_INDEX_BITS))
+	MAX(32, (ZS_MAX_PAGES_PER_ZSPAGE << PAGE_SHIFT >> OBJ_INDEX_BITS))
 /* each chunk includes extra space to keep handle */
 #define ZS_MAX_ALLOC_SIZE	PAGE_SIZE
 
@@ -1119,7 +1122,7 @@ static struct zspage *alloc_zspage(struc
 					gfp_t gfp)
 {
 	int i;
-	struct page *pages[CONFIG_ZSMALLOC_CHAIN_SIZE];
+	struct page *pages[ZS_MAX_PAGES_PER_ZSPAGE];
 	struct zspage *zspage = cache_alloc_zspage(pool, gfp);
 
 	if (!zspage)
@@ -1986,7 +1989,7 @@ static void replace_sub_page(struct size
 				struct page *newpage, struct page *oldpage)
 {
 	struct page *page;
-	struct page *pages[CONFIG_ZSMALLOC_CHAIN_SIZE] = {NULL, };
+	struct page *pages[ZS_MAX_PAGES_PER_ZSPAGE] = {NULL, };
 	int idx = 0;
 
 	page = get_first_page(zspage);
@@ -2366,7 +2369,7 @@ static int calculate_zspage_chain_size(i
 	if (is_power_of_2(class_size))
 		return chain_size;
 
-	for (i = 1; i <= CONFIG_ZSMALLOC_CHAIN_SIZE; i++) {
+	for (i = 1; i <= ZS_MAX_PAGES_PER_ZSPAGE; i++) {
 		int waste;
 
 		waste = (i * PAGE_SIZE) % class_size;
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-correctly-handle-all-next_arg-cases.patch
zsmalloc-rework-zspage-chain-size-selection.patch
zsmalloc-skip-chain-size-calculation-for-pow_of_2-classes.patch
zsmalloc-make-zspage-chain-size-configurable.patch
zsmalloc-make-zspage-chain-size-configurable-fix.patch
zsmalloc-set-default-zspage-chain-size-to-8.patch

