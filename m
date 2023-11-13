Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC1C2C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 13 Nov 2023 16:42:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbjKMQmK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Nov 2023 11:42:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjKMQmJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Nov 2023 11:42:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C98A10EC
        for <mm-commits@vger.kernel.org>; Mon, 13 Nov 2023 08:42:06 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6ECEC433C7;
        Mon, 13 Nov 2023 16:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699893725;
        bh=hgjTkJM40AWhdkAfZCsnDzdQadqBhdWRDRupfMtWmPs=;
        h=Date:To:From:Subject:From;
        b=GZAkCKeAIxKedpmZqVdXTL5ufHUq3kAqLzQtt71QGD+kKQVUJiJ4SBHq4BUIEBLZi
         1vT7huq3rur214K9rI/Ht7Sxme+oVnigfo4sGm60GE+Jd9trS92UEovo/YEhn3UzMr
         p61NV/D7DAkFpsMFwOzhx26lNPm1xSq7HQXmF3Bo=
Date:   Mon, 13 Nov 2023 08:42:05 -0800
To:     mm-commits@vger.kernel.org, david@redhat.com, ardb@kernel.org,
        lukas.bulwahn@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mmap-remove-the-ia64-specific-vma-expansion-implementation.patch added to mm-unstable branch
Message-Id: <20231113164205.D6ECEC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mmap: remove the IA64-specific vma expansion implementation
has been added to the -mm mm-unstable branch.  Its filename is
     mmap-remove-the-ia64-specific-vma-expansion-implementation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmap-remove-the-ia64-specific-vma-expansion-implementation.patch

This patch will later appear in the mm-unstable branch at
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
From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: mmap: remove the IA64-specific vma expansion implementation
Date: Mon, 13 Nov 2023 13:47:28 +0100

With commit cf8e8658100d ("arch: Remove Itanium (IA-64) architecture"),
there is no need to keep the IA64-specific vma expansion.

Clean up the IA64-specific vma expansion implementation.

Link: https://lkml.kernel.org/r/20231113124728.3974-1-lukas.bulwahn@gmail.com
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   37 +------------------------------------
 1 file changed, 1 insertion(+), 36 deletions(-)

--- a/mm/mmap.c~mmap-remove-the-ia64-specific-vma-expansion-implementation
+++ a/mm/mmap.c
@@ -2207,42 +2207,7 @@ struct vm_area_struct *find_extend_vma_l
 }
 #endif
 
-/*
- * IA64 has some horrid mapping rules: it can expand both up and down,
- * but with various special rules.
- *
- * We'll get rid of this architecture eventually, so the ugliness is
- * temporary.
- */
-#ifdef CONFIG_IA64
-static inline bool vma_expand_ok(struct vm_area_struct *vma, unsigned long addr)
-{
-	return REGION_NUMBER(addr) == REGION_NUMBER(vma->vm_start) &&
-		REGION_OFFSET(addr) < RGN_MAP_LIMIT;
-}
-
-/*
- * IA64 stacks grow down, but there's a special register backing store
- * that can grow up. Only sequentially, though, so the new address must
- * match vm_end.
- */
-static inline int vma_expand_up(struct vm_area_struct *vma, unsigned long addr)
-{
-	if (!vma_expand_ok(vma, addr))
-		return -EFAULT;
-	if (vma->vm_end != (addr & PAGE_MASK))
-		return -EFAULT;
-	return expand_upwards(vma, addr);
-}
-
-static inline bool vma_expand_down(struct vm_area_struct *vma, unsigned long addr)
-{
-	if (!vma_expand_ok(vma, addr))
-		return -EFAULT;
-	return expand_downwards(vma, addr);
-}
-
-#elif defined(CONFIG_STACK_GROWSUP)
+#if defined(CONFIG_STACK_GROWSUP)
 
 #define vma_expand_up(vma,addr) expand_upwards(vma, addr)
 #define vma_expand_down(vma, addr) (-EFAULT)
_

Patches currently in -mm which might be from lukas.bulwahn@gmail.com are

mmap-remove-the-ia64-specific-vma-expansion-implementation.patch

