Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94EC1C433FE
	for <mm-commits@archiver.kernel.org>; Sat,  7 May 2022 17:56:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386726AbiEGR7w (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 7 May 2022 13:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386662AbiEGR7u (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 7 May 2022 13:59:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 888872A258
        for <mm-commits@vger.kernel.org>; Sat,  7 May 2022 10:56:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01FF861377
        for <mm-commits@vger.kernel.org>; Sat,  7 May 2022 17:56:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56A18C385A6;
        Sat,  7 May 2022 17:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651946161;
        bh=a2MRXWiNqnHWy+qfbIcr2K0Cwh8eVpsuwG5uCP+A2+g=;
        h=Date:To:From:Subject:From;
        b=DAL5fsdTjJDRrKSpHSDEUim7rVYJIwwMyTLPzqxLsd4WW/8rZryeL7S53ROpm0v+g
         ua4biU2fclgPg2l+1TslpjphFBdiJudUZRGQvZKji/+Z4O6soQJYor2qUgT9RPweo8
         y1nH1qFklvAotMbejKG5L04ejAV8fc1UaDVvOWDQ=
Date:   Sat, 07 May 2022 10:56:00 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        wangkefeng.wang@huawei.com, paul.walmsley@sifive.com,
        pasha.tatashin@soleen.com, palmer@dabbelt.com, mingo@redhat.com,
        hpa@zytor.com, dave.hansen@linux.intel.com,
        catalin.marinas@arm.com, bp@alien8.de, anshuman.khandual@arm.com,
        tongtiangen@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-__have_arch_ptep_clear-in-pgtableh.patch added to mm-unstable branch
Message-Id: <20220507175601.56A18C385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove __HAVE_ARCH_PTEP_CLEAR in pgtable.h
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-__have_arch_ptep_clear-in-pgtableh.patch

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
From: Tong Tiangen <tongtiangen@huawei.com>
Subject: mm: remove __HAVE_ARCH_PTEP_CLEAR in pgtable.h

Currently, there is no architecture definition __HAVE_ARCH_PTEP_CLEAR,
Generic ptep_clear() is the only definition for all architecture, So drop
the "#ifndef __HAVE_ARCH_PTEP_CLEAR".

Link: https://lkml.kernel.org/r/20220507110114.4128854-5-tongtiangen@huawei.com
Signed-off-by: Tong Tiangen <tongtiangen@huawei.com>
Suggested-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/linux/pgtable.h~mm-remove-__have_arch_ptep_clear-in-pgtableh
+++ a/include/linux/pgtable.h
@@ -272,13 +272,11 @@ static inline pte_t ptep_get_and_clear(s
 }
 #endif
 
-#ifndef __HAVE_ARCH_PTEP_CLEAR
 static inline void ptep_clear(struct mm_struct *mm, unsigned long addr,
 			      pte_t *ptep)
 {
 	ptep_get_and_clear(mm, addr, ptep);
 }
-#endif
 
 #ifndef __HAVE_ARCH_PTEP_GET
 static inline pte_t ptep_get(pte_t *ptep)
_

Patches currently in -mm which might be from tongtiangen@huawei.com are

mm-page_table_check-using-pxd_size-instead-of-pxd_page_size.patch
mm-page_table_check-add-hooks-to-public-helpers.patch
mm-remove-__have_arch_ptep_clear-in-pgtableh.patch
riscv-mm-enable-arch_supports_page_table_check.patch

