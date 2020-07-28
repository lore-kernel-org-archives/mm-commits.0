Return-Path: <SRS0=nZXm=BH=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91DFEC433E3
	for <mm-commits@archiver.kernel.org>; Tue, 28 Jul 2020 22:21:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F67F2074F
	for <mm-commits@archiver.kernel.org>; Tue, 28 Jul 2020 22:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595974919;
	bh=Ag5JUIN2l+ucDFVHL/jkaUlKUGxnxhOyqGMmIPXi5jY=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=EVetvqeSxPgbSz9Q9JpAecNIQtbS4QKwGf2PM6XWbO7U1MAZ8MjbZfzkZT3BYrxub
	 aaDO8Z6G++4+mJgVS9YnVrG+GuR+AtdwGWGOqVJaxzcC+5DPD5DBaVNLvo2ToKba4d
	 m0vXj1DknhtSR/TpNR/Y5WaNtr0Maa/nMgd4J874=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729602AbgG1WV7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Jul 2020 18:21:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:37044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729491AbgG1WV6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 28 Jul 2020 18:21:58 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36CF72070B;
        Tue, 28 Jul 2020 22:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595974918;
        bh=Ag5JUIN2l+ucDFVHL/jkaUlKUGxnxhOyqGMmIPXi5jY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=NWDaXXk9BjT2auFhhjLvdVd6SlUyUuIWtwAjguHCtKhekb7qL1tN3H2Qz+t/H9igu
         gQF8Vd4hq4Tw5plY2CljzejEvAi4M8RwjM2otE0Dx30uTcGKT6KCJElgXjVeJKCvV0
         iDtc0USRhM21jmfQF9BOmJ6hFb2iPWXkwCUd9Ul4=
Date:   Tue, 28 Jul 2020 15:21:57 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     jcmvbkbc@gmail.com, mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        sfr@canb.auug.org.au
Subject:  +
 xtensa-switch-to-generic-version-of-pte-allocation-fix.patch added to -mm
 tree
Message-ID: <20200728222157.v3FMETQLL%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: xtensa: fix closing endif comment
has been added to the -mm tree.  Its filename is
     xtensa-switch-to-generic-version-of-pte-allocation-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/xtensa-switch-to-generic-version-of-pte-allocation-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/xtensa-switch-to-generic-version-of-pte-allocation-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

xtensa-switch-to-generic-version-of-pte-allocation-fix.patch

