Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7291BC43334
	for <mm-commits@archiver.kernel.org>; Wed, 22 Jun 2022 20:33:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbiFVUdw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 22 Jun 2022 16:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiFVUdw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jun 2022 16:33:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2332338792
        for <mm-commits@vger.kernel.org>; Wed, 22 Jun 2022 13:33:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B18E0618CE
        for <mm-commits@vger.kernel.org>; Wed, 22 Jun 2022 20:33:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14D71C3411D;
        Wed, 22 Jun 2022 20:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655930030;
        bh=tasGzb/B7w5kMiUKJNvEsbo+Kisf/aM3nHdT6HJ8dE8=;
        h=Date:To:From:Subject:From;
        b=fEOSMcrEFmpPxIpbllHMDZv9LCuhA+b5FvtnULhvkVHrp72MdSqXO/MkncfuQ1PNm
         fzEiYhB9EIcxGNs/Z/IhCnDht5+qD0LCWZi1fZ/GSIXTn2ruFV2AZrz23SUALZllt1
         /uleNvxMMJrQZjS1BJLy3N9f8IerjFwDF5vjxOmk=
Date:   Wed, 22 Jun 2022 13:33:49 -0700
To:     mm-commits@vger.kernel.org, shy828301@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] mm-thp-kill-__transhuge_page_enabled-fix.patch removed from -mm tree
Message-Id: <20220622203350.14D71C3411D@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: thp: fix hugepage_vma_check() for gate vma
has been removed from the -mm tree.  Its filename was
     mm-thp-kill-__transhuge_page_enabled-fix.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: mm: thp: fix hugepage_vma_check() for gate vma
Date: Fri, 17 Jun 2022 17:47:36 -0700

The syzbot reported the below issue:

BUG: KASAN: null-ptr-deref in instrument_atomic_read include/linux/instrumented.h:71 [inline]
BUG: KASAN: null-ptr-deref in test_bit include/asm-generic/bitops/instrumented-non-atomic.h:134 [inline]
BUG: KASAN: null-ptr-deref in hugepage_vma_check+0x8e/0x750 mm/huge_memory.c:82
Read of size 8 at addr 00000000000005a8 by task syz-executor.5/21978

CPU: 0 PID: 21978 Comm: syz-executor.5 Not tainted 5.19.0-rc2-next-20220616-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 kasan_report+0xbe/0x1f0 mm/kasan/report.c:495
 check_region_inline mm/kasan/generic.c:183 [inline]
 kasan_check_range+0x13d/0x180 mm/kasan/generic.c:189
 instrument_atomic_read include/linux/instrumented.h:71 [inline]
 test_bit include/asm-generic/bitops/instrumented-non-atomic.h:134 [inline]
 hugepage_vma_check+0x8e/0x750 mm/huge_memory.c:82
 show_smap+0x1c6/0x470 fs/proc/task_mmu.c:866
 traverse.part.0+0xcf/0x5f0 fs/seq_file.c:111
 traverse fs/seq_file.c:101 [inline]
 seq_read_iter+0x90f/0x1280 fs/seq_file.c:195
 seq_read+0x337/0x4b0 fs/seq_file.c:162
 do_loop_readv_writev fs/read_write.c:763 [inline]
 do_loop_readv_writev fs/read_write.c:750 [inline]
 do_iter_read+0x4f8/0x750 fs/read_write.c:805
 vfs_readv+0xe5/0x150 fs/read_write.c:923
 do_preadv fs/read_write.c:1015 [inline]
 __do_sys_preadv fs/read_write.c:1065 [inline]
 __se_sys_preadv fs/read_write.c:1060 [inline]
 __x64_sys_preadv+0x22b/0x310 fs/read_write.c:1060
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7f5c1d889109
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f5c1ea69168 EFLAGS: 00000246 ORIG_RAX: 0000000000000127
RAX: ffffffffffffffda RBX: 00007f5c1d99bf60 RCX: 00007f5c1d889109
RDX: 0000000000000001 RSI: 00000000200006c0 RDI: 0000000000000005
RBP: 00007f5c1d8e305d R08: 0000000000000000 R09: 0000000000000000
R10: 00000000fffffffe R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffd8514b43f R14: 00007f5c1ea69300 R15: 0000000000022000

The mm of the vma returned by smaps is NULL.  But it seems impossible
for normal vma since the mm is pinned before reaching hugepage_vma_check()
unless the vma is gate vma.

The gate vma doesn't have valid mm, but its size is PAGE_SIZE so the old
code (checking vma size first) did return before dereferencing mm.  So
move vma size check to the top to make sure it returns for gate vma
before dereferencing mm.

Link: https://lkml.kernel.org/r/20220618004736.1235352-1-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Reported-by: syzbot+4d875b4d2e2b60bae9b4@syzkaller.appspotmail.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

--- a/mm/huge_memory.c~mm-thp-kill-__transhuge_page_enabled-fix
+++ a/mm/huge_memory.c
@@ -104,16 +104,6 @@ bool hugepage_vma_check(struct vm_area_s
 		return false;
 
 	/*
-	 * Check alignment for file vma and size for both file and anon vma.
-	 *
-	 * Skip the check for page fault. Huge fault does the check in fault
-	 * handlers. And this check is not suitable for huge PUD fault.
-	 */
-	if (!in_pf &&
-	    !transhuge_vma_suitable(vma, (vma->vm_end - HPAGE_PMD_SIZE)))
-		return false;
-
-	/*
 	 * Enabled via shmem mount options or sysfs settings.
 	 * Must be done before hugepage flags check since shmem has its
 	 * own flags.
@@ -182,6 +172,20 @@ retry:
 static void put_huge_zero_page(void)
 {
 	/*
+	 * Check alignment for file vma and size for both file and anon vma.
+	 *
+	 * Call this before touching mm since gate vma may be met by smaps,
+	 * which doesn't have valid mm. The size of gate vma is PAGE_SIZE so
+	 * it will just return here.
+	 *
+	 * Skip the check for page fault. Huge fault does the check in fault
+	 * handlers. And this check is not suitable for huge PUD fault.
+	 */
+	if (!in_pf &&
+	    !transhuge_vma_suitable(vma, (vma->vm_end - HPAGE_PMD_SIZE)))
+		return false;
+
+	/*
 	 * Counter should never go to zero here. Only shrinker can put
 	 * last reference.
 	 */
_

Patches currently in -mm which might be from shy828301@gmail.com are

mm-rmap-use-the-correct-parameter-name-for-define_page_vma_walk.patch
mm-pvmw-check-possible-huge-pmd-map-by-transhuge_vma_suitable.patch
mm-khugepaged-check-thp-flag-in-hugepage_vma_check.patch
mm-thp-consolidate-vma-size-check-to-transhuge_vma_suitable.patch
mm-khugepaged-better-comments-for-anon-vma-check-in-hugepage_vma_revalidate.patch
mm-thp-kill-transparent_hugepage_active.patch
mm-thp-kill-__transhuge_page_enabled.patch
mm-khugepaged-reorg-some-khugepaged-helpers.patch
doc-proc-fix-the-description-to-thpeligible.patch

