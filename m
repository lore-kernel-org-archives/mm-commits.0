Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE19FC43334
	for <mm-commits@archiver.kernel.org>; Tue, 21 Jun 2022 23:26:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354433AbiFUX0l (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Jun 2022 19:26:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353746AbiFUX0k (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jun 2022 19:26:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC2283056D
        for <mm-commits@vger.kernel.org>; Tue, 21 Jun 2022 16:26:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 742CC61544
        for <mm-commits@vger.kernel.org>; Tue, 21 Jun 2022 23:26:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2908DC3411C;
        Tue, 21 Jun 2022 23:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655853998;
        bh=NSkaCpoUk16VMriczXvcWuOxH2nia+hfdj0h0sqPKvQ=;
        h=Date:To:From:Subject:From;
        b=z+2NKZmwcWYDm7iD13VAmwVehq5eGHeihWcVnnYslJ4+TAwDqICAwkHUF/ijCp7or
         WtusqeQzlg6NNVXklDVnBLjFGWS8wAM16JGayPKD4SbqBVzPWW2U+NMByINmkmLXTS
         1spJ2nrNyZdSCEhmhZZcKKe8euoFlqFGyzgMbvcY=
Date:   Tue, 21 Jun 2022 16:26:30 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        songmuchun@bytedance.com, peterx@redhat.com, osalvador@suse.de,
        mike.kravetz@oracle.com, lkp@intel.com, hch@lst.de,
        dhowells@redhat.com, david@redhat.com, cl@linux.com,
        apopple@nvidia.com, linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] mm-reduce-the-rcu-lock-duration.patch removed from -mm tree
Message-Id: <20220621232637.2908DC3411C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: reduce the rcu lock duration
has been removed from the -mm tree.  Its filename was
     mm-reduce-the-rcu-lock-duration.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: reduce the rcu lock duration
Date: Mon, 30 May 2022 19:30:13 +0800

Patch series "A few cleanup and fixup patches for migration", v4.

This series contains a few patches to remove unneeded lock page and
PageMovable check, reduce the rcu lock duration.  Also we fix potential
pte_unmap on an not mapped pte.  More details can be found in the
respective changelogs.


This patch (of 4):

Commit 3268c63eded4 ("mm: fix move/migrate_pages() race on task struct")
extends the period of the rcu_read_lock until after the permissions checks
are done to prevent the task pointed to from changing from under us.  But
the task_struct refcount is also taken at that time, the reference to task
is guaranteed to be stable.  So it's unnecessary to extend the period of
the rcu_read_lock.  Release the rcu lock after task refcount is
successfully grabbed to reduce the rcu holding time.

Link: https://lkml.kernel.org/r/20220530113016.16663-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20220530113016.16663-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: David Howells <dhowells@redhat.com>
Cc: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    3 +--
 mm/migrate.c   |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

--- a/mm/mempolicy.c~mm-reduce-the-rcu-lock-duration
+++ a/mm/mempolicy.c
@@ -1617,6 +1617,7 @@ static int kernel_migrate_pages(pid_t pi
 		goto out;
 	}
 	get_task_struct(task);
+	rcu_read_unlock();
 
 	err = -EINVAL;
 
@@ -1625,11 +1626,9 @@ static int kernel_migrate_pages(pid_t pi
 	 * Use the regular "ptrace_may_access()" checks.
 	 */
 	if (!ptrace_may_access(task, PTRACE_MODE_READ_REALCREDS)) {
-		rcu_read_unlock();
 		err = -EPERM;
 		goto out_put;
 	}
-	rcu_read_unlock();
 
 	task_nodes = cpuset_mems_allowed(task);
 	/* Is the user allowed to access the target nodes? */
--- a/mm/migrate.c~mm-reduce-the-rcu-lock-duration
+++ a/mm/migrate.c
@@ -1902,17 +1902,16 @@ static struct mm_struct *find_mm_struct(
 		return ERR_PTR(-ESRCH);
 	}
 	get_task_struct(task);
+	rcu_read_unlock();
 
 	/*
 	 * Check if this process has the right to modify the specified
 	 * process. Use the regular "ptrace_may_access()" checks.
 	 */
 	if (!ptrace_may_access(task, PTRACE_MODE_READ_REALCREDS)) {
-		rcu_read_unlock();
 		mm = ERR_PTR(-EPERM);
 		goto out;
 	}
-	rcu_read_unlock();
 
 	mm = ERR_PTR(security_task_movememory(task));
 	if (IS_ERR(mm))
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-migration-remove-unneeded-lock-page-and-pagemovable-check.patch
mm-migration-return-errno-when-isolate_huge_page-failed.patch
mm-migration-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-swapfile-make-security_vm_enough_memory_mm-work-as-expected.patch
mm-swapfile-fix-possible-data-races-of-inuse_pages.patch
mm-swap-remove-swap_cache_info-statistics.patch
mm-vmscan-dont-try-to-reclaim-freed-folios.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch
mm-madvise-minor-cleanup-for-swapin_walk_pmd_entry.patch

