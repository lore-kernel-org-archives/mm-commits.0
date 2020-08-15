Return-Path: <SRS0=U74d=BZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA3D7C433E1
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 22:13:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D80F2063A
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 22:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597529584;
	bh=E7fw8tCpk6T7/+SCegpwA8nehBcjVROtnx8FLOgafMk=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=XyA9yhkV2qK4ThTPjZVVeIfoLCn/yhtKStCVrxoSMWa6Qj9lIiJut9k9oS4e0Ghkq
	 BoBB1J04M8KVz6BmW9OlA+u1DZr1s85dQXFiytTCq6Qej9/kvqj31+98ucpXne102/
	 iM7uq6lCGBw+OzgtvajuyLajMEm5sWffJvfTIPpo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729387AbgHOWNA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 15 Aug 2020 18:13:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:41780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728889AbgHOWK1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 15 Aug 2020 18:10:27 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24F8420838;
        Sat, 15 Aug 2020 00:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597451405;
        bh=E7fw8tCpk6T7/+SCegpwA8nehBcjVROtnx8FLOgafMk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=2N7gSHdWpsWrCtJmlzRbi34KBSVFspmGfArimhP5NlOAmBEtAyG0KQvzD19I0PmzB
         cvc8e/UbDZblSLFiF8gH7dfUG+O72kJwMSfRg1wts6+hJ1/YivTVpha2KydOT01bmb
         ipd8zePAD08uMlBbZXQNQKem5LYgdMQ5FKQ0co+Y=
Date:   Fri, 14 Aug 2020 17:30:04 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org, lkp@intel.com,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        torvalds@linux-foundation.org
Subject:  [patch 01/39] asm-generic: pgalloc.h: use correct #ifdef
 to enable pud_alloc_one()
Message-ID: <20200815003004.mp-mW9op5%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
