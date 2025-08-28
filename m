Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E317082D;
	Thu, 28 Aug 2025 23:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756423175; cv=none; b=kgjaaLIX1sub6VNjofKPGWh3IVBjBnZ/OwSe/bvT9IMiIsrJdhmeuLkN9YCyllhnHV0nAMGGKv5iWHgKPbWiDjmnSSK3+pdvYwEj413VeBnT0yv3Kr/jyfLj/xn6n0gZc0JvBlagUg3aLDnPM0nmaBvZ/ET5p1uga3ZCQaUabJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756423175; c=relaxed/simple;
	bh=VLwNbmkR89mKoTUx8RIBr4lfBqASXd/0jIL78aT9de8=;
	h=Date:To:From:Subject:Message-Id; b=L3p3GM2Ydu3civfwh8jlRQIhgs02+hyC3ki6Zg9G4UN4eY9HKbVqII2h3lopbW4srEuhEd2phzhNpU2GGfDhNUelwNtGnU7cuDiq7U8y2qrYFh28BTURoUFKzsf33yTJgqkAPsSw+lTKjBZWWBSCFvfFSJnyN/sTqCEp4HKmvS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IRJu2F5j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IRJu2F5j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29FB6C4CEEB;
	Thu, 28 Aug 2025 23:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756423175;
	bh=VLwNbmkR89mKoTUx8RIBr4lfBqASXd/0jIL78aT9de8=;
	h=Date:To:From:Subject:From;
	b=IRJu2F5j9PRzONlx5s+CRR+bC9+k/ab8LRmO83u94sALwAl7Qqi+Vmdqx4IrXAOPx
	 IsqfXILgzThBxJgDm6Q9DM12AM1bWZ+gdLBYJvnYIHTwUYWYIMbzcKtMod0Uo8GEx9
	 zViN9VVM8HUNMEB/PR8T5HCPUbEXMGuYwUBBe/TA=
Date: Thu, 28 Aug 2025 16:19:34 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,nao.horiguchi@gmail.com,david@redhat.com,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-fix-vm_bug_on_pagepagepoisonedpage-when-unpoison-memory.patch added to mm-hotfixes-unstable branch
Message-Id: <20250828231935.29FB6C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: fix VM_BUG_ON_PAGE(PagePoisoned(page)) when unpoison memory
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memory-failure-fix-vm_bug_on_pagepagepoisonedpage-when-unpoison-memory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-fix-vm_bug_on_pagepagepoisonedpage-when-unpoison-memory.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory-failure: fix VM_BUG_ON_PAGE(PagePoisoned(page)) when unpoison memory
Date: Thu, 28 Aug 2025 10:46:18 +0800

When I did memory failure tests, below panic occurs:

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

The root cause is that unpoison_memory() tries to check the PG_HWPoison
flags of an uninitialized page.  So VM_BUG_ON_PAGE(PagePoisoned(page)) is
triggered.  This can be reproduced by below steps:

1.Offline memory block:

 echo offline > /sys/devices/system/memory/memory12/state

2.Get offlined memory pfn:

 page-types -b n -rlN

3.Write pfn to unpoison-pfn

 echo <pfn> > /sys/kernel/debug/hwpoison/unpoison-pfn

This scenario can be identified by pfn_to_online_page() returning NULL. 
And ZONE_DEVICE pages are never expected, so we can simply fail if
pfn_to_online_page() == NULL to fix the bug.

Link: https://lkml.kernel.org/r/20250828024618.1744895-1-linmiaohe@huawei.com
Fixes: f1dd2cd13c4b ("mm, memory_hotplug: do not associate hotadded memory to zones until online")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-fix-vm_bug_on_pagepagepoisonedpage-when-unpoison-memory
+++ a/mm/memory-failure.c
@@ -2568,10 +2568,9 @@ int unpoison_memory(unsigned long pfn)
 	static DEFINE_RATELIMIT_STATE(unpoison_rs, DEFAULT_RATELIMIT_INTERVAL,
 					DEFAULT_RATELIMIT_BURST);
 
-	if (!pfn_valid(pfn))
-		return -ENXIO;
-
-	p = pfn_to_page(pfn);
+	p = pfn_to_online_page(pfn);
+	if (!p)
+		return -EIO;
 	folio = page_folio(p);
 
 	mutex_lock(&mf_mutex);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memory-failure-fix-vm_bug_on_pagepagepoisonedpage-when-unpoison-memory.patch
revert-hugetlb-make-hugetlb-depends-on-sysfs-or-sysctl.patch

