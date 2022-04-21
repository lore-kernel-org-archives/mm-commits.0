Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B8B0C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 21 Apr 2022 20:39:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353740AbiDUUmF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Apr 2022 16:42:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243661AbiDUUmE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 21 Apr 2022 16:42:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B221E4E38C
        for <mm-commits@vger.kernel.org>; Thu, 21 Apr 2022 13:39:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64561B82916
        for <mm-commits@vger.kernel.org>; Thu, 21 Apr 2022 20:39:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F12C9C385A1;
        Thu, 21 Apr 2022 20:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650573551;
        bh=5R3UpHmcYOmlJXdlEBoNWF5nNUJspapnNwBpmABj0po=;
        h=Date:To:From:Subject:From;
        b=LLpPA64zhczv/IprrG8ir0CBE48vN8JAdvyJ5+7fHiPZfBjjnGRbh9BwdMB6kDytt
         dXUO2BUhAw/uGF3i8ugmEY8nTTdHL277jdXhspJUyKbGhp+Uit/olsp3+wRL3kemZl
         uPqrNQlNmWm+7Mzk6AiR2m7wCemgHkkWe1jOtzOQ=
Date:   Thu, 21 Apr 2022 13:39:10 -0700
To:     mm-commits@vger.kernel.org, pasha.tatashin@soleen.com,
        anshuman.khandual@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_table_check-drop-all-redundant-export_symbol.patch added to -mm tree
Message-Id: <20220421203910.F12C9C385A1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_table_check: drop all redundant EXPORT_SYMBOL()
has been added to the -mm tree.  Its filename is
     mm-page_table_check-drop-all-redundant-export_symbol.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_table_check-drop-all-redundant-export_symbol.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_table_check-drop-all-redundant-export_symbol.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/page_table_check: drop all redundant EXPORT_SYMBOL()

Function definitions need not be exported via EXPORT_SYMBOL() mechanism. 
In this case these functions just get called only inside their wrappers. 
Even __page_table_check_zero() gets called without such an export.  Just
drop all these redundant EXPORT_SYMBOL()s.

Link: https://lkml.kernel.org/r/20220421070631.1273879-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_table_check.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/mm/page_table_check.c~mm-page_table_check-drop-all-redundant-export_symbol
+++ a/mm/page_table_check.c
@@ -150,7 +150,6 @@ void __page_table_check_pte_clear(struct
 				       PAGE_SIZE >> PAGE_SHIFT);
 	}
 }
-EXPORT_SYMBOL(__page_table_check_pte_clear);
 
 void __page_table_check_pmd_clear(struct mm_struct *mm, unsigned long addr,
 				  pmd_t pmd)
@@ -163,7 +162,6 @@ void __page_table_check_pmd_clear(struct
 				       PMD_SIZE >> PAGE_SHIFT);
 	}
 }
-EXPORT_SYMBOL(__page_table_check_pmd_clear);
 
 void __page_table_check_pud_clear(struct mm_struct *mm, unsigned long addr,
 				  pud_t pud)
@@ -176,7 +174,6 @@ void __page_table_check_pud_clear(struct
 				       PUD_SIZE >> PAGE_SHIFT);
 	}
 }
-EXPORT_SYMBOL(__page_table_check_pud_clear);
 
 void __page_table_check_pte_set(struct mm_struct *mm, unsigned long addr,
 				pte_t *ptep, pte_t pte)
@@ -206,7 +203,6 @@ void __page_table_check_pmd_set(struct m
 				     pmd_write(pmd));
 	}
 }
-EXPORT_SYMBOL(__page_table_check_pmd_set);
 
 void __page_table_check_pud_set(struct mm_struct *mm, unsigned long addr,
 				pud_t *pudp, pud_t pud)
@@ -221,7 +217,6 @@ void __page_table_check_pud_set(struct m
 				     pud_write(pud));
 	}
 }
-EXPORT_SYMBOL(__page_table_check_pud_set);
 
 void __page_table_check_pte_clear_range(struct mm_struct *mm,
 					unsigned long addr,
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-page_table_check-drop-all-redundant-export_symbol.patch
mm-debug_vm_pgtable-drop-protection_map-usage.patch
mm-mmap-clarify-protection_map-indices.patch
mm-mmap-add-new-config-arch_has_vm_get_page_prot.patch
powerpc-mm-enable-arch_has_vm_get_page_prot.patch
arm64-mm-enable-arch_has_vm_get_page_prot.patch
sparc-mm-enable-arch_has_vm_get_page_prot.patch
mm-mmap-drop-arch_filter_pgprot.patch
mm-mmap-drop-arch_vm_get_page_pgprot.patch

