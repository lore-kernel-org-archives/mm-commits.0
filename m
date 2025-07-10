Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E87121FF3B
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 04:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752120550; cv=none; b=TPGHsRuSdvuJRSqSJSW/5xYeFcupT+Z6Vj0OdRl7ECbkMTMzO2xsD8HN5u8OIIx14s+BDXlL4KqLMjWD2l5XsaNkdVFWI6w5aZLY2UEKn/a36qGjt7zB1HALfdv7TJ25XHETsT5R4yoDz/6FyVEY1n9Hta7A7V1q0r1aw/s3tJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752120550; c=relaxed/simple;
	bh=iYpNNQL4gq8d2LyTO6hTQiT+ULlzNoBXz1BGpI+Skhw=;
	h=Date:To:From:Subject:Message-Id; b=C9BVBBAIUFMQGoWUgjVdvdttpO3tr0Zve4fSqnwBX0LfQfce2DZACSpcTXpcltbRBHSQA4R0/OPFlUlutXME+Xb1xXRotQiNshNo4G2xxuwjKORAv+v6xU4Wrbdzn/gfw81q24b4fn1qVpYHdOPIz5p54+LUD5FJcvI5t7ZNdK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ivKp8J+5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ivKp8J+5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BF63C4CEE3;
	Thu, 10 Jul 2025 04:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752120550;
	bh=iYpNNQL4gq8d2LyTO6hTQiT+ULlzNoBXz1BGpI+Skhw=;
	h=Date:To:From:Subject:From;
	b=ivKp8J+5bXrQxm89qIkYwuGGKGtVjxnNT7uZjimcCus5JRACLCzrzs9PciEfboz94
	 TP8+O1Bk0Om9He9x+hF04jU9JabA9A6xuWlPd2t+Qax9ZdQdTNAQuC86tsMODUjAP7
	 0c1vj1NFxVpcFwKQUBefbz3Gx9sxhOX71IKjz5PQ=
Date: Wed, 09 Jul 2025 21:09:09 -0700
To: mm-commits@vger.kernel.org,steven.sistare@oracle.com,osalvador@suse.de,muchun.song@linux.dev,david@redhat.com,anshuman.khandual@arm.com,vivek.kasireddy@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-hugetlb-dont-crash-when-allocating-a-folio-if-there-are-no-resv.patch removed from -mm tree
Message-Id: <20250710040910.5BF63C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: don't crash when allocating a folio if there are no resv
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-dont-crash-when-allocating-a-folio-if-there-are-no-resv.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vivek Kasireddy <vivek.kasireddy@intel.com>
Subject: mm/hugetlb: don't crash when allocating a folio if there are no resv
Date: Thu, 26 Jun 2025 12:11:16 -0700

There are cases when we try to pin a folio but discover that it has not
been faulted-in.  So, we try to allocate it in memfd_alloc_folio() but
there is a chance that we might encounter a fatal crash/failure
(VM_BUG_ON(!h->resv_huge_pages) in alloc_hugetlb_folio_reserve()) if there
are no active reservations at that instant.  This issue was reported by
syzbot:

