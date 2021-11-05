Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEE27C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:40:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C830861262
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:40:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233055AbhKEUnb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:43:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:38164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232269AbhKEUna (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:43:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F226E6126A;
        Fri,  5 Nov 2021 20:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144850;
        bh=qx+wnyrQEAhzRmfure/hImz/Fd4gS4JblO0Wae+xy04=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=kFaEeiFtkBoL0sevdIwDsEVOzAcbsQkIZmpVIw1o57F0ocSYMIXgvkD/Wy9BJYM4H
         Hc3wP7yuocf2smtQooKMHOSdLM27/MruO5XdCoQvQuwz+sAQVUI+zHMwPAV3fJ502J
         sRVz+ttI3RPYc4Np53Xa+edASB/6v8goieFWxKus=
Date:   Fri, 05 Nov 2021 13:40:49 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, benh@kernel.crashing.org,
        christophe.leroy@csgroup.eu, gerald.schaefer@linux.ibm.com,
        hca@linux.ibm.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        paulus@ozlabs.org, torvalds@linux-foundation.org,
        wangkefeng.wang@huawei.com
Subject:  [patch 118/262] s390: use generic version of
 arch_is_kernel_initmem_freed()
Message-ID: <20211105204049.JWzd6dfQk%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
