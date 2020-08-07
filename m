Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A934C433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 05:54:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D46E2177B
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 05:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596779672;
	bh=H889yGLQpSokcW5LKpbXsfLQYWniBADTR17872KCoJM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=QS4UmEHGy/Ta44iw0PxQEqpQO5k48sFzxZ3rhfNCA05/b4WJpluY5naLS57ImeIEE
	 Hrie+pCxkVU+CcrpAkU8+v0Tb2Z0W6JdsUJR/VYG7GjzHbXBzLf45JB2qqOKRyLuQX
	 wkvuT1gUuPhzDdQWVT7bXK/3BuFvU9TnTbSorAC0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725805AbgHGFyb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 01:54:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:45386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGFyb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 01:54:31 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27EED21744;
        Fri,  7 Aug 2020 05:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596779671;
        bh=H889yGLQpSokcW5LKpbXsfLQYWniBADTR17872KCoJM=;
        h=Date:From:To:Subject:From;
        b=sKvOVPQrWGv5/NFXnUSUZFX3ODjwtkKcF4i6ZAukzEQWzP0UAcAAfg8bjTRFIqShU
         GIVBPff6uRBpyWKKAk0oICqK7apX9WnWEW4NCBYW/jOcMe7TE2f3A1arLDLz4SnBqo
         XPvFjouo+gJW1uTmeA22Sj+hSz8uOhD/DUwgh2rY=
Date:   Thu, 06 Aug 2020 22:54:30 -0700
From:   akpm@linux-foundation.org
To:     jcmvbkbc@gmail.com, mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        sfr@canb.auug.org.au
Subject:  [folded-merged]
 xtensa-switch-to-generic-version-of-pte-allocation-fix.patch removed from
 -mm tree
Message-ID: <20200807055430.rJu6AUSm7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: xtensa: fix closing endif comment
has been removed from the -mm tree.  Its filename was
     xtensa-switch-to-generic-version-of-pte-allocation-fix.patch

This patch was dropped because it was folded into xtensa-switch-to-generic-version-of-pte-allocation.patch

------------------------------------------------------
From: Max Filippov <jcmvbkbc@gmail.com>
Subject: xtensa: fix closing endif comment

Commit 8f74afa22d9b ("xtensa: switch to generic version of pte
allocation") introduced the following build warning for xtensa
  arch/xtensa/include/asm/pgalloc.h:67:8: warning: extra tokens at end of
  #endif directive [-Wendif-labels]
Fix #endif comment.

Link: http://lkml.kernel.org/r/20200721024751.1257-1-jcmvbkbc@gmail.com
Fixes: 8f74afa22d9b ("xtensa: switch to generic version of pte allocation")
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/include/asm/pgalloc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/xtensa/include/asm/pgalloc.h~xtensa-switch-to-generic-version-of-pte-allocation-fix
+++ a/arch/xtensa/include/asm/pgalloc.h
@@ -69,6 +69,6 @@ static inline pgtable_t pte_alloc_one(st
 }
 
 #define pmd_pgtable(pmd) pmd_page(pmd)
-#endif CONFIG_MMU
+#endif /* CONFIG_MMU */
 
 #endif /* _XTENSA_PGALLOC_H */
_

Patches currently in -mm which might be from jcmvbkbc@gmail.com are

xtensa-switch-to-generic-version-of-pte-allocation.patch

