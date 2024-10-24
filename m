Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E157017335E
	for <mm-commits@vger.kernel.org>; Thu, 24 Oct 2024 06:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729750517; cv=none; b=FXtPe7QjJJnyMcoqWXQwiu5JKKgwLS6x4O3P4EyUccD2CfCBxt6YAfrZE9IIPizBvou0jqjyrKirNW0HKMdc70GC8EWvVnm+5SiJfj7H58F5rNNaON+ROUshkSMj0nyTn4AD0NUAHiqjLKylsO44Cjd67glPANOvjvw2s0+ahTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729750517; c=relaxed/simple;
	bh=hMGBo481k/plK+MnH7iEEqBHcKMt6UTlREH2ZtFqkV8=;
	h=Date:To:From:Subject:Message-Id; b=baJURxtdumxXalsT+vGZAjJcWBL9cwdgEcYR9gVS16zaK7snOYn47BcgfbiayGGbbybUutvUzlUTEjg237Iu9X2kgAyiTpJEHqNKcN3pvfd/eqWXiWSKJFISkRVSRRsti1NtyZU4fGLkml1Jv19gUW8EbWg5YrCTzyRtIU/Ii2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YvDR23TB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YvDR23TB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72837C4CECC;
	Thu, 24 Oct 2024 06:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729750516;
	bh=hMGBo481k/plK+MnH7iEEqBHcKMt6UTlREH2ZtFqkV8=;
	h=Date:To:From:Subject:From;
	b=YvDR23TBw3psGDAR/uWDZifwtgHJEWAfu8TR/cciznHgcYNb8qO1f8iRLYVbd7xUg
	 qNRcGaB7lyt37HMpNuU2i1pmGQNoteszMZC17ijH5Gg9mfFsjfZxxneLS7sHPduKGK
	 Uf7n4kHw2h0tqdBh6NJ5Q2VEzLxrCtrmPWe/qzEA=
Date: Wed, 23 Oct 2024 23:15:14 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,kirill.shutemov@linux.intel.com,jannh@google.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-pagewalk-fix-usage-of-pmd_leaf-pud_leaf-without-present-check.patch removed from -mm tree
Message-Id: <20241024061516.72837C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/pagewalk: fix usage of pmd_leaf()/pud_leaf() without present check
has been removed from the -mm tree.  Its filename was
     mm-pagewalk-fix-usage-of-pmd_leaf-pud_leaf-without-present-check.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/pagewalk: fix usage of pmd_leaf()/pud_leaf() without present check
Date: Tue, 15 Oct 2024 13:12:36 +0200

pmd_leaf()/pud_leaf() only implies a pmd_present()/pud_present() check on
some architectures.  We really should check for
pmd_present()/pud_present() first.

This should explain the report we got on ppc64 (which has
CONFIG_PGTABLE_HAS_HUGE_LEAVES set in the config) that triggered:
	VM_WARN_ON_ONCE(pmd_leaf(pmdp_get_lockless(pmdp)));

Likely we had a PMD migration entry for which pmd_leaf() did not trigger. 
We raced with restoring the PMD migration entry, and suddenly saw a
pmd_leaf().  In this case, pte_offset_map_lock() saved us from more
trouble, because it rechecks the PMD value, but we would not have
processed the migration entry -- which is not too bad because the only
user of FW_MIGRATION is KSM for unsharing, and KSM only applies to small
folios.

Further, we shouldn't re-read the PMD/PUD value for our warning, the
primary purpose of the VM_WARN_ON_ONCE() is to find spurious use of
pmd_leaf()/pud_leaf() without CONFIG_PGTABLE_HAS_HUGE_LEAVES.

As a side note, we are currently not implementing FW_MIGRATION support for
PUD migration entries, which likely should exist due to hugetlb.  Add a
TODO so this won't fall through the cracks if more FW_MIGRATION users get
added.

Was able to write a quick reproducer and verify that the issue no longer triggers with this fix.

https://gitlab.com/davidhildenbrand/scratchspace/-/blob/main/reproducers/move-pages-pmd-leaf.c

Without this fix after a couple of seconds in a VM with 2 NUMA nodes:

