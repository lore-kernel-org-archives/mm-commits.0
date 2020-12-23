Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3840AC433DB
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 00:35:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE763206E5
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 00:35:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725902AbgLWAfd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Dec 2020 19:35:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:48282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725882AbgLWAfd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Dec 2020 19:35:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3F0120691;
        Wed, 23 Dec 2020 00:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608683692;
        bh=NerD+STOugCNfeLNUs37dBNT907IWOY8gSoKtfCuIXY=;
        h=Date:From:To:Subject:From;
        b=raZZXduJVkdcHggNwZmfYf2REm9vctMQeL17ub4lUp2Qauej/T/8XEEzT2HvBfM4a
         315QMMAM/OA+Sj40Hgme0CbaFNPsJVspzyQLm8p5mX6m1SdAl/GKfSkXIhZtSpOx/P
         /KWUOBnBDCpovOPZDSjxxacfu+mHO1y1shpazhv4=
Date:   Tue, 22 Dec 2020 16:34:52 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, jrdr.linux@gmail.com,
        ahuang12@lenovo.com
Subject:  + mm-mmap-remove-unnecessary-local-variable.patch added to
 -mm tree
Message-ID: <20201223003452.YuHd-%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: remove unnecessary local variable
has been added to the -mm tree.  Its filename is
     mm-mmap-remove-unnecessary-local-variable.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mmap-remove-unnecessary-local-variable.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mmap-remove-unnecessary-local-variable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Adrian Huang <ahuang12@lenovo.com>
Subject: mm/mmap.c: remove unnecessary local variable

The local variable 'retval' is assigned just for once in __do_sys_brk(),
and the function returns the value of the local variable right after the
assignment.  Remove unnecessary assignment and local variable declaration.

Link: https://lkml.kernel.org/r/20201222103249.30683-1-adrianhuang0701@gmail.com
Signed-off-by: Adrian Huang <ahuang12@lenovo.com>
Acked-by: Souptick Joarder <jrdr.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/mmap.c~mm-mmap-remove-unnecessary-local-variable
+++ a/mm/mmap.c
@@ -189,7 +189,6 @@ static int do_brk_flags(unsigned long ad
 		struct list_head *uf);
 SYSCALL_DEFINE1(brk, unsigned long, brk)
 {
-	unsigned long retval;
 	unsigned long newbrk, oldbrk, origbrk;
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *next;
@@ -281,9 +280,8 @@ success:
 	return brk;
 
 out:
-	retval = origbrk;
 	mmap_write_unlock(mm);
-	return retval;
+	return origbrk;
 }
 
 static inline unsigned long vma_compute_gap(struct vm_area_struct *vma)
_

Patches currently in -mm which might be from ahuang12@lenovo.com are

mm-mmap-remove-unnecessary-local-variable.patch

