Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9139BC6FA82
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:51:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbiI0Cvq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:51:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbiI0Ctl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:49:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E9CDF193C
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:49:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE5E4B81903
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:48:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63B78C433D7;
        Tue, 27 Sep 2022 02:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246938;
        bh=yMo7okV3J/koasG/vNVWRkjkLsVV7zr0I+9dQA2/UfI=;
        h=Date:To:From:Subject:From;
        b=tX68vIPNwzbqlIAaahgiamL9e8gRt/2OIv3AKvNC4Nts0O+d6CMG+CRIFZzd+bmL5
         CL8HvzklyHxIS79Yto5Ku2j9acBfb/1wa89UyPwy08e9pPg9V6udNnSIOdhJfBECHp
         vxEzXVlMpM2j46DCEgtjwOAjItX2iQWk1UJcZcwI=
Date:   Mon, 26 Sep 2022 19:48:57 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        will@kernel.org, vbabka@suse.cz, svens@linux.ibm.com,
        sj@kernel.org, dhowells@redhat.com, david@redhat.com,
        dave@stgolabs.net, catalin.marinas@arm.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-optimize-find_exact_vma-to-use-vma_lookup.patch removed from -mm tree
Message-Id: <20220927024858.63B78C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: optimize find_exact_vma() to use vma_lookup()
has been removed from the -mm tree.  Its filename was
     mm-optimize-find_exact_vma-to-use-vma_lookup.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm: optimize find_exact_vma() to use vma_lookup()
Date: Tue, 6 Sep 2022 19:48:49 +0000

Use vma_lookup() to walk the tree to the start value requested.  If the
vma at the start does not match, then the answer is NULL and there is no
need to look at the next vma the way that find_vma() would.

Link: https://lkml.kernel.org/r/20220906194824.2110408-21-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Yu Zhao <yuzhao@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mm.h~mm-optimize-find_exact_vma-to-use-vma_lookup
+++ a/include/linux/mm.h
@@ -2850,7 +2850,7 @@ static inline unsigned long vma_pages(st
 static inline struct vm_area_struct *find_exact_vma(struct mm_struct *mm,
 				unsigned long vm_start, unsigned long vm_end)
 {
-	struct vm_area_struct *vma = find_vma(mm, vm_start);
+	struct vm_area_struct *vma = vma_lookup(mm, vm_start);
 
 	if (vma && (vma->vm_start != vm_start || vma->vm_end != vm_end))
 		vma = NULL;
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


