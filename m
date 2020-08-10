Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4707C433E1
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:38:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F8F220723
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027084;
	bh=oB2qdjgjDLW3/McxA93ikrcNOVzYi5vqKMCM9NIG28Q=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=1s75x8r/A75ExkgaW+QJ3iyNzMkJVklRmmtoLSslx+XEvCSuWS0FxxW8efLtcLm03
	 EUaNUV8tSLsAoyhMZeHXIBk5qzrZlX5MFR7V4WL7jE0mHh1Ers3v8JRFi8XX2559iZ
	 c8fR/JYBjgm97NSZLADWo2J0zBTjpehU0c51ftx0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgHJCiE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:38:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:41214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCiD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:38:03 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABD552078B;
        Mon, 10 Aug 2020 02:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027083;
        bh=oB2qdjgjDLW3/McxA93ikrcNOVzYi5vqKMCM9NIG28Q=;
        h=Date:From:To:Subject:From;
        b=V9qb/d+2825HHcYJjiusK7YgfVErWvdkxqXfWRorU6+zyASc5gqGODIFB9xvK6OQI
         yUeGGo3hyInc8SSQEALWrKgQF2RFzM6hf6UViOe0jz32AxiPXBkxKwvHUrV3XXAM0V
         mNdYv021AVnr0TCG3Ako/LGPXrxYjRNvcpkgoe74=
Date:   Sun, 09 Aug 2020 19:38:02 -0700
From:   akpm@linux-foundation.org
To:     abdhalee@linux.vnet.ibm.com, arnd@arndb.de,
        christophe.leroy@csgroup.eu, geert@linux-m68k.org,
        jcmvbkbc@gmail.com, jroedel@suse.de, luto@kernel.org,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        peterz@infradead.org, rostedt@goodmis.org, rppt@linux.ibm.com,
        sathnaga@linux.vnet.ibm.com, sfr@canb.auug.org.au,
        shorne@gmail.com, willy@infradead.org
Subject:  [merged]
 mm-move-pd_alloc_track-to-separate-header-file.patch removed from -mm tree
Message-ID: <20200810023802.So1aQYCJd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move p?d_alloc_track to separate header file
has been removed from the -mm tree.  Its filename was
     mm-move-pd_alloc_track-to-separate-header-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joerg Roedel <jroedel@suse.de>
Subject: mm: move p?d_alloc_track to separate header file

The functions are only used in two source files, so there is no need for
them to be in the global <linux/mm.h> header.  Move them to the new
<linux/pgalloc-track.h> header and include it only where needed.

Link: http://lkml.kernel.org/r/20200609120533.25867-1-joro@8bytes.org
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Cc: Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   45 -------------------------------------
 mm/ioremap.c       |    2 +
 mm/pgalloc-track.h |   51 +++++++++++++++++++++++++++++++++++++++++++
 mm/vmalloc.c       |    1 
 4 files changed, 54 insertions(+), 45 deletions(-)

--- a/include/linux/mm.h~mm-move-pd_alloc_track-to-separate-header-file
+++ a/include/linux/mm.h
@@ -2103,51 +2103,11 @@ static inline pud_t *pud_alloc(struct mm
 		NULL : pud_offset(p4d, address);
 }
 
-static inline p4d_t *p4d_alloc_track(struct mm_struct *mm, pgd_t *pgd,
-				     unsigned long address,
-				     pgtbl_mod_mask *mod_mask)
-
-{
-	if (unlikely(pgd_none(*pgd))) {
-		if (__p4d_alloc(mm, pgd, address))
-			return NULL;
-		*mod_mask |= PGTBL_PGD_MODIFIED;
-	}
-
-	return p4d_offset(pgd, address);
-}
-
-static inline pud_t *pud_alloc_track(struct mm_struct *mm, p4d_t *p4d,
-				     unsigned long address,
-				     pgtbl_mod_mask *mod_mask)
-{
-	if (unlikely(p4d_none(*p4d))) {
-		if (__pud_alloc(mm, p4d, address))
-			return NULL;
-		*mod_mask |= PGTBL_P4D_MODIFIED;
-	}
-
-	return pud_offset(p4d, address);
-}
-
 static inline pmd_t *pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long address)
 {
 	return (unlikely(pud_none(*pud)) && __pmd_alloc(mm, pud, address))?
 		NULL: pmd_offset(pud, address);
 }
