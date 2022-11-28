Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68A27C4321E
	for <mm-commits@archiver.kernel.org>; Mon, 28 Nov 2022 23:10:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234669AbiK1XKl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Nov 2022 18:10:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234628AbiK1XK1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Nov 2022 18:10:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3175D2DABA
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2022 15:10:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE5D5614DE
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2022 23:10:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 543ACC433C1;
        Mon, 28 Nov 2022 23:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669677024;
        bh=QKXBOlXyKMYfa2Y53yuLpSJo/qzcFbggslqmj3SAsL8=;
        h=Date:To:From:Subject:From;
        b=B4XMExk84K3gEKoW/znXcLIBrTjTBn1A4PH3tL3nhKlNZAS6AknmT+oMVgPtH7BLD
         zDr2H7Q2NqkL6HXVx7ouHm67MjIRrjgIY+iVjF1C3IyAD+6YYgi8jJPYxOge48n4Nq
         Ks0Ys1ziqwGX7YyzZoMuyTj70X+YHbMw170m80+E=
Date:   Mon, 28 Nov 2022 15:10:23 -0800
To:     mm-commits@vger.kernel.org, zhoumin@loongson.cn, will@kernel.org,
        tsbogend@alpha.franken.de, songmuchun@bytedance.com,
        philmd@linaro.org, peterz@infradead.org, luto@kernel.org,
        lixuefeng@loongson.cn, kernel@xen0n.name, jiaxun.yang@flygoat.com,
        guoren@kernel.org, dinguyen@kernel.org,
        dave.hansen@linux.intel.com, chenhuacai@loongson.cn,
        catalin.marinas@arm.com, arnd@arndb.de, chenfeiyang@loongson.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + loongarch-enable-arch_want_hugetlb_page_optimize_vmemmap.patch added to mm-unstable branch
Message-Id: <20221128231024.543ACC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: LoongArch: enable ARCH_WANT_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
has been added to the -mm mm-unstable branch.  Its filename is
     loongarch-enable-arch_want_hugetlb_page_optimize_vmemmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/loongarch-enable-arch_want_hugetlb_page_optimize_vmemmap.patch

This patch will later appear in the mm-unstable branch at
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
From: Feiyang Chen <chenfeiyang@loongson.cn>
Subject: LoongArch: enable ARCH_WANT_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
Date: Thu, 27 Oct 2022 20:52:53 +0800

The feature of minimizing overhead of struct page associated with each
HugeTLB page is implemented on x86_64.  However, the infrastructure of
this feature is already there, so just select ARCH_WANT_HUGETLB_PAGE_
OPTIMIZE_VMEMMAP is enough to enable this feature for LoongArch.

Link: https://lkml.kernel.org/r/20221027125253.3458989-5-chenhuacai@loongson.cn
Signed-off-by: Feiyang Chen <chenfeiyang@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Acked-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Guo Ren <guoren@kernel.org>
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: Min Zhou <zhoumin@loongson.cn>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Will Deacon <will@kernel.org>
Cc: Xuefeng Li <lixuefeng@loongson.cn>
Cc: Xuerui Wang <kernel@xen0n.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/loongarch/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/loongarch/Kconfig~loongarch-enable-arch_want_hugetlb_page_optimize_vmemmap
+++ a/arch/loongarch/Kconfig
@@ -52,6 +52,7 @@ config LOONGARCH
 	select ARCH_USE_QUEUED_RWLOCKS
 	select ARCH_USE_QUEUED_SPINLOCKS
 	select ARCH_WANT_DEFAULT_TOPDOWN_MMAP_LAYOUT
+	select ARCH_WANT_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 	select ARCH_WANT_LD_ORPHAN_WARN
 	select ARCH_WANTS_NO_INSTR
 	select BUILDTIME_TABLE_SORT
_

Patches currently in -mm which might be from chenfeiyang@loongson.cn are

mipsloongarchnios2-adjust-prototypes-of-pd_init.patch
loongarch-add-sparse-memory-vmemmap-support.patch
mm-sparse-vmemmap-generalise-vmemmap_populate_hugepages.patch
loongarch-enable-arch_want_hugetlb_page_optimize_vmemmap.patch

