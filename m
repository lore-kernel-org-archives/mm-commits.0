Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 565C6C433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:24:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33BAF22CAF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781463;
	bh=I67SOxd+0NxxmWFXayESQbfiJLykcDAXVnSVai/VMLU=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=VzLJyT4iL+IdgkjMxgwalWodlzpoU82bhY9eoIIXs5upvILZJJl/k0sYof2KSFPCl
	 qc/Ns9NqTiIgDm4VRT8ws+Fhj6ODxk2qez6DvnNFH9nADw0Ck/D2VdtExSK9ffKmOC
	 lb4KNIE2vbP2uoo2OKh57hHMD0eEQG6bQPD9oObU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgHGGYW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:24:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:33256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbgHGGYW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:24:22 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20FD122CAE;
        Fri,  7 Aug 2020 06:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781462;
        bh=I67SOxd+0NxxmWFXayESQbfiJLykcDAXVnSVai/VMLU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ZUHYIeM/0MkNvjktg6cOEJ4j2jHc345IHGHYGf+gPz1PCKqvy07D0mSRdkZJZyEnt
         ZabU4FowqjdQd69Fbvb7mXcm6p28VocTtzbfm+4FLLmysAkUSVQd6dVIssz28CXjns
         pCG5++F5jXb0R4wDGGTAGVWlsf7EKVyxeSQPHZR0=
Date:   Thu, 06 Aug 2020 23:24:21 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, jroedel@suse.de,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        torvalds@linux-foundation.org
Subject:  [patch 126/163] mm: vmalloc: remove redundant assignment
 in unmap_kernel_range_noflush()
Message-ID: <20200807062421.fL9YXbo6M%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>
Subject: mm: vmalloc: remove redundant assignment in unmap_kernel_range_noflush()

'addr' is set to 'start' and then a few lines afterwards 'start' is set to
'addr'.  Remove the second asignment.

Link: http://lkml.kernel.org/r/20200707163226.374685-1-rppt@kernel.org
Fixes: 2ba3e6947aed ("mm/vmalloc: track which page-table levels were modified")
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-remove-redundant-asignmnet-in-unmap_kernel_range_noflush
+++ a/mm/vmalloc.c
@@ -175,7 +175,6 @@ void unmap_kernel_range_noflush(unsigned
 	pgtbl_mod_mask mask = 0;
 
 	BUG_ON(addr >= end);
-	start = addr;
 	pgd = pgd_offset_k(addr);
 	do {
 		next = pgd_addr_end(addr, end);
_
