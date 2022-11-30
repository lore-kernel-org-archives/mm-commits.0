Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EE7DC47088
	for <mm-commits@archiver.kernel.org>; Wed, 30 Nov 2022 22:51:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiK3Wvw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 17:51:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbiK3Wvt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 17:51:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12C0C1FF90
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 14:51:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3113B81D4C
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 22:51:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4630FC433D6;
        Wed, 30 Nov 2022 22:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669848702;
        bh=7P2IPJz8kah5N/J3nJ6Y9mDvrirfptWRfspPob0NXak=;
        h=Date:To:From:Subject:From;
        b=ZK4DNGDQovrOrsSZBTInH1ADEmGQ8Onrj+nDzYVIautJ8I1HpmxaenymUYWjVDVUO
         tKEX2Wj7iOIa6zam9cTX3quAf3l1LSOt8c2ahtvk9+QIJjMwdDlH1K9NJsXxjO7Ddl
         Pmv2pZ0UizHwoLQKWrU3SS4lTqsj6FHQ9uKdQSeM=
Date:   Wed, 30 Nov 2022 14:51:41 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com, tglx@linutronix.de,
        mingo@redhat.com, linux@eikelenboom.it, hpa@zytor.com,
        geert@linux-m68k.org, dave.hansen@linux.intel.com, bp@alien8.de,
        jgross@suse.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-add-dummy-pmd_young-for-architectures-not-having-it.patch removed from -mm tree
Message-Id: <20221130225142.4630FC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: add dummy pmd_young() for architectures not having it
has been removed from the -mm tree.  Its filename was
     mm-add-dummy-pmd_young-for-architectures-not-having-it.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Juergen Gross <jgross@suse.com>
Subject: mm: add dummy pmd_young() for architectures not having it

In order to avoid #ifdeffery add a dummy pmd_young() implementation as a
fallback.  This is required for the later patch "mm: introduce
arch_has_hw_nonleaf_pmd_young()".

Link: https://lkml.kernel.org/r/fd3ac3cd-7349-6bbd-890a-71a9454ca0b3@suse.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Acked-by: Yu Zhao <yuzhao@google.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Sander Eikelenboom <linux@eikelenboom.it>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/loongarch/include/asm/pgtable.h |    1 +
 arch/mips/include/asm/pgtable.h      |    1 +
 arch/riscv/include/asm/pgtable.h     |    1 +
 arch/s390/include/asm/pgtable.h      |    1 +
 arch/sparc/include/asm/pgtable_64.h  |    1 +
 arch/x86/include/asm/pgtable.h       |    1 +
 include/linux/pgtable.h              |    7 +++++++
 7 files changed, 13 insertions(+)

--- a/arch/loongarch/include/asm/pgtable.h~mm-add-dummy-pmd_young-for-architectures-not-having-it
+++ a/arch/loongarch/include/asm/pgtable.h
@@ -482,6 +482,7 @@ static inline pmd_t pmd_mkdirty(pmd_t pm
 	return pmd;
 }
 
+#define pmd_young pmd_young
 static inline int pmd_young(pmd_t pmd)
 {
 	return !!(pmd_val(pmd) & _PAGE_ACCESSED);
--- a/arch/mips/include/asm/pgtable.h~mm-add-dummy-pmd_young-for-architectures-not-having-it
+++ a/arch/mips/include/asm/pgtable.h
@@ -622,6 +622,7 @@ static inline pmd_t pmd_mkdirty(pmd_t pm
 	return pmd;
 }
 
+#define pmd_young pmd_young
 static inline int pmd_young(pmd_t pmd)
 {
 	return !!(pmd_val(pmd) & _PAGE_ACCESSED);
--- a/arch/riscv/include/asm/pgtable.h~mm-add-dummy-pmd_young-for-architectures-not-having-it
+++ a/arch/riscv/include/asm/pgtable.h
@@ -600,6 +600,7 @@ static inline int pmd_dirty(pmd_t pmd)
 	return pte_dirty(pmd_pte(pmd));
 }
 
+#define pmd_young pmd_young
 static inline int pmd_young(pmd_t pmd)
 {
 	return pte_young(pmd_pte(pmd));
--- a/arch/s390/include/asm/pgtable.h~mm-add-dummy-pmd_young-for-architectures-not-having-it
+++ a/arch/s390/include/asm/pgtable.h
@@ -763,6 +763,7 @@ static inline int pmd_dirty(pmd_t pmd)
 	return (pmd_val(pmd) & _SEGMENT_ENTRY_DIRTY) != 0;
 }
 
+#define pmd_young pmd_young
 static inline int pmd_young(pmd_t pmd)
 {
 	return (pmd_val(pmd) & _SEGMENT_ENTRY_YOUNG) != 0;
--- a/arch/sparc/include/asm/pgtable_64.h~mm-add-dummy-pmd_young-for-architectures-not-having-it
+++ a/arch/sparc/include/asm/pgtable_64.h
@@ -693,6 +693,7 @@ static inline unsigned long pmd_dirty(pm
 	return pte_dirty(pte);
 }
 
+#define pmd_young pmd_young
 static inline unsigned long pmd_young(pmd_t pmd)
 {
 	pte_t pte = __pte(pmd_val(pmd));
--- a/arch/x86/include/asm/pgtable.h~mm-add-dummy-pmd_young-for-architectures-not-having-it
+++ a/arch/x86/include/asm/pgtable.h
@@ -139,6 +139,7 @@ static inline int pmd_dirty(pmd_t pmd)
 	return pmd_flags(pmd) & _PAGE_DIRTY;
 }
 
+#define pmd_young pmd_young
 static inline int pmd_young(pmd_t pmd)
 {
 	return pmd_flags(pmd) & _PAGE_ACCESSED;
--- a/include/linux/pgtable.h~mm-add-dummy-pmd_young-for-architectures-not-having-it
+++ a/include/linux/pgtable.h
@@ -165,6 +165,13 @@ static inline pte_t *virt_to_kpte(unsign
 	return pmd_none(*pmd) ? NULL : pte_offset_kernel(pmd, vaddr);
 }
 
+#ifndef pmd_young
+static inline int pmd_young(pmd_t pmd)
+{
+	return 0;
+}
+#endif
+
 #ifndef __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
 extern int ptep_set_access_flags(struct vm_area_struct *vma,
 				 unsigned long address, pte_t *ptep,
_

Patches currently in -mm which might be from jgross@suse.com are


