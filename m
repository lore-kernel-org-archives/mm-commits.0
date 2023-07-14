Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD273C001DC
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jul 2023 18:01:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236658AbjGNSBv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jul 2023 14:01:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236634AbjGNSBc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jul 2023 14:01:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB24F35B6
        for <mm-commits@vger.kernel.org>; Fri, 14 Jul 2023 11:01:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 490F861CEA
        for <mm-commits@vger.kernel.org>; Fri, 14 Jul 2023 17:54:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ABECC433C7;
        Fri, 14 Jul 2023 17:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689357277;
        bh=5jcZpx7ncI2sw5CUUX93bWcM5rskon8i5lTMR8PQ/Ak=;
        h=Date:To:From:Subject:From;
        b=SFcyIFlPZsWfIXFBjWZzRVPfYEMUB5kpbSTgw8MnabzUcmdrvP3AXqk0iWS9Z9hQ0
         739P+fkx0lLvqdoa7Sl/8Kr8f+RFRdWSVpmzghXDiFsfbY0DDsgogTDUsfSKRLzmpF
         TFI5mFxzdhb6Jn6N8at32GJkp20hvpXe8QI+iBOM=
Date:   Fri, 14 Jul 2023 10:54:37 -0700
To:     mm-commits@vger.kernel.org, iamjoonsoo.kim@lge.com,
        shikemeng@huaweicloud.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_ext-remove-unused-return-value-of-offline_page_ext.patch added to mm-unstable branch
Message-Id: <20230714175437.9ABECC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_ext: remove unused return value of offline_page_ext
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_ext-remove-unused-return-value-of-offline_page_ext.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_ext-remove-unused-return-value-of-offline_page_ext.patch

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
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm/page_ext: remove unused return value of offline_page_ext
Date: Fri, 14 Jul 2023 19:47:47 +0800

Patch series "minor cleanups for page_ext".

This series contains some random minor cleanups for page_ext.  More
details can be found in respective patches.  


This patch (of 3):

offline_page_ext always returns 0 and no caller checks the return value. 
Just remove unused return value of offline_page_ext.

Link: https://lkml.kernel.org/r/20230714114749.1743032-1-shikemeng@huaweicloud.com
Link: https://lkml.kernel.org/r/20230714114749.1743032-2-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_ext.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/page_ext.c~mm-page_ext-remove-unused-return-value-of-offline_page_ext
+++ a/mm/page_ext.c
@@ -430,7 +430,7 @@ static int __meminit online_page_ext(uns
 	return -ENOMEM;
 }
 
-static int __meminit offline_page_ext(unsigned long start_pfn,
+static void __meminit offline_page_ext(unsigned long start_pfn,
 				unsigned long nr_pages)
 {
 	unsigned long start, end, pfn;
@@ -454,8 +454,6 @@ static int __meminit offline_page_ext(un
 
 	for (pfn = start; pfn < end; pfn += PAGES_PER_SECTION)
 		__free_page_ext(pfn);
-	return 0;
-
 }
 
 static int __meminit page_ext_callback(struct notifier_block *self,
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

mm-correct-stale-comment-of-function-check_pte.patch
mm-page_table_check-remove-unused-parameters-in-page_table_check_clear.patch
mm-page_table_check-remove-unused-parameters-in-page_table_check_set.patch
mm-page_table_check-remove-unused-parameter-in-page_table_check_pte_clear.patch
mm-page_table_check-remove-unused-parameter-in-page_table_check_pmd_clear.patch
mm-page_table_check-remove-unused-parameter-in-page_table_check_pud_clear.patch
mm-page_table_check-remove-unused-parameter-in-page_table_check_pte_set.patch
mm-page_table_check-remove-unused-parameter-in-page_table_check_pmd_set.patch
mm-page_table_check-remove-unused-parameter-in-page_table_check_pud_set.patch
mm-page_ext-remove-unused-return-value-of-offline_page_ext.patch
mm-page_ext-remove-rollback-for-untouched-mem_section-in-online_page_ext.patch
mm-page_ext-move-functions-around-for-minor-cleanups-to-page_ext.patch

