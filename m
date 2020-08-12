Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7456AC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:32:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54D26207F7
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597195949;
	bh=Sp738s1Tx2xuGa6veOeLR33fodxaKZIR+r8U/n4OTO8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=yQ9GjuGIq/XvwkPVRomgA/3MgiB3cwzwCI/5e0RzrW2Dsn16S2P0AFPSPgvaiiyS8
	 3bPYBNR6PEv5UYc9dZeVLsuC7MkNFbS2BEBGoce11jndAj+NNDobfHvX+HWo3TRFGF
	 RNUDUefKMCqx/Ah5fIVO/3SJKGi6hyFmk9gOVmyI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbgHLBc3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:32:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:60926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726761AbgHLBc3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:32:29 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 133002076C;
        Wed, 12 Aug 2020 01:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597195948;
        bh=Sp738s1Tx2xuGa6veOeLR33fodxaKZIR+r8U/n4OTO8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=xCrgfUwopthF1cpHp8Y5H5px4+d5I5tkOV7CkE6JB3TH/YRaia302MN8GSh5aboAT
         N4qtqyzjmOafT2kamXuSv85x9IVyTGR+OgCTY6PT2ip8oPrnlvpBY2BusYbaUOMd+X
         EWGTpS9hgT0ZBCJ/9Uc27nUQuhnVuN20sj+0vZm8=
Date:   Tue, 11 Aug 2020 18:32:27 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        sjpark@amazon.de, torvalds@linux-foundation.org
Subject:  [patch 041/165] mm: drop duplicated words in
 <linux/pgtable.h>
Message-ID: <20200812013227.sPMNhiKNc%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm: drop duplicated words in <linux/pgtable.h>

Drop the doubled words "used" and "by".

Drop the repeated acronym "TLB" and make several other fixes around it.
(capital letters, spellos)

Link: http://lkml.kernel.org/r/2bb6e13e-44df-4920-52d9-4d3539945f73@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: SeongJae Park <sjpark@amazon.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/include/linux/pgtable.h~mm-drop-duplicated-words-in-linux-pgtableh
+++ a/include/linux/pgtable.h
@@ -804,7 +804,7 @@ static inline void ptep_modify_prot_comm
 
 /*
  * No-op macros that just return the current protection value. Defined here
- * because these macros can be used used even if CONFIG_MMU is not defined.
+ * because these macros can be used even if CONFIG_MMU is not defined.
  */
 
 #ifndef pgprot_nx
@@ -1234,7 +1234,7 @@ static inline int pmd_trans_unstable(pmd
  * Technically a PTE can be PROTNONE even when not doing NUMA balancing but
  * the only case the kernel cares is for NUMA balancing and is only ever set
  * when the VMA is accessible. For PROT_NONE VMAs, the PTEs are not marked
- * _PAGE_PROTNONE so by by default, implement the helper as "always no". It
+ * _PAGE_PROTNONE so by default, implement the helper as "always no". It
  * is the responsibility of the caller to distinguish between PROT_NONE
  * protections and NUMA hinting fault protections.
  */
@@ -1318,10 +1318,10 @@ static inline int pmd_free_pte_page(pmd_
 /*
  * ARCHes with special requirements for evicting THP backing TLB entries can
  * implement this. Otherwise also, it can help optimize normal TLB flush in
- * THP regime. stock flush_tlb_range() typically has optimization to nuke the
- * entire TLB TLB if flush span is greater than a threshold, which will
- * likely be true for a single huge page. Thus a single thp flush will
- * invalidate the entire TLB which is not desitable.
+ * THP regime. Stock flush_tlb_range() typically has optimization to nuke the
+ * entire TLB if flush span is greater than a threshold, which will
+ * likely be true for a single huge page. Thus a single THP flush will
+ * invalidate the entire TLB which is not desirable.
  * e.g. see arch/arc: flush_pmd_tlb_range
  */
 #define flush_pmd_tlb_range(vma, addr, end)	flush_tlb_range(vma, addr, end)
_
