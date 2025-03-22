Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE59D1547CC
	for <mm-commits@vger.kernel.org>; Sat, 22 Mar 2025 05:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742619847; cv=none; b=LTWztnql8MR/LNVgZ56BIO/B5IcrIDwlLj4g2g5b9XGZO6ihY9OyaFGxhxfutdM1kKVLOf78JW0ZHKQ/jxL5cHXZKyASA+HNeBdjJ45f9Asu83FYXWu8/gcFg5mB0xM+sc1otdAS60KDDJhjHAw4gKu8svKJ0mjva4fJCWsvuJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742619847; c=relaxed/simple;
	bh=HWG/VZwg7Bm8xtbVP/B+qggxXFu8SU96NyrWpAGWqCE=;
	h=Date:To:From:Subject:Message-Id; b=s3KDqaETRpihPhlMzwZZJTJwQpCwEdsW8fEEvOb19kZSeSwOPJDfpUqMWnXRWuW3jU6Rw7dBGGFNOkf6cLped1Mum/9cMrkTKadfnnPAIP9vodFSiC3G08ARwiGMK5gD16RU/6z8HZyyE4IFZi3ByoqsugfqtotL6aNip7g8J4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZkzmpW7Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZkzmpW7Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52A3CC4CEDD;
	Sat, 22 Mar 2025 05:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742619847;
	bh=HWG/VZwg7Bm8xtbVP/B+qggxXFu8SU96NyrWpAGWqCE=;
	h=Date:To:From:Subject:From;
	b=ZkzmpW7YrRfRfP18cuzROgwvu7Rb9h5dbVr/4NLwsvkepR/aGJy65fRPbgGp9BbLV
	 w92o+g0uly1Si2SfjmmFT2VO5LQPF/f3ORU4zqA2j5hdBIM7cuZEWfLKx5M/kS5D+i
	 7nuFs9ZSmaYnh9IDB8fU+WBtVoqUXUmxLGHovpdI=
Date: Fri, 21 Mar 2025 22:04:06 -0700
To: mm-commits@vger.kernel.org,oliver.sang@intel.com,jhubbard@nvidia.com,jgg@nvidia.com,djwong@kernel.org,david@redhat.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,balbirs@nvidia.com,alison.schofield@intel.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-dax-dont-disassociate-zero-page-entries.patch removed from -mm tree
Message-Id: <20250322050407.52A3CC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/dax: don't disassociate zero page entries
has been removed from the -mm tree.  Its filename was
     fs-dax-dont-disassociate-zero-page-entries.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: fs/dax: don't disassociate zero page entries
Date: Tue, 18 Mar 2025 18:33:01 -0700

Prior to commit 38607c62b34b ("fs/dax: properly refcount fs dax pages")
dax_associate_entry() and dax_disassociate_entry() would implicitly skip
zero and empty dax entries using the for_each_mapped_pfn() macro.  The use
of compound ZONE_DEVICE folios removed the need for this macro and so it
was removed, leading dax_folio_put() to be called on zero pages.

This lead to the below warning. To fix this explicitly skip zero and
empty entries in dax_associate/disassociate_entry().

