Return-Path: <SRS0=0jXN=B4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B6BFC433DF
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 22:40:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36AD520789
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 22:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597790426;
	bh=MMx12fIwsKUJvdChcsN/LKjdtezWj4UhXUL5Zp0Jfrw=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=PAcECkhze9oAkedaZ8DqXsGXF27tJB7opgHMAH7+RNCB6FAazx4XnY/iAkZAC4V3J
	 zWR081E5ESEUzJHGMNI8yw92kkTBVHEkW7H5ROVKIIUAMBkbwxnsLT/0HmAO586r13
	 YczWsE+yFqg1gS9Wqt8eEkCdjYC6DC/xrQVPdKLM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726972AbgHRWkW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 18:40:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:49042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727041AbgHRWkJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 18:40:09 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E63620709;
        Tue, 18 Aug 2020 22:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597790409;
        bh=MMx12fIwsKUJvdChcsN/LKjdtezWj4UhXUL5Zp0Jfrw=;
        h=Date:From:To:Subject:From;
        b=pKXHFtNj3utqD2Tlg8J8aitwqGJ/eQ83GVlPbgxa5QkAZlHbPdBuLsOe1wCCP0yZ3
         dV+RRh0RUy5M3BKlwbOBtJ9vZAACn2WJ9duwDsEZ8LjTyCf+oo1NX83eltmUXfCaHY
         fHIhwuDItPkDSrXbsizZ1R3cl5YH4lJ7P6JzCujU=
Date:   Tue, 18 Aug 2020 15:40:08 -0700
From:   akpm@linux-foundation.org
To:     lkp@intel.com, mm-commits@vger.kernel.org, rppt@linux.ibm.com
Subject:  [merged]
 asm-generic-pgalloch-use-correct-ifdef-to-enable-pud_alloc_one.patch
 removed from -mm tree
Message-ID: <20200818224008.3blFxPteA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: asm-generic: pgalloc.h: use correct #ifdef to enable pud_alloc_one()
has been removed from the -mm tree.  Its filename was
     asm-generic-pgalloch-use-correct-ifdef-to-enable-pud_alloc_one.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: asm-generic: pgalloc.h: use correct #ifdef to enable pud_alloc_one()

The #ifdef statement that guards the generic version of pud_alloc_one() by
mistake used __HAVE_ARCH_PUD_FREE instead of __HAVE_ARCH_PUD_ALLOC_ONE.

Fix it.

Link: http://lkml.kernel.org/r/20200812191415.GE163101@linux.ibm.com
Fixes: d9e8b929670b ("asm-generic: pgalloc: provide generic pud_alloc_one() and pud_free_one()")
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/pgalloc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/asm-generic/pgalloc.h~asm-generic-pgalloch-use-correct-ifdef-to-enable-pud_alloc_one
+++ a/include/asm-generic/pgalloc.h
@@ -147,7 +147,7 @@ static inline void pmd_free(struct mm_st
 
 #if CONFIG_PGTABLE_LEVELS > 3
 
-#ifndef __HAVE_ARCH_PUD_FREE
+#ifndef __HAVE_ARCH_PUD_ALLOC_ONE
 /**
  * pud_alloc_one - allocate a page for PUD-level page table
  * @mm: the mm_struct of the current context
_

Patches currently in -mm which might be from rppt@linux.ibm.com are


