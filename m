Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B40EC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:25:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383859AbiEMTZE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383869AbiEMTXQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:23:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A6EC30F43
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:22:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1C5EB83193
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:22:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52AC5C34113;
        Fri, 13 May 2022 19:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469731;
        bh=/2FYF9QK/2bR8vnRe4nQ/SeLy+sSqMq+KgTjJPTSq4s=;
        h=Date:To:From:Subject:From;
        b=vI+iQ9ZuIbMp2bKGjgRMUCcHX6SUdWroDgYXV+3hyjoo2e+i2xxKtAGXxe045NC46
         eYjBmlJbioBfc2+B1ip3om0w8oVXSgGiKInOWoe/q3oUOStURlU7U81SJyDg5+3TdH
         WsyuLBkpx6RH4hCR3Lq0dUKVNk0/0unU6gOrl7lk=
Date:   Fri, 13 May 2022 12:22:10 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        wangkefeng.wang@huawei.com, paul.walmsley@sifive.com,
        pasha.tatashin@soleen.com, palmer@dabbelt.com, mingo@redhat.com,
        hpa@zytor.com, dave.hansen@linux.intel.com,
        catalin.marinas@arm.com, bp@alien8.de, anshuman.khandual@arm.com,
        tongtiangen@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-__have_arch_ptep_clear-in-pgtableh.patch removed from -mm tree
Message-Id: <20220513192211.52AC5C34113@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: remove __HAVE_ARCH_PTEP_CLEAR in pgtable.h
has been removed from the -mm tree.  Its filename was
     mm-remove-__have_arch_ptep_clear-in-pgtableh.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


