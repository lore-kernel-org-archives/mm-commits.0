Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59804C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 19:09:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbiCVTLK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 15:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231269AbiCVTLJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 15:11:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB5E952E2E
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 12:09:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8739361657
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 19:09:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D985BC340F2;
        Tue, 22 Mar 2022 19:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647976181;
        bh=Zi6J0NGTjB6IOcJVln5rbCHAnZJvsWZSQCclifU48Ok=;
        h=Date:To:From:Subject:From;
        b=vCMu0m3Fg7XBRPI99037g4IEuOKbE39MY5iShvLjkeAHfofA8YUYmgNJa1G4XxLHP
         uiH+9W3yBwl79nb/ogtBYGj7h42ZkoW6TOadLJU3eQVaVmpZ314eoU/FTZUScmcdr1
         RoTLcuk8bDscCvihQpQTOIqF8XkvWArVsSFdTDgo=
Date:   Tue, 22 Mar 2022 12:09:40 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-list_lru-replace-linear-array-with-xarray-fix.patch removed from -mm tree
Message-Id: <20220322190940.D985BC340F2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-list_lru-replace-linear-array-with-xarray-fix
has been removed from the -mm tree.  Its filename was
     mm-list_lru-replace-linear-array-with-xarray-fix.patch

This patch was dropped because it was folded into mm-list_lru-replace-linear-array-with-xarray.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-list_lru-replace-linear-array-with-xarray-fix

remove unused local

mm/list_lru.c: In function 'memcg_list_lru_alloc':
mm/list_lru.c:477:32: error: unused variable 'mlrus' [-Werror=unused-variable]
  477 |         struct list_lru_memcg *mlrus;
      |                                ^~~~~

Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/list_lru.c~mm-list_lru-replace-linear-array-with-xarray-fix
+++ a/mm/list_lru.c
@@ -480,7 +480,6 @@ int memcg_list_lru_alloc(struct mem_cgro
 {
 	int i;
 	unsigned long flags;
-	struct list_lru_memcg *mlrus;
 	struct list_lru_memcg_table {
 		struct list_lru_per_memcg *mlru;
 		struct mem_cgroup *memcg;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-list_lru-replace-linear-array-with-xarray.patch
mm-hwpoison-inject-support-injecting-hwpoison-to-free-page-fix.patch
mm-memory-failurec-fix-race-with-changing-page-compound-again-fix.patch
mm-export-pageheadhuge-fix.patch
userfaultfd-provide-unmasked-address-on-page-fault-v3-fix.patch
mm-handle-uninitialized-numa-nodes-gracefully-fix.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix.patch
memcg-sync-flush-only-if-periodic-flush-is-delayed-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch
linux-typesh-remove-unnecessary-__bitwise__-fix.patch
taskstats-remove-unneeded-dead-assignment-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch
kasan-improve-vmalloc-tests-fix-3-fix.patch
mm-slightly-clarify-ksm-logic-in-do_swap_page-fix.patch
mm-huge_memory-remove-stale-locking-logic-from-__split_huge_pmd-fix.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

