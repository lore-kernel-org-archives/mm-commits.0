Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE08FC4321E
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 22:32:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238149AbiKOWcd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 17:32:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238566AbiKOWcI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 17:32:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F31C19
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 14:32:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9423A61A04
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 22:32:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9B98C433D6;
        Tue, 15 Nov 2022 22:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668551527;
        bh=Fto+xEuFC67mmjk2uTz8wmM2+/oa2nMX7WKYnGRcpKs=;
        h=Date:To:From:Subject:From;
        b=WsfVn1qf1SRGA0bWPOYGHDadlIisVyQEXRwmBG3uVRHrCwuSMnM2P67LnuwOThXKY
         +v+58yh76+3dYa0MlhY0yzbq7LG9iG5vCSVsVLpiExi7aMEJkYzRPQdgApy1o4QtCG
         p6fI3bMdhuZUArTpY3QjQ+AzdkC0Z/VqTP6qVrQE=
Date:   Tue, 15 Nov 2022 14:32:06 -0800
To:     mm-commits@vger.kernel.org, zealci@zte.com.cn,
        ye.xingchen@zte.com.cn, pmladek@suse.com, paulus@samba.org,
        niejianglei2021@163.com, mpe@ellerman.id.au, linux@armlinux.org.uk,
        ebiederm@xmission.com, chenlifu@huawei.com, bhe@redhat.com,
        benh@kernel.crashing.org, lchen@ambarella.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kexec-replace-crash_mem_range-with-range.patch removed from -mm tree
Message-Id: <20221115223206.E9B98C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kexec: replace crash_mem_range with range
has been removed from the -mm tree.  Its filename was
     kexec-replace-crash_mem_range-with-range.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Li Chen <lchen@ambarella.com>
Subject: kexec: replace crash_mem_range with range
Date: Thu, 29 Sep 2022 12:29:35 +0800

We already have struct range, so just use it.

Link: https://lkml.kernel.org/r/20220929042936.22012-4-bhe@redhat.com
Signed-off-by: Li Chen <lchen@ambarella.com>
Signed-off-by: Baoquan He <bhe@redhat.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Chen Lifu <chenlifu@huawei.com>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Jianglei Nie <niejianglei2021@163.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: ye xingchen <ye.xingchen@zte.com.cn>
Cc: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kexec/file_load_64.c |    2 +-
 arch/powerpc/kexec/ranges.c       |    8 ++++----
 include/linux/kexec.h             |    7 ++-----
 kernel/kexec_file.c               |    2 +-
 4 files changed, 8 insertions(+), 11 deletions(-)

--- a/arch/powerpc/kexec/file_load_64.c~kexec-replace-crash_mem_range-with-range
+++ a/arch/powerpc/kexec/file_load_64.c
@@ -35,7 +35,7 @@ struct umem_info {
 
 	/* usable memory ranges to look up */
 	unsigned int nr_ranges;
-	const struct crash_mem_range *ranges;
+	const struct range *ranges;
 };
 
 const struct kexec_file_ops * const kexec_file_loaders[] = {
--- a/arch/powerpc/kexec/ranges.c~kexec-replace-crash_mem_range-with-range
+++ a/arch/powerpc/kexec/ranges.c
@@ -33,7 +33,7 @@
 static inline unsigned int get_max_nr_ranges(size_t size)
 {
 	return ((size - sizeof(struct crash_mem)) /
-		sizeof(struct crash_mem_range));
+		sizeof(struct range));
 }
 
 /**
@@ -51,7 +51,7 @@ static inline size_t get_mem_rngs_size(s
 		return 0;
 
 	size = (sizeof(struct crash_mem) +
-		(mem_rngs->max_nr_ranges * sizeof(struct crash_mem_range)));
+		(mem_rngs->max_nr_ranges * sizeof(struct range)));
 
 	/*
 	 * Memory is allocated in size multiple of MEM_RANGE_CHUNK_SZ.
@@ -98,7 +98,7 @@ static int __add_mem_range(struct crash_
  */
 static void __merge_memory_ranges(struct crash_mem *mem_rngs)
 {
-	struct crash_mem_range *ranges;
+	struct range *ranges;
 	int i, idx;
 
 	if (!mem_rngs)
@@ -123,7 +123,7 @@ static void __merge_memory_ranges(struct
 /* cmp_func_t callback to sort ranges with sort() */
 static int rngcmp(const void *_x, const void *_y)
 {
-	const struct crash_mem_range *x = _x, *y = _y;
+	const struct range *x = _x, *y = _y;
 
 	if (x->start > y->start)
 		return 1;
--- a/include/linux/kexec.h~kexec-replace-crash_mem_range-with-range
+++ a/include/linux/kexec.h
@@ -17,6 +17,7 @@
 
 #include <linux/crash_core.h>
 #include <asm/io.h>
+#include <linux/range.h>
 
 #include <uapi/linux/kexec.h>
 #include <linux/verification.h>
@@ -240,14 +241,10 @@ static inline int arch_kexec_locate_mem_
 /* Alignment required for elf header segment */
 #define ELF_CORE_HEADER_ALIGN   4096
 
-struct crash_mem_range {
-	u64 start, end;
-};
-
 struct crash_mem {
 	unsigned int max_nr_ranges;
 	unsigned int nr_ranges;
-	struct crash_mem_range ranges[];
+	struct range ranges[];
 };
 
 extern int crash_exclude_mem_range(struct crash_mem *mem,
--- a/kernel/kexec_file.c~kexec-replace-crash_mem_range-with-range
+++ a/kernel/kexec_file.c
@@ -1141,7 +1141,7 @@ int crash_exclude_mem_range(struct crash
 {
 	int i, j;
 	unsigned long long start, end, p_start, p_end;
-	struct crash_mem_range temp_range = {0, 0};
+	struct range temp_range = {0, 0};
 
 	for (i = 0; i < mem->nr_ranges; i++) {
 		start = mem->ranges[i].start;
_

Patches currently in -mm which might be from lchen@ambarella.com are


