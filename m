Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58F2EC433E6
	for <mm-commits@archiver.kernel.org>; Wed,  3 Mar 2021 13:32:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 073CE64EE7
	for <mm-commits@archiver.kernel.org>; Wed,  3 Mar 2021 13:32:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359045AbhCCN00 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 08:26:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:53812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231942AbhCBX5G (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Mar 2021 18:57:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF53C64F2B;
        Tue,  2 Mar 2021 23:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614729380;
        bh=v32TR4O5l72v9WdTlPfqswa2uy5+2Rbvewb7mPTNNps=;
        h=Date:From:To:Subject:From;
        b=G2subc9G0YgeQdU5eArSKIR3w4IgcrCwQzNUOAbICHrPRYLt6TZdjcOkvoMCAFzTx
         kvC+gUO5LE3Dm+mNlr41r9kbBf02rTgZPSrE2X6WtsMRogDng8KAAi2YKAiwbAoJ0x
         a2I8wANCemXChUQ3BQj+z4KHDwai5Xi4ePDQsKEw=
Date:   Tue, 02 Mar 2021 15:56:20 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        wangqing@vivo.com
Subject:  + mm-delete-bool-migrated.patch added to -mm tree
Message-ID: <20210302235620.ru-4I2AGZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory.c: do_numa_page(): delete bool "migrated"
has been added to the -mm tree.  Its filename is
     mm-delete-bool-migrated.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-delete-bool-migrated.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-delete-bool-migrated.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wang Qing <wangqing@vivo.com>
Subject: mm/memory.c: do_numa_page(): delete bool "migrated"

Smatch gives the warning:
	do_numa_page() warn: assigning (-11) to unsigned variable 'migrated'

Link: https://lkml.kernel.org/r/1614603421-2681-1-git-send-email-wangqing@vivo.com
Signed-off-by: Wang Qing <wangqing@vivo.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/memory.c~mm-delete-bool-migrated
+++ a/mm/memory.c
@@ -4098,7 +4098,6 @@ static vm_fault_t do_numa_page(struct vm
 	int page_nid = NUMA_NO_NODE;
 	int last_cpupid;
 	int target_nid;
-	bool migrated = false;
 	pte_t pte, old_pte;
 	bool was_writable = pte_savedwrite(vmf->orig_pte);
 	int flags = 0;
@@ -4168,8 +4167,7 @@ static vm_fault_t do_numa_page(struct vm
 	}
 
 	/* Migrate to the requested node */
-	migrated = migrate_misplaced_page(page, vma, target_nid);
-	if (migrated) {
+	if (migrate_misplaced_page(page, vma, target_nid)) {
 		page_nid = target_nid;
 		flags |= TNF_MIGRATED;
 	} else
_

Patches currently in -mm which might be from wangqing@vivo.com are

mm-delete-bool-migrated.patch

