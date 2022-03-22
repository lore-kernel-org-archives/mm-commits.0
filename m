Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFCB3C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 19:15:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbiCVTQr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 15:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbiCVTQr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 15:16:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68635BF6F
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 12:15:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 043576165E
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 19:15:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56DDDC340EC;
        Tue, 22 Mar 2022 19:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647976518;
        bh=bBo2qevl0i3hofFsbmHE35QPU1ANzS/w/LLxBdBsTxo=;
        h=Date:To:From:Subject:From;
        b=M3wRO3eTo18ci4+9azO9sAMfAQ1GpMzk7EclzgKZ5iEDtNPref8vgkNdWazYUQ8uZ
         hDSf5GwqGU4BqMkkBzLm8JX19Zz/AT/332Qgds0WSnR6+G/mgv9zJBKGM1ACgbF0xZ
         SKXmHjejp1iSCDkcVDaCGgmHOuB6nHPlPR3Cuiiw=
Date:   Tue, 22 Mar 2022 12:15:17 -0700
To:     mm-commits@vger.kernel.org, tj@kernel.org, rppt@linux.ibm.com,
        richard.weiyang@gmail.com, raquini@redhat.com, osalvador@suse.de,
        npache@redhat.com, mhocko@suse.com, eric.dumazet@gmail.com,
        dennis@kernel.org, david@redhat.com, cl@linux.com,
        amakhalov@vmware.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-handle-uninitialized-numa-nodes-gracefully-fix.patch removed from -mm tree
Message-Id: <20220322191518.56DDDC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-handle-uninitialized-numa-nodes-gracefully-fix
has been removed from the -mm tree.  Its filename was
     mm-handle-uninitialized-numa-nodes-gracefully-fix.patch

This patch was dropped because it was folded into mm-handle-uninitialized-numa-nodes-gracefully.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-handle-uninitialized-numa-nodes-gracefully-fix

replace comment, per Mike

Cc: Alexey Makhalov <amakhalov@vmware.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Rafael Aquini <raquini@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/mm/page_alloc.c~mm-handle-uninitialized-numa-nodes-gracefully-fix
+++ a/mm/page_alloc.c
@@ -8073,12 +8073,16 @@ void __init free_area_init(unsigned long
 			}
 			arch_refresh_nodedata(nid, pgdat);
 			free_area_init_memoryless_node(nid);
+
 			/*
-			 * not marking this node online because we do not want to
-			 * confuse userspace by sysfs files/directories for node
-			 * without any memory attached to it (see topology_init)
-			 * The pgdat will get fully initialized when a memory is
-			 * hotpluged into it by hotadd_init_pgdat
+			 * We do not want to confuse userspace by sysfs
+			 * files/directories for node without any memory
+			 * attached to it, so this node is not marked as
+			 * N_MEMORY and not marked online so that no sysfs
+			 * hierarchy will be created via register_one_node for
+			 * it. The pgdat will get fully initialized by
+			 * hotadd_init_pgdat() when memory is hotplugged into
+			 * this node.
 			 */
 			continue;
 		}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-handle-uninitialized-numa-nodes-gracefully.patch
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

