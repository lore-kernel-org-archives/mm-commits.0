Return-Path: <SRS0=YRC/=A3=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C015C433FB
	for <mm-commits@archiver.kernel.org>; Thu, 16 Jul 2020 23:10:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF26220870
	for <mm-commits@archiver.kernel.org>; Thu, 16 Jul 2020 23:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594941022;
	bh=hqCAxrm26TLvise9a0JVMoBZjYNy8X2fcdVGpJJBNfU=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=T28qu3cL0JDArEpPwS5cDY5iUBv0csVCCaTGRcQO26qgUK0cSXSaNlByxqMq5f/wy
	 1FL18gCs/wGf4Fj22d+mdns0cONHaKTn0sGxIVq7p8t5gI6RAsvaIpNAmgP0VKR9Pm
	 Kbe/jDLICL+zCPs/4JKu2pFBHcBcUos0xuixB1Zg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728212AbgGPXKV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jul 2020 19:10:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:55064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727951AbgGPXKS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 16 Jul 2020 19:10:18 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E4B6208FE;
        Thu, 16 Jul 2020 22:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594939900;
        bh=hqCAxrm26TLvise9a0JVMoBZjYNy8X2fcdVGpJJBNfU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=rv20CmjecUJsjAm72sfXIco35zHfMQtC62B0TsYjfFihn/HGgZPUfpygyuvHdjjsT
         Jwt/jAbyKgej3aOTGFhWOPV9vL5fQME4w3/Fmh9nXxOCE++Sv2xrfBcWUthGGPGrwv
         Oz1CyiVPfxcDw2ERTuLrSUKn27vJri4O2VhjeU54=
Date:   Thu, 16 Jul 2020 15:51:40 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org, sjpark@amazon.de
Subject:  + mm-drop-duplicated-words-in-linux-pgtableh.patch added
 to -mm tree
Message-ID: <20200716225140.F6Jul7CzI%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: drop duplicated words in <linux/pgtable.h>
has been added to the -mm tree.  Its filename is
     mm-drop-duplicated-words-in-linux-pgtableh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-drop-duplicated-words-in-linux-pgtableh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-drop-duplicated-words-in-linux-pgtableh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -838,7 +838,7 @@ static inline void ptep_modify_prot_comm
 
 /*
  * No-op macros that just return the current protection value. Defined here
- * because these macros can be used used even if CONFIG_MMU is not defined.
+ * because these macros can be used even if CONFIG_MMU is not defined.
  */
 #ifndef pgprot_encrypted
 #define pgprot_encrypted(prot)	(prot)
@@ -1231,7 +1231,7 @@ static inline int pmd_trans_unstable(pmd
  * Technically a PTE can be PROTNONE even when not doing NUMA balancing but
  * the only case the kernel cares is for NUMA balancing and is only ever set
  * when the VMA is accessible. For PROT_NONE VMAs, the PTEs are not marked
- * _PAGE_PROTNONE so by by default, implement the helper as "always no". It
+ * _PAGE_PROTNONE so by default, implement the helper as "always no". It
  * is the responsibility of the caller to distinguish between PROT_NONE
  * protections and NUMA hinting fault protections.
  */
@@ -1315,10 +1315,10 @@ static inline int pmd_free_pte_page(pmd_
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

Patches currently in -mm which might be from rdunlap@infradead.org are

linux-sched-mmh-drop-duplicated-words-in-comments.patch
mm-drop-duplicated-words-in-linux-pgtableh.patch