kernel BUG at mm/hugetlb.c:2403!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5315 Comm: syz.0.0 Not tainted
6.13.0-rc5-syzkaller-00161-g63676eefb7a0 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:alloc_hugetlb_folio_reserve+0xbc/0xc0 mm/hugetlb.c:2403
Code: 1f eb 05 e8 56 18 a0 ff 48 c7 c7 40 56 61 8e e8 ba 21 cc 09 4c 89
f0 5b 41 5c 41 5e 41 5f 5d c3 cc cc cc cc e8 35 18 a0 ff 90 <0f> 0b 66
90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f
RSP: 0018:ffffc9000d3d77f8 EFLAGS: 00010087
RAX: ffffffff81ff6beb RBX: 0000000000000000 RCX: 0000000000100000
RDX: ffffc9000e51a000 RSI: 00000000000003ec RDI: 00000000000003ed
RBP: 1ffffffff34810d9 R08: ffffffff81ff6ba3 R09: 1ffffd4000093005
R10: dffffc0000000000 R11: fffff94000093006 R12: dffffc0000000000
R13: dffffc0000000000 R14: ffffea0000498000 R15: ffffffff9a4086c8
FS:  00007f77ac12e6c0(0000) GS:ffff88801fc00000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f77ab54b170 CR3: 0000000040b70000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 memfd_alloc_folio+0x1bd/0x370 mm/memfd.c:88
 memfd_pin_folios+0xf10/0x1570 mm/gup.c:3750
 udmabuf_pin_folios drivers/dma-buf/udmabuf.c:346 [inline]
 udmabuf_create+0x70e/0x10c0 drivers/dma-buf/udmabuf.c:443
 udmabuf_ioctl_create drivers/dma-buf/udmabuf.c:495 [inline]
 udmabuf_ioctl+0x301/0x4e0 drivers/dma-buf/udmabuf.c:526
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:906 [inline]
 __se_sys_ioctl+0xf5/0x170 fs/ioctl.c:892
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Therefore, prevent the above crash by removing the VM_BUG_ON() as there is
no need to crash the system in this situation and instead we could just
fail the allocation request.

Furthermore, as described above, the specific situation where this happens
is when we try to pin memfd folios before they are faulted-in.  Although,
this is a valid thing to do, it is not the regular or the common use-case.
Let us consider the following scenarios:

1) hugetlbfs_file_mmap()
    memfd_alloc_folio()
    hugetlb_fault()

2) memfd_alloc_folio()
    hugetlbfs_file_mmap()
    hugetlb_fault()

3) hugetlbfs_file_mmap()
    hugetlb_fault()
        alloc_hugetlb_folio()

3) is the most common use-case where first a memfd is allocated followed
by mmap(), user writes/updates and then the relevant folios are pinned
(memfd_pin_folios()).  The BUG this patch is fixing occurs in 2) because
we try to pin the folios before hugetlbfs_file_mmap() is called.  So, in
this situation we try to allocate the folios before pinning them but since
we did not make any reservations, resv_huge_pages would be 0, leading to
this issue.

Link: https://lkml.kernel.org/r/20250626191116.1377761-1-vivek.kasireddy@intel.com
Fixes: 26a8ea80929c ("mm/hugetlb: fix memfd_pin_folios resv_huge_pages leak")
Reported-by: syzbot+a504cb5bae4fe117ba94@syzkaller.appspotmail.com
Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Closes: https://syzkaller.appspot.com/bug?extid=a504cb5bae4fe117ba94
Closes: https://lore.kernel.org/all/677928b5.050a0220.3b53b0.004d.GAE@google.com/T/
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: Steve Sistare <steven.sistare@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-dont-crash-when-allocating-a-folio-if-there-are-no-resv
+++ a/mm/hugetlb.c
@@ -2340,12 +2340,15 @@ struct folio *alloc_hugetlb_folio_reserv
 	struct folio *folio;
 
 	spin_lock_irq(&hugetlb_lock);
+	if (!h->resv_huge_pages) {
+		spin_unlock_irq(&hugetlb_lock);
+		return NULL;
+	}
+
 	folio = dequeue_hugetlb_folio_nodemask(h, gfp_mask, preferred_nid,
 					       nmask);
-	if (folio) {
-		VM_BUG_ON(!h->resv_huge_pages);
+	if (folio)
 		h->resv_huge_pages--;
-	}
 
 	spin_unlock_irq(&hugetlb_lock);
 	return folio;
_

Patches currently in -mm which might be from vivek.kasireddy@intel.com are

mm-hugetlb-make-hugetlb_reserve_pages-return-nr-of-entries-updated.patch
mm-memfd-reserve-hugetlb-folios-before-allocation.patch
selftests-udmabuf-add-a-test-to-pin-first-before-writing-to-memfd.patch

