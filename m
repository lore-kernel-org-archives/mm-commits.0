Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AE4CC433E0
	for <mm-commits@archiver.kernel.org>; Mon,  8 Mar 2021 20:02:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4B28652B3
	for <mm-commits@archiver.kernel.org>; Mon,  8 Mar 2021 20:02:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbhCHUB5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Mar 2021 15:01:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:55426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231759AbhCHUBx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Mar 2021 15:01:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE8626525F;
        Mon,  8 Mar 2021 20:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615233713;
        bh=iZUc+0krDoiXoYlHfCriXJJJawSUyk1Q5FpoyV9aBhQ=;
        h=Date:From:To:Subject:From;
        b=rybfCnb8p6CNIBjqc2lpYXhdHdlmFR1Qlx/t8HPKOJWabzhHSl7ojXGtjx2S8rGGS
         +8aRmBldn6uyxdbtJ4byDj1WAt5Dxvr8AYzee58O4nI00xMO20bMhWSI3A/PktsSw0
         PpUODPA4k3/euuRsV7N7nJPs2lPEDDZVkqXe1Co8=
Date:   Mon, 08 Mar 2021 12:01:52 -0800
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org
Subject:  +
 =?US-ASCII?Q?mm-hugetlb-optimize-the-surplus-state-transfer-code-in-move?=
 =?US-ASCII?Q?=5Fhugetlb=5Fstate.patch?= added to -mm tree
Message-ID: <20210308200152.ZXDZmYU8N%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: optimize the surplus state transfer code in move_hugetlb_state()
has been added to the -mm tree.  Its filename is
     mm-hugetlb-optimize-the-surplus-state-transfer-code-in-move_hugetlb_state.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-optimize-the-surplus-state-transfer-code-in-move_hugetlb_state.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-optimize-the-surplus-state-transfer-code-in-move_hugetlb_state.patch

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
Subject: mm/hugetlb: optimize the surplus state transfer code in move_hugetlb_state()

We should not transfer the per-node surplus state when we do not cross the
node in order to save some cpu cycles

Link: https://lkml.kernel.org/r/20210308112809.26107-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/hugetlb.c~mm-hugetlb-optimize-the-surplus-state-transfer-code-in-move_hugetlb_state
+++ a/mm/hugetlb.c
@@ -5681,6 +5681,12 @@ void move_hugetlb_state(struct page *old
 		SetHPageTemporary(oldpage);
 		ClearHPageTemporary(newpage);
 
+		/*
+		 * There is no need to transfer the per-node surplus state
+		 * when we do not cross the node.
+		 */
+		if (new_nid == old_nid)
+			return;
 		spin_lock(&hugetlb_lock);
 		if (h->surplus_huge_pages_node[old_nid]) {
 			h->surplus_huge_pages_node[old_nid]--;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

hugetlb_cgroup-fix-imbalanced-css_get-and-css_put-pair-for-shared-mappings.patch
mm-hugetlb-remove-redundant-reservation-check-condition-in-alloc_huge_page.patch
mm-hugetlb-use-some-helper-functions-to-cleanup-code.patch
mm-hugetlb-optimize-the-surplus-state-transfer-code-in-move_hugetlb_state.patch
hugetlb_cgroup-remove-unnecessary-vm_bug_on_page-in-hugetlb_cgroup_migrate.patch
mm-hugetlb-simplify-the-code-when-alloc_huge_page-failed-in-hugetlb_no_page.patch
mm-hugetlb-avoid-calculating-fault_mutex_hash-in-truncate_op-case.patch

