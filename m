Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33704C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 30 May 2022 20:30:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232989AbiE3UaV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 30 May 2022 16:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238909AbiE3UaU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 30 May 2022 16:30:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67C6F72E03
        for <mm-commits@vger.kernel.org>; Mon, 30 May 2022 13:30:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1EC8CB80ED4
        for <mm-commits@vger.kernel.org>; Mon, 30 May 2022 20:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6507C3411C;
        Mon, 30 May 2022 20:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653942615;
        bh=beXGrSfgQ/CcgqotlBdjHeQlM3GSABwQB0PwHTF/dfo=;
        h=Date:To:From:Subject:From;
        b=tREuCXnr/iAmwQ6Lv6fheiA9tjjhfO/NBqQSSNfP0+veZwFCfmsgIv++LLLt7/9Gc
         eqFI27VR7gzy9yawyoqEHVNOBANGd8xWXJ6ceIhQjew1KJAlS194PN4Sy6x/YlLKN/
         /NRUcmS6aqgiONw1ZaN8mWWeJO/YGiA8znlr8Sgo=
Date:   Mon, 30 May 2022 13:30:15 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        songmuchun@bytedance.com, peterx@redhat.com, osalvador@suse.de,
        mike.kravetz@oracle.com, lkp@intel.com, hch@lst.de,
        dhowells@redhat.com, david@redhat.com, cl@linux.com,
        apopple@nvidia.com, linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-reduce-the-rcu-lock-duration.patch added to mm-unstable branch
Message-Id: <20220530203015.C6507C3411C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: reduce the rcu lock duration
has been added to the -mm mm-unstable branch.  Its filename is
     mm-reduce-the-rcu-lock-duration.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-reduce-the-rcu-lock-duration.patch

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
Cc: Huang Ying <ying.huang@intel.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: David Howells <dhowells@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    3 +--
 mm/migrate.c   |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

--- a/mm/mempolicy.c~mm-reduce-the-rcu-lock-duration
+++ a/mm/mempolicy.c
@@ -1609,6 +1609,7 @@ static int kernel_migrate_pages(pid_t pi
 		goto out;
 	}
 	get_task_struct(task);
+	rcu_read_unlock();
 
 	err = -EINVAL;
 
@@ -1617,11 +1618,9 @@ static int kernel_migrate_pages(pid_t pi
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

maintainers-add-maintainer-information-for-z3fold.patch
mm-shmemc-clean-up-comment-of-shmem_swapin_folio.patch
mm-reduce-the-rcu-lock-duration.patch
mm-migration-remove-unneeded-lock-page-and-pagemovable-check.patch
mm-migration-return-errno-when-isolate_huge_page-failed.patch
mm-migration-fix-potential-pte_unmap-on-an-not-mapped-pte.patch

