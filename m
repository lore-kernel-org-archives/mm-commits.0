Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F216FC433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:56:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B95CD2223F
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633386;
	bh=d8BQPaSUXgf3rZB71+wUc88+dC2x10P0iaOpNftvqUw=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=h5/0STy+XGLy5H6BBhOPcmR9MKMSMJNSzBPNcs1Zgw5jUZ4JnZYA1tR43J3g+Wp/r
	 ecLTganwfz/Es0c8r3YYUCPRDexxI/XzMYcrHPmXr+rqawhCgwp85lLaQl2Eix9JH2
	 Yp0Zd4nVi5iVMgb/LY9g37kfk0yRogDP8Mn0wiS4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388681AbgJMX40 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:56:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:42066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387742AbgJMX40 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:56:26 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5151E2222F;
        Tue, 13 Oct 2020 23:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633384;
        bh=d8BQPaSUXgf3rZB71+wUc88+dC2x10P0iaOpNftvqUw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=SChWUI+PJQLrKYlbXtQB/RaBbCGKwaPe6LUkS36ImZCpEzAKYLh6+BC9R4zGYJcCM
         OeM0Fx17n0n5Yyj999AXeli+p4E0q6mXeoMCFAGkatGM3KQtVhlolCRc6TN5h/QWyj
         8gm+nz9mccDPCSbiaQfCKMfsqbAzY2MYvFqK4GGQ=
Date:   Tue, 13 Oct 2020 16:56:23 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bhe@redhat.com, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        richard.weiyang@linux.alibaba.com, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject:  [patch 145/181] mm/hugetlb: remove VM_BUG_ON(!nrg) in
 get_file_region_entry_from_cache()
Message-ID: <20201013235623.P9Xo2utZl%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Wei Yang <richard.weiyang@linux.alibaba.com>
Subject: mm/hugetlb: remove VM_BUG_ON(!nrg) in get_file_region_entry_from_cache()

We are sure to get a valid file_region, otherwise the
VM_BUG_ON(resv->region_cache_count <= 0) at the very beginning would be
triggered.

Let's remove the redundant one.

Link: https://lkml.kernel.org/r/20200831022351.20916-3-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-remove-vm_bug_onnrg-in-get_file_region_entry_from_cache
+++ a/mm/hugetlb.c
@@ -240,7 +240,6 @@ get_file_region_entry_from_cache(struct
 
 	resv->region_cache_count--;
 	nrg = list_first_entry(&resv->region_cache, struct file_region, link);
-	VM_BUG_ON(!nrg);
 	list_del(&nrg->link);
 
 	nrg->from = from;
_
