Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F083A1DB;
	Thu, 18 Jul 2024 04:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721275767; cv=none; b=t03vmGP1u4JPuXJXpSWUh2f5imtIEuT2yqAnJlx9KpVHUY3EdbWB9JUs85kUSLjFaMJpqdiSldISOFojZCjj3QsBx2mwY2xwFgCY9UshCW9OhMQ37xY57e92eZf7mV14IB0JK9LiY/iaW52ta1WeUxD9sKqW09OVE3Ztka5xWzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721275767; c=relaxed/simple;
	bh=A6DlK2AfrtOC9MMHdk9LEpEt8Z+5C6r+EWsVNe9qo3U=;
	h=Date:To:From:Subject:Message-Id; b=Q+qBVwff3I/xMbIcbcJnu8X6yq6h3+b2d4lwhLsJpSYwSVQOTbLFRZn3+nC34NHwSFhw79z3Y1w9hgmHLqofvnEJ6xWOnb5MfPD6xz53Lj0uOBqGf75tu63O3uwNE184ZIz3h6dCULrPylLXaeeSB/cXGK8cYboaGIY1uGuHZWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=saRbaHpe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="saRbaHpe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EF2AC4AF0A;
	Thu, 18 Jul 2024 04:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721275766;
	bh=A6DlK2AfrtOC9MMHdk9LEpEt8Z+5C6r+EWsVNe9qo3U=;
	h=Date:To:From:Subject:From;
	b=saRbaHpeJdeX2NCLqw0ZXmwDRXK4RKy/xRemVDZGlcsflaRNgbe5PPclYW7L5QAk5
	 KLeqdPCZz4rEeNWKsbu+YJLTRnSyp2C1Pfd7kjqr+CRBMrvhwvemzBOuQyKF3goYST
	 xiUbIYawioqZPDLivmwyMatNDQnaLpAKedwGVlyQ=
Date: Wed, 17 Jul 2024 21:09:26 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,muchun.song@linux.dev,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-fix-possible-recursive-locking-detected-warning.patch removed from -mm tree
Message-Id: <20240718040926.9EF2AC4AF0A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: fix possible recursive locking detected warning
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-possible-recursive-locking-detected-warning.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hugetlb: fix possible recursive locking detected warning
Date: Fri, 12 Jul 2024 11:13:14 +0800

When tries to demote 1G hugetlb folios, a lockdep warning is observed:

============================================
WARNING: possible recursive locking detected
6.10.0-rc6-00452-ga4d0275fa660-dirty #79 Not tainted
--------------------------------------------
bash/710 is trying to acquire lock:
ffffffff8f0a7850 (&h->resize_lock){+.+.}-{3:3}, at: demote_store+0x244/0x460

but task is already holding lock:
ffffffff8f0a6f48 (&h->resize_lock){+.+.}-{3:3}, at: demote_store+0xae/0x460

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&h->resize_lock);
  lock(&h->resize_lock);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

4 locks held by bash/710:
 #0: ffff8f118439c3f0 (sb_writers#5){.+.+}-{0:0}, at: ksys_write+0x64/0xe0
 #1: ffff8f11893b9e88 (&of->mutex#2){+.+.}-{3:3}, at: kernfs_fop_write_iter+0xf8/0x1d0
 #2: ffff8f1183dc4428 (kn->active#98){.+.+}-{0:0}, at: kernfs_fop_write_iter+0x100/0x1d0
 #3: ffffffff8f0a6f48 (&h->resize_lock){+.+.}-{3:3}, at: demote_store+0xae/0x460

stack backtrace:
CPU: 3 PID: 710 Comm: bash Not tainted 6.10.0-rc6-00452-ga4d0275fa660-dirty #79
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x68/0xa0
 __lock_acquire+0x10f2/0x1ca0
 lock_acquire+0xbe/0x2d0
 __mutex_lock+0x6d/0x400
 demote_store+0x244/0x460
 kernfs_fop_write_iter+0x12c/0x1d0
 vfs_write+0x380/0x540
 ksys_write+0x64/0xe0
 do_syscall_64+0xb9/0x1d0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa61db14887
RSP: 002b:00007ffc56c48358 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007fa61db14887
RDX: 0000000000000002 RSI: 000055a030050220 RDI: 0000000000000001
RBP: 000055a030050220 R08: 00007fa61dbd1460 R09: 000000007fffffff
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000002
R13: 00007fa61dc1b780 R14: 00007fa61dc17600 R15: 00007fa61dc16a00
 </TASK>

Lockdep considers this an AA deadlock because the different resize_lock
mutexes reside in the same lockdep class, but this is a false positive.
Place them in distinct classes to avoid these warnings.

Link: https://lkml.kernel.org/r/20240712031314.2570452-1-linmiaohe@huawei.com
Fixes: 8531fc6f52f5 ("hugetlb: add hugetlb demote page support")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    1 +
 mm/hugetlb.c            |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-fix-possible-recursive-locking-detected-warning
+++ a/include/linux/hugetlb.h
@@ -663,6 +663,7 @@ HPAGEFLAG(RawHwpUnreliable, raw_hwp_unre
 /* Defines one hugetlb page size */
 struct hstate {
 	struct mutex resize_lock;
+	struct lock_class_key resize_key;
 	int next_nid_to_alloc;
 	int next_nid_to_free;
 	unsigned int order;
--- a/mm/hugetlb.c~mm-hugetlb-fix-possible-recursive-locking-detected-warning
+++ a/mm/hugetlb.c
@@ -4642,7 +4642,7 @@ void __init hugetlb_add_hstate(unsigned
 	BUG_ON(hugetlb_max_hstate >= HUGE_MAX_HSTATE);
 	BUG_ON(order < order_base_2(__NR_USED_SUBPAGE));
 	h = &hstates[hugetlb_max_hstate++];
-	mutex_init(&h->resize_lock);
+	__mutex_init(&h->resize_lock, "resize mutex", &h->resize_key);
 	h->order = order;
 	h->mask = ~(huge_page_size(h) - 1);
 	for (i = 0; i < MAX_NUMNODES; ++i)
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memory-failure-fix-vm_bug_on_pagepagepoisonedpage-when-unpoison-memory.patch

