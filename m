Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AEA8C001DC
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jul 2023 17:56:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236595AbjGNR4a (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jul 2023 13:56:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236696AbjGNR4M (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jul 2023 13:56:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B8934496
        for <mm-commits@vger.kernel.org>; Fri, 14 Jul 2023 10:55:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0DD8161D9A
        for <mm-commits@vger.kernel.org>; Fri, 14 Jul 2023 17:54:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66899C433C7;
        Fri, 14 Jul 2023 17:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689357279;
        bh=RJUD2OU/73HnIDZkAn1GlcFi+KuESOqKm2+2+2L4nq0=;
        h=Date:To:From:Subject:From;
        b=sq8oYWZgQUadMOJOcXhqafdJ+BwGT3X3cMt92nO6pHUNyoPze6DNUMcpYWeMoyFvg
         ErEnTuzRkz62bBndfMZRhfhOhlSGH4/uBT+75wXi+3kLX1y/RzRJFBKdzThvo5ArIB
         T8lsSU21P+xmnJM9P3R2mwUFKMO6wv2WuCo2gOsg=
Date:   Fri, 14 Jul 2023 10:54:38 -0700
To:     mm-commits@vger.kernel.org, iamjoonsoo.kim@lge.com,
        shikemeng@huaweicloud.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_ext-remove-rollback-for-untouched-mem_section-in-online_page_ext.patch added to mm-unstable branch
Message-Id: <20230714175439.66899C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_ext: remove rollback for untouched mem_section in online_page_ext
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_ext-remove-rollback-for-untouched-mem_section-in-online_page_ext.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_ext-remove-rollback-for-untouched-mem_section-in-online_page_ext.patch

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
Subject: mm/page_ext: remove rollback for untouched mem_section in online_page_ext
Date: Fri, 14 Jul 2023 19:47:48 +0800

If init_section_page_ext failed, we only need rollback for mem_section
before failed mem_section.  Make rollback end point to failed mem_section
to remove unnecessary rollback.

As pfn += PAGES_PER_SECTION will be executed even if init_section_page_ext
failed.  So pfn points to mem_section after failed mem_section.  Subtract
one mem_section from pfn to get failed mem_section.

Link: https://lkml.kernel.org/r/20230714114749.1743032-3-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_ext.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/page_ext.c~mm-page_ext-remove-rollback-for-untouched-mem_section-in-online_page_ext
+++ a/mm/page_ext.c
@@ -424,6 +424,7 @@ static int __meminit online_page_ext(uns
 		return 0;
 
 	/* rollback */
+	end = pfn - PAGES_PER_SECTION;
 	for (pfn = start; pfn < end; pfn += PAGES_PER_SECTION)
 		__free_page_ext(pfn);
 
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

