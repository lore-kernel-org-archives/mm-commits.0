Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39D85C6FA8E
	for <mm-commits@archiver.kernel.org>; Fri,  3 Mar 2023 02:05:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbjCCCF6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Mar 2023 21:05:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjCCCF6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Mar 2023 21:05:58 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC26117CF0
        for <mm-commits@vger.kernel.org>; Thu,  2 Mar 2023 18:05:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3A4B7CE2016
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 02:05:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E029C433EF;
        Fri,  3 Mar 2023 02:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677809153;
        bh=mWdCZ5ewzz8JkygyAf/n/k9T1dUpQTI1rvVwCybnhL4=;
        h=Date:To:From:Subject:From;
        b=n8ujW1wDIYnLUaMHSy0C9duroJUxchjCcjnJ+V2RKtNj0Sk7EaABgiWe7PA4RFBG/
         JSdVOFnvzTUSwt67/M6nfQiEs7LApZ1iJ71kUhqu/ReHXcTV7sCOwHVf1ZorJags/y
         0QvtdnlIArzH9CCXpw9ROY/Ct45mh7WgF31hTBoM=
Date:   Thu, 02 Mar 2023 18:05:53 -0800
To:     mm-commits@vger.kernel.org, rppt@kernel.org,
        mike.kravetz@oracle.com, david@redhat.com, corbet@lwn.net,
        christophe.leroy@csgroup.eu, anshuman.khandual@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-debug_vm_pgtable-replace-pte_mkhuge-with-arch_make_huge_pte.patch added to mm-unstable branch
Message-Id: <20230303020553.9E029C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable: replace pte_mkhuge() with arch_make_huge_pte()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-debug_vm_pgtable-replace-pte_mkhuge-with-arch_make_huge_pte.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-debug_vm_pgtable-replace-pte_mkhuge-with-arch_make_huge_pte.patch

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
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/debug_vm_pgtable: replace pte_mkhuge() with arch_make_huge_pte()
Date: Thu, 2 Mar 2023 17:18:45 +0530

Since the following commit arch_make_huge_pte() should be used directly in
generic memory subsystem as a platform provided page table helper, instead
of pte_mkhuge().  Change hugetlb_basic_tests() to call
arch_make_huge_pte() directly, and update its relevant documentation entry
as required.

'commit 16785bd77431 ("mm: merge pte_mkhuge() call into arch_make_huge_pte()")'

Link: https://lkml.kernel.org/r/20230302114845.421674-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reported-by: Christophe Leroy <christophe.leroy@csgroup.eu>
  Link: https://lore.kernel.org/all/1ea45095-0926-a56a-a273-816709e9075e@csgroup.eu/
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/Documentation/mm/arch_pgtable_helpers.rst~mm-debug_vm_pgtable-replace-pte_mkhuge-with-arch_make_huge_pte
+++ a/Documentation/mm/arch_pgtable_helpers.rst
@@ -214,7 +214,7 @@ HugeTLB Page Table Helpers
 +---------------------------+--------------------------------------------------+
 | pte_huge                  | Tests a HugeTLB                                  |
 +---------------------------+--------------------------------------------------+
-| pte_mkhuge                | Creates a HugeTLB                                |
+| arch_make_huge_pte        | Creates a HugeTLB                                |
 +---------------------------+--------------------------------------------------+
 | huge_pte_dirty            | Tests a dirty HugeTLB                            |
 +---------------------------+--------------------------------------------------+
--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-replace-pte_mkhuge-with-arch_make_huge_pte
+++ a/mm/debug_vm_pgtable.c
@@ -934,7 +934,7 @@ static void __init hugetlb_basic_tests(s
 #ifdef CONFIG_ARCH_WANT_GENERAL_HUGETLB
 	pte = pfn_pte(args->fixed_pmd_pfn, args->page_prot);
 
-	WARN_ON(!pte_huge(pte_mkhuge(pte)));
+	WARN_ON(!pte_huge(arch_make_huge_pte(pte, PMD_SHIFT, VM_ACCESS_FLAGS)));
 #endif /* CONFIG_ARCH_WANT_GENERAL_HUGETLB */
 }
 #else  /* !CONFIG_HUGETLB_PAGE */
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-debug_vm_pgtable-replace-pte_mkhuge-with-arch_make_huge_pte.patch

