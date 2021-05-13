Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3F3BC43461
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 00:45:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4200613CA
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 00:45:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234029AbhEMArD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 May 2021 20:47:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:55786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231190AbhEMAnx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 May 2021 20:43:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17333613DF;
        Thu, 13 May 2021 00:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620866564;
        bh=U0nRCI3tJdoc6Y5CXX5hqgOHz/TfUr9oiD/VzFMo+qs=;
        h=Date:From:To:Subject:From;
        b=Vkkdwm2GwIorTr5p72yoEQ+FS3rNyAp77O8YXBSMDz6BY+4N+8A4Usq911FvPpKDC
         RjSC3KZMSMWyCGb0WjuyuXZruAQyR8mPbOmnxJXHNQ0HOGM+A12CE+dFBSXQfyuYRB
         e+gMKl3pyoZmGV0CoAFbTyIcCs/bodyxYgKe/EiQ=
Date:   Wed, 12 May 2021 17:42:43 -0700
From:   akpm@linux-foundation.org
To:     benh@kernel.crashing.org, christophe.leroy@csgroup.eu,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        mpe@ellerman.id.au, npiggin@gmail.com, paulus@samba.org,
        rppt@kernel.org, uladzislau.rezki@sony.com
Subject:  +
 mm-vmalloc-enable-mapping-of-huge-pages-at-pte-level-in-vmalloc.patch added
 to -mm tree
Message-ID: <20210513004243.5ZSWBkWYK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: enable mapping of huge pages at pte level in vmalloc
has been added to the -mm tree.  Its filename is
     mm-vmalloc-enable-mapping-of-huge-pages-at-pte-level-in-vmalloc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-enable-mapping-of-huge-pages-at-pte-level-in-vmalloc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-enable-mapping-of-huge-pages-at-pte-level-in-vmalloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: mm/vmalloc: enable mapping of huge pages at pte level in vmalloc

On some architectures like powerpc, there are huge pages that are mapped
at pte level.

Enable it in vmalloc.

For that, architectures can provide arch_vmap_pte_supported_shift() that
returns the shift for pages to map at pte level.

Link: https://lkml.kernel.org/r/2c717e3b1fba1894d890feb7669f83025bfa314d.1620795204.git.christophe.leroy@csgroup.eu
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Uladzislau Rezki <uladzislau.rezki@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    7 +++++++
 mm/vmalloc.c            |   13 +++++++------
 2 files changed, 14 insertions(+), 6 deletions(-)

--- a/include/linux/vmalloc.h~mm-vmalloc-enable-mapping-of-huge-pages-at-pte-level-in-vmalloc
+++ a/include/linux/vmalloc.h
@@ -112,6 +112,13 @@ static inline unsigned long arch_vmap_pt
 }
 #endif
 
+#ifndef arch_vmap_pte_supported_shift
+static inline int arch_vmap_pte_supported_shift(unsigned long size)
+{
+	return PAGE_SHIFT;
+}
+#endif
+
 /*
  *	Highlevel APIs for driver use
  */
--- a/mm/vmalloc.c~mm-vmalloc-enable-mapping-of-huge-pages-at-pte-level-in-vmalloc
+++ a/mm/vmalloc.c
@@ -2895,8 +2895,7 @@ void *__vmalloc_node_range(unsigned long
 		return NULL;
 	}
 
-	if (vmap_allow_huge && !(vm_flags & VM_NO_HUGE_VMAP) &&
-			arch_vmap_pmd_supported(prot)) {
+	if (vmap_allow_huge && !(vm_flags & VM_NO_HUGE_VMAP)) {
 		unsigned long size_per_node;
 
 		/*
@@ -2909,11 +2908,13 @@ void *__vmalloc_node_range(unsigned long
 		size_per_node = size;
 		if (node == NUMA_NO_NODE)
 			size_per_node /= num_online_nodes();
-		if (size_per_node >= PMD_SIZE) {
+		if (arch_vmap_pmd_supported(prot) && size_per_node >= PMD_SIZE)
 			shift = PMD_SHIFT;
-			align = max(real_align, 1UL << shift);
-			size = ALIGN(real_size, 1UL << shift);
-		}
+		else
+			shift = arch_vmap_pte_supported_shift(size_per_node);
+
+		align = max(real_align, 1UL << shift);
+		size = ALIGN(real_size, 1UL << shift);
 	}
 
 again:
_

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are

mm-hugetlb-change-parameters-of-arch_make_huge_pte.patch
mm-pgtable-add-stubs-for-pmd-pub_set-clear_huge.patch
mm-vmalloc-enable-mapping-of-huge-pages-at-pte-level-in-vmap.patch
mm-vmalloc-enable-mapping-of-huge-pages-at-pte-level-in-vmalloc.patch
powerpc-8xx-add-support-for-huge-pages-on-vmap-and-vmalloc.patch

