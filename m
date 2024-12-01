Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6277F4120B;
	Sun,  1 Dec 2024 07:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733036405; cv=none; b=JafX7EUwNJ8xou2fk3GGzD5+YIdIX0ujxi9sqYrJ92WEDH6OsWJ9kMq6fL1Ghi8/ELk/guF9memww5O/cDFfiqg/cvDIRRbNjUyv/rRhdBxkQgTJ5HWSO8Sz2MoS6FXemssAGYbSMHAKu3GYr9bqcm5vza8rbEqswJjLtCTC5xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733036405; c=relaxed/simple;
	bh=6mPgB53FRk0RTyGy5XDK1rmOjoTs+6pls7igk5ryNSI=;
	h=Date:To:From:Subject:Message-Id; b=obVcQVXx3bjQCafTRMH2VkDNdtF+FeQUxr6FsPsL4gI2zvCvPY6AeQffNN47XAOieFfL8ERiuiRKeeHYFLmTxOnDK0Xfw5uDlr+V2okoBx9+rjWCVb6LgmLgpa+N0s4+nUpFR3Wj8109Wm+AJzglz9xX/d9B+yT5bRRCHAG+rAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zfco3/M6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zfco3/M6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C756AC4CECF;
	Sun,  1 Dec 2024 07:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733036404;
	bh=6mPgB53FRk0RTyGy5XDK1rmOjoTs+6pls7igk5ryNSI=;
	h=Date:To:From:Subject:From;
	b=zfco3/M6DncJ/huylmzuVoJ3NL+2DVBgqJYzzXhIMyYNNMNjqBoXO1YTvL18+EpVc
	 FIxIUZCcX0UUyTr2kzwpqbrdlydh/gefbyOVwdof+YqhgQiDwbc+nD6mfzfmBD6VPW
	 R5ITcoeFzcXWWFFYDnLavOHbQnPwbHlcEYIBIn3U=
Date: Sat, 30 Nov 2024 23:00:04 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,nao.horiguchi@gmail.com,david@redhat.com,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memory-failure-fix-vm_bug_on_pagepagepoisonedpage-when-unpoison-memory.patch removed from -mm tree
Message-Id: <20241201070004.C756AC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: fix VM_BUG_ON_PAGE(PagePoisoned(page)) when unpoison memory
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-fix-vm_bug_on_pagepagepoisonedpage-when-unpoison-memory.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory-failure: fix VM_BUG_ON_PAGE(PagePoisoned(page)) when unpoison memory
Date: Fri, 12 Jul 2024 14:42:49 +0800

When I did memory failure tests recently, below panic occurs:

page dumped because: VM_BUG_ON_PAGE(PagePoisoned(page))
kernel BUG at include/linux/page-flags.h:616!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
CPU: 3 PID: 720 Comm: bash Not tainted 6.10.0-rc1-00195-g148743902568 #40
RIP: 0010:unpoison_memory+0x2f3/0x590
RSP: 0018:ffffa57fc8787d60 EFLAGS: 00000246
RAX: 0000000000000037 RBX: 0000000000000009 RCX: ffff9be25fcdc9c8
RDX: 0000000000000000 RSI: 0000000000000027 RDI: ffff9be25fcdc9c0
RBP: 0000000000300000 R08: ffffffffb4956f88 R09: 0000000000009ffb
R10: 0000000000000284 R11: ffffffffb4926fa0 R12: ffffe6b00c000000
R13: ffff9bdb453dfd00 R14: 0000000000000000 R15: fffffffffffffffe
FS:  00007f08f04e4740(0000) GS:ffff9be25fcc0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000564787a30410 CR3: 000000010d4e2000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 unpoison_memory+0x2f3/0x590
 simple_attr_write_xsigned.constprop.0.isra.0+0xb3/0x110
 debugfs_attr_write+0x42/0x60
 full_proxy_write+0x5b/0x80
 vfs_write+0xd5/0x540
 ksys_write+0x64/0xe0
 do_syscall_64+0xb9/0x1d0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f08f0314887
RSP: 002b:00007ffece710078 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000009 RCX: 00007f08f0314887
RDX: 0000000000000009 RSI: 0000564787a30410 RDI: 0000000000000001
RBP: 0000564787a30410 R08: 000000000000fefe R09: 000000007fffffff
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000009
R13: 00007f08f041b780 R14: 00007f08f0417600 R15: 00007f08f0416a00
 </TASK>
Modules linked in: hwpoison_inject
---[ end trace 0000000000000000 ]---
RIP: 0010:unpoison_memory+0x2f3/0x590
RSP: 0018:ffffa57fc8787d60 EFLAGS: 00000246
RAX: 0000000000000037 RBX: 0000000000000009 RCX: ffff9be25fcdc9c8
RDX: 0000000000000000 RSI: 0000000000000027 RDI: ffff9be25fcdc9c0
RBP: 0000000000300000 R08: ffffffffb4956f88 R09: 0000000000009ffb
R10: 0000000000000284 R11: ffffffffb4926fa0 R12: ffffe6b00c000000
R13: ffff9bdb453dfd00 R14: 0000000000000000 R15: fffffffffffffffe
FS:  00007f08f04e4740(0000) GS:ffff9be25fcc0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000564787a30410 CR3: 000000010d4e2000 CR4: 00000000000006f0
Kernel panic - not syncing: Fatal exception
Kernel Offset: 0x31c00000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
---[ end Kernel panic - not syncing: Fatal exception ]---

We're hitting a BUG_ON in PF_ANY():

PAGEFLAG(HWPoison, hwpoison, PF_ANY)

#define PF_ANY(page, enforce)	PF_POISONED_CHECK(page)

#define PF_POISONED_CHECK(page) ({					\
	VM_BUG_ON_PGFLAGS(PagePoisoned(page), page);		\
	page; })

#define	PAGE_POISON_PATTERN	-1l
static inline int PagePoisoned(const struct page *page)
{
	return READ_ONCE(page->flags) == PAGE_POISON_PATTERN;
}

The offlined pages will have page->flags set to PAGE_POISON_PATTERN
while pfn is still valid:

offline_pages
  remove_pfn_range_from_zone
    page_init_poison
      memset(page, PAGE_POISON_PATTERN, size);

The root cause is that unpoison_memory() tries to check the PG_HWPoison
flags of an uninitialized page. So VM_BUG_ON_PAGE(PagePoisoned(page)) is
triggered. This can be reproduced by below steps:
1.Offline memory block:
 echo offline > /sys/devices/system/memory/memory12/state
2.Get offlined memory pfn:
 page-types -b n -rlN
3.Write pfn to unpoison-pfn
 echo <pfn> > /sys/kernel/debug/hwpoison/unpoison-pfn

Link: https://lkml.kernel.org/r/20240712064249.3882707-1-linmiaohe@huawei.com
Fixes: f165b378bbdf ("mm: uninitialized struct page poisoning sanity checking")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/memory-failure.c~mm-memory-failure-fix-vm_bug_on_pagepagepoisonedpage-when-unpoison-memory
+++ a/mm/memory-failure.c
@@ -2578,6 +2578,13 @@ int unpoison_memory(unsigned long pfn)
 		goto unlock_mutex;
 	}
 
+	if (PagePoisoned(p)) {
+		unpoison_pr_info("%#lx: page is uninitialized\n",
+				 pfn, &unpoison_rs);
+		ret = -EOPNOTSUPP;
+		goto unlock_mutex;
+	}
+
 	if (!PageHWPoison(p)) {
 		unpoison_pr_info("%#lx: page was already unpoisoned\n",
 				 pfn, &unpoison_rs);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


