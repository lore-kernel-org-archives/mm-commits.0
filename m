Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFF6EC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 11 Oct 2021 20:56:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C053060F4B
	for <mm-commits@archiver.kernel.org>; Mon, 11 Oct 2021 20:56:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234022AbhJKU6o (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 11 Oct 2021 16:58:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:33328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230299AbhJKU6o (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 11 Oct 2021 16:58:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6879560F23;
        Mon, 11 Oct 2021 20:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633985803;
        bh=QHg8dz17yvMiSSCNB6SzSvs+To0LgSwYmj27tfIeMjs=;
        h=Date:From:To:Subject:From;
        b=hzpJqf5lMaeaWP/QLA9qw2+y4wKhby3+5Ir3suA+xd/cCJAqiv1rcgNL5IJG+oHnZ
         GsKlvPAAVLYlkiWIzTq9WcYMym/6dOY2cbixlFKKvZ4lvNyOIHYu3l0fz9hJg83KhP
         AWKPonaaOPyXE4vRdnYhRWm4sKCkmWB5n9JfAnTU=
Date:   Mon, 11 Oct 2021 13:56:42 -0700
From:   akpm@linux-foundation.org
To:     catalin.marinas@arm.com, dvyukov@google.com, lkft@linaro.org,
        mm-commits@vger.kernel.org, naresh.kamboju@linaro.org,
        ryabinin.a.a@gmail.com, sfr@canb.auug.org.au,
        wangkefeng.wang@huawei.com
Subject:  +
 kasan-arm64-fix-pcpu_page_first_chunk-crash-with-kasan_vmalloc-fix.patch
 added to -mm tree
Message-ID: <20211011205642.MrLcZAmUS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kasan: fix redefinition of 'kasan_populate_early_vm_area_shadow'
has been added to the -mm tree.  Its filename is
     kasan-arm64-fix-pcpu_page_first_chunk-crash-with-kasan_vmalloc-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-arm64-fix-pcpu_page_first_chunk-crash-with-kasan_vmalloc-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-arm64-fix-pcpu_page_first_chunk-crash-with-kasan_vmalloc-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
kasan-arm64-fix-pcpu_page_first_chunk-crash-with-kasan_vmalloc-fix.patch
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

