Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77AE9C433EF
	for <mm-commits@archiver.kernel.org>; Sat,  7 May 2022 17:50:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386718AbiEGRyS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 7 May 2022 13:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244094AbiEGRyQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 7 May 2022 13:54:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D0F5227
        for <mm-commits@vger.kernel.org>; Sat,  7 May 2022 10:50:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4A0161370
        for <mm-commits@vger.kernel.org>; Sat,  7 May 2022 17:50:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38900C385A6;
        Sat,  7 May 2022 17:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651945827;
        bh=NrSLFP71spoTAv4JiXCKzJ7YESsqqQQrNiDFWsOknl8=;
        h=Date:To:From:Subject:From;
        b=z4xlTiI6iuGzGQT3k97NS19Q0RP2TJH/UF+CfPRX8bszJVqb2YtN83ONVbrXMp1gU
         UcxDzN0Cllvxp9tFBM7XiLC8iD8TvuDBbN+USeC8b5H4oNfy/xFoW+D/rJtO60qtAx
         I5ycF/bSa5Y+Y5t4eCHi6pjLatjzNo5sCC6mNu9o=
Date:   Sat, 07 May 2022 10:50:26 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        peterz@infradead.org, mingo@redhat.com, luto@kernel.org,
        hpa@zytor.com, dave.hansen@linux.intel.com, bp@alien8.de,
        kunyu@nfschina.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-functions-may-simplify-the-use-of-return-values.patch added to mm-unstable branch
Message-Id: <20220507175027.38900C385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: functions may simplify the use of return values
has been added to the -mm mm-unstable branch.  Its filename is
     mm-functions-may-simplify-the-use-of-return-values.patch

This patch should soon appear in the mm-unstable branch at
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
From: Li kunyu <kunyu@nfschina.com>
Subject: mm: functions may simplify the use of return values

p4d_clear_huge may be optimized for void return type and function usage. 
vunmap_p4d_range function saves a few steps here.

Link: https://lkml.kernel.org/r/20220507150630.90399-1-kunyu@nfschina.com
Signed-off-by: Li kunyu <kunyu@nfschina.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/pgtable.c   |    3 +--
 include/linux/pgtable.h |   12 +++---------
 mm/vmalloc.c            |    7 ++-----
 3 files changed, 6 insertions(+), 16 deletions(-)

--- a/arch/x86/mm/pgtable.c~mm-functions-may-simplify-the-use-of-return-values
+++ a/arch/x86/mm/pgtable.c
@@ -686,9 +686,8 @@ int p4d_set_huge(p4d_t *p4d, phys_addr_t
  *
  * No 512GB pages yet -- always return 0
  */
-int p4d_clear_huge(p4d_t *p4d)
+void p4d_clear_huge(p4d_t *p4d)
 {
-	return 0;
 }
 #endif
 
--- a/include/linux/pgtable.h~mm-functions-may-simplify-the-use-of-return-values
+++ a/include/linux/pgtable.h
@@ -1443,16 +1443,13 @@ static inline int pmd_protnone(pmd_t pmd
 
 #ifndef __PAGETABLE_P4D_FOLDED
 int p4d_set_huge(p4d_t *p4d, phys_addr_t addr, pgprot_t prot);
-int p4d_clear_huge(p4d_t *p4d);
+void p4d_clear_huge(p4d_t *p4d);
 #else
 static inline int p4d_set_huge(p4d_t *p4d, phys_addr_t addr, pgprot_t prot)
 {
 	return 0;
 }
-static inline int p4d_clear_huge(p4d_t *p4d)
-{
-	return 0;
-}
+static inline void p4d_clear_huge(p4d_t *p4d) { }
 #endif /* !__PAGETABLE_P4D_FOLDED */
 
 int pud_set_huge(pud_t *pud, phys_addr_t addr, pgprot_t prot);
@@ -1475,10 +1472,7 @@ static inline int pmd_set_huge(pmd_t *pm
 {
 	return 0;
 }
-static inline int p4d_clear_huge(p4d_t *p4d)
-{
-	return 0;
-}
+static inline void p4d_clear_huge(p4d_t *p4d) { }
 static inline int pud_clear_huge(pud_t *pud)
 {
 	return 0;
--- a/mm/vmalloc.c~mm-functions-may-simplify-the-use-of-return-values
+++ a/mm/vmalloc.c
@@ -389,18 +389,15 @@ static void vunmap_p4d_range(pgd_t *pgd,
 {
 	p4d_t *p4d;
 	unsigned long next;
-	int cleared;
 
 	p4d = p4d_offset(pgd, addr);
 	do {
 		next = p4d_addr_end(addr, end);
 
-		cleared = p4d_clear_huge(p4d);
-		if (cleared || p4d_bad(*p4d))
+		p4d_clear_huge(p4d);
+		if (p4d_bad(*p4d))
 			*mask |= PGTBL_P4D_MODIFIED;
 
-		if (cleared)
-			continue;
 		if (p4d_none_or_clear_bad(p4d))
 			continue;
 		vunmap_pud_range(p4d, addr, next, mask);
_

Patches currently in -mm which might be from kunyu@nfschina.com are

mm-functions-may-simplify-the-use-of-return-values.patch

