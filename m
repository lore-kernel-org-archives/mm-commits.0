Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AAA2C77B75
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 00:57:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbjDRA5d (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Apr 2023 20:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjDRA5d (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Apr 2023 20:57:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 405F4E41;
        Mon, 17 Apr 2023 17:57:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9D5C62B94;
        Tue, 18 Apr 2023 00:57:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD72C433EF;
        Tue, 18 Apr 2023 00:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681779451;
        bh=N9qe0aOgZQaJ/2cIrJFZPbH0wU65sFclz6ip6iLhzsI=;
        h=Date:To:From:Subject:From;
        b=VS4MCLCw1QPchnKBMrmJmfvN7mbkuIw/34EZfWH9eUcHvHTRysv6JxZJBBpsAkVrq
         RZ8av+H/niULKxKrs79FEDojB4Ut8IfitLs0Nk4Oli8cuW2/HmCTOZhsjV/yOtTtD8
         ohtwFL6i9nrZCRkNLQoZhyzFNSYwkid5rr1JLfFY=
Date:   Mon, 17 Apr 2023 17:57:30 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        rppt@linux.ibm.com, mike.kravetz@oracle.com, ardb@kernel.org,
        hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ia64-fix-an-addr-to-taddr-in-huge_pte_offset.patch added to mm-nonmm-unstable branch
Message-Id: <20230418005731.1DD72C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: fix an addr to taddr in huge_pte_offset()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ia64-fix-an-addr-to-taddr-in-huge_pte_offset.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ia64-fix-an-addr-to-taddr-in-huge_pte_offset.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: ia64: fix an addr to taddr in huge_pte_offset()
Date: Sun, 16 Apr 2023 22:17:05 -0700 (PDT)

I know nothing of ia64 htlbpage_to_page(), but guess that the p4d
line should be using taddr rather than addr, like everywhere else.

Link: https://lkml.kernel.org/r/732eae88-3beb-246-2c72-281de786740@google.com
Fixes: c03ab9e32a2c ("ia64: add support for folded p4d page tables")
Signed-off-by: Hugh Dickins <hughd@google.com
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/hugetlbpage.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/ia64/mm/hugetlbpage.c~ia64-fix-an-addr-to-taddr-in-huge_pte_offset
+++ a/arch/ia64/mm/hugetlbpage.c
@@ -58,7 +58,7 @@ huge_pte_offset (struct mm_struct *mm, u
 
 	pgd = pgd_offset(mm, taddr);
 	if (pgd_present(*pgd)) {
-		p4d = p4d_offset(pgd, addr);
+		p4d = p4d_offset(pgd, taddr);
 		if (p4d_present(*p4d)) {
 			pud = pud_offset(p4d, taddr);
 			if (pud_present(*pud)) {
_

Patches currently in -mm which might be from hughd@google.com are

ia64-fix-an-addr-to-taddr-in-huge_pte_offset.patch

