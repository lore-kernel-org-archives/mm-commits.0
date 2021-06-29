Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B475C11F66
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:39:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2813861D0B
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:39:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231750AbhF2Clp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:41:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:34090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231706AbhF2Clp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:41:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B01AC61D0B;
        Tue, 29 Jun 2021 02:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934358;
        bh=RYlWrWyPrDRJY503V8l/8+h7P2RlKicAdyozH95/gao=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=jYJ1KHuSIs5mKLaXf9L8H2uY7q70rXq2+lkFRvhtwnjbqemAkU3/U1r1LrWxLuVqr
         s9E//qMPBjKAHsk5+kt8s/Dmyjg2jyrSVTg6qnkGzx8SZ3z1tbZXEyeS4nxPHX9fuc
         THQNADtX/tgybMRGOB01J3lj1bSjjHxBduoOt2cE=
Date:   Mon, 28 Jun 2021 19:39:17 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, dbueso@suse.de,
        geert@linux-m68k.org, ldufour@linux.ibm.com,
        Liam.Howlett@Oracle.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 114/192] virt/kvm: use vma_lookup() instead of
 find_vma_intersection()
Message-ID: <20210629023917.xrxsJ4S9Q%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Liam Howlett <liam.howlett@oracle.com>
Subject: virt/kvm: use vma_lookup() instead of find_vma_intersection()

vma_lookup() finds the vma of a specific address with a cleaner interface
and is more readable.

Link: https://lkml.kernel.org/r/20210521174745.2219620-11-Liam.Howlett@Oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Laurent Dufour <ldufour@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 virt/kvm/kvm_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/virt/kvm/kvm_main.c~virt-kvm-use-vma_lookup-instead-of-find_vma_intersection
+++ a/virt/kvm/kvm_main.c
@@ -2170,7 +2170,7 @@ static kvm_pfn_t hva_to_pfn(unsigned lon
 	}
 
 retry:
-	vma = find_vma_intersection(current->mm, addr, addr + 1);
+	vma = vma_lookup(current->mm, addr);
 
 	if (vma == NULL)
 		pfn = KVM_PFN_ERR_FAULT;
_
