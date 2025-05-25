Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39FFEFC1D;
	Sun, 25 May 2025 07:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748159667; cv=none; b=PWALsx/vz2MDitJ+PoHcaG4rWLwtCVATK5m2o/u73qW3h22jMKhJePbSHSDR09r7DKyxFYJoygLlWnJk3dzWNa3cnyuIb/Q7nCr2Ae+jJJyBmOaV1h/MOcg1PVqLnFfuF2lembbtZZ5BlssXduUfclZFFHhZSf3VV7kCe2QBFsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748159667; c=relaxed/simple;
	bh=ZSJo55QDwWQqZIh82//73/yit+Hj4/jlWAGE8NNe0dc=;
	h=Date:To:From:Subject:Message-Id; b=qdAMA9vepokFac1kYEsLp2rhDzWIU8VSSPMHU+OzmX1+2YjLz4jxOdMaLEcRGqChZcRLuGNfnM+Ob9kvwX37Fg8OuV+WydPsO1d6Z22Cd8Lw6R+EoDAGCEQVsMPTAvdNRuzCgYpW/JvxkjQc3eD0YMnhN1Slpjm25E0ayVOEkHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w6nrQR3k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w6nrQR3k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EB60C4CEED;
	Sun, 25 May 2025 07:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748159667;
	bh=ZSJo55QDwWQqZIh82//73/yit+Hj4/jlWAGE8NNe0dc=;
	h=Date:To:From:Subject:From;
	b=w6nrQR3kfhL/VxWyj1zFfWmAocz7j6mM7hHh4v9b+1TYIQo22adhd1i8pUBIk2JCv
	 bVF0m31VHBxD25OlytWnvi1Zt88IAAAeL+9F0vr8BoGPF20S4FR+YfAlh1ylQEJRD4
	 lVhVvThP1sgCHqv82Ao4V2aX/3n1mmmXruwbU5YA=
Date: Sun, 25 May 2025 00:54:26 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@redhat.com,baolin.wang@linux.alibaba.com,21cnbao@gmail.com,yangge1116@126.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-hugetlb-fix-kernel-null-pointer-dereference-when-replacing-free-hugetlb-folios.patch removed from -mm tree
Message-Id: <20250525075427.0EB60C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: fix kernel NULL pointer dereference when replacing free hugetlb folios
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-kernel-null-pointer-dereference-when-replacing-free-hugetlb-folios.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ge Yang <yangge1116@126.com>
Subject: mm/hugetlb: fix kernel NULL pointer dereference when replacing free hugetlb folios
Date: Thu, 22 May 2025 11:22:17 +0800

A kernel crash was observed when replacing free hugetlb folios:

BUG: kernel NULL pointer dereference, address: 0000000000000028
PGD 0 P4D 0
Oops: Oops: 0000 [#1] SMP NOPTI
CPU: 28 UID: 0 PID: 29639 Comm: test_cma.sh Tainted 6.15.0-rc6-zp #41 PREEMPT(voluntary)
RIP: 0010:alloc_and_dissolve_hugetlb_folio+0x1d/0x1f0
RSP: 0018:ffffc9000b30fa90 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000342cca RCX: ffffea0043000000
RDX: ffffc9000b30fb08 RSI: ffffea0043000000 RDI: 0000000000000000
RBP: ffffc9000b30fb20 R08: 0000000000001000 R09: 0000000000000000
R10: ffff88886f92eb00 R11: 0000000000000000 R12: ffffea0043000000
R13: 0000000000000000 R14: 00000000010c0200 R15: 0000000000000004
FS:  00007fcda5f14740(0000) GS:ffff8888ec1d8000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000028 CR3: 0000000391402000 CR4: 0000000000350ef0
Call Trace:
<TASK>
 replace_free_hugepage_folios+0xb6/0x100
 alloc_contig_range_noprof+0x18a/0x590
 ? srso_return_thunk+0x5/0x5f
 ? down_read+0x12/0xa0
 ? srso_return_thunk+0x5/0x5f
 cma_range_alloc.constprop.0+0x131/0x290
 __cma_alloc+0xcf/0x2c0
 cma_alloc_write+0x43/0xb0
 simple_attr_write_xsigned.constprop.0.isra.0+0xb2/0x110
 debugfs_attr_write+0x46/0x70
 full_proxy_write+0x62/0xa0
 vfs_write+0xf8/0x420
 ? srso_return_thunk+0x5/0x5f
 ? filp_flush+0x86/0xa0
 ? srso_return_thunk+0x5/0x5f
 ? filp_close+0x1f/0x30
 ? srso_return_thunk+0x5/0x5f
 ? do_dup2+0xaf/0x160
 ? srso_return_thunk+0x5/0x5f
 ksys_write+0x65/0xe0
 do_syscall_64+0x64/0x170
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

There is a potential race between __update_and_free_hugetlb_folio() and
replace_free_hugepage_folios():

CPU1                              CPU2
__update_and_free_hugetlb_folio   replace_free_hugepage_folios
                                    folio_test_hugetlb(folio)
                                    -- It's still hugetlb folio.

  __folio_clear_hugetlb(folio)
  hugetlb_free_folio(folio)
                                    h = folio_hstate(folio)
                                    -- Here, h is NULL pointer

When the above race condition occurs, folio_hstate(folio) returns NULL,
and subsequent access to this NULL pointer will cause the system to crash.
To resolve this issue, execute folio_hstate(folio) under the protection
of the hugetlb_lock lock, ensuring that folio_hstate(folio) does not
return NULL.

Link: https://lkml.kernel.org/r/1747884137-26685-1-git-send-email-yangge1116@126.com
Fixes: 04f13d241b8b ("mm: replace free hugepage folios after migration")
Signed-off-by: Ge Yang <yangge1116@126.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/hugetlb.c~mm-hugetlb-fix-kernel-null-pointer-dereference-when-replacing-free-hugetlb-folios
+++ a/mm/hugetlb.c
@@ -2949,12 +2949,20 @@ int replace_free_hugepage_folios(unsigne
 
 	while (start_pfn < end_pfn) {
 		folio = pfn_folio(start_pfn);
+
+		/*
+		 * The folio might have been dissolved from under our feet, so make sure
+		 * to carefully check the state under the lock.
+		 */
+		spin_lock_irq(&hugetlb_lock);
 		if (folio_test_hugetlb(folio)) {
 			h = folio_hstate(folio);
 		} else {
+			spin_unlock_irq(&hugetlb_lock);
 			start_pfn++;
 			continue;
 		}
+		spin_unlock_irq(&hugetlb_lock);
 
 		if (!folio_ref_count(folio)) {
 			ret = alloc_and_dissolve_hugetlb_folio(h, folio,
_

Patches currently in -mm which might be from yangge1116@126.com are


