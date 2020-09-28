Return-Path: <SRS0=DYKa=DF=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CBDBC2D0A8
	for <mm-commits@archiver.kernel.org>; Mon, 28 Sep 2020 21:15:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4931D208FE
	for <mm-commits@archiver.kernel.org>; Mon, 28 Sep 2020 21:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601327703;
	bh=xpyIg0on4e3WmS8KjR/3TqG63GFCDEyXInh9JjxwfBs=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=HHfXK0rXWTo5kHBvaledXrEQQFYFGKeWTeN5QlC0k/W6LQrG9HAQNfWI/8Ee3cVBB
	 rEbzx252N7hUk1Gf22P7M6VVrSoKrF2QSbcehO3xirBrQxCFxdsHA083/8rd/yN6Lj
	 7PS1v4puA73Wc089l+gL5Nxx2wgi/ApmgTMbUJwc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgI1VPD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Sep 2020 17:15:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:58700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726393AbgI1VPC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Sep 2020 17:15:02 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3AF82083B;
        Mon, 28 Sep 2020 21:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601327700;
        bh=xpyIg0on4e3WmS8KjR/3TqG63GFCDEyXInh9JjxwfBs=;
        h=Date:From:To:Subject:From;
        b=i1vf0OH4H3Pn7EP8umTMMXDcgwYaX9Tz5NwL692W3jTYK+2YLy1IdA3Wy7JYPzP2M
         eaSXbJU9Kcg1h4in7hhkBNzi0eCpZN07RX9xK0apmxB6/7upkQUKYrKPOxi+3NsvgS
         Mz/+P1v+2YV7L9Jq6WXfg/UUJ7Op7z1MR5LfUAK0=
Date:   Mon, 28 Sep 2020 14:14:59 -0700
From:   akpm@linux-foundation.org
To:     kirill.shutemov@linux.intel.com, minchan@kernel.org,
        mm-commits@vger.kernel.org
Subject:  [merged] mm-validate-pmd-after-splitting.patch removed
 from -mm tree
Message-ID: <20200928211459.g4cuXjfmz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: validate pmd after splitting
has been removed from the -mm tree.  Its filename was
     mm-validate-pmd-after-splitting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: validate pmd after splitting

syzbot reported following.

general protection fault, probably for non-canonical address 0xdffffc0000000003: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
CPU: 1 PID: 6826 Comm: syz-executor142 Not tainted 5.9.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__lock_acquire+0x84/0x2ae0 kernel/locking/lockdep.c:4296
Code: ff df 8a 04 30 84 c0 0f 85 e3 16 00 00 83 3d 56 58 35 08 00 0f 84 0e 17 00 00 83 3d 25 c7 f5 07 00 74 2c 4c 89 e8 48 c1 e8 03 <80> 3c 30 00 74 12 4c 89 ef e8 3e d1 5a 00 48 be 00 00 00 00 00 fc
RSP: 0018:ffffc90004b9f850 EFLAGS: 00010006
RAX: 0000000000000003 RBX: 0000000000000001 RCX: 0000000000000000
RDX: 0000000000000000 RSI: dffffc0000000000 RDI: 0000000000000018
RBP: ffffc90004b9f9a8 R08: 0000000000000001 R09: 0000000000000000
R10: fffffbfff131e2e6 R11: 0000000000000000 R12: ffff8880937161c0
R13: 0000000000000018 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000002638880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000002100003f CR3: 00000000a49a2000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 lock_acquire+0x140/0x6f0 kernel/locking/lockdep.c:5006
 __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
 _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
 spin_lock include/linux/spinlock.h:354 [inline]
 madvise_cold_or_pageout_pte_range+0x52f/0x25c0 mm/madvise.c:389
 walk_pmd_range mm/pagewalk.c:89 [inline]
 walk_pud_range mm/pagewalk.c:160 [inline]
 walk_p4d_range mm/pagewalk.c:193 [inline]
 walk_pgd_range mm/pagewalk.c:229 [inline]
 __walk_page_range+0xe7b/0x1da0 mm/pagewalk.c:331
 walk_page_range+0x2c3/0x5c0 mm/pagewalk.c:427
 madvise_pageout_page_range mm/madvise.c:521 [inline]
 madvise_pageout mm/madvise.c:557 [inline]
 madvise_vma mm/madvise.c:946 [inline]
 do_madvise+0x12d0/0x2090 mm/madvise.c:1145
 __do_sys_madvise mm/madvise.c:1171 [inline]
 __se_sys_madvise mm/madvise.c:1169 [inline]
 __x64_sys_madvise+0x76/0x80 mm/madvise.c:1169
 do_syscall_64+0x31/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

In case of split page of file-backed THP, it zaps the pmd instead of
remapping of sub-pages so need to check pmd validity after split.

Link: https://lkml.kernel.org/r/20200915163349.GA2868856@google.com
Fixes: 1a4e58cce84e ("mm: introduce MADV_PAGEOUT")
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reported-by: syzbot+ecf80462cb7d5d552bc7@syzkaller.appspotmail.com
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/madvise.c~mm-validate-pmd-after-splitting
+++ a/mm/madvise.c
@@ -381,9 +381,9 @@ huge_unlock:
 		return 0;
 	}
 
+regular_page:
 	if (pmd_trans_unstable(pmd))
 		return 0;
-regular_page:
 #endif
 	tlb_change_page_size(tlb, PAGE_SIZE);
 	orig_pte = pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-madvise-pass-mm-to-do_madvise.patch
pid-move-pidfd_get_pid-to-pidc.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix-fix.patch

