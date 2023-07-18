Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4492FEB64DC
	for <mm-commits@archiver.kernel.org>; Tue, 18 Jul 2023 18:09:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbjGRSJ6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Jul 2023 14:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231300AbjGRSJ4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Jul 2023 14:09:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F337EE60
        for <mm-commits@vger.kernel.org>; Tue, 18 Jul 2023 11:09:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2AEC616B4
        for <mm-commits@vger.kernel.org>; Tue, 18 Jul 2023 18:08:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00E71C433C8;
        Tue, 18 Jul 2023 18:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689703734;
        bh=MtSh2/c4dkOb4cgJZYCEGIEhXrad3eMSEcVFNMIDft4=;
        h=Date:To:From:Subject:From;
        b=YIKfXcvkArWKADfSwsvyZiuCF3ZARvxy21es9YwW4H/CFGTCPXwcLP9uVtehbhtA8
         tbKI1cdV6bkBriQm2xXncIcMnAnmvkT30SSo9rvNeEuNK+Bx9MpL1gwmaIU/hJpl+G
         FngYhIghnQaRaa8YFk1nEYHqgQM4tLeAKzUX9xrQ=
Date:   Tue, 18 Jul 2023 11:08:53 -0700
To:     mm-commits@vger.kernel.org, akpm@linux-foudation.org,
        shikemeng@huaweicloud.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_ext-use-page_ext_data-helper-in-page_table_check.patch added to mm-unstable branch
Message-Id: <20230718180854.00E71C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_ext: use page_ext_data helper in page_table_check
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_ext-use-page_ext_data-helper-in-page_table_check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_ext-use-page_ext_data-helper-in-page_table_check.patch

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
Subject: mm/page_ext: use page_ext_data helper in page_table_check
Date: Tue, 18 Jul 2023 22:58:11 +0800

use page_ext_data helper in page_table_check to avoid access offset
directly.

Link: https://lkml.kernel.org/r/20230718145812.1991717-3-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Andrew Morton <akpm@linux-foudation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_table_check.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_table_check.c~mm-page_ext-use-page_ext_data-helper-in-page_table_check
+++ a/mm/page_table_check.c
@@ -51,7 +51,7 @@ struct page_ext_operations page_table_ch
 static struct page_table_check *get_page_table_check(struct page_ext *page_ext)
 {
 	BUG_ON(!page_ext);
-	return (void *)(page_ext) + page_table_check_ops.offset;
+	return page_ext_data(page_ext, &page_table_check_ops);
 }
 
 /*
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
mm-page_ext-add-common-function-to-get-client-data-from-page_ext.patch
mm-page_ext-use-page_ext_data-helper-in-page_table_check.patch
mm-page_ext-use-page_ext_data-helper-in-page_owner.patch

