Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98BBBC433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:46:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 791FD61426
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:46:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbhEHWre (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:47:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:58634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229552AbhEHWre (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:47:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85C73613E8;
        Sat,  8 May 2021 22:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513992;
        bh=PFGUIhwOZAtAKZF597RVIpZKqqJk1j2k0NFGFCUlthw=;
        h=Date:From:To:Subject:From;
        b=dgvT5TSIBL1Fd38Vyx+QykOWzsCxw5aaK5czZR8OUvcz/sHz1Q5KB7kTeCXJaeE8K
         V1x4WgyafERcOzGUZREH1QmN0LnBeUrRmpZSJ60UV03+FT31JXIstGt/xochLe3ZTw
         NiHi2lcXZID3g3nJrWqWka/cvNEHBmo7jtvVIHqQ=
Date:   Sat, 08 May 2021 15:46:32 -0700
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 =?US-ASCII?Q?hugetlb=5Fcgroup-remove-unnecessary-vm=5Fbug=5Fon=5Fpage-in-?=
 =?US-ASCII?Q?hugetlb=5Fcgroup=5Fmigrate.patch?= removed from -mm tree
Message-ID: <20210508224632.u8g0LQv-v%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb_cgroup: remove unnecessary VM_BUG_ON_PAGE in hugetlb_cgroup_migrate()
has been removed from the -mm tree.  Its filename was
     hugetlb_cgroup-remove-unnecessary-vm_bug_on_page-in-hugetlb_cgroup_migrate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -784,7 +784,6 @@ void hugetlb_cgroup_migrate(struct page
 	if (hugetlb_cgroup_disabled())
 		return;
 
-	VM_BUG_ON_PAGE(!PageHuge(oldhpage), oldhpage);
 	spin_lock(&hugetlb_lock);
 	h_cg = hugetlb_cgroup_from_page(oldhpage);
 	h_cg_rsvd = hugetlb_cgroup_from_page_rsvd(oldhpage);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


