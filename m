Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28F44C7619A
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:47:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235068AbjDFCrv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:47:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234704AbjDFCqa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:46:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1986F977F
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:45:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A255B6421A
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:45:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 079BEC433D2;
        Thu,  6 Apr 2023 02:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749126;
        bh=/agAwXolswCl8LvRA5/M5Ck+nypgf73yV1lbyVxCdrs=;
        h=Date:To:From:Subject:From;
        b=Lb+q1bUmwo1lWS9tLnKiDH36/57zGl9ybKIdc+89uUFBuh5sS2PyiDnEt67AlDxdN
         ABurAUeaH06/t0qjiT4DZ4en3lxYPh2keECnllbEQDOIe/p96ZdV3EwiUJxe6F5zpZ
         cqwejLWex1V+n3S9tDC9p1GbMzQUbqit0aZ3GvuA=
Date:   Wed, 05 Apr 2023 19:45:25 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, corbet@lwn.net,
        tomas.mudrunka@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] add-results-of-early-memtest-to-proc-meminfo.patch removed from -mm tree
Message-Id: <20230406024526.079BEC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memtest: add results of early memtest to /proc/meminfo
has been removed from the -mm tree.  Its filename was
     add-results-of-early-memtest-to-proc-meminfo.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tomas Mudrunka <tomas.mudrunka@gmail.com>
Subject: mm/memtest: add results of early memtest to /proc/meminfo
Date: Tue, 21 Mar 2023 11:34:30 +0100

Currently the memtest results were only presented in dmesg.

When running a large fleet of devices without ECC RAM it's currently not
easy to do bulk monitoring for memory corruption.  You have to parse
dmesg, but that's a ring buffer so the error might disappear after some
time.  In general I do not consider dmesg to be a great API to query RAM
status.

In several companies I've seen such errors remain undetected and cause
issues for way too long.  So I think it makes sense to provide a
monitoring API, so that we can safely detect and act upon them.

This adds /proc/meminfo entry which can be easily used by scripts.

Link: https://lkml.kernel.org/r/20230321103430.7130-1-tomas.mudrunka@gmail.com
Signed-off-by: Tomas Mudrunka <tomas.mudrunka@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |    8 ++++++++
 fs/proc/meminfo.c                  |   13 +++++++++++++
 include/linux/memblock.h           |    2 ++
 mm/memtest.c                       |    6 ++++++
 4 files changed, 29 insertions(+)

--- a/Documentation/filesystems/proc.rst~add-results-of-early-memtest-to-proc-meminfo
+++ a/Documentation/filesystems/proc.rst
@@ -996,6 +996,7 @@ Example output. You may not have all of
     VmallocUsed:       40444 kB
     VmallocChunk:          0 kB
     Percpu:            29312 kB
+    EarlyMemtestBad:       0 kB
     HardwareCorrupted:     0 kB
     AnonHugePages:   4149248 kB
     ShmemHugePages:        0 kB
@@ -1146,6 +1147,13 @@ VmallocChunk
 Percpu
               Memory allocated to the percpu allocator used to back percpu
               allocations. This stat excludes the cost of metadata.
+EarlyMemtestBad
+              The amount of RAM/memory in kB, that was identified as corrupted
+              by early memtest. If memtest was not run, this field will not
+              be displayed at all. Size is never rounded down to 0 kB.
+              That means if 0 kB is reported, you can safely assume
+              there was at least one pass of memtest and none of the passes
+              found a single faulty byte of RAM.
 HardwareCorrupted
               The amount of RAM/memory in KB, the kernel identifies as
               corrupted.
--- a/fs/proc/meminfo.c~add-results-of-early-memtest-to-proc-meminfo
+++ a/fs/proc/meminfo.c
@@ -6,6 +6,7 @@
 #include <linux/hugetlb.h>
 #include <linux/mman.h>
 #include <linux/mmzone.h>
+#include <linux/memblock.h>
 #include <linux/proc_fs.h>
 #include <linux/percpu.h>
 #include <linux/seq_file.h>
@@ -131,6 +132,18 @@ static int meminfo_proc_show(struct seq_
 	show_val_kb(m, "VmallocChunk:   ", 0ul);
 	show_val_kb(m, "Percpu:         ", pcpu_nr_pages());
 
+#ifdef CONFIG_MEMTEST
+	if (early_memtest_done) {
+		unsigned long early_memtest_bad_size_kb;
+
+		early_memtest_bad_size_kb = early_memtest_bad_size>>10;
+		if (early_memtest_bad_size && !early_memtest_bad_size_kb)
+			early_memtest_bad_size_kb = 1;
+		/* When 0 is reported, it means there actually was a successful test */
+		seq_printf(m, "EarlyMemtestBad:   %5lu kB\n", early_memtest_bad_size_kb);
+	}
+#endif
+
 #ifdef CONFIG_MEMORY_FAILURE
 	seq_printf(m, "HardwareCorrupted: %5lu kB\n",
 		   atomic_long_read(&num_poisoned_pages) << (PAGE_SHIFT - 10));
--- a/include/linux/memblock.h~add-results-of-early-memtest-to-proc-meminfo
+++ a/include/linux/memblock.h
@@ -597,6 +597,8 @@ extern int hashdist;		/* Distribute hash
 #endif
 
 #ifdef CONFIG_MEMTEST
+extern phys_addr_t early_memtest_bad_size;	/* Size of faulty ram found by memtest */
+extern bool early_memtest_done;			/* Was early memtest done? */
 extern void early_memtest(phys_addr_t start, phys_addr_t end);
 #else
 static inline void early_memtest(phys_addr_t start, phys_addr_t end)
--- a/mm/memtest.c~add-results-of-early-memtest-to-proc-meminfo
+++ a/mm/memtest.c
@@ -4,6 +4,9 @@
 #include <linux/init.h>
 #include <linux/memblock.h>
 
+bool early_memtest_done;
+phys_addr_t early_memtest_bad_size;
+
 static u64 patterns[] __initdata = {
 	/* The first entry has to be 0 to leave memtest with zeroed memory */
 	0,
@@ -30,6 +33,7 @@ static void __init reserve_bad_mem(u64 p
 	pr_info("  %016llx bad mem addr %pa - %pa reserved\n",
 		cpu_to_be64(pattern), &start_bad, &end_bad);
 	memblock_reserve(start_bad, end_bad - start_bad);
+	early_memtest_bad_size += (end_bad - start_bad);
 }
 
 static void __init memtest(u64 pattern, phys_addr_t start_phys, phys_addr_t size)
@@ -61,6 +65,8 @@ static void __init memtest(u64 pattern,
 	}
 	if (start_bad)
 		reserve_bad_mem(pattern, start_bad, last_bad + incr);
+
+	early_memtest_done = true;
 }
 
 static void __init do_one_pass(u64 pattern, phys_addr_t start, phys_addr_t end)
_

Patches currently in -mm which might be from tomas.mudrunka@gmail.com are


