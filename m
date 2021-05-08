Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94777C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:46:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B1416101D
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:46:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbhEHWre (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:47:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:58572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229602AbhEHWrc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:47:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8252661421;
        Sat,  8 May 2021 22:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513990;
        bh=ZvaU+bm8MNANRlZdjvpc6qnTqGikBtHHcDAIkISGymc=;
        h=Date:From:To:Subject:From;
        b=0uYCF7SzSbe/amwiU2XXLGrXNZC/NXRcVTj7XpSXF/bp3m5r/MTVwJsK2Uzj29mK9
         FJL+XOx7RfV89CqXeOKnYPjr33aAokbqeoXQGLeSxDSmJrw10AwcZMnovTkPpr2Quf
         rceRUv4rT5/5Os56MitBITqP2eu6dNV02v7j8mdI=
Date:   Sat, 08 May 2021 15:46:30 -0700
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 =?US-ASCII?Q?mm-hugetlb-optimize-the-surplus-state-transfer-code-in-move?=
 =?US-ASCII?Q?=5Fhugetlb=5Fstate.patch?= removed from -mm tree
Message-ID: <20210508224630.yfDoBrbDh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: optimize the surplus state transfer code in move_hugetlb_state()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-optimize-the-surplus-state-transfer-code-in-move_hugetlb_state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -5682,6 +5682,12 @@ void move_hugetlb_state(struct page *old
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


