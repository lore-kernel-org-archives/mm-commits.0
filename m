Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D60C1C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:08:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93C8264F09
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:08:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234917AbhBXUIF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:08:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:56272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235287AbhBXUHZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:07:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B16764E60;
        Wed, 24 Feb 2021 20:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197226;
        bh=U1XGcjm1zL4VDArObARHXrQYuQHUmmj/NdRZmLmtHbA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=MWk1jijJ/85bjsjdSUeR0RYLYUpw9Gu06BeEbQHI94ruVpkkPSszUEzfSAIL+7tKv
         zanTGZBk0+w2SFhcrNBXrFIP61wxNfwxSG81jeA98L57yOX8R5kXMzuSt9RfbKpDsF
         wGo4W8AqQuiUBb00wy4WZhjwYfQNx+pAKbkbWxEw=
Date:   Wed, 24 Feb 2021 12:07:05 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        linux-mm@kvack.org, louhongxiang@huawei.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 117/173] mm/hugetlb: fix use after free when
 subpool max_hpages accounting is not enabled
Message-ID: <20210224200705.o8J0hqp8s%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hugetlb: fix use after free when subpool max_hpages accounting is not enabled

If a hugetlbfs filesystem is created with the min_size option and
without the size option, used_hpages is always 0 and might lead to
release subpool prematurely because it indicates no pages are used now
while there might be.

In order to fix this issue, we should check used_hpages == 0 iff
max_hpages accounting is enabled.  As max_hpages accounting should be
enabled in most common case, this is not worth a Cc stable.

[mike.kravetz@oracle.com: new changelog]
Link: https://lkml.kernel.org/r/20210126115510.53374-1-linmiaohe@huawei.com
Signed-off-by: Hongxiang Lou <louhongxiang@huawei.com>
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-use-after-free-when-subpool-max_hpages-accounting-is-not-enabled
+++ a/mm/hugetlb.c
@@ -97,16 +97,26 @@ static inline void ClearPageHugeFreed(st
 /* Forward declaration */
 static int hugetlb_acct_memory(struct hstate *h, long delta);
 
-static inline void unlock_or_release_subpool(struct hugepage_subpool *spool)
+static inline bool subpool_is_free(struct hugepage_subpool *spool)
 {
-	bool free = (spool->count == 0) && (spool->used_hpages == 0);
+	if (spool->count)
+		return false;
+	if (spool->max_hpages != -1)
+		return spool->used_hpages == 0;
+	if (spool->min_hpages != -1)
+		return spool->rsv_hpages == spool->min_hpages;
+
+	return true;
+}
 
+static inline void unlock_or_release_subpool(struct hugepage_subpool *spool)
+{
 	spin_unlock(&spool->lock);
 
 	/* If no pages are used, and no other handles to the subpool
 	 * remain, give up any reservations based on minimum size and
 	 * free the subpool */
-	if (free) {
+	if (subpool_is_free(spool)) {
 		if (spool->min_hpages != -1)
 			hugetlb_acct_memory(spool->hstate,
 						-spool->min_hpages);
_
