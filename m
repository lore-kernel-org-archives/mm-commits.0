Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5B49C43461
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:34:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9749361413
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:34:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbhEEBf0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:35:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:38352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231650AbhEEBf0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:35:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E1A76140E;
        Wed,  5 May 2021 01:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178470;
        bh=2PVJH+tCcuvyw7GdSOiMfFckG+YmcleKix3nAa7cTYA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=e2MNyjDVNY8z34+OyIqE/u45olAuweUiv83QjZ2UL6pOtfmWE9BPApFdWYXFi8qqo
         Ne5paooFczx1XRtVxN9sJ4BZqPpauXggZmM+MWin2pHlOAezoeW/Rd7dFiiuTa9zzd
         y5V3fVvb3371A59GKHz5F1qeEHpW0y1CqBO6wwDg=
Date:   Tue, 04 May 2021 18:34:30 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linfeilong@huawei.com,
        linmiaohe@huawei.com, linux-mm@kvack.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 034/143] mm/hugeltb: remove redundant VM_BUG_ON()
 in region_add()
Message-ID: <20210505013430.VjLI5oWMk%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hugeltb: remove redundant VM_BUG_ON() in region_add()

Patch series "Cleanup and fixup for hugetlb", v2.

This series contains cleanups to remove redundant VM_BUG_ON() and simplify
the return code.  Also this handles the error case in
hugetlb_fix_reserve_counts() correctly.  More details can be found in the
respective changelogs.


This patch (of 5):

The same VM_BUG_ON() check is already done in the callee.  Remove this
extra one to simplify the code slightly.

Link: https://lkml.kernel.org/r/20210410072348.20437-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20210410072348.20437-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Feilong Lin <linfeilong@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugeltb-remove-redundant-vm_bug_on-in-region_add
+++ a/mm/hugetlb.c
@@ -553,7 +553,6 @@ retry:
 	resv->adds_in_progress -= in_regions_needed;
 
 	spin_unlock(&resv->lock);
-	VM_BUG_ON(add < 0);
 	return add;
 }
 
_
