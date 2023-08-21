Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF922EE49AA
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:42:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbjHUUmH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbjHUUlE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:41:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7228CCF3
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:40:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07367647D7
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:40:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B2D4C433C7;
        Mon, 21 Aug 2023 20:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650444;
        bh=Kfx5q20HoShKRHZ4jXRkSBaU59qYHuYVVeuLgwkvVKQ=;
        h=Date:To:From:Subject:From;
        b=lgp7R7ZSmm4y9YMQl1ptH8uM7O2CpynM5mwZAiU+3hV0RSgpK+Ve3ofLZcxeThBF9
         mbyYzi2/veagLzYXVYaomTnlFHga4ddSp8YU8L5Hlxg6RdRbcZooZmNY9eWLkucC9j
         NSAZD9Q2YZcy0X8ZkDM+hwA/3NaT1WWqO/QHTiYw=
Date:   Mon, 21 Aug 2023 13:40:43 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tomas.mudrunka@gmail.com, rppt@kernel.org,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memtest-convert-to-memtest_report_meminfo.patch removed from -mm tree
Message-Id: <20230821204044.5B2D4C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memtest: convert to memtest_report_meminfo()
has been removed from the -mm tree.  Its filename was
     mm-memtest-convert-to-memtest_report_meminfo.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memtest: convert to memtest_report_meminfo()
Date: Tue, 8 Aug 2023 11:33:59 +0800

It is better to not expose too many internal variables of memtest,
add a helper memtest_report_meminfo() to show memtest results.

Link: https://lkml.kernel.org/r/20230808033359.174986-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
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


