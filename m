Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 376B6C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:47:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E496B20897
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816422;
	bh=Mxd1Ax7SjAVTOHSwLcrllBgVXMiyjzZTjRuukJa9wo0=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=IhIBuyWyDnh3mcl+1qSXqbnlj9ASpCGMJia2wk0tCAMfL3JzwgNi6lN/qyRyu5lZH
	 g2mKkXbxuWOhCx1wPxdFIcvXeopX1cS9XEDbPuJAPEq7f8dzEBMvVqYQcYaqqPRvIr
	 DIQ0WQWNBkGDeorE8TV12UN8SaxJ58kmSz934gkk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393916AbgJPCrB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:47:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:34656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393913AbgJPCrB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:47:01 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B41F208E4;
        Fri, 16 Oct 2020 02:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816420;
        bh=Mxd1Ax7SjAVTOHSwLcrllBgVXMiyjzZTjRuukJa9wo0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=blMVmuetoS9B3cqCUUvKMbzmj7nfkbv90ySyhllX2fcfsMEsJe0NOzCFTlyKvhN+q
         uZ0mNdVxW8Q5OrOunsDL4bhifrRAwIBkqzFNvkP5f1D+w+rrhDXXCzpjyC6wYV9TJZ
         M+AF3RXD9s4Dfe+edAvct5z30ek1Wrj5RUk4WkWM=
Date:   Thu, 15 Oct 2020 19:47:00 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, tanxiaofei@huawei.com,
        torvalds@linux-foundation.org
Subject:  [patch 091/156] mm/workingset.c: fix some doc warnings
Message-ID: <20201016024700.GIGWk_IYF%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Xiaofei Tan <tanxiaofei@huawei.com>
Subject: mm/workingset.c: fix some doc warnings

Fix following warnings caused by mismatch bewteen function parameters and
comments.

mm/workingset.c:228: warning: Function parameter or member 'lruvec' not described in 'workingset_age_nonresident'
mm/workingset.c:228: warning: Excess function parameter 'memcg' description in 'workingset_age_nonresident'

Link: https://lkml.kernel.org/r/1600485913-11192-1-git-send-email-tanxiaofei@huawei.com
Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/workingset.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/workingset.c~mm-fix-some-doc-warnings-in-workingsetc
+++ a/mm/workingset.c
@@ -216,7 +216,7 @@ static void unpack_shadow(void *shadow,
 
 /**
  * workingset_age_nonresident - age non-resident entries as LRU ages
- * @memcg: the lruvec that was aged
+ * @lruvec: the lruvec that was aged
  * @nr_pages: the number of pages to count
  *
  * As in-memory pages are aged, non-resident pages need to be aged as
_
