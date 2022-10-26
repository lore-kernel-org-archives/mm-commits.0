Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B837C38A02
	for <mm-commits@archiver.kernel.org>; Wed, 26 Oct 2022 03:31:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232200AbiJZDbX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Oct 2022 23:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232963AbiJZDbM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Oct 2022 23:31:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5322960E3
        for <mm-commits@vger.kernel.org>; Tue, 25 Oct 2022 20:31:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DEA0E61CAF
        for <mm-commits@vger.kernel.org>; Wed, 26 Oct 2022 03:31:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 224A9C433D6;
        Wed, 26 Oct 2022 03:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666755070;
        bh=gP/U/pc9WJcs5lBJChZFRELM84i+fBali3M9c7rhTP4=;
        h=Date:To:From:Subject:From;
        b=bBYnFwe6Lf4ZMdFSxN+SAIUUaBEZPFNLy4GE0TIKKo2NEqYwnfXyN3Sqv8jdnNfg6
         v/0eQSgtL/J2nWak7mbgahfX6F+/w/m7+0UqZM4gNruKcYdjVf0tD6g1YDpQVxAi4P
         NfccFdQ/snbzktdQ2/xMH4SHOZ838+uSZoFNtvEk=
Date:   Tue, 25 Oct 2022 20:31:09 -0700
To:     mm-commits@vger.kernel.org, xueshuai@linux.alibaba.com,
        willy@infradead.org, npiggin@gmail.com, naoya.horiguchi@nec.com,
        mpe@ellerman.id.au, linmiaohe@huawei.com, dan.j.williams@intel.com,
        christophe.leroy@csgroup.eu, tony.luck@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hwpoison-when-copy-on-write-hits-poison-take-page-offline.patch added to mm-unstable branch
Message-Id: <20221026033110.224A9C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hwpoison: when copy-on-write hits poison, take page offline
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hwpoison-when-copy-on-write-hits-poison-take-page-offline.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hwpoison-when-copy-on-write-hits-poison-take-page-offline.patch

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
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Shuai Xue <xueshuai@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/mm.h~mm-hwpoison-when-copy-on-write-hits-poison-take-page-offline
+++ a/include/linux/mm.h
@@ -3228,7 +3228,6 @@ enum mf_flags {
 int mf_dax_kill_procs(struct address_space *mapping, pgoff_t index,
 		      unsigned long count, int mf_flags);
 extern int memory_failure(unsigned long pfn, int flags);
-extern void memory_failure_queue(unsigned long pfn, int flags);
 extern void memory_failure_queue_kick(int cpu);
 extern int unpoison_memory(unsigned long pfn);
 extern int sysctl_memory_failure_early_kill;
@@ -3237,11 +3236,16 @@ extern void shake_page(struct page *p);
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
@@ -2817,8 +2817,10 @@ static inline int __wp_page_copy_user(st
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

mm-hwpoison-try-to-recover-from-copy-on-write-faults.patch
mm-hwpoison-when-copy-on-write-hits-poison-take-page-offline.patch

