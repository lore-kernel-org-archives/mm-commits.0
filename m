Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C25D7C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 26 Apr 2022 21:48:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239762AbiDZVvW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Apr 2022 17:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235052AbiDZVvT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Apr 2022 17:51:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7605C692B3
        for <mm-commits@vger.kernel.org>; Tue, 26 Apr 2022 14:48:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C840B82169
        for <mm-commits@vger.kernel.org>; Tue, 26 Apr 2022 21:48:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1708C385A4;
        Tue, 26 Apr 2022 21:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651009689;
        bh=RGrXugOVlE5w9JtYicfvcnSl4PbhfWo/8QyUX8fsMSI=;
        h=Date:To:From:Subject:From;
        b=hQrvbT+BZz1VrwKLNC0t8Wbe8Fjvr9QXgT3kIw3AQm/L2loX1kfJgXn0liDVma9my
         CRVTdOxY+Az092cEZaR5QTOJAmMlFFw/igOTjX7v0NafOvCzyPPqk2yYdxDcv/6ruK
         Jtod3XM9jrhyPJzs2x8nhB2mmbzy9KpIwb9pzwRA=
Date:   Tue, 26 Apr 2022 14:48:08 -0700
To:     mm-commits@vger.kernel.org, richard.weiyang@gmail.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-not-necessary-to-re-init-the-list-for-each-iteration-fix.patch added to -mm tree
Message-Id: <20220426214808.E1708C385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmscan-not-necessary-to-re-init-the-list-for-each-iteration-fix
has been added to the -mm tree.  Its filename is
     mm-vmscan-not-necessary-to-re-init-the-list-for-each-iteration-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-not-necessary-to-re-init-the-list-for-each-iteration-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-not-necessary-to-re-init-the-list-for-each-iteration-fix.patch

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
Subject: mm-vmscan-not-necessary-to-re-init-the-list-for-each-iteration-fix

remove unneeded braces

Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-not-necessary-to-re-init-the-list-for-each-iteration-fix
+++ a/mm/vmscan.c
@@ -2572,9 +2572,8 @@ unsigned long reclaim_pages(struct list_
 
 	while (!list_empty(page_list)) {
 		page = lru_to_page(page_list);
-		if (nid == NUMA_NO_NODE) {
+		if (nid == NUMA_NO_NODE)
 			nid = page_to_nid(page);
-		}
 
 		if (nid == page_to_nid(page)) {
 			ClearPageActive(page);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-prevent-cpu_quarantine-corruption-when-cpu-offline-and-cache-shrink-occur-at-same-time-fix.patch
mm.patch
mm-create-new-mm-swaph-header-file-fix.patch
mm-check-against-orig_pte-for-finish_fault-fix-checkpatch-fixes.patch
mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix-fix.patch
mm-vmscan-fix-comment-for-current_may_throttle-fix.patch
ksm-count-ksm-merging-pages-for-each-process-fix.patch
mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node-checkpatch-fixes.patch
kfence-enable-check-kfence-canary-on-panic-via-boot-param-fix.patch
lib-kstrtoxc-add-false-true-support-to-kstrtobool-fix.patch
mm-vmscan-not-necessary-to-re-init-the-list-for-each-iteration-fix.patch
proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch
fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body-fix.patch
add-fat-messages-to-printk-index-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

