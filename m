Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E867FC433E6
	for <mm-commits@archiver.kernel.org>; Mon,  8 Mar 2021 20:02:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B909265238
	for <mm-commits@archiver.kernel.org>; Mon,  8 Mar 2021 20:02:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbhCHUB5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Mar 2021 15:01:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:55442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231760AbhCHUBz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Mar 2021 15:01:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA72065238;
        Mon,  8 Mar 2021 20:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615233715;
        bh=1Un9gUpNIb0tIz97ITsdIT/jRTL6Q4yJ1Sd+5ggti3U=;
        h=Date:From:To:Subject:From;
        b=HwxNat976e7YaSeDJnKhSDvLRbzapjZPdlmL/G4YwLJX5kc1FB6hHXvT3b7fHfbf1
         sxThLtlYFTLTHOcqRoAJBMTK0aedXgR+YF/VElUOkFdrtJIxwpvhP6WLiAIsFUQZcA
         l47Ymp8jzLAlkJuXb+0x1fIzwLYFBfODSGWXBX5c=
Date:   Mon, 08 Mar 2021 12:01:54 -0800
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org
Subject:  +
 =?US-ASCII?Q?hugetlb=5Fcgroup-remove-unnecessary-vm=5Fbug=5Fon=5Fpage-in-?=
 =?US-ASCII?Q?hugetlb=5Fcgroup=5Fmigrate.patch?= added to -mm tree
Message-ID: <20210308200154.AIzgw2fZZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb_cgroup: remove unnecessary VM_BUG_ON_PAGE in hugetlb_cgroup_migrate()
has been added to the -mm tree.  Its filename is
     hugetlb_cgroup-remove-unnecessary-vm_bug_on_page-in-hugetlb_cgroup_migrate.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlb_cgroup-remove-unnecessary-vm_bug_on_page-in-hugetlb_cgroup_migrate.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlb_cgroup-remove-unnecessary-vm_bug_on_page-in-hugetlb_cgroup_migrate.patch

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
Subject: mm/hugetlb_cgroup: remove unnecessary VM_BUG_ON_PAGE in hugetlb_cgroup_migrate()

!PageHuge(oldhpage) is implicitly checked in page_hstate() above, so we
remove this explicit one.

Link: https://lkml.kernel.org/r/20210308112809.26107-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cgroup.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/hugetlb_cgroup.c~hugetlb_cgroup-remove-unnecessary-vm_bug_on_page-in-hugetlb_cgroup_migrate
+++ a/mm/hugetlb_cgroup.c
@@ -785,7 +785,6 @@ void hugetlb_cgroup_migrate(struct page
 	if (hugetlb_cgroup_disabled())
 		return;
 
-	VM_BUG_ON_PAGE(!PageHuge(oldhpage), oldhpage);
 	spin_lock(&hugetlb_lock);
 	h_cg = hugetlb_cgroup_from_page(oldhpage);
 	h_cg_rsvd = hugetlb_cgroup_from_page_rsvd(oldhpage);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

hugetlb_cgroup-fix-imbalanced-css_get-and-css_put-pair-for-shared-mappings.patch
mm-hugetlb-remove-redundant-reservation-check-condition-in-alloc_huge_page.patch
mm-hugetlb-use-some-helper-functions-to-cleanup-code.patch
mm-hugetlb-optimize-the-surplus-state-transfer-code-in-move_hugetlb_state.patch
hugetlb_cgroup-remove-unnecessary-vm_bug_on_page-in-hugetlb_cgroup_migrate.patch
mm-hugetlb-simplify-the-code-when-alloc_huge_page-failed-in-hugetlb_no_page.patch
mm-hugetlb-avoid-calculating-fault_mutex_hash-in-truncate_op-case.patch

