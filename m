Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D91FFC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 11 Feb 2022 18:43:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352849AbiBKSn3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Feb 2022 13:43:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352832AbiBKSnC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Feb 2022 13:43:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E9F8335
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 10:43:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DA2661EDF
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 18:43:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C76CFC340E9;
        Fri, 11 Feb 2022 18:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644604979;
        bh=bBiXPivoO7MpjzlwEP53BTxNrbZTyGV82iCwUMAFhVo=;
        h=Date:To:From:Subject:From;
        b=ph2CaD8T8djAokyizMbcMB0TP3QyPHns2sGtfadQ9r0CDaxFDAWKE0FjhVB49ysr5
         Nna6hbDTfLG2R0H9CCW+kN5CR5L6EnOlHjNdcYQCT6zfKjlltPY61segxOoy6Teer1
         6sIxb+3kOj5Nzefp7ZMPH+r6ietg/tlbuXwy7g1Y=
Date:   Fri, 11 Feb 2022 10:42:59 -0800
To:     mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failurec-rework-the-signaling-logic-in-kill_proc.patch added to -mm tree
Message-Id: <20220211184259.C76CFC340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure.c: rework the signaling logic in kill_proc
has been added to the -mm tree.  Its filename is
     mm-memory-failurec-rework-the-signaling-logic-in-kill_proc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory-failurec-rework-the-signaling-logic-in-kill_proc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-failurec-rework-the-signaling-logic-in-kill_proc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory-failure.c: rework the signaling logic in kill_proc

BUS_MCEERR_AR code is only sent when MF_ACTION_REQUIRED is set and the
target is current.  Rework the code to make this clear.

Link: https://lkml.kernel.org/r/20220210141733.1908-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/memory-failure.c~mm-memory-failurec-rework-the-signaling-logic-in-kill_proc
+++ a/mm/memory-failure.c
@@ -258,16 +258,13 @@ static int kill_proc(struct to_kill *tk,
 	pr_err("Memory failure: %#lx: Sending SIGBUS to %s:%d due to hardware memory corruption\n",
 			pfn, t->comm, t->pid);
 
-	if (flags & MF_ACTION_REQUIRED) {
-		if (t == current)
-			ret = force_sig_mceerr(BUS_MCEERR_AR,
-					 (void __user *)tk->addr, addr_lsb);
-		else
-			/* Signal other processes sharing the page if they have PF_MCE_EARLY set. */
-			ret = send_sig_mceerr(BUS_MCEERR_AO, (void __user *)tk->addr,
-				addr_lsb, t);
-	} else {
+	if ((flags & MF_ACTION_REQUIRED) && (t == current))
+		ret = force_sig_mceerr(BUS_MCEERR_AR,
+				 (void __user *)tk->addr, addr_lsb);
+	else
 		/*
+		 * Signal other processes sharing the page if they have
+		 * PF_MCE_EARLY set.
 		 * Don't use force here, it's convenient if the signal
 		 * can be temporarily blocked.
 		 * This could cause a loop when the user sets SIGBUS
@@ -275,7 +272,6 @@ static int kill_proc(struct to_kill *tk,
 		 */
 		ret = send_sig_mceerr(BUS_MCEERR_AO, (void __user *)tk->addr,
 				      addr_lsb, t);  /* synchronous? */
-	}
 	if (ret < 0)
 		pr_info("Memory failure: Error sending signal to %s:%d: %d\n",
 			t->comm, t->pid, ret);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memremap-avoid-calling-kasan_remove_zero_shadow-for-device-private-memory.patch
filemap-remove-find_get_pages.patch
mm-sparse-make-mminit_validate_memmodel_limits-static.patch
mm-vmalloc-remove-unneeded-function-forward-declaration.patch
mm-mmzoneh-remove-unused-macros.patch
mm-memory-failurec-minor-clean-up-for-memory_failure_dev_pagemap.patch
mm-memory-failurec-avoid-walking-page-table-when-vma_address-return-efault.patch
mm-memory-failurec-rework-the-signaling-logic-in-kill_proc.patch
mm-memory-failurec-remove-unneeded-orig_head.patch
mm-memory-failurec-remove-pageslab-check-in-hwpoison_filter_dev.patch
mm-memory-failurec-rework-the-try_to_unmap-logic-in-hwpoison_user_mappings.patch
mm-memory-failurec-remove-obsolete-comment-in-__soft_offline_page.patch
mm-memory-failurec-remove-unnecessary-pagetranstail-check.patch
mm-balloon_compaction-make-balloon-page-compaction-callbacks-static.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages.patch
mm-memory_hotplug-avoid-calling-zone_intersects-for-zone_normal.patch
mm-memory_hotplug-clean-up-try_offline_node.patch
mm-memory_hotplug-fix-misplaced-comment-in-offline_pages.patch
mm-highmem-remove-unnecessary-done-label.patch
mm-hmmc-remove-unneeded-local-variable-ret.patch

