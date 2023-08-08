Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97BC5C001B0
	for <mm-commits@archiver.kernel.org>; Tue,  8 Aug 2023 19:56:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232662AbjHHT4I (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Aug 2023 15:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232626AbjHHTzu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Aug 2023 15:55:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 752D563D6E
        for <mm-commits@vger.kernel.org>; Tue,  8 Aug 2023 11:08:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B8E0629AB
        for <mm-commits@vger.kernel.org>; Tue,  8 Aug 2023 18:08:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 630AFC433C7;
        Tue,  8 Aug 2023 18:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691518125;
        bh=igSzUVn2BRlhutrRNvCe9510gZIKK8Og3xAII/5sGIM=;
        h=Date:To:From:Subject:From;
        b=YLmqwWkKLr1FxltgaHgTsqBayv4zLRUMjfwMv1d8CKHBFjuNHebTG10ZlI8ZlRMlN
         APk/URjDrkgyr79QOV6x5UHzKYdH7ypAQr76NQbIeJVnLOLo7yNu7Hy9hicjG0h/xf
         BGr8ERyW2n0wnxjtMZYit7LX97x1v6X42UDuO2eI=
Date:   Tue, 08 Aug 2023 11:08:44 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tomas.mudrunka@gmail.com, rppt@kernel.org,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memtest-convert-to-memtest_report_meminfo.patch added to mm-unstable branch
Message-Id: <20230808180845.630AFC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memtest: convert to memtest_report_meminfo()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memtest-convert-to-memtest_report_meminfo.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memtest-convert-to-memtest_report_meminfo.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memtest: convert to memtest_report_meminfo()
Date: Tue, 8 Aug 2023 11:33:59 +0800

It is better to not expose too many internal variables of memtest,
add a helper memtest_report_meminfo() to show memtest results.

Link: https://lkml.kernel.org/r/20230808033359.174986-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Tomas Mudrunka <tomas.mudrunka@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/meminfo.c        |   12 +-----------
 include/linux/memblock.h |   10 ++++------
 mm/memtest.c             |   22 ++++++++++++++++++++--
 3 files changed, 25 insertions(+), 19 deletions(-)

--- a/fs/proc/meminfo.c~mm-memtest-convert-to-memtest_report_meminfo
+++ a/fs/proc/meminfo.c
@@ -133,17 +133,7 @@ static int meminfo_proc_show(struct seq_
 	show_val_kb(m, "VmallocChunk:   ", 0ul);
 	show_val_kb(m, "Percpu:         ", pcpu_nr_pages());
 
-#ifdef CONFIG_MEMTEST
-	if (early_memtest_done) {
-		unsigned long early_memtest_bad_size_kb;
-
-		early_memtest_bad_size_kb = early_memtest_bad_size>>10;
-		if (early_memtest_bad_size && !early_memtest_bad_size_kb)
-			early_memtest_bad_size_kb = 1;
-		/* When 0 is reported, it means there actually was a successful test */
-		seq_printf(m, "EarlyMemtestBad:   %5lu kB\n", early_memtest_bad_size_kb);
-	}
-#endif
+	memtest_report_meminfo(m);
 
 #ifdef CONFIG_MEMORY_FAILURE
 	seq_printf(m, "HardwareCorrupted: %5lu kB\n",
--- a/include/linux/memblock.h~mm-memtest-convert-to-memtest_report_meminfo
+++ a/include/linux/memblock.h
@@ -594,13 +594,11 @@ extern int hashdist;		/* Distribute hash
 #endif
 
 #ifdef CONFIG_MEMTEST
-extern phys_addr_t early_memtest_bad_size;	/* Size of faulty ram found by memtest */
-extern bool early_memtest_done;			/* Was early memtest done? */
-extern void early_memtest(phys_addr_t start, phys_addr_t end);
+void early_memtest(phys_addr_t start, phys_addr_t end);
+void memtest_report_meminfo(struct seq_file *m);
 #else
-static inline void early_memtest(phys_addr_t start, phys_addr_t end)
-{
-}
+static inline void early_memtest(phys_addr_t start, phys_addr_t end) { }
+static inline void memtest_report_meminfo(struct seq_file *m) { }
 #endif
 
 
--- a/mm/memtest.c~mm-memtest-convert-to-memtest_report_meminfo
+++ a/mm/memtest.c
@@ -3,9 +3,10 @@
 #include <linux/types.h>
 #include <linux/init.h>
 #include <linux/memblock.h>
+#include <linux/seq_file.h>
 
-bool early_memtest_done;
-phys_addr_t early_memtest_bad_size;
+static bool early_memtest_done;
+static phys_addr_t early_memtest_bad_size;
 
 static u64 patterns[] __initdata = {
 	/* The first entry has to be 0 to leave memtest with zeroed memory */
@@ -117,3 +118,20 @@ void __init early_memtest(phys_addr_t st
 		do_one_pass(patterns[idx], start, end);
 	}
 }
+
+void memtest_report_meminfo(struct seq_file *m)
+{
+	unsigned long early_memtest_bad_size_kb;
+
+	if (!IS_ENABLED(CONFIG_PROC_FS))
+		return;
+
+	if (!early_memtest_done)
+		return;
+
+	early_memtest_bad_size_kb = early_memtest_bad_size >> 10;
+	if (early_memtest_bad_size && !early_memtest_bad_size_kb)
+		early_memtest_bad_size_kb = 1;
+	/* When 0 is reported, it means there actually was a successful test */
+	seq_printf(m, "EarlyMemtestBad:   %5lu kB\n", early_memtest_bad_size_kb);
+}
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-remove-arguments-of-show_mem.patch
mm-make-show_free_areas-static.patch
mm-factor-out-vma-stack-and-heap-checks.patch
drm-amdkfd-use-vma_is_initial_stack-and-vma_is_initial_heap.patch
selinux-use-vma_is_initial_stack-and-vma_is_initial_heap.patch
perf-core-use-vma_is_initial_stack-and-vma_is_initial_heap.patch
mm-hugetlb-use-flush_hugetlb_tlb_range-in-move_hugetlb_page_tables.patch
arm64-hugetlb-enable-__have_arch_flush_hugetlb_tlb_range.patch
mm-memtest-convert-to-memtest_report_meminfo.patch

