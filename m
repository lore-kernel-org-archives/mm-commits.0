Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C36624503B
	for <mm-commits@vger.kernel.org>; Thu, 26 Jun 2025 21:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750973629; cv=none; b=SHnKTGLSOQRfH51IvAi6pMM2bLl69nT7X6KSHDN2YFmbNrJTB32y3mnIcsM/VJ9G3Hkp657CtgUXvv791rIF84I1Ztc2gasnYJeM4cFIrhXScOoRGDgTVo6QlRF+RRgdi2kT64GyQlVvbcWQtne9681cPnuuX75sV3Ufbemxliw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750973629; c=relaxed/simple;
	bh=RNZbv+fbxyzrKUwjZlF+CQAy4HhFdVoe2uRkDYA0ocA=;
	h=Date:To:From:Subject:Message-Id; b=R+umiKeTiDipFlOrSeo+nCEfudCmiFDM3eVmd9oPpEhsbroKf6YfSHyPu78wxMTDO7jp9uv04zD1emZCiQxvyK6rL+LHhCZqzAJF4WaLMjTL6Rosn+UzffPTw+5gJLcZNspcY5sa/KFfbJTSFBYkGoWDOhaIxY/xGS5Vn4u5EBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Dh92UTcu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Dh92UTcu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11C2BC4CEEB;
	Thu, 26 Jun 2025 21:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750973629;
	bh=RNZbv+fbxyzrKUwjZlF+CQAy4HhFdVoe2uRkDYA0ocA=;
	h=Date:To:From:Subject:From;
	b=Dh92UTcuLLVmPTi0vnupY0UHR4A68OyBOcvQrRC8lZspMJWAvMHxBzdTtLs8QPIFM
	 aWrWN+3K79J/tid8V7atZVzV50x6KPfl3Vx7xF3fKImBbMzfvIzAgljqdOMhtY2Zmz
	 kRJuRNcqa+ROxq3u10X5yqM7/A81cx+6tG8PWarM=
Date: Thu, 26 Jun 2025 14:33:48 -0700
To: mm-commits@vger.kernel.org,steven.sistare@oracle.com,osalvador@suse.de,muchun.song@linux.dev,david@redhat.com,anshuman.khandual@arm.com,vivek.kasireddy@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-dont-crash-when-allocating-a-folio-if-there-are-no-resv.patch added to mm-hotfixes-unstable branch
Message-Id: <20250626213349.11C2BC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: don't crash when allocating a folio if there are no resv
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-dont-crash-when-allocating-a-folio-if-there-are-no-resv.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-dont-crash-when-allocating-a-folio-if-there-are-no-resv.patch

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

mm-hugetlb-dont-crash-when-allocating-a-folio-if-there-are-no-resv.patch
mm-hugetlb-make-hugetlb_reserve_pages-return-nr-of-entries-updated.patch
mm-memfd-reserve-hugetlb-folios-before-allocation.patch
selftests-udmabuf-add-a-test-to-pin-first-before-writing-to-memfd.patch

