Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3892C43381
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:08:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F41364F2C
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:08:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235369AbhBXUIk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:08:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:59436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234995AbhBXUH6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:07:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5040264F29;
        Wed, 24 Feb 2021 20:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197260;
        bh=mEtSQa/cE/LWdEp2XFe1XgeBpvKg8seZ00QYZRH2M2Q=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=H1ZOjJUlA16UgOzwt+Rmz04pwzmiox49nQilfujR4/9gvl5Y9JerH081UDSy5Omo1
         n51ie4GzeCpWwQMVchyx+vM2NDZaW29AbLaSHbKN060q7kwn3HBxzxWtrawdYqYnpe
         lxnpIm8xupDWxckB8HpKxDt+B5U6wAOOexMa5E3g=
Date:   Wed, 24 Feb 2021 12:07:39 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        linux-mm@kvack.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 127/173] mm/hugetlb: use helper function
 range_in_vma() in page_table_shareable()
Message-ID: <20210224200739.v_LULY55m%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hugetlb: use helper function range_in_vma() in page_table_shareable()

We could use helper function range_in_vma() to check whether the vma is in
the desired range to simplify the code.

Link: https://lkml.kernel.org/r/20210204112949.43051-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-use-helper-function-range_in_vma-in-page_table_shareable
+++ a/mm/hugetlb.c
@@ -5282,7 +5282,7 @@ static unsigned long page_table_shareabl
 	 */
 	if (pmd_index(addr) != pmd_index(saddr) ||
 	    vm_flags != svm_flags ||
-	    sbase < svma->vm_start || svma->vm_end < s_end)
+	    !range_in_vma(svma, sbase, s_end))
 		return 0;
 
 	return saddr;
_
