Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE3F8C4167B
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 02:15:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbiLLCPA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 21:15:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbiLLCOQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 21:14:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D374963CA
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 18:14:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82926B80B6F
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 02:14:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43DCBC433EF;
        Mon, 12 Dec 2022 02:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670811247;
        bh=Uq5rbHEmoNe/N27GoLyYCDeS2PxH2e7qpQkgHbypsNs=;
        h=Date:To:From:Subject:From;
        b=dyRHAKK9WxjVIba2efrZsBPBe9WkCr+0m7nDXfm9yF92wPv7wL0EEeMdDpquoxmMK
         Gvg11dI65y/gD5BHOEJYy7FTNJG6Pbn7fe51Vn+9428uwo+iA4CLbPI/rYO8103t6b
         pEEgIOHHMTSeFiAIS0Gn+rgV55hET3MINubYu9Vc=
Date:   Sun, 11 Dec 2022 18:14:06 -0800
To:     mm-commits@vger.kernel.org, zhoumin@loongson.cn, will@kernel.org,
        tsbogend@alpha.franken.de, songmuchun@bytedance.com,
        philmd@linaro.org, peterz@infradead.org, luto@kernel.org,
        lixuefeng@loongson.cn, kernel@xen0n.name, jiaxun.yang@flygoat.com,
        guoren@kernel.org, dinguyen@kernel.org,
        dave.hansen@linux.intel.com, chenhuacai@loongson.cn,
        catalin.marinas@arm.com, arnd@arndb.de, chenfeiyang@loongson.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] loongarch-enable-arch_want_hugetlb_page_optimize_vmemmap.patch removed from -mm tree
Message-Id: <20221212021407.43DCBC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: LoongArch: enable ARCH_WANT_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
has been removed from the -mm tree.  Its filename was
     loongarch-enable-arch_want_hugetlb_page_optimize_vmemmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


