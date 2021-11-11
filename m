Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F0FBC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:44:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5719861247
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:44:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234315AbhKKCrM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:47:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:52256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234032AbhKKCrJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:47:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C14361208;
        Thu, 11 Nov 2021 02:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598661;
        bh=lGEE/K9IfJxa9FBO5dbsKE6N+mqkDQ34KIlrJL2S36I=;
        h=Date:From:To:Subject:From;
        b=RtV+8sPvt9ypSBaxFG/ZXMR2SQkx38RLzwInC6aEiS9/8PCzGtls2TK76RUVObl4A
         Lswv4hkHaPRLZD4eihbpELUwTCXH8b+9Rrif5qMSkmZoe/ohijbeWAYn2cndIOv60u
         QjTZ+4nPoYvIivQbNgGBQoz9jh7yYWpVzIHh8lzA=
Date:   Wed, 10 Nov 2021 18:44:21 -0800
From:   akpm@linux-foundation.org
To:     benh@kernel.crashing.org, christophe.leroy@csgroup.eu,
        gerald.schaefer@linux.ibm.com, hca@linux.ibm.com,
        mm-commits@vger.kernel.org, paulus@ozlabs.org,
        wangkefeng.wang@huawei.com
Subject:  [merged]
 powerpc-use-generic-version-of-arch_is_kernel_initmem_freed.patch removed
 from -mm tree
Message-ID: <20211111024421.qLggcFRxh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: use generic version of arch_is_kernel_initmem_freed()
has been removed from the -mm tree.  Its filename was
     powerpc-use-generic-version-of-arch_is_kernel_initmem_freed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are


