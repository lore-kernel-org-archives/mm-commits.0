Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC182C48BE5
	for <mm-commits@archiver.kernel.org>; Wed, 16 Jun 2021 22:58:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91B91613CB
	for <mm-commits@archiver.kernel.org>; Wed, 16 Jun 2021 22:58:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbhFPXAp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Jun 2021 19:00:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:43928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230486AbhFPXAo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Jun 2021 19:00:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3710C60FE6;
        Wed, 16 Jun 2021 22:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623884318;
        bh=RdyTfy9XcuGhPtnr7FS9eWTU/FeN7FGz0lMOIqjFzek=;
        h=Date:From:To:Subject:From;
        b=XniDgnpAhAi7zxCMkJaN1pVXnBL2HrC5BMC58qbJt4fagUs/CCzTnO9MZ2qYZDmOX
         Baz/6ImwMPJT6QdDkPQzvZcz2zzpdzZl6Psnj7t6mqQV9bOlVK5/e5cvCJryRoTzwe
         TaZ9t72Grq8KyCDrffkjaetjCR4sX5yPi2p9aMKk=
Date:   Wed, 16 Jun 2021 15:58:37 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, mm-commits@vger.kernel.org,
        sfr@canb.auug.org.au
Subject:  +
 mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t-fix.patch
 added to -mm tree
Message-ID: <20210616225837.72-woFVrt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t-fix
has been added to the -mm tree.  Its filename is
     mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t-fix

m68k build error reported by kernel robot.

  We may want to fixup pgd_page_vaddr correctly later. pgd_page_vaddr() gets
  cast to different pointer types based on architecture. But for now this
  should work? This ensure we keep the pgd_page_vaddr() same as before.

Link: https://lkml.kernel.org/r/87tulxnb2v.fsf@linux.ibm.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/pgtable-nop4d.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/asm-generic/pgtable-nop4d.h~mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t-fix
+++ a/include/asm-generic/pgtable-nop4d.h
@@ -42,7 +42,7 @@ static inline p4d_t *p4d_offset(pgd_t *p
 #define __p4d(x)				((p4d_t) { __pgd(x) })
 
 #define pgd_page(pgd)				(p4d_page((p4d_t){ pgd }))
-#define pgd_page_vaddr(pgd)			(p4d_pgtable((p4d_t){ pgd }))
+#define pgd_page_vaddr(pgd)			((unsigned long)(p4d_pgtable((p4d_t){ pgd })))
 
 /*
  * allocating and freeing a p4d is trivial: the 1-entry p4d is
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are

mm-rename-pud_page_vaddr-to-pud_pgtable-and-make-it-return-pmd_t.patch
mm-rename-pud_page_vaddr-to-pud_pgtable-and-make-it-return-pmd_t-fix-2.patch
mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t.patch
mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t-fix.patch

