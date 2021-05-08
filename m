Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6689DC433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:41:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 486C16100C
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:41:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbhEHWmr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:42:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:47330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229660AbhEHWmq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:42:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 721926100C;
        Sat,  8 May 2021 22:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513703;
        bh=gsevqsUJOm6vhUVpNBjZ9yTxZ4Q+2Lc0ABtPt/xN+0U=;
        h=Date:From:To:Subject:From;
        b=G3CVMERvb6P/HpZGks7KDnmJUChU/QpWXd3GgEIvMdngxwn+yD+VOq2K/bgIlsZ7e
         AsGx+GWyWYw4/NJlD5ER1119RsP0ex3uh72HRqtZ7E4EVmz+bY8RC+q92qpQCrZVrG
         BVXTxpUzwo9gRCDScMeNd6nDdgn2oSOLayU84FOM=
Date:   Sat, 08 May 2021 15:41:43 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        wangqing@vivo.com
Subject:  [merged] mm-delete-bool-migrated.patch removed from -mm
 tree
Message-ID: <20210508224143.fKLicKFAB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory.c: do_numa_page(): delete bool "migrated"
has been removed from the -mm tree.  Its filename was
     mm-delete-bool-migrated.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