[   27.536963] ------------[ cut here ]------------
[   27.537674] WARNING: CPU: 11 PID: 874 at fs/dax.c:415 dax_folio_put.isra.0+0x10d/0x170
[   27.538844] Modules linked in: nd_pmem nd_btt nd_e820 libnvdimm
[   27.539732] CPU: 11 UID: 0 PID: 874 Comm: ctl_prefault Tainted: G        W          6.14.0-rc2+ #1104
[   27.541093] Tainted: [W]=WARN
[   27.541549] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/204
[   27.543197] RIP: 0010:dax_folio_put.isra.0+0x10d/0x170
[   27.543970] Code: 20 48 85 c0 0f 84 29 ff ff ff 48 83 e8 01 48 89 47 20 0f 84 1b ff ff ff 48 83 c4 10 5b 5d 41 5c c3 cc cc4
[   27.546723] RSP: 0000:ffff961e4102fae0 EFLAGS: 00010002
[   27.547505] RAX: 0000000000000001 RBX: ffffc9cce4e18000 RCX: 0000000000000009
[   27.548564] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff8a2a7badca40
[   27.549630] RBP: ffffc9cce4e18000 R08: 0000000000009ffb R09: 00000000ffffdfff
[   27.550691] R10: 00000000ffffdfff R11: ffffffffa4e823a0 R12: 0000000000000000
[   27.551748] R13: 0000000000000000 R14: 0000000010f10005 R15: 0000000000000004
[   27.552819] FS:  00007f5f539d74c0(0000) GS:ffff8a2a7bac0000(0000) knlGS:0000000000000000
[   27.554015] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   27.554873] CR2: 00007f5f52e00000 CR3: 0000000909340000 CR4: 00000000000006f0
[   27.555938] Call Trace:
[   27.556318]  <TASK>
[   27.556650]  ? __warn+0x91/0x190
[   27.557146]  ? dax_folio_put.isra.0+0x10d/0x170
[   27.557824]  ? report_bug+0x164/0x190
[   27.558378]  ? handle_bug+0x54/0x90
[   27.558898]  ? exc_invalid_op+0x17/0x70
[   27.559489]  ? asm_exc_invalid_op+0x1a/0x20
[   27.560125]  ? dax_folio_put.isra.0+0x10d/0x170
[   27.560808]  dax_insert_entry+0x1e1/0x420
[   27.561419]  dax_fault_iter+0x252/0x860
[   27.561995]  dax_iomap_pmd_fault+0x23c/0x4a0
[   27.562651]  ext4_dax_huge_fault+0x1e2/0x450
[   27.563296]  __handle_mm_fault+0x6c8/0x12b0
[   27.563920]  ? do_user_addr_fault+0x1ca/0x670
[   27.564577]  ? lock_vma_under_rcu+0x178/0x3b0
[   27.565235]  handle_mm_fault+0xe5/0x290
[   27.565816]  do_user_addr_fault+0x208/0x670
[   27.566446]  exc_page_fault+0x6d/0x230
[   27.567008]  asm_exc_page_fault+0x26/0x30
[   27.567610] RIP: 0033:0x7f5f543bcb4f
[   27.568152] Code: 45 f0 48 8b 45 f0 48 8b 4d f8 48 03 41 18 48 89 45 e8 48 8b 45 f0 48 3b 45 e8 0f 83 97 00 00 00 48 8b 458
[   27.570895] RSP: 002b:00007ffc2d774460 EFLAGS: 00010287
[   27.571672] RAX: 00007f5f52e00000 RBX: 0000000000200000 RCX: 000055760153fc00
[   27.572731] RDX: 0000000000000000 RSI: 0000557601542a20 RDI: 000055760153fc00
[   27.573787] RBP: 00007ffc2d774460 R08: 0000000000000000 R09: 0000000000000073
[   27.574840] R10: 0000000000000000 R11: 0000000000000202 R12: 00007ffc2d77534b
[   27.575897] R13: 00007ffc2d774aa0 R14: 0000000000800000 R15: 0000000000800000
[   27.576961]  </TASK>
[   27.577301] irq event stamp: 13394
[   27.577810] hardirqs last  enabled at (13393): [<ffffffffa3485780>] flush_tlb_mm_range+0x1c0/0x220
[   27.579138] hardirqs last disabled at (13394): [<ffffffffa450d0c7>] _raw_spin_lock_irq+0x47/0x50
[   27.580428] softirqs last  enabled at (12530): [<ffffffffa433941a>] xs_tcp_send_request+0x22a/0x2e0
[   27.581762] softirqs last disabled at (12528): [<ffffffffa40a60fd>] release_sock+0x1d/0xb0
[   27.582986] ---[ end trace 0000000000000000 ]---

Link: https://lkml.kernel.org/r/20250319013301.369822-1-apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Fixes: 38607c62b34b ("fs/dax: properly refcount fs dax pages")
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202503102229.122fbd6c-lkp@intel.com
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/fs/dax.c~fs-dax-dont-disassociate-zero-page-entries
+++ a/fs/dax.c
@@ -445,6 +445,9 @@ static void dax_associate_entry(void *en
 	unsigned long size = dax_entry_size(entry), index;
 	struct folio *folio = dax_to_folio(entry);
 
+	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry))
+		return;
+
 	if (IS_ENABLED(CONFIG_FS_DAX_LIMITED))
 		return;
 
@@ -473,6 +476,9 @@ static void dax_disassociate_entry(void
 	if (IS_ENABLED(CONFIG_FS_DAX_LIMITED))
 		return;
 
+	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry))
+		return;
+
 	dax_folio_put(folio);
 }
 
@@ -1074,8 +1080,7 @@ static void *dax_insert_entry(struct xa_
 		void *old;
 
 		dax_disassociate_entry(entry, mapping, false);
-		if (!(flags & DAX_ZERO_PAGE))
-			dax_associate_entry(new_entry, mapping, vmf->vma,
+		dax_associate_entry(new_entry, mapping, vmf->vma,
 					vmf->address, shared);
 
 		/*
_

Patches currently in -mm which might be from apopple@nvidia.com are


