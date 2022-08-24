Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 716CDC004D4
	for <mm-commits@archiver.kernel.org>; Wed, 24 Aug 2022 19:42:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236829AbiHXTmj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Aug 2022 15:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbiHXTmi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 Aug 2022 15:42:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D03BD6DFA1
        for <mm-commits@vger.kernel.org>; Wed, 24 Aug 2022 12:42:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 595296178D
        for <mm-commits@vger.kernel.org>; Wed, 24 Aug 2022 19:42:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E71C433C1;
        Wed, 24 Aug 2022 19:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661370156;
        bh=C0po0dAfWfeFJiFDApf4qnNngxUA+3BbMZNpldce1Dg=;
        h=Date:To:From:Subject:From;
        b=BqPGXhZgFljXuuZVmfRSUWXgyBCLEL3oT9iftuLMnNow38MLC71+vz74d16hsEpRJ
         GzGJCnVLut6xR39epAvPy/HagR5P7ZJ7s9mFjitKO7podLvuuw3GWPHP/pLZwVqnFb
         MBpiS0Os+N8IJGZX95dCPPiWIwRR12hQ6Km4981Q=
Date:   Wed, 24 Aug 2022 12:42:35 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hwpoison-fix-possible-use-after-free-in-mf_dax_kill_procs-v2.patch added to mm-unstable branch
Message-Id: <20220824194236.A8E71C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hwpoison: fix possible use-after-free in mf_dax_kill_procs()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hwpoison-fix-possible-use-after-free-in-mf_dax_kill_procs-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hwpoison-fix-possible-use-after-free-in-mf_dax_kill_procs-v2.patch

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
Subject: mm, hwpoison: fix possible use-after-free in mf_dax_kill_procs()
Date: Tue, 23 Aug 2022 11:23:44 +0800

After kill_procs(), tk will be freed without being removed from the
to_kill list.  In the next iteration, the freed list entry in the to_kill
list will be accessed, thus leading to use-after-free issue.  Adding
list_del() in kill_procs() to fix the issue.

Link: https://lkml.kernel.org/r/20220823032346.4260-5-linmiaohe@huawei.com
Fixes: c36e20249571 ("mm: introduce mf_dax_kill_procs() for fsdax case")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/memory-failure.c~mm-hwpoison-fix-possible-use-after-free-in-mf_dax_kill_procs-v2
+++ a/mm/memory-failure.c
@@ -413,7 +413,7 @@ static void kill_procs(struct list_head
 {
 	struct to_kill *tk, *next;
 
-	list_for_each_entry_safe (tk, next, to_kill, nd) {
+	list_for_each_entry_safe(tk, next, to_kill, nd) {
 		if (forcekill) {
 			/*
 			 * In case something went wrong with munmapping
@@ -437,6 +437,7 @@ static void kill_procs(struct list_head
 				pr_err("%#lx: Cannot send advisory machine check signal to %s:%d\n",
 				       pfn, tk->tsk->comm, tk->tsk->pid);
 		}
+		list_del(&tk->nd);
 		put_task_struct(tk->tsk);
 		kfree(tk);
 	}
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch
hugetlb_cgroup-remove-unneeded-nr_pages-0-check.patch
hugetlb_cgroup-hugetlbfs-use-helper-macro-sz_1kmg.patch
hugetlb_cgroup-remove-unneeded-return-value.patch
hugetlb_cgroup-use-helper-macro-numa_no_node.patch
hugetlb_cgroup-use-helper-for_each_hstate-and-hstate_index.patch
mm-hugetlb-fix-incorrect-update-of-max_huge_pages.patch
mm-hugetlb-fix-warn_onkobj-in-sysfs_create_group.patch
mm-hugetlb-fix-missing-call-to-restore_reserve_on_error.patch
mm-hugetlb_vmemmap-add-missing-smp_wmb-before-set_pte_at.patch
mm-hugetlb-fix-sysfs-group-leak-in-hugetlb_unregister_node.patch
mm-hugetlb-make-detecting-shared-pte-more-reliable.patch
mm-hwpoison-fix-page-refcnt-leaking-in-try_memory_failure_hugetlb.patch
mm-hwpoison-fix-page-refcnt-leaking-in-unpoison_memory.patch
mm-hwpoison-fix-extra-put_page-in-soft_offline_page.patch
mm-hwpoison-fix-possible-use-after-free-in-mf_dax_kill_procs-v2.patch
mm-hwpoison-kill-procs-if-unmap-fails.patch
mm-hwpoison-avoid-trying-to-unpoison-reserved-page.patch

