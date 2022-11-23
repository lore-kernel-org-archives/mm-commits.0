Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A161C47089
	for <mm-commits@archiver.kernel.org>; Wed, 23 Nov 2022 20:18:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238976AbiKWUS3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Nov 2022 15:18:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240000AbiKWUSX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Nov 2022 15:18:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E438CF3E
        for <mm-commits@vger.kernel.org>; Wed, 23 Nov 2022 12:18:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29D13B8247C
        for <mm-commits@vger.kernel.org>; Wed, 23 Nov 2022 20:18:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4E53C433D6;
        Wed, 23 Nov 2022 20:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669234699;
        bh=LXhqlAeAR+uey1OKZZZetbtqE4gEYlPJy7arLgmjgf4=;
        h=Date:To:From:Subject:From;
        b=mkvKhf8Qg4yyF0Vqy78z57HeBGM2nr7kOkcZ7/W4odrhrFTw7YC/qqgPlHIF0mbAr
         HDtaxz+fwKz8MD4B+g+vJ4pDJy6y19vrfmCeE1ePj9pvo3R7i2vePNxVfGWa+u7cH+
         0jC44GCgeNsEuAbkmsffCJJ/p5f4iBHV4+qffqCo=
Date:   Wed, 23 Nov 2022 12:18:18 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        linux@eikelenboom.it, david@redhat.com, jgross@suse.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-arch_has_hw_nonleaf_pmd_young.patch added to mm-hotfixes-unstable branch
Message-Id: <20221123201819.B4E53C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce arch_has_hw_nonleaf_pmd_young()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-introduce-arch_has_hw_nonleaf_pmd_young.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-arch_has_hw_nonleaf_pmd_young.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Juergen Gross <jgross@suse.com>
Subject: mm: introduce arch_has_hw_nonleaf_pmd_young()
Date: Wed, 23 Nov 2022 07:45:10 +0100

When running as a Xen PV guests commit eed9a328aa1a ("mm: x86: add
CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG") can cause a protection violation in
pmdp_test_and_clear_young():

 BUG: unable to handle page fault for address: ffff8880083374d0
 #PF: supervisor write access in kernel mode
 #PF: error_code(0x0003) - permissions violation
 PGD 3026067 P4D 3026067 PUD 3027067 PMD 7fee5067 PTE 8010000008337065
 Oops: 0003 [#1] PREEMPT SMP NOPTI
 CPU: 7 PID: 158 Comm: kswapd0 Not tainted 6.1.0-rc5-20221118-doflr+ #1
 RIP: e030:pmdp_test_and_clear_young+0x25/0x40

This happens because the Xen hypervisor can't emulate direct writes to
page table entries other than PTEs.

This can easily be fixed by introducing arch_has_hw_nonleaf_pmd_young()
similar to arch_has_hw_pte_young() and test that instead of
CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG.

Link: https://lkml.kernel.org/r/20221123064510.16225-1-jgross@suse.com
Fixes: eed9a328aa1a ("mm: x86: add CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG")
Signed-off-by: Juergen Gross <jgross@suse.com>
Reported-by: Sander Eikelenboom <linux@eikelenboom.it>
Acked-by: Yu Zhao <yuzhao@google.com>
Tested-by: Sander Eikelenboom <linux@eikelenboom.it>
Acked-by: David Hildenbrand <david@redhat.com>	[core changes]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h |    8 ++++++++
 include/linux/pgtable.h        |   11 +++++++++++
 mm/vmscan.c                    |   10 +++++-----
 3 files changed, 24 insertions(+), 5 deletions(-)

--- a/arch/x86/include/asm/pgtable.h~mm-introduce-arch_has_hw_nonleaf_pmd_young
+++ a/arch/x86/include/asm/pgtable.h
@@ -1438,6 +1438,14 @@ static inline bool arch_has_hw_pte_young
 	return true;
 }
 
+#ifdef CONFIG_XEN_PV
+#define arch_has_hw_nonleaf_pmd_young arch_has_hw_nonleaf_pmd_young
+static inline bool arch_has_hw_nonleaf_pmd_young(void)
+{
+	return !cpu_feature_enabled(X86_FEATURE_XENPV);
+}
+#endif
+
 #ifdef CONFIG_PAGE_TABLE_CHECK
 static inline bool pte_user_accessible_page(pte_t pte)
 {
--- a/include/linux/pgtable.h~mm-introduce-arch_has_hw_nonleaf_pmd_young
+++ a/include/linux/pgtable.h
@@ -260,6 +260,17 @@ static inline int pmdp_clear_flush_young
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif
 
+#ifndef arch_has_hw_nonleaf_pmd_young
+/*
+ * Return whether the accessed bit in non-leaf PMD entries is supported on the
+ * local CPU.
+ */
+static inline bool arch_has_hw_nonleaf_pmd_young(void)
+{
+	return IS_ENABLED(CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG);
+}
+#endif
+
 #ifndef arch_has_hw_pte_young
 /*
  * Return whether the accessed bit is supported on the local CPU.
--- a/mm/vmscan.c~mm-introduce-arch_has_hw_nonleaf_pmd_young
+++ a/mm/vmscan.c
@@ -3987,7 +3987,7 @@ static void walk_pmd_range_locked(pud_t
 			goto next;
 
 		if (!pmd_trans_huge(pmd[i])) {
-			if (IS_ENABLED(CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG) &&
+			if (arch_has_hw_nonleaf_pmd_young() &&
 			    get_cap(LRU_GEN_NONLEAF_YOUNG))
 				pmdp_test_and_clear_young(vma, addr, pmd + i);
 			goto next;
@@ -4085,14 +4085,14 @@ restart:
 #endif
 		walk->mm_stats[MM_NONLEAF_TOTAL]++;
 
-#ifdef CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG
-		if (get_cap(LRU_GEN_NONLEAF_YOUNG)) {
+		if (arch_has_hw_nonleaf_pmd_young() &&
+		    get_cap(LRU_GEN_NONLEAF_YOUNG)) {
 			if (!pmd_young(val))
 				continue;
 
 			walk_pmd_range_locked(pud, addr, vma, args, bitmap, &pos);
 		}
-#endif
+
 		if (!walk->force_scan && !test_bloom_filter(walk->lruvec, walk->max_seq, pmd + i))
 			continue;
 
@@ -5392,7 +5392,7 @@ static ssize_t show_enabled(struct kobje
 	if (arch_has_hw_pte_young() && get_cap(LRU_GEN_MM_WALK))
 		caps |= BIT(LRU_GEN_MM_WALK);
 
-	if (IS_ENABLED(CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG) && get_cap(LRU_GEN_NONLEAF_YOUNG))
+	if (arch_has_hw_nonleaf_pmd_young() && get_cap(LRU_GEN_NONLEAF_YOUNG))
 		caps |= BIT(LRU_GEN_NONLEAF_YOUNG);
 
 	return snprintf(buf, PAGE_SIZE, "0x%04x\n", caps);
_

Patches currently in -mm which might be from jgross@suse.com are

mm-introduce-arch_has_hw_nonleaf_pmd_young.patch

