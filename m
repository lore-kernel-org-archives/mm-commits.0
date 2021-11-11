Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26799C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:44:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F5B361208
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:44:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234306AbhKKCrN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:47:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:52284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234310AbhKKCrM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:47:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8739A6103C;
        Thu, 11 Nov 2021 02:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598663;
        bh=qa5c03aGITMIr7tB4p5XuzHGMkbagP8qeY1MS9L4i/0=;
        h=Date:From:To:Subject:From;
        b=ZB0c54iIUwhnvTS/M08anGBc/0JYTJ1hujD9/D+3GIj/DFpsnKTIVeGcLaTg9tB4D
         Ywjub8gPTK2xYERHQdWaqkpv4x+7jrXWhTDGeIEOkrD48KXZsJq+54USXdVMEPueMD
         5AIn0WpsdOtoQ4heC8z3I0rSUqaduMs9rxg8ttqk=
Date:   Wed, 10 Nov 2021 18:44:23 -0800
From:   akpm@linux-foundation.org
To:     benh@kernel.crashing.org, christophe.leroy@csgroup.eu,
        gerald.schaefer@linux.ibm.com, hca@linux.ibm.com,
        mm-commits@vger.kernel.org, paulus@ozlabs.org,
        wangkefeng.wang@huawei.com
Subject:  [merged]
 s390-use-generic-version-of-arch_is_kernel_initmem_freed.patch removed from
 -mm tree
Message-ID: <20211111024423.coX3HO4iG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: s390: use generic version of arch_is_kernel_initmem_freed()
has been removed from the -mm tree.  Its filename was
     s390-use-generic-version-of-arch_is_kernel_initmem_freed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


