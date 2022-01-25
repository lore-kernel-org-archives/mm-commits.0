Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B59C1C5AC75
	for <mm-commits@archiver.kernel.org>; Tue, 25 Jan 2022 23:33:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234839AbiAYXdn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Jan 2022 18:33:43 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44532 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234842AbiAYXdc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jan 2022 18:33:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5607861324
        for <mm-commits@vger.kernel.org>; Tue, 25 Jan 2022 23:33:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1690C340E0;
        Tue, 25 Jan 2022 23:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643153611;
        bh=sZRCgbAlXWGvZDAwFFhwZRvZZJ30uw2EJsGoz5mHBBw=;
        h=Date:From:To:Subject:From;
        b=Mdrwjfg7eQp2YXr5sISZYUiRI/xor/D2yCEDvqKBRfXVv35qU1tkmt/SuEyDLDAXD
         xxG9TZjVjLOQuQO7qC+HeYm+7I/JC7oKJ80Tj7VzNJ9gYLN9/xwpOp+qlhRVZDsInd
         2qNGSmvhuPHkW+KKso8WJhsDgwai4JRKnp0ICD0Q=
Date:   Tue, 25 Jan 2022 15:33:31 -0800
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        songmuchun@bytedance.com
Subject:  + mm-hmmc-remove-unneeded-local-variable-ret.patch added
 to -mm tree
Message-ID: <20220125233331.PoeEWeyWr%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hmm.c: remove unneeded local variable ret
has been added to the -mm tree.  Its filename is
     mm-hmmc-remove-unneeded-local-variable-ret.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hmmc-remove-unneeded-local-variable-ret.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hmmc-remove-unneeded-local-variable-ret.patch

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

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-vmalloc-remove-unneeded-function-forward-declaration.patch
mm-balloon_compaction-make-balloon-page-compaction-callbacks-static.patch
mm-hmmc-remove-unneeded-local-variable-ret.patch

