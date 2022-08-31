Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4807BECAAD4
	for <mm-commits@archiver.kernel.org>; Wed, 31 Aug 2022 01:21:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbiHaBVw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 30 Aug 2022 21:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231537AbiHaBVs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 Aug 2022 21:21:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35F19B07F5
        for <mm-commits@vger.kernel.org>; Tue, 30 Aug 2022 18:21:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D524BB81DFF
        for <mm-commits@vger.kernel.org>; Wed, 31 Aug 2022 01:21:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 788E4C433D6;
        Wed, 31 Aug 2022 01:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661908901;
        bh=WzRDMQgrDwxplQBlOpBelWhbCvezub0yJL9ks9yrl/4=;
        h=Date:To:From:Subject:From;
        b=gTFGsIMfEdx3IX80VnubGHN8e5qtgpLo/EjWBot+kdnXMAd9HFg0yVPOWtCx6zw7/
         0drGbdPVSGgYsmdZhPD8Xan9EeYuGQaDkjsLhu8N97wVBljOD+pCeGBrNQVgq3+G3f
         iYkAIgDDf76DzlgjMHpTsB3kg7kSNiz3h0Pis/64=
Date:   Tue, 30 Aug 2022 18:21:40 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hwpoison-cleanup-some-obsolete-comments.patch added to mm-unstable branch
Message-Id: <20220831012141.788E4C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hwpoison: cleanup some obsolete comments
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hwpoison-cleanup-some-obsolete-comments.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hwpoison-cleanup-some-obsolete-comments.patch

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
Subject: mm, hwpoison: cleanup some obsolete comments
Date: Tue, 30 Aug 2022 20:36:04 +0800

1.Remove meaningless comment in kill_proc(). That doesn't tell anything.
2.Fix the wrong function name get_hwpoison_unless_zero(). It should be
get_page_unless_zero().
3.The gate keeper for free hwpoison page has moved to check_new_page().
Update the corresponding comment.

Link: https://lkml.kernel.org/r/20220830123604.25763-7-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-cleanup-some-obsolete-comments
+++ a/mm/memory-failure.c
@@ -277,7 +277,7 @@ static int kill_proc(struct to_kill *tk,
 		 * to SIG_IGN, but hopefully no one will do that?
 		 */
 		ret = send_sig_mceerr(BUS_MCEERR_AO, (void __user *)tk->addr,
-				      addr_lsb, t);  /* synchronous? */
+				      addr_lsb, t);
 	if (ret < 0)
 		pr_info("Error sending signal to %s:%d: %d\n",
 			t->comm, t->pid, ret);
@@ -1246,9 +1246,9 @@ static int __get_hwpoison_page(struct pa
 		return ret;
 
 	/*
-	 * This check prevents from calling get_hwpoison_unless_zero()
-	 * for any unsupported type of page in order to reduce the risk of
-	 * unexpected races caused by taking a page refcount.
+	 * This check prevents from calling get_page_unless_zero() for any
+	 * unsupported type of page in order to reduce the risk of unexpected
+	 * races caused by taking a page refcount.
 	 */
 	if (!HWPoisonHandlable(head, flags))
 		return -EBUSY;
@@ -2025,7 +2025,7 @@ try_again:
 	/*
 	 * We need/can do nothing about count=0 pages.
 	 * 1) it's a free page, and therefore in safe hand:
-	 *    prep_new_page() will be the gate keeper.
+	 *    check_new_page() will be the gate keeper.
 	 * 2) it's part of a non-compound high order page.
 	 *    Implies some kernel user: cannot stop them from
 	 *    R/W the page; let's pray that the page has been
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
mm-hugetlb-fix-missing-call-to-restore_reserve_on_error-v2.patch
mm-hugetlb_vmemmap-add-missing-smp_wmb-before-set_pte_at.patch
mm-hugetlb-fix-sysfs-group-leak-in-hugetlb_unregister_node.patch
mm-hugetlb-make-detecting-shared-pte-more-reliable.patch
mm-hwpoison-fix-page-refcnt-leaking-in-try_memory_failure_hugetlb.patch
mm-hwpoison-fix-page-refcnt-leaking-in-unpoison_memory.patch
mm-hwpoison-fix-extra-put_page-in-soft_offline_page.patch
mm-hwpoison-fix-possible-use-after-free-in-mf_dax_kill_procs-v2.patch
mm-hwpoison-kill-procs-if-unmap-fails.patch
mm-hwpoison-kill-procs-if-unmap-fails-v2.patch
mm-hwpoison-avoid-trying-to-unpoison-reserved-page.patch
mm-hwpoison-use-clearpagehwpoison-in-memory_failure.patch
mm-hwpoison-use-__pagemovable-to-detect-non-lru-movable-pages.patch
mm-hwpoison-use-num_poisoned_pages_sub-to-decrease-num_poisoned_pages.patch
mm-hwpoison-avoid-unneeded-page_mapped_in_vma-overhead-in-collect_procs_anon.patch
mm-hwpoison-check-pagetable-explicitly-in-hwpoison_user_mappings.patch
mm-hwpoison-cleanup-some-obsolete-comments.patch

