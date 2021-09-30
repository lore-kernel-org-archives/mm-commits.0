Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B817C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 30 Sep 2021 20:42:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02CE961994
	for <mm-commits@archiver.kernel.org>; Thu, 30 Sep 2021 20:42:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbhI3UoE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Sep 2021 16:44:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:48054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348276AbhI3UoE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 30 Sep 2021 16:44:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D552E61881;
        Thu, 30 Sep 2021 20:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633034541;
        bh=P9Irb5T6RGTAvPibGYSJtjbWlr2u/8c+lb9M6RqAoMs=;
        h=Date:From:To:Subject:From;
        b=lneZ/5CjCpyvBVuEHr+sXf+3hgjjnDNo2hZMTlep/mteuuvO8mY7pz1YFnDKnUCep
         KsKnm9bh+2ilzLBkZB+FPBl2TSMXoHGcoSKBxQa7wNnGOe4nHL7yfFKWLlbCDE/Vib
         e0+swB6/RWIDsQiXe9A0shLO6RD8gN8Pf2rF5D7w=
Date:   Thu, 30 Sep 2021 13:42:20 -0700
From:   akpm@linux-foundation.org
To:     benh@kernel.crashing.org, christophe.leroy@csgroup.eu,
        gerald.schaefer@linux.ibm.com, hca@linux.ibm.com,
        mm-commits@vger.kernel.org, paulus@ozlabs.org,
        wangkefeng.wang@huawei.com
Subject:  +
 s390-use-generic-version-of-arch_is_kernel_initmem_freed.patch added to -mm
 tree
Message-ID: <20210930204220.0ENuTDHW9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: s390: use generic version of arch_is_kernel_initmem_freed()
has been added to the -mm tree.  Its filename is
     s390-use-generic-version-of-arch_is_kernel_initmem_freed.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/s390-use-generic-version-of-arch_is_kernel_initmem_freed.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/s390-use-generic-version-of-arch_is_kernel_initmem_freed.patch

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
Subject: s390: use generic version of arch_is_kernel_initmem_freed()

Generic version of arch_is_kernel_initmem_freed() now does the same
as s390 version.

Remove the s390 version.

Link: https://lkml.kernel.org/r/b6feb5dfe611a322de482762fc2df3a9eece70c7.1633001016.git.christophe.leroy@csgroup.eu
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/sections.h |   12 ------------
 arch/s390/mm/init.c              |    3 ---
 2 files changed, 15 deletions(-)

--- a/arch/s390/include/asm/sections.h~s390-use-generic-version-of-arch_is_kernel_initmem_freed
+++ a/arch/s390/include/asm/sections.h
@@ -2,20 +2,8 @@
 #ifndef _S390_SECTIONS_H
 #define _S390_SECTIONS_H
 
-#define arch_is_kernel_initmem_freed arch_is_kernel_initmem_freed
-
 #include <asm-generic/sections.h>
 
-extern bool initmem_freed;
-
-static inline int arch_is_kernel_initmem_freed(unsigned long addr)
-{
-	if (!initmem_freed)
-		return 0;
-	return addr >= (unsigned long)__init_begin &&
-	       addr < (unsigned long)__init_end;
-}
-
 /*
  * .boot.data section contains variables "shared" between the decompressor and
  * the decompressed kernel. The decompressor will store values in them, and
--- a/arch/s390/mm/init.c~s390-use-generic-version-of-arch_is_kernel_initmem_freed
+++ a/arch/s390/mm/init.c
@@ -58,8 +58,6 @@ unsigned long empty_zero_page, zero_page
 EXPORT_SYMBOL(empty_zero_page);
 EXPORT_SYMBOL(zero_page_mask);
 
-bool initmem_freed;
-
 static void __init setup_zero_pages(void)
 {
 	unsigned int order;
@@ -214,7 +212,6 @@ void __init mem_init(void)
 
 void free_initmem(void)
 {
-	initmem_freed = true;
 	__set_memory((unsigned long)_sinittext,
 		     (unsigned long)(_einittext - _sinittext) >> PAGE_SHIFT,
 		     SET_MEMORY_RW | SET_MEMORY_NX);
_

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are

mm-create-a-new-system-state-and-fix-core_kernel_text.patch
mm-make-generic-arch_is_kernel_initmem_freed-do-what-it-says.patch
powerpc-use-generic-version-of-arch_is_kernel_initmem_freed.patch
s390-use-generic-version-of-arch_is_kernel_initmem_freed.patch