[   54.333753] ------------[ cut here ]------------
[   54.334901] WARNING: CPU: 20 PID: 1704 at mm/pagewalk.c:815 folio_walk_start+0x48f/0x6e0
[   54.336455] Modules linked in: ...
[   54.345009] CPU: 20 UID: 0 PID: 1704 Comm: move-pages-pmd- Not tainted 6.12.0-rc2+ #81
[   54.346529] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-2.fc40 04/01/2014
[   54.348191] RIP: 0010:folio_walk_start+0x48f/0x6e0
[   54.349134] Code: b5 ad 48 8d 35 00 00 00 00 e8 6d 59 d7 ff e8 08 74 da ff e9 9c fe ff ff 4c 8b 7c 24 08 4c 89 ff e8 26 2b be 00 e9 8a fe ff ff <0f> 0b e9 ec fe ff ff f7 c2 ff 0f 00 00 0f 85 81 fe ff ff 48 8b 02
[   54.352660] RSP: 0018:ffffb7e4c430bc78 EFLAGS: 00010282
[   54.353679] RAX: 80000002a3e008e7 RBX: ffff9946039aa580 RCX: ffff994380000000
[   54.355056] RDX: ffff994606aec000 RSI: 00007f004b000000 RDI: 0000000000000000
[   54.356440] RBP: 00007f004b000000 R08: 0000000000000591 R09: 0000000000000001
[   54.357820] R10: 0000000000000200 R11: 0000000000000001 R12: ffffb7e4c430bd10
[   54.359198] R13: ffff994606aec2c0 R14: 0000000000000002 R15: ffff994604a89b00
[   54.360564] FS:  00007f004ae006c0(0000) GS:ffff9947f7400000(0000) knlGS:0000000000000000
[   54.362111] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   54.363242] CR2: 00007f004adffe58 CR3: 0000000281e12005 CR4: 0000000000770ef0
[   54.364615] PKRU: 55555554
[   54.365153] Call Trace:
[   54.365646]  <TASK>
[   54.366073]  ? __warn.cold+0xb7/0x14d
[   54.366796]  ? folio_walk_start+0x48f/0x6e0
[   54.367628]  ? report_bug+0xff/0x140
[   54.368324]  ? handle_bug+0x58/0x90
[   54.369019]  ? exc_invalid_op+0x17/0x70
[   54.369771]  ? asm_exc_invalid_op+0x1a/0x20
[   54.370606]  ? folio_walk_start+0x48f/0x6e0
[   54.371415]  ? folio_walk_start+0x9e/0x6e0
[   54.372227]  do_pages_move+0x1c5/0x680
[   54.372972]  kernel_move_pages+0x1a1/0x2b0
[   54.373804]  __x64_sys_move_pages+0x25/0x30

Link: https://lkml.kernel.org/r/20241015111236.1290921-1-david@redhat.com
Fixes: aa39ca6940f1 ("mm/pagewalk: introduce folio_walk_start() + folio_walk_end()")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: syzbot+7d917f67c05066cec295@syzkaller.appspotmail.com
Closes: https://lkml.kernel.org/r/670d3248.050a0220.3e960.0064.GAE@google.com
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pagewalk.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/mm/pagewalk.c~mm-pagewalk-fix-usage-of-pmd_leaf-pud_leaf-without-present-check
+++ a/mm/pagewalk.c
@@ -744,7 +744,8 @@ struct folio *folio_walk_start(struct fo
 	pud = pudp_get(pudp);
 	if (pud_none(pud))
 		goto not_found;
-	if (IS_ENABLED(CONFIG_PGTABLE_HAS_HUGE_LEAVES) && pud_leaf(pud)) {
+	if (IS_ENABLED(CONFIG_PGTABLE_HAS_HUGE_LEAVES) &&
+	    (!pud_present(pud) || pud_leaf(pud))) {
 		ptl = pud_lock(vma->vm_mm, pudp);
 		pud = pudp_get(pudp);
 
@@ -753,6 +754,10 @@ struct folio *folio_walk_start(struct fo
 		fw->pudp = pudp;
 		fw->pud = pud;
 
+		/*
+		 * TODO: FW_MIGRATION support for PUD migration entries
+		 * once there are relevant users.
+		 */
 		if (!pud_present(pud) || pud_devmap(pud) || pud_special(pud)) {
 			spin_unlock(ptl);
 			goto not_found;
@@ -769,12 +774,13 @@ struct folio *folio_walk_start(struct fo
 	}
 
 pmd_table:
-	VM_WARN_ON_ONCE(pud_leaf(*pudp));
+	VM_WARN_ON_ONCE(!pud_present(pud) || pud_leaf(pud));
 	pmdp = pmd_offset(pudp, addr);
 	pmd = pmdp_get_lockless(pmdp);
 	if (pmd_none(pmd))
 		goto not_found;
-	if (IS_ENABLED(CONFIG_PGTABLE_HAS_HUGE_LEAVES) && pmd_leaf(pmd)) {
+	if (IS_ENABLED(CONFIG_PGTABLE_HAS_HUGE_LEAVES) &&
+	    (!pmd_present(pmd) || pmd_leaf(pmd))) {
 		ptl = pmd_lock(vma->vm_mm, pmdp);
 		pmd = pmdp_get(pmdp);
 
@@ -786,7 +792,7 @@ pmd_table:
 		if (pmd_none(pmd)) {
 			spin_unlock(ptl);
 			goto not_found;
-		} else if (!pmd_leaf(pmd)) {
+		} else if (pmd_present(pmd) && !pmd_leaf(pmd)) {
 			spin_unlock(ptl);
 			goto pte_table;
 		} else if (pmd_present(pmd)) {
@@ -812,7 +818,7 @@ pmd_table:
 	}
 
 pte_table:
-	VM_WARN_ON_ONCE(pmd_leaf(pmdp_get_lockless(pmdp)));
+	VM_WARN_ON_ONCE(!pmd_present(pmd) || pmd_leaf(pmd));
 	ptep = pte_offset_map_lock(vma->vm_mm, pmdp, addr, &ptl);
 	if (!ptep)
 		goto not_found;
_

Patches currently in -mm which might be from david@redhat.com are

selftests-mm-hugetlb_fault_after_madv-use-default-hguetlb-page-size.patch
selftests-mm-hugetlb_fault_after_madv-improve-test-output.patch

