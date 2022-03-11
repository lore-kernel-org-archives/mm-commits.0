Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93D55C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 11 Mar 2022 01:19:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345308AbiCKBUv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 10 Mar 2022 20:20:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345304AbiCKBUu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Mar 2022 20:20:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB88EE237A
        for <mm-commits@vger.kernel.org>; Thu, 10 Mar 2022 17:19:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F30DB8299F
        for <mm-commits@vger.kernel.org>; Fri, 11 Mar 2022 01:19:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F764C340E8;
        Fri, 11 Mar 2022 01:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646961584;
        bh=UxgFErMZxboGFqAXHVItc1gq6Nwna4slDaL+L07jBDU=;
        h=Date:To:From:Subject:From;
        b=1WM/rQRfoIwWBqwMwAMHhT7/oVZch6JRlKSsDk/209/6JTsbOcW+RvcE6i5yPXcmF
         JGAcZPJDlb/X9gmBGUQ8cg981nYRMXm0bgIIq1wuOJ+/QVnzWLHAHxyudzrKT6xYxe
         crcGBOx9/pfP3x/EIZ9yDSJvbenlnY92ld4ykQ7M=
Date:   Thu, 10 Mar 2022 17:19:43 -0800
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + linux-next-git-rejects.patch added to -mm tree
Message-Id: <20220311011944.1F764C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/gdm724x/gdm_lte.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/staging/gdm724x/gdm_lte.c~linux-next-git-rejects
+++ a/drivers/staging/gdm724x/gdm_lte.c
@@ -79,11 +79,7 @@ static int gdm_lte_rx(struct sk_buff *sk
 	int ret, len;
 
 	len = skb->len + ETH_HLEN;
-<<<<<<< HEAD
-	ret = netif_rx_ni(skb);
-=======
 	ret = netif_rx(skb);
->>>>>>> linux-next/akpm-base
 	if (ret == NET_RX_DROP) {
 		nic->stats.rx_dropped++;
 	} else {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

memcg-sync-flush-only-if-periodic-flush-is-delayed-fix.patch
remove-bdi_congested-and-wb_congested-and-related-functions-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-list_lru-replace-linear-array-with-xarray-fix.patch
mm-hwpoison-inject-support-injecting-hwpoison-to-free-page-fix.patch
mm-export-pageheadhuge-fix.patch
userfaultfd-provide-unmasked-address-on-page-fault-v3-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-handle-uninitialized-numa-nodes-gracefully-fix.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix.patch
proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch
taskstats-remove-unneeded-dead-assignment-fix.patch
linux-next-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch
kasan-improve-vmalloc-tests-fix-3-fix.patch
mm-slightly-clarify-ksm-logic-in-do_swap_page-fix.patch
mm-huge_memory-remove-stale-locking-logic-from-__split_huge_pmd-fix.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
linux-next-git-rejects.patch

