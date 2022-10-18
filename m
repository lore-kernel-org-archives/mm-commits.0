Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7508EC4332F
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 00:52:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbiJRAwT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Oct 2022 20:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230389AbiJRAv7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2022 20:51:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D56FA7CA9F
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 17:51:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62735B819D6
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 00:51:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FAE5C433C1;
        Tue, 18 Oct 2022 00:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666054316;
        bh=pz5IMVgdd+OLohUCRn2nwt8WSVceuxryFJwRp63kkcc=;
        h=Date:To:From:Subject:From;
        b=vDlBfw0b6fCu1nYcvPA3bCV5Wd8YacYCnzhR4CObSIkiJiqmWoXR18BRpzPbw+BFA
         AlWeySJ8M48IE/6o3uB0MLUgq23MoG1eZzm+kUkiVwCGeUJk0OniXKUdx4hywMFJB4
         xCURECNb10rgw1d5fWtd5rXFhTm2JZPjU5INC12I=
Date:   Mon, 17 Oct 2022 17:51:55 -0700
To:     mm-commits@vger.kernel.org, zealci@zte.com.cn,
        ye.xingchen@zte.com.cn, pmladek@suse.com, paulus@samba.org,
        niejianglei2021@163.com, mpe@ellerman.id.au, linux@armlinux.org.uk,
        ebiederm@xmission.com, chenlifu@huawei.com, bhe@redhat.com,
        benh@kernel.crashing.org, lchen@ambarella.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-replace-crash_mem_range-with-range.patch added to mm-nonmm-unstable branch
Message-Id: <20221018005156.1FAE5C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: replace crash_mem_range with range
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec-replace-crash_mem_range-with-range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-replace-crash_mem_range-with-range.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

kexec-replace-crash_mem_range-with-range.patch