-
-static inline pmd_t *pmd_alloc_track(struct mm_struct *mm, pud_t *pud,
-				     unsigned long address,
-				     pgtbl_mod_mask *mod_mask)
-{
-	if (unlikely(pud_none(*pud))) {
-		if (__pmd_alloc(mm, pud, address))
-			return NULL;
-		*mod_mask |= PGTBL_PUD_MODIFIED;
-	}
-
-	return pmd_offset(pud, address);
-}
 #endif /* CONFIG_MMU */
 
 #if USE_SPLIT_PTE_PTLOCKS
@@ -2263,11 +2223,6 @@ static inline void pgtable_pte_page_dtor
 	((unlikely(pmd_none(*(pmd))) && __pte_alloc_kernel(pmd))? \
 		NULL: pte_offset_kernel(pmd, address))
 
-#define pte_alloc_kernel_track(pmd, address, mask)			\
-	((unlikely(pmd_none(*(pmd))) &&					\
-	  (__pte_alloc_kernel(pmd) || ({*(mask)|=PGTBL_PMD_MODIFIED;0;})))?\
-		NULL: pte_offset_kernel(pmd, address))
-
 #if USE_SPLIT_PMD_PTLOCKS
 
 static struct page *pmd_to_page(pmd_t *pmd)
--- a/mm/ioremap.c~mm-move-pd_alloc_track-to-separate-header-file
+++ a/mm/ioremap.c
@@ -13,6 +13,8 @@
 #include <linux/export.h>
 #include <asm/cacheflush.h>
 
+#include "pgalloc-track.h"
+
 #ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
 static int __read_mostly ioremap_p4d_capable;
 static int __read_mostly ioremap_pud_capable;
--- /dev/null
+++ a/mm/pgalloc-track.h
@@ -0,0 +1,51 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_PGALLLC_TRACK_H
+#define _LINUX_PGALLLC_TRACK_H
+
+#if defined(CONFIG_MMU)
+static inline p4d_t *p4d_alloc_track(struct mm_struct *mm, pgd_t *pgd,
+				     unsigned long address,
+				     pgtbl_mod_mask *mod_mask)
+{
+	if (unlikely(pgd_none(*pgd))) {
+		if (__p4d_alloc(mm, pgd, address))
+			return NULL;
+		*mod_mask |= PGTBL_PGD_MODIFIED;
+	}
+
+	return p4d_offset(pgd, address);
+}
+
+static inline pud_t *pud_alloc_track(struct mm_struct *mm, p4d_t *p4d,
+				     unsigned long address,
+				     pgtbl_mod_mask *mod_mask)
+{
+	if (unlikely(p4d_none(*p4d))) {
+		if (__pud_alloc(mm, p4d, address))
+			return NULL;
+		*mod_mask |= PGTBL_P4D_MODIFIED;
+	}
+
+	return pud_offset(p4d, address);
+}
+
+static inline pmd_t *pmd_alloc_track(struct mm_struct *mm, pud_t *pud,
+				     unsigned long address,
+				     pgtbl_mod_mask *mod_mask)
+{
+	if (unlikely(pud_none(*pud))) {
+		if (__pmd_alloc(mm, pud, address))
+			return NULL;
+		*mod_mask |= PGTBL_PUD_MODIFIED;
+	}
+
+	return pmd_offset(pud, address);
+}
+#endif /* CONFIG_MMU */
+
+#define pte_alloc_kernel_track(pmd, address, mask)			\
+	((unlikely(pmd_none(*(pmd))) &&					\
+	  (__pte_alloc_kernel(pmd) || ({*(mask)|=PGTBL_PMD_MODIFIED;0;})))?\
+		NULL: pte_offset_kernel(pmd, address))
+
+#endif /* _LINUX_PGALLLC_TRACK_H */
--- a/mm/vmalloc.c~mm-move-pd_alloc_track-to-separate-header-file
+++ a/mm/vmalloc.c
@@ -41,6 +41,7 @@
 #include <asm/shmparam.h>
 
 #include "internal.h"
+#include "pgalloc-track.h"
 
 bool is_vmalloc_addr(const void *x)
 {
_

Patches currently in -mm which might be from jroedel@suse.de are


