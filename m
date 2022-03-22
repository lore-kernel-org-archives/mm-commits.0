Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FD46C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:48:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236727AbiCVVuB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236764AbiCVVuA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:50:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F344C2DC
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:48:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98BFAB81DC3
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:48:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 257E0C340EC;
        Tue, 22 Mar 2022 21:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985709;
        bh=uRITHZf8d6O7W32n304m1vz3dms6bCgyqp7pO2fMBr8=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=mDavlmCmh1Fq0DkQpofy2B+33lTcPhonwJgxzWAVXLWvjZG7FVhtuLfpZB1RKW982
         3IFKBkMhZgw21ltkQLiNn4ya3A1xAl6SrUki1fAzhZp0s0WfXgNJ7yoa0+g/q/6OE4
         2azALnnQtNam1lQ1jWrD1epj2T1sEyBnQ02C2mEc=
Date:   Tue, 22 Mar 2022 14:48:28 -0700
To:     songmuchun@bytedance.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 196/227] mm/hmm.c: remove unneeded local variable ret
Message-Id: <20220322214829.257E0C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hmm.c: remove unneeded local variable ret

The local variable ret is always 0. Remove it to make code more tight.

Link: https://lkml.kernel.org/r/20220125124833.39718-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hmm.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/hmm.c~mm-hmmc-remove-unneeded-local-variable-ret
+++ a/mm/hmm.c
@@ -417,7 +417,6 @@ static int hmm_vma_walk_pud(pud_t *pudp,
 	struct hmm_range *range = hmm_vma_walk->range;
 	unsigned long addr = start;
 	pud_t pud;
-	int ret = 0;
 	spinlock_t *ptl = pud_trans_huge_lock(pudp, walk->vma);
 
 	if (!ptl)
@@ -466,7 +465,7 @@ static int hmm_vma_walk_pud(pud_t *pudp,
 
 out_unlock:
 	spin_unlock(ptl);
-	return ret;
+	return 0;
 }
 #else
 #define hmm_vma_walk_pud	NULL
_
