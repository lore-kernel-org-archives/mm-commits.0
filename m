Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30818C47088
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:00:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbiLAAAZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:00:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbiLAAAS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:00:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 374AA6DFEC
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:00:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5044B81D80
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4663C433D7;
        Thu,  1 Dec 2022 00:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852814;
        bh=cB8ZMGkfcVV9tPycbPhUF0oPWDSwHTv3N6mhUNfD+gI=;
        h=Date:To:From:Subject:From;
        b=PTjMToCaF+dIdK/2O2He/JDG0mmRMVWczRu8k0w0t4eHATDg8Cnh1Ck+zXnpRl9wW
         RwNRFVTKBeiqrcwctnkQtxuuw7hUwbeoFy35yrJOcAK4DEvpuk/VLd1ygdVhDTOFYi
         kNDhU+nUQ64u7UwEnOr5/EKiHD15beCXCS/4doiI=
Date:   Wed, 30 Nov 2022 16:00:13 -0800
To:     mm-commits@vger.kernel.org, xueshuai@linux.alibaba.com,
        willy@infradead.org, npiggin@gmail.com, naoya.horiguchi@nec.com,
        mpe@ellerman.id.au, linmiaohe@huawei.com, dan.j.williams@intel.com,
        christophe.leroy@csgroup.eu, tony.luck@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hwpoison-when-copy-on-write-hits-poison-take-page-offline.patch removed from -mm tree
Message-Id: <20221201000014.A4663C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm, hwpoison: when copy-on-write hits poison, take page offline
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-when-copy-on-write-hits-poison-take-page-offline.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tony Luck <tony.luck@intel.com>
Subject: mm, hwpoison: when copy-on-write hits poison, take page offline
Date: Fri, 21 Oct 2022 13:01:20 -0700

Cannot call memory_failure() directly from the fault handler because
mmap_lock (and others) are held.

It is important, but not urgent, to mark the source page as h/w poisoned
and unmap it from other tasks.

Use memory_failure_queue() to request a call to memory_failure() for the
page with the error.

Also provide a stub version for CONFIG_MEMORY_FAILURE=n

Link: https://lkml.kernel.org/r/20221021200120.175753-3-tony.luck@intel.com
Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Shuai Xue <xueshuai@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    6 +++++-
 mm/memory.c        |    4 +++-
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/include/linux/mm.h~mm-hwpoison-when-copy-on-write-hits-poison-take-page-offline
+++ a/include/linux/mm.h
@@ -3280,7 +3280,6 @@ enum mf_flags {
 int mf_dax_kill_procs(struct address_space *mapping, pgoff_t index,
 		      unsigned long count, int mf_flags);
 extern int memory_failure(unsigned long pfn, int flags);
-extern void memory_failure_queue(unsigned long pfn, int flags);
 extern void memory_failure_queue_kick(int cpu);
 extern int unpoison_memory(unsigned long pfn);
 extern int sysctl_memory_failure_early_kill;
@@ -3289,11 +3288,16 @@ extern void shake_page(struct page *p);
 extern atomic_long_t num_poisoned_pages __read_mostly;
 extern int soft_offline_page(unsigned long pfn, int flags);
 #ifdef CONFIG_MEMORY_FAILURE
+extern void memory_failure_queue(unsigned long pfn, int flags);
 extern int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
 					bool *migratable_cleared);
 void num_poisoned_pages_inc(unsigned long pfn);
 void num_poisoned_pages_sub(unsigned long pfn, long i);
 #else
+static inline void memory_failure_queue(unsigned long pfn, int flags)
+{
+}
+
 static inline int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
 					bool *migratable_cleared)
 {
--- a/mm/memory.c~mm-hwpoison-when-copy-on-write-hits-poison-take-page-offline
+++ a/mm/memory.c
@@ -2816,8 +2816,10 @@ static inline int __wp_page_copy_user(st
 	unsigned long addr = vmf->address;
 
 	if (likely(src)) {
-		if (copy_mc_user_highpage(dst, src, addr, vma))
+		if (copy_mc_user_highpage(dst, src, addr, vma)) {
+			memory_failure_queue(page_to_pfn(src), 0);
 			return -EHWPOISON;
+		}
 		return 0;
 	}
 
_

Patches currently in -mm which might be from tony.luck@intel.com are


