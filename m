Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED3767A13
	for <mm-commits@vger.kernel.org>; Thu,  8 Feb 2024 05:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707369679; cv=none; b=PxmeNEPs6vo2qYWgOfEP8lYQo9UhGPRMdmsqfV5VWT+2ehYQwPAEsbkNJXJc+ZA9APABdlhoYbDmLLZYNHVUQzt1Ig5yxEVNJ8zfKoSwa62R2v3AK953q9gqA7pkuUlgeEsePb99AJRZr1aWHAHKo1uVguzd6QO2tvxklPh1nHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707369679; c=relaxed/simple;
	bh=aUgdKKTFrIR2mW8VEbWjY+Z7/sRzYdJ6e/H6AuvnPXM=;
	h=Date:To:From:Subject:Message-Id; b=osFxzsxIw0mc1b8FjUP7LVCUDS75dTaYTq+MQ//mgFzgG7G8Y1mQBKlQRkDeYZZlkp9if26nF5vPFF+1SCMWHxsfReNGjQgWLSTKNY+lVXFN3tBl7tdWANaBslzwhW49HEamdge2CxM1+XI+lu49V3xrFbXINlIFKeLbPTxH+N8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cOYLJTkk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cOYLJTkk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7001C433C7;
	Thu,  8 Feb 2024 05:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707369678;
	bh=aUgdKKTFrIR2mW8VEbWjY+Z7/sRzYdJ6e/H6AuvnPXM=;
	h=Date:To:From:Subject:From;
	b=cOYLJTkk4/j5+XlDnHOOvgWLV25OSglv4HyOl3lkjFQwlGO6FsdfDN+NXUGFZTUVk
	 n4WW9F4B7x3Z6bOzHJg8SVTIej8b6cCvAHL+tMk0HxKwnIsnJLy8OmFkBCibwfztPP
	 qxh0KbiouPyg1v09Najq0oZ3KwEIwlBSGS46N7U8=
Date: Wed, 07 Feb 2024 21:21:18 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,naoya.horiguchi@nec.com,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-memory-failure-fix-crash-in-split_huge_page_to_list-from-soft_offline_page.patch removed from -mm tree
Message-Id: <20240208052118.B7001C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: fix crash in split_huge_page_to_list from soft_offline_page
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-fix-crash-in-split_huge_page_to_list-from-soft_offline_page.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory-failure: fix crash in split_huge_page_to_list from soft_offline_page
Date: Wed, 24 Jan 2024 16:40:14 +0800

When I did soft offline stress test, a machine was observed to crash with
the following message:

  kernel BUG at include/linux/memcontrol.h:554!
  invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
  CPU: 5 PID: 3837 Comm: hwpoison.sh Not tainted 6.7.0-next-20240112-00001-g8ecf3e7fb7c8-dirty #97
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
  RIP: 0010:folio_memcg+0xaf/0xd0
  Code: 10 5b 5d c3 cc cc cc cc 48 c7 c6 08 b1 f2 b2 48 89 ef e8 b4 c5 f8 ff 90 0f 0b 48 c7 c6 d0 b0 f2 b2 48 89 ef e8 a2 c5 f8 ff 90 <0f> 0b 48 c7 c6 08 b1 f2 b2 48 89 ef e8 90 c5 f8 ff 90 0f 0b 66 66
  RSP: 0018:ffffb6c043657c98 EFLAGS: 00000296
  RAX: 000000000000004b RBX: ffff932bc1d1e401 RCX: ffff933abfb5c908
  RDX: 0000000000000000 RSI: 0000000000000027 RDI: ffff933abfb5c900
  RBP: ffffea6f04019080 R08: ffffffffb3338ce8 R09: 0000000000009ffb
  R10: 00000000000004dd R11: ffffffffb3308d00 R12: ffffea6f04019080
  R13: ffffea6f04019080 R14: 0000000000000001 R15: ffffb6c043657da0
  FS:  00007f6c60f6b740(0000) GS:ffff933abfb40000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000559c3bc8b980 CR3: 0000000107f1c000 CR4: 00000000000006f0
  Call Trace:
   <TASK>
   split_huge_page_to_list+0x4d/0x1380
   try_to_split_thp_page+0x3a/0xf0
   soft_offline_page+0x1ea/0x8a0
   soft_offline_page_store+0x52/0x90
   kernfs_fop_write_iter+0x118/0x1b0
   vfs_write+0x30b/0x430
   ksys_write+0x5e/0xe0
   do_syscall_64+0xb0/0x1b0
   entry_SYSCALL_64_after_hwframe+0x6d/0x75
  RIP: 0033:0x7f6c60d14697
  Code: 10 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 48 89 54 24 18 48 89 74 24
  RSP: 002b:00007ffe9b72b8d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
  RAX: ffffffffffffffda RBX: 000000000000000c RCX: 00007f6c60d14697
  RDX: 000000000000000c RSI: 0000559c3bc8b980 RDI: 0000000000000001
  RBP: 0000559c3bc8b980 R08: 00007f6c60dd1460 R09: 000000007fffffff
  R10: 0000000000000000 R11: 0000000000000246 R12: 000000000000000c
  R13: 00007f6c60e1a780 R14: 00007f6c60e16600 R15: 00007f6c60e15a00

The problem is that page->mapping is overloaded with slab->slab_list or
slabs fields now, so slab pages could be taken as non-LRU movable pages if
field slabs contains PAGE_MAPPING_MOVABLE or slab_list->prev is set to
LIST_POISON2.  These slab pages will be treated as thp later leading to
crash in split_huge_page_to_list().

Link: https://lkml.kernel.org/r/20240126065837.2100184-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20240124084014.1772906-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Fixes: 130d4df57390 ("mm/sl[au]b: rearrange struct slab fields to allow larger rcu_head")
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/memory-failure.c~mm-memory-failure-fix-crash-in-split_huge_page_to_list-from-soft_offline_page
+++ a/mm/memory-failure.c
@@ -1377,6 +1377,9 @@ void ClearPageHWPoisonTakenOff(struct pa
  */
 static inline bool HWPoisonHandlable(struct page *page, unsigned long flags)
 {
+	if (PageSlab(page))
+		return false;
+
 	/* Soft offline could migrate non-LRU movable pages */
 	if ((flags & MF_SOFT_OFFLINE) && __PageMovable(page))
 		return true;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


