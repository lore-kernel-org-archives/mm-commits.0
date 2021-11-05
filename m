Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18BCDC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 18:37:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E52A2604DA
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 18:37:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232395AbhKESjv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 14:39:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:48312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230291AbhKESju (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 14:39:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8EADB60D07;
        Fri,  5 Nov 2021 18:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636137430;
        bh=0ZaZFP1PBWzc8IOjcoloon0NAJTVTbOeQdvwzf5gI0U=;
        h=Date:From:To:Subject:From;
        b=a6EhvQWDkPZrj+Ferqme9uCvSco3QPzj3x7+VCLnLTivtGdreFC35PM8p6npzoDsR
         4rS+FfRn81VLT9gRGrYMBxTkODdDXtMCAzIosywG5WP833rin9CoMF2SVvkWPR1MJp
         2rKsglByusIH6vUN7odownIy4DNekS04PupT61EA=
Date:   Fri, 05 Nov 2021 11:37:10 -0700
From:   akpm@linux-foundation.org
To:     catalin.marinas@arm.com, dvyukov@google.com, lkft@linaro.org,
        mm-commits@vger.kernel.org, naresh.kamboju@linaro.org,
        ryabinin.a.a@gmail.com, sfr@canb.auug.org.au,
        wangkefeng.wang@huawei.com
Subject:  [folded-merged]
 kasan-arm64-fix-pcpu_page_first_chunk-crash-with-kasan_vmalloc-fix.patch
 removed from -mm tree
Message-ID: <20211105183710.M3zm5x1g6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kasan: fix redefinition of 'kasan_populate_early_vm_area_shadow'
has been removed from the -mm tree.  Its filename was
     kasan-arm64-fix-pcpu_page_first_chunk-crash-with-kasan_vmalloc-fix.patch

This patch was dropped because it was folded into kasan-arm64-fix-pcpu_page_first_chunk-crash-with-kasan_vmalloc.patch

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: kasan: fix redefinition of 'kasan_populate_early_vm_area_shadow'

Move kasan_populate_early_vm_area_shadow() from mm/kasan/init.c to
mm/kasan/shadow.c, make it under CONFIG_KASAN_VMALLOC to fix the
redefinition issue.

Link: https://lkml.kernel.org/r/20211011123211.3936196-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: resh Kamboju <naresh.kamboju@linaro.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/init.c   |    5 -----
 mm/kasan/shadow.c |    5 +++++
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/mm/kasan/init.c~kasan-arm64-fix-pcpu_page_first_chunk-crash-with-kasan_vmalloc-fix
+++ a/mm/kasan/init.c
@@ -279,11 +279,6 @@ int __ref kasan_populate_early_shadow(co
 	return 0;
 }
 
-void __init __weak kasan_populate_early_vm_area_shadow(void *start,
-						       unsigned long size)
-{
-}
-
 static void kasan_free_pte(pte_t *pte_start, pmd_t *pmd)
 {
 	pte_t *pte;
--- a/mm/kasan/shadow.c~kasan-arm64-fix-pcpu_page_first_chunk-crash-with-kasan_vmalloc-fix
+++ a/mm/kasan/shadow.c
@@ -254,6 +254,11 @@ core_initcall(kasan_memhotplug_init);
 
 #ifdef CONFIG_KASAN_VMALLOC
 
+void __init __weak kasan_populate_early_vm_area_shadow(void *start,
+						       unsigned long size)
+{
+}
+
 static int kasan_populate_vmalloc_pte(pte_t *ptep, unsigned long addr,
 				      void *unused)
 {
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

slub-add-back-check-for-free-nonslab-objects.patch
vmalloc-choose-a-better-start-address-in-vm_area_register_early.patch
arm64-support-page-mapping-percpu-first-chunk-allocator.patch
kasan-arm64-fix-pcpu_page_first_chunk-crash-with-kasan_vmalloc.patch
mm-nommu-kill-arch_get_unmapped_area.patch
kallsyms-remove-arch-specific-text-and-data-check.patch
kallsyms-fix-address-checks-for-kernel-related-range.patch
sections-move-and-rename-core_kernel_data-to-is_kernel_core_data.patch
sections-move-is_kernel_inittext-into-sectionsh.patch
x86-mm-rename-__is_kernel_text-to-is_x86_32_kernel_text.patch
sections-provide-internal-__is_kernel-and-__is_kernel_text-helper.patch
mm-kasan-use-is_kernel-helper.patch
extable-use-is_kernel_text-helper.patch
powerpc-mm-use-core_kernel_text-helper.patch
microblaze-use-is_kernel_text-helper.patch
alpha-use-is_kernel_text-helper.patch

