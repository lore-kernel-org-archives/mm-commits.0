Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ACBFC11F66
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:39:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7125461D0B
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:39:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbhF2Clb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:41:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:33868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231348AbhF2Cla (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:41:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4E4461D08;
        Tue, 29 Jun 2021 02:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934343;
        bh=Foq9GdnRId3c3knDGTH4yGCZm/gVS+3RIMWrCptaFmE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ywBUEak82jGCEhNqKLWzQtloRE5PeRj7xHA4p2Ra7XazO1vC2eeKsu3vbnFHW7JI+
         zeWcP7TFP1tUbjPeu6pWrwZL7a2gjldmAz7yT7+VtcY128JMRfIjkor5+jHLEBzAkQ
         7biWpUzc6eeyglN/jz8HMab5lXK/0RGd3HrjhGws=
Date:   Mon, 28 Jun 2021 19:39:02 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, dbueso@suse.de,
        geert@linux-m68k.org, ldufour@linux.ibm.com,
        Liam.Howlett@Oracle.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 109/192] arch/powerpc/kvm/book3s_hv_uvmem: use
 vma_lookup() instead of find_vma_intersection()
Message-ID: <20210629023902.WWIcVup0j%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Liam Howlett <liam.howlett@oracle.com>
Subject: arch/powerpc/kvm/book3s_hv_uvmem: use vma_lookup() instead of find_vma_intersection()

vma_lookup() finds the vma of a specific address with a cleaner interface
and is more readable.

Link: https://lkml.kernel.org/r/20210521174745.2219620-6-Liam.Howlett@Oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Laurent Dufour <ldufour@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kvm/book3s_hv_uvmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kvm/book3s_hv_uvmem.c~arch-powerpc-kvm-book3s_hv_uvmem-use-vma_lookup-instead-of-find_vma_intersection
+++ a/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -614,7 +614,7 @@ void kvmppc_uvmem_drop_pages(const struc
 
 		/* Fetch the VMA if addr is not in the latest fetched one */
 		if (!vma || addr >= vma->vm_end) {
-			vma = find_vma_intersection(kvm->mm, addr, addr+1);
+			vma = vma_lookup(kvm->mm, addr);
 			if (!vma) {
 				pr_err("Can't find VMA for gfn:0x%lx\n", gfn);
 				break;
_
