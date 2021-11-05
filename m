Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92ABFC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:40:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82EBE6126A
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:40:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232810AbhKEUn1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:43:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:38118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232269AbhKEUn1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:43:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E63FC61262;
        Fri,  5 Nov 2021 20:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144847;
        bh=xVtEAAcaucpAD7AVdd2plSCAMlOUcuPZqZOvzfzdmoE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=fxdccbG6+eK0gIwoT8Lso4FQL8vu2KIooCwOqc2egO7O0jpMQKrpj8+RCS3dVnCCZ
         DzvaFVVcfm8j+8z08vGvzwVarsFAMWtvNdr8Vr6FsMtNu2RI6IxFSgxubgdTHbAVAT
         GawHk+gyBlyvSXwIC9UxRHrg3XZ1wjQu4YwlMN0c=
Date:   Fri, 05 Nov 2021 13:40:46 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, benh@kernel.crashing.org,
        christophe.leroy@csgroup.eu, gerald.schaefer@linux.ibm.com,
        hca@linux.ibm.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        paulus@ozlabs.org, torvalds@linux-foundation.org,
        wangkefeng.wang@huawei.com
Subject:  [patch 117/262] powerpc: use generic version of
 arch_is_kernel_initmem_freed()
Message-ID: <20211105204046.cC6SA8eua%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: powerpc: use generic version of arch_is_kernel_initmem_freed()

Generic version of arch_is_kernel_initmem_freed() now does the same as
powerpc version.

Remove the powerpc version.

Link: https://lkml.kernel.org/r/c53764eb45d41491e2b21da2e7812239897dbebb.1633001016.git.christophe.leroy@csgroup.eu
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/sections.h |   13 -------------
 1 file changed, 13 deletions(-)

--- a/arch/powerpc/include/asm/sections.h~powerpc-use-generic-version-of-arch_is_kernel_initmem_freed
+++ a/arch/powerpc/include/asm/sections.h
@@ -6,21 +6,8 @@
 #include <linux/elf.h>
 #include <linux/uaccess.h>
 
-#define arch_is_kernel_initmem_freed arch_is_kernel_initmem_freed
-
 #include <asm-generic/sections.h>
 
-extern bool init_mem_is_free;
-
-static inline int arch_is_kernel_initmem_freed(unsigned long addr)
-{
-	if (!init_mem_is_free)
-		return 0;
-
-	return addr >= (unsigned long)__init_begin &&
-		addr < (unsigned long)__init_end;
-}
-
 extern char __head_end[];
 
 #ifdef __powerpc64__
_
