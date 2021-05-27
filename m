Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A317AC47082
	for <mm-commits@archiver.kernel.org>; Thu, 27 May 2021 00:43:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74039613C3
	for <mm-commits@archiver.kernel.org>; Thu, 27 May 2021 00:43:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232006AbhE0ApX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 26 May 2021 20:45:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:46872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232416AbhE0ApX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 26 May 2021 20:45:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC650613B0;
        Thu, 27 May 2021 00:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622076230;
        bh=6azAkDvG9ax9QWjOaUTILL3o+vUW6roAcoEYf1/hdfo=;
        h=Date:From:To:Subject:From;
        b=CjtsTi1C4erGuF7O2qtdIUCq89IAjgqXSTS1uV8Af7AgE/2BQZuJ+Wbghz4npOX88
         1iRugP11iIW88xCk4SWjFo84ycVBPX2mGOicCTTE3mbSquo38/n2bV8G45Gu2MzmNY
         bvGfOpRvSaeaTEpYqV7QQ7jdlKUMkqNp8kB3b5F8=
Date:   Wed, 26 May 2021 17:43:49 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, gerald.schaefer@linux.ibm.com,
        gor@linux.ibm.com, hca@linux.ibm.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, tglx@linutronix.de
Subject:  +
 =?US-ASCII?Q?mm-thp-make-arch=5Fenable=5Fsplit=5Fpmd=5Fptlock-dependent-o?=
 =?US-ASCII?Q?n-pgtable=5Flevels-2.patch?= added to -mm tree
Message-ID: <20210527004349.Z7j-MumtT%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/thp: make ARCH_ENABLE_SPLIT_PMD_PTLOCK dependent on PGTABLE_LEVELS > 2
has been added to the -mm tree.  Its filename is
     mm-thp-make-arch_enable_split_pmd_ptlock-dependent-on-pgtable_levels-2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-thp-make-arch_enable_split_pmd_ptlock-dependent-on-pgtable_levels-2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-make-arch_enable_split_pmd_ptlock-dependent-on-pgtable_levels-2.patch

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
Subject: mm/thp: make ARCH_ENABLE_SPLIT_PMD_PTLOCK dependent on PGTABLE_LEVELS > 2

ARCH_ENABLE_SPLIT_PMD_PTLOCK is irrelevant unless there are more than two
page table levels including PMD (also per
Documentation/vm/split_page_table_lock.rst).  Make this dependency
explicit on remaining platforms i.e x86 and s390 where
ARCH_ENABLE_SPLIT_PMD_PTLOCK is subscribed.

Link: https://lkml.kernel.org/r/1622013501-20409-1-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com> # s390
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/Kconfig |    2 +-
 arch/x86/Kconfig  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/s390/Kconfig~mm-thp-make-arch_enable_split_pmd_ptlock-dependent-on-pgtable_levels-2
+++ a/arch/s390/Kconfig
@@ -62,7 +62,7 @@ config S390
 	select ARCH_BINFMT_ELF_STATE
 	select ARCH_ENABLE_MEMORY_HOTPLUG if SPARSEMEM
 	select ARCH_ENABLE_MEMORY_HOTREMOVE
-	select ARCH_ENABLE_SPLIT_PMD_PTLOCK
+	select ARCH_ENABLE_SPLIT_PMD_PTLOCK if PGTABLE_LEVELS > 2
 	select ARCH_HAS_DEBUG_VM_PGTABLE
 	select ARCH_HAS_DEBUG_WX
 	select ARCH_HAS_DEVMEM_IS_ALLOWED
--- a/arch/x86/Kconfig~mm-thp-make-arch_enable_split_pmd_ptlock-dependent-on-pgtable_levels-2
+++ a/arch/x86/Kconfig
@@ -63,7 +63,7 @@ config X86
 	select ARCH_ENABLE_HUGEPAGE_MIGRATION if X86_64 && HUGETLB_PAGE && MIGRATION
 	select ARCH_ENABLE_MEMORY_HOTPLUG if X86_64 || (X86_32 && HIGHMEM)
 	select ARCH_ENABLE_MEMORY_HOTREMOVE if MEMORY_HOTPLUG
-	select ARCH_ENABLE_SPLIT_PMD_PTLOCK if X86_64 || X86_PAE
+	select ARCH_ENABLE_SPLIT_PMD_PTLOCK if (PGTABLE_LEVELS > 2) && (X86_64 || X86_PAE)
 	select ARCH_ENABLE_THP_MIGRATION if X86_64 && TRANSPARENT_HUGEPAGE
 	select ARCH_HAS_ACPI_TABLE_UPGRADE	if ACPI
 	select ARCH_HAS_CACHE_LINE_SIZE
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-debug_vm_pgtable-ensure-thp-availability-via-has_transparent_hugepage.patch
mm-thp-make-alloc_split_ptlocks-dependent-on-use_split_pte_ptlocks.patch
mm-thp-make-arch_enable_split_pmd_ptlock-dependent-on-pgtable_levels-2.patch
mm-define-default-value-for-first_user_address.patch

