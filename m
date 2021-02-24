Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FC8FC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:08:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 394DD64F1B
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:08:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234905AbhBXUIS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:08:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:59764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235098AbhBXUHj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:07:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 786B564EC4;
        Wed, 24 Feb 2021 20:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197218;
        bh=KpeBFR/dGOJBi1Oh10U6eRZSUVrBkCx1AFX7PM/uvEY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=yKSHnlS+wXLplcNYbCfxIfoHXwf1k4bYdGNDebtR6+HZ//Q0EKj4zmbaxXPk8Y8qn
         pgnimL0UN378C/Tcijaxk+DlVTyhljlm/e++dNyG2LsoQipzy00kWsI5eivKEcVHcN
         fEVfUqjdEIbUksue+YfJqwk4ERKK8eyehYFdBn2c=
Date:   Wed, 24 Feb 2021 12:06:57 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        torvalds@linux-foundation.org
Subject:  [patch 115/173] mm/hugetlb: avoid unnecessary
 hugetlb_acct_memory() call
Message-ID: <20210224200657.oU6qkHah9%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hugetlb: avoid unnecessary hugetlb_acct_memory() call

When reservation accounting remains unchanged, hugetlb_acct_memory() will
do nothing except holding and releasing hugetlb_lock.  We should avoid
this unnecessary hugetlb_lock lock/unlock cycle which is happening on
'most' hugetlb munmap operations by check delta against 0 at the beginning
of hugetlb_acct_memory.

Link: https://lkml.kernel.org/r/20210115092013.61012-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/hugetlb.c~mm-hugetlb-avoid-unnecessary-hugetlb_acct_memory-call
+++ a/mm/hugetlb.c
@@ -3591,6 +3591,9 @@ static int hugetlb_acct_memory(struct hs
 {
 	int ret = -ENOMEM;
 
+	if (!delta)
+		return 0;
+
 	spin_lock(&hugetlb_lock);
 	/*
 	 * When cpuset is configured, it breaks the strict hugetlb page
_
