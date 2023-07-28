Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD58AC04FDF
	for <mm-commits@archiver.kernel.org>; Fri, 28 Jul 2023 16:43:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234008AbjG1Qng (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 28 Jul 2023 12:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234548AbjG1QnE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Jul 2023 12:43:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E7D244B1
        for <mm-commits@vger.kernel.org>; Fri, 28 Jul 2023 09:42:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF5A162169
        for <mm-commits@vger.kernel.org>; Fri, 28 Jul 2023 16:42:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E9A7C433C7;
        Fri, 28 Jul 2023 16:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690562575;
        bh=diY0Lmsk50vyi2wqXH9/RnmeujH/ibDKAJYU1trLZe8=;
        h=Date:To:From:Subject:From;
        b=iyR+CVkbyIilKLswkwyYSn5pvXmndlhKwh8x1v1pxVLllxkRFP0UOr+wVfzClyT+D
         ee9eZVKOlljOwXOp5CwNTrVAKkE+MNlPGnmxwoM5o+DTRw3RepST2y5+NxXlWnXt8u
         /Zf/ffcxmGrV0eDe8Utd/q49x+I5fKfQvnb+Hp3E=
Date:   Fri, 28 Jul 2023 09:42:54 -0700
To:     mm-commits@vger.kernel.org, shikemeng@huaweicloud.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_poison-remove-unused-page_exth-from-page_poison.patch added to mm-unstable branch
Message-Id: <20230728164255.1E9A7C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_poison: remove unused page_ext.h from page_poison
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_poison-remove-unused-page_exth-from-page_poison.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_poison-remove-unused-page_exth-from-page_poison.patch

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
Subject: mm/page_poison: remove unused page_ext.h from page_poison
Date: Mon, 17 Jul 2023 19:32:25 +0800

Patch series "minor cleanups to page_ext header".

No page_ext function or structure is used in page_poison.  Just remove
page_ext header from page_poison.

Link: https://lkml.kernel.org/r/20230717113227.1897173-1-shikemeng@huaweicloud.com
Link: https://lkml.kernel.org/r/20230717113227.1897173-2-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_poison.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/page_poison.c~mm-page_poison-remove-unused-page_exth-from-page_poison
+++ a/mm/page_poison.c
@@ -4,7 +4,6 @@
 #include <linux/mm.h>
 #include <linux/mmdebug.h>
 #include <linux/highmem.h>
-#include <linux/page_ext.h>
 #include <linux/poison.h>
 #include <linux/ratelimit.h>
 #include <linux/kasan.h>
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

