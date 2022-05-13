Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11209C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:25:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383860AbiEMTZE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383873AbiEMTXQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:23:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C370F3123F
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:22:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4493560A66
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:22:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97B4AC34100;
        Fri, 13 May 2022 19:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469734;
        bh=OHpDOahGKwWuUSuDrWxRQCNpGR0WyE9uqRAL6+0P6vo=;
        h=Date:To:From:Subject:From;
        b=i/AkSJ0dF7XHQDef9vo+3eC6NzbMJ4mDDTfvfPpOFMj4Ri4TpndBhe9kQVAsEb3pL
         cM0aE0b8us+9HG2w62eEXcOl07Qxxk9H6GyOETJGqDriCGlwdHv/7NokOMFXhdBAnh
         1Lo49ifZy8jfrjacUWRYOqkay3IdM0umhpU+66DU=
Date:   Fri, 13 May 2022 12:22:14 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        peterz@infradead.org, mingo@redhat.com, luto@kernel.org,
        hpa@zytor.com, dave.hansen@linux.intel.com, bp@alien8.de,
        kunyu@nfschina.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-functions-may-simplify-the-use-of-return-values.patch removed from -mm tree
Message-Id: <20220513192214.97B4AC34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: functions may simplify the use of return values
has been removed from the -mm tree.  Its filename was
     mm-functions-may-simplify-the-use-of-return-values.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -1448,16 +1448,13 @@ static inline int pmd_protnone(pmd_t pmd
 
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
@@ -1480,10 +1477,7 @@ static inline int pmd_set_huge(pmd_t *pm
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


