Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B44CAC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 19:57:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97DB36103D
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 19:57:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348268AbhIXT70 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Sep 2021 15:59:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:42860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348267AbhIXT7X (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 24 Sep 2021 15:59:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2206610EA;
        Fri, 24 Sep 2021 19:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632513469;
        bh=w1KPq8gGC/u5HGFPLvQaYKitO9FvffvLZVde3fxiMvM=;
        h=Date:From:To:Subject:From;
        b=WWDnA4V/mQnE7Vvy/vfthqzZrTq/sORr3wlTFBNTAZNLhDTorgwITo2KM+LR8Gx9d
         u0GxDs0RTxJ0CBaGGbm0jj0x5BNc6ul47+5PFM7IE1ZXK69MD4ZAm135biM/YroYMs
         8S5qBFCjjPcMgojtvxwoExNoCqedrYrdoAOCPj+0=
Date:   Fri, 24 Sep 2021 12:57:49 -0700
From:   akpm@linux-foundation.org
To:     benh@kernel.crashing.org, christophe.leroy@csgroup.eu,
        gerald.schaefer@linux.ibm.com, mm-commits@vger.kernel.org,
        paulus@ozlabs.org
Subject:  +
 s390-use-generic-version-of-arch_is_kernel_initmem_freed.patch added to -mm
 tree
Message-ID: <20210924195749.kQAhnn6lj%akpm@linux-foundation.org>
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

Generic version of arch_is_kernel_initmem_freed() now does the same as
s390 version.

Remove the s390 version.

Link: https://lkml.kernel.org/r/8e7f31b51ce62c9c495f71845f29a6d825d6e852.1632491308.git.christophe.leroy@csgroup.eu
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
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

mm-make-generic-arch_is_kernel_initmem_freed-do-what-it-says.patch
powerpc-use-generic-version-of-arch_is_kernel_initmem_freed.patch
s390-use-generic-version-of-arch_is_kernel_initmem_freed.patch

