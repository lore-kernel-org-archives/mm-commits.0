Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09C30C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 19:20:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D46B62080C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 19:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597260023;
	bh=RDeq4lxGcUYE7ptzbyS/Ut0eRYXn0PP8t1xbqdDbeKA=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=wVv0Kf5yj+eVO0YEWpoT6WEi+vAU1RXkK7m3bsb4fiGCgHrvRNf1Bvj+mwEuRcX0K
	 QYPJQopj3/jFCOfZxT6ZnQHSTS+S8Ml80kVT/phhxuispIx8UMhzJWFlmFfijT8wJ9
	 2WhUgbmqZHGTsEZ9UpV3FYeKhTwPR4epPHUulHZY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbgHLTUX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 15:20:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:58118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726512AbgHLTUX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 15:20:23 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA989206DA;
        Wed, 12 Aug 2020 19:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597260022;
        bh=RDeq4lxGcUYE7ptzbyS/Ut0eRYXn0PP8t1xbqdDbeKA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=UeW5q/0AXXparHDUqaW9jdM4RNJWs0KqPQRAbngH6aUTlqRnAVBBAM4GsGaJcNGbd
         BYpWuosXOAjYizaqFju7OLKWTInq9y/3pdp2IGT2xmTQjEeSi92Io2n6Dx0ziM1LtN
         0w58SOnD7XNtdbjH5gaVPxyz3UxWsHJ4C2ZV3CB4=
Date:   Wed, 12 Aug 2020 12:20:22 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     lkp@intel.com, mm-commits@vger.kernel.org, rppt@linux.ibm.com
Subject:  +
 asm-generic-pgalloch-use-correct-ifdef-to-enable-pud_alloc_one.patch added
 to -mm tree
Message-ID: <20200812192022.9lIC3x3KL%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: asm-generic: pgalloc.h: use correct #ifdef to enable pud_alloc_one()
has been added to the -mm tree.  Its filename is
     asm-generic-pgalloch-use-correct-ifdef-to-enable-pud_alloc_one.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/asm-generic-pgalloch-use-correct-ifdef-to-enable-pud_alloc_one.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/asm-generic-pgalloch-use-correct-ifdef-to-enable-pud_alloc_one.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

asm-generic-pgalloch-use-correct-ifdef-to-enable-pud_alloc_one.patch

