Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23C9FC433DF
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:53:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D502022202
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633223;
	bh=r3a9eWIr6TpZzwob5vP0vQbcITkkDtlWSLTouVblxdw=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=qbJc8w9rdtUEwcr16nEaH70EetYEsj2TzWahbi2pYZiQS4RIdwqLEl5hUhbquTcm7
	 G4Z3XFx2xVbEm7gdRe17BV7Dg+amawmmPYqmXegYHnPsa66UZfGnAHbRUOYXnkYDFS
	 n/7UY9SpQKgahl+ek3BvxqklZ7yh4xkaA/lZRv4o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729746AbgJMXxn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:53:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:38570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387433AbgJMXxa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:53:30 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 353AB21D7B;
        Tue, 13 Oct 2020 23:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633210;
        bh=r3a9eWIr6TpZzwob5vP0vQbcITkkDtlWSLTouVblxdw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=H0XxrXjTWN+MfAbhVcNqfE5ObNpUusV/830vOoifN57ah9HZZ4qEJY1LyhI1CK52u
         Vr7DUrElFJql4tC8vNwQ9G/+TLp0Eb26CFe9UOtEA1aeJl/3d70dyJA2s64Fupkz1M
         UJwrsjLhm7vpSTEbXgsVjlP0egdsJShZU9VaGZq0=
Date:   Tue, 13 Oct 2020 16:53:29 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        willy@infradead.org, yanfei.xu@windriver.com
Subject:  [patch 094/181] mm/memory.c: replace vmf->vma with
 variable vma
Message-ID: <20201013235329.17-Y0o_vq%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yanfei Xu <yanfei.xu@windriver.com>
Subject: mm/memory.c: replace vmf->vma with variable vma

The code has declared a vma_struct named vma which is assigned a value of
vmf->vma.  Thus, use variable vma directly here.

Link: http://lkml.kernel.org/r/20200818084607.37616-1-yanfei.xu@windriver.com
Signed-off-by: Yanfei Xu <yanfei.xu@windriver.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-memoryc-replace-vmf-vma-with-variable-vma
+++ a/mm/memory.c
@@ -3597,7 +3597,7 @@ static vm_fault_t __do_fault(struct vm_f
 	 *				# flush A, B to clear the writeback
 	 */
 	if (pmd_none(*vmf->pmd) && !vmf->prealloc_pte) {
-		vmf->prealloc_pte = pte_alloc_one(vmf->vma->vm_mm);
+		vmf->prealloc_pte = pte_alloc_one(vma->vm_mm);
 		if (!vmf->prealloc_pte)
 			return VM_FAULT_OOM;
 		smp_wmb(); /* See comment in __pte_alloc() */
_
