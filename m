Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58F01C77B76
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:33:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbjDRXdc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbjDRXda (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:33:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 000FC7AAE
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:33:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8249062F22
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:33:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD41DC433EF;
        Tue, 18 Apr 2023 23:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860808;
        bh=NnxKHx0baR+89MagzHcH6AF5NUHCtz21mlqcvNqd/rU=;
        h=Date:To:From:Subject:From;
        b=AtNMegTfanFE8NXRJH2ZTHDqL3lr51Lf+jY4ZBmkVXXQKD+3BkVYGMpqqlyIBCa9V
         GqBGQcK8MBVL73smHqEsyOQbn1TUkDfXYzS5cOHz2Lx7CNYIfFrGQgbmRFx2Chf0Tr
         BfAuk9A6k68qkszITJOg5M1Q9cRiKoINJJ2LKPm8=
Date:   Tue, 18 Apr 2023 16:33:27 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        songliubraving@fb.com, skhan@linuxfoundation.org,
        shy828301@gmail.com, riel@surriel.com,
        kirill.shutemov@linux.intel.com, himadrispandya@gmail.com,
        hannes@cmpxchg.org, ivan.orlov0322@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-fix-kernel-bug-in-hpage_collapse_scan_file.patch removed from -mm tree
Message-Id: <20230418233327.DD41DC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: khugepaged: fix kernel BUG in hpage_collapse_scan_file()
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-fix-kernel-bug-in-hpage_collapse_scan_file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ivan Orlov <ivan.orlov0322@gmail.com>
Subject: mm: khugepaged: fix kernel BUG in hpage_collapse_scan_file()
Date: Wed, 29 Mar 2023 18:53:30 +0400

Syzkaller reported the following issue:

kernel BUG at mm/khugepaged.c:1823!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 5097 Comm: syz-executor220 Not tainted 6.2.0-syzkaller-13154-g857f1268a591 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/16/2023
RIP: 0010:collapse_file mm/khugepaged.c:1823 [inline]
RIP: 0010:hpage_collapse_scan_file+0x67c8/0x7580 mm/khugepaged.c:2233
Code: 00 00 89 de e8 c9 66 a3 ff 31 ff 89 de e8 c0 66 a3 ff 45 84 f6 0f 85 28 0d 00 00 e8 22 64 a3 ff e9 dc f7 ff ff e8 18 64 a3 ff <0f> 0b f3 0f 1e fa e8 0d 64 a3 ff e9 93 f6 ff ff f3 0f 1e fa 4c 89
RSP: 0018:ffffc90003dff4e0 EFLAGS: 00010093
RAX: ffffffff81e95988 RBX: 00000000000001c1 RCX: ffff8880205b3a80
RDX: 0000000000000000 RSI: 00000000000001c0 RDI: 00000000000001c1
RBP: ffffc90003dff830 R08: ffffffff81e90e67 R09: fffffbfff1a433c3
R10: 0000000000000000 R11: dffffc0000000001 R12: 0000000000000000
R13: ffffc90003dff6c0 R14: 00000000000001c0 R15: 0000000000000000
FS:  00007fdbae5ee700(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fdbae6901e0 CR3: 000000007b2dd000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 madvise_collapse+0x721/0xf50 mm/khugepaged.c:2693
 madvise_vma_behavior mm/madvise.c:1086 [inline]
 madvise_walk_vmas mm/madvise.c:1260 [inline]
 do_madvise+0x9e5/0x4680 mm/madvise.c:1439
 __do_sys_madvise mm/madvise.c:1452 [inline]
 __se_sys_madvise mm/madvise.c:1450 [inline]
 __x64_sys_madvise+0xa5/0xb0 mm/madvise.c:1450
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

The xas_store() call during page cache scanning can potentially translate
'xas' into the error state (with the reproducer provided by the syzkaller
the error code is -ENOMEM).  However, there are no further checks after
the 'xas_store', and the next call of 'xas_next' at the start of the
scanning cycle doesn't increase the xa_index, and the issue occurs.

This patch will add the xarray state error checking after the xas_store()
and the corresponding result error code.

Tested via syzbot.

[akpm@linux-foundation.org: update include/trace/events/huge_memory.h's SCAN_STATUS]
Link: https://lkml.kernel.org/r/20230329145330.23191-1-ivan.orlov0322@gmail.com
Link: https://syzkaller.appspot.com/bug?id=7d6bb3760e026ece7524500fe44fb024a0e959fc
Signed-off-by: Ivan Orlov <ivan.orlov0322@gmail.com>
Reported-by: syzbot+9578faa5475acb35fa50@syzkaller.appspotmail.com
Tested-by: Zach O'Keefe <zokeefe@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Himadri Pandya <himadrispandya@gmail.com>
Cc: Ivan Orlov <ivan.orlov0322@gmail.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/huge_memory.h |    3 ++-
 mm/khugepaged.c                    |   20 ++++++++++++++++++++
 2 files changed, 22 insertions(+), 1 deletion(-)

--- a/include/trace/events/huge_memory.h~mm-khugepaged-fix-kernel-bug-in-hpage_collapse_scan_file
+++ a/include/trace/events/huge_memory.h
@@ -36,7 +36,8 @@
 	EM( SCAN_ALLOC_HUGE_PAGE_FAIL,	"alloc_huge_page_failed")	\
 	EM( SCAN_CGROUP_CHARGE_FAIL,	"ccgroup_charge_failed")	\
 	EM( SCAN_TRUNCATED,		"truncated")			\
-	EMe(SCAN_PAGE_HAS_PRIVATE,	"page_has_private")		\
+	EM( SCAN_PAGE_HAS_PRIVATE,	"page_has_private")		\
+	EMe(SCAN_STORE_FAILED,		"store_failed")
 
 #undef EM
 #undef EMe
--- a/mm/khugepaged.c~mm-khugepaged-fix-kernel-bug-in-hpage_collapse_scan_file
+++ a/mm/khugepaged.c
@@ -55,6 +55,7 @@ enum scan_result {
 	SCAN_CGROUP_CHARGE_FAIL,
 	SCAN_TRUNCATED,
 	SCAN_PAGE_HAS_PRIVATE,
+	SCAN_STORE_FAILED,
 };
 
 #define CREATE_TRACE_POINTS
@@ -1857,6 +1858,15 @@ static int collapse_file(struct mm_struc
 					goto xa_locked;
 				}
 				xas_store(&xas, hpage);
+				if (xas_error(&xas)) {
+					/* revert shmem_charge performed
+					 * in the previous condition
+					 */
+					mapping->nrpages--;
+					shmem_uncharge(mapping->host, 1);
+					result = SCAN_STORE_FAILED;
+					goto xa_locked;
+				}
 				nr_none++;
 				continue;
 			}
@@ -2009,6 +2019,11 @@ static int collapse_file(struct mm_struc
 
 		/* Finally, replace with the new page. */
 		xas_store(&xas, hpage);
+		/* We can't get an ENOMEM here (because the allocation happened before)
+		 * but let's check for errors (XArray implementation can be
+		 * changed in the future)
+		 */
+		WARN_ON_ONCE(xas_error(&xas));
 		continue;
 out_unlock:
 		unlock_page(page);
@@ -2046,6 +2061,11 @@ out_unlock:
 	/* Join all the small entries into a single multi-index entry */
 	xas_set_order(&xas, start, HPAGE_PMD_ORDER);
 	xas_store(&xas, hpage);
+	/* Here we can't get an ENOMEM (because entries were
+	 * previously allocated) But let's check for errors
+	 * (XArray implementation can be changed in the future)
+	 */
+	WARN_ON_ONCE(xas_error(&xas));
 xa_locked:
 	xas_unlock_irq(&xas);
 xa_unlocked:
_

Patches currently in -mm which might be from ivan.orlov0322@gmail.com are


