Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96830C001DE
	for <mm-commits@archiver.kernel.org>; Fri, 28 Jul 2023 16:43:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233687AbjG1Qnf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 28 Jul 2023 12:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234868AbjG1QnK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Jul 2023 12:43:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A94B04209
        for <mm-commits@vger.kernel.org>; Fri, 28 Jul 2023 09:43:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67A6E621A7
        for <mm-commits@vger.kernel.org>; Fri, 28 Jul 2023 16:42:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF43CC433C8;
        Fri, 28 Jul 2023 16:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690562578;
        bh=dsIcQS71vfPDl/zth9SnYKBZAcdrcEh57WvgYXTSPCI=;
        h=Date:To:From:Subject:From;
        b=o2jHRinRTDTysrkCivBYDAB4VtuMRGQz44ln7kXS4aHRfVJFYGCJrCPaFowFUpuxm
         ajlaKEueGfJys0d/4NONXfva+ULDW+1LuUVfv3mRKJhwXRmp0zeCKJKbA3+PzLQjT5
         dInTEYxaVWOp0N0r9zLVyU8f7zg1ec8L2izYqORc=
Date:   Fri, 28 Jul 2023 09:42:58 -0700
To:     mm-commits@vger.kernel.org, shikemeng@huaweicloud.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_ext-move-page_ext_operations-definition-under-config_page_extension.patch added to mm-unstable branch
Message-Id: <20230728164258.BF43CC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_ext: move page_ext_operations definition under CONFIG_PAGE_EXTENSION
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_ext-move-page_ext_operations-definition-under-config_page_extension.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_ext-move-page_ext_operations-definition-under-config_page_extension.patch

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
Subject: mm/page_ext: move page_ext_operations definition under CONFIG_PAGE_EXTENSION
Date: Mon, 17 Jul 2023 19:32:27 +0800

page_ext_operations should only be defined when CONFIG_PAGE_EXTENSION is
enabled.

Besides, this may detect missing reliance on CONFIG_PAGE_EXTENSION from
future Page Extension clients at compile time.

Link: https://lkml.kernel.org/r/20230717113227.1897173-4-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_ext.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/include/linux/page_ext.h~mm-page_ext-move-page_ext_operations-definition-under-config_page_extension
+++ a/include/linux/page_ext.h
@@ -8,6 +8,7 @@
 
 struct pglist_data;
 
+#ifdef CONFIG_PAGE_EXTENSION
 /**
  * struct page_ext_operations - per page_ext client operations
  * @offset: Offset to the client's data within page_ext. Offset is returned to
@@ -29,8 +30,6 @@ struct page_ext_operations {
 	bool need_shared_flags;
 };
 
-#ifdef CONFIG_PAGE_EXTENSION
-
 /*
  * The page_ext_flags users must set need_shared_flags to true.
  */
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
mm-rmap-correct-stale-comment-of-rmap_walk_anon-and-rmap_walk_file.patch
mm-page_poison-remove-unused-page_exth-from-page_poison.patch
mm-vmstat-remove-unused-page_exth-from-vmstat.patch
mm-page_ext-move-page_ext_operations-definition-under-config_page_extension.patch

