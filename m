Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289E713FEE;
	Tue, 19 Aug 2025 02:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755572211; cv=none; b=jGaVYBHdErrdwLNqai+WhWoSobqUq1CzXdvKLJGxT4i/x8PrI5ykelMO2vJhuXGu6QqxtKjjeCLO68JaFQEOogmY9JYjK2BjhHKYsIR5VshDZWnRoJyYp2o0KuX1nqdR3s0izftRqgvvmYvhPt6Tj1gqL6Kjk1lV2vSrDLdd77U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755572211; c=relaxed/simple;
	bh=rYfih2fnWnJrQ/As3cIiUo6u1GhBijom/rniVzogbWE=;
	h=Date:To:From:Subject:Message-Id; b=pZ1ECVBe0mryGdIBKAW0BX+q6dSV09FFtuBv//Y91xjdIs6WjoUPdGopnVhRpjUqGBZBuSFNQuMBQ5At988B6sfF0hmDPaYX8i6h8yhJ3K0/NwjyQclabnxsVJudb7kfApMJZzA27a4j1UCHbtPLghYL5St3yt4EuIIcd/4zr7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qnJnk+wN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qnJnk+wN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A30F4C4CEEB;
	Tue, 19 Aug 2025 02:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755572210;
	bh=rYfih2fnWnJrQ/As3cIiUo6u1GhBijom/rniVzogbWE=;
	h=Date:To:From:Subject:From;
	b=qnJnk+wNlmcj+x2VfCwyp1QROD3+pWlS1B5KMoym4Tyyiuk5mp79Md1T3tLynlq9n
	 sQ9L03MweZ9Lr9g6gTv8+AdVjUQT8w0TBmXc0ZIzRgV1pbm30j+iEfw2FUvptdouTT
	 gAwzE4VSQxbJgO0dOA/o/nAHLtErrQsXgxdfJJnw=
Date: Mon, 18 Aug 2025 19:56:50 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,pfalcato@suse.de,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,jannh@google.com,harry.yoo@oracle.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-fix-warn-with-uffd-that-has-remap-events-disabled.patch added to mm-hotfixes-unstable branch
Message-Id: <20250819025650.A30F4C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mremap: fix WARN with uffd that has remap events disabled
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-mremap-fix-warn-with-uffd-that-has-remap-events-disabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-fix-warn-with-uffd-that-has-remap-events-disabled.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm/mremap: fix WARN with uffd that has remap events disabled
Date: Mon, 18 Aug 2025 19:53:58 +0200

Registering userfaultd on a VMA that spans at least one PMD and then
mremap()'ing that VMA can trigger a WARN when recovering from a failed
page table move due to a page table allocation error.

The code ends up doing the right thing (recurse, avoiding moving actual
page tables), but triggering that WARN is unpleasant:

WARNING: CPU: 2 PID: 6133 at mm/mremap.c:357 move_normal_pmd mm/mremap.c:357 [inline]
WARNING: CPU: 2 PID: 6133 at mm/mremap.c:357 move_pgt_entry mm/mremap.c:595 [inline]
WARNING: CPU: 2 PID: 6133 at mm/mremap.c:357 move_page_tables+0x3832/0x44a0 mm/mremap.c:852
Modules linked in:
CPU: 2 UID: 0 PID: 6133 Comm: syz.0.19 Not tainted 6.17.0-rc1-syzkaller-00004-g53e760d89498 #0 PREEMPT(full)
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:move_normal_pmd mm/mremap.c:357 [inline]
RIP: 0010:move_pgt_entry mm/mremap.c:595 [inline]
RIP: 0010:move_page_tables+0x3832/0x44a0 mm/mremap.c:852
Code: ...
RSP: 0018:ffffc900037a76d8 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000032930007 RCX: ffffffff820c6645
RDX: ffff88802e56a440 RSI: ffffffff820c7201 RDI: 0000000000000007
RBP: ffff888037728fc0 R08: 0000000000000007 R09: 0000000000000000
R10: 0000000032930007 R11: 0000000000000000 R12: 0000000000000000
R13: ffffc900037a79a8 R14: 0000000000000001 R15: dffffc0000000000
FS:  000055556316a500(0000) GS:ffff8880d68bc000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b30863fff CR3: 0000000050171000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 copy_vma_and_data+0x468/0x790 mm/mremap.c:1215
 move_vma+0x548/0x1780 mm/mremap.c:1282
 mremap_to+0x1b7/0x450 mm/mremap.c:1406
 do_mremap+0xfad/0x1f80 mm/mremap.c:1921
 __do_sys_mremap+0x119/0x170 mm/mremap.c:1977
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0x4c0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f00d0b8ebe9
Code: ...
RSP: 002b:00007ffe5ea5ee98 EFLAGS: 00000246 ORIG_RAX: 0000000000000019
RAX: ffffffffffffffda RBX: 00007f00d0db5fa0 RCX: 00007f00d0b8ebe9
RDX: 0000000000400000 RSI: 0000000000c00000 RDI: 0000200000000000
RBP: 00007ffe5ea5eef0 R08: 0000200000c00000 R09: 0000000000000000
R10: 0000000000000003 R11: 0000000000000246 R12: 0000000000000002
R13: 00007f00d0db5fa0 R14: 00007f00d0db5fa0 R15: 0000000000000005
 </TASK>

The underlying issue is that we recurse during the original page table
move, but not during the recovery move.

Fix it by checking for both VMAs and performing the check before the
pmd_none() sanity check.

Add a new helper where we perform+document that check for the PMD and PUD
level.

Thanks to Harry for bisecting.

Link: https://lkml.kernel.org/r/20250818175358.1184757-1-david@redhat.com
Fixes: 0cef0bb836e ("mm: clear uffd-wp PTE/PMD state on mremap()")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: syzbot+4d9a13f0797c46a29e42@syzkaller.appspotmail.com
Closes: https://lkml.kernel.org/r/689bb893.050a0220.7f033.013a.GAE@google.com
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |   41 +++++++++++++++++++++++------------------
 1 file changed, 23 insertions(+), 18 deletions(-)

--- a/mm/mremap.c~mm-mremap-fix-warn-with-uffd-that-has-remap-events-disabled
+++ a/mm/mremap.c
@@ -323,6 +323,25 @@ static inline bool arch_supports_page_ta
 }
 #endif
 
+static inline bool uffd_supports_page_table_move(struct pagetable_move_control *pmc)
+{
+	/*
+	 * If we are moving a VMA that has uffd-wp registered but with
+	 * remap events disabled (new VMA will not be registered with uffd), we
+	 * need to ensure that the uffd-wp state is cleared from all pgtables.
+	 * This means recursing into lower page tables in move_page_tables().
+	 *
+	 * We might get called with VMAs reversed when recovering from a
+	 * failed page table move. In that case, the
+	 * "old"-but-actually-"originally new" VMA during recovery will not have
+	 * a uffd context. Recursing into lower page tables during the original
+	 * move but not during the recovery move will cause trouble, because we
+	 * run into already-existing page tables. So check both VMAs.
+	 */
+	return !vma_has_uffd_without_event_remap(pmc->old) &&
+	       !vma_has_uffd_without_event_remap(pmc->new);
+}
+
 #ifdef CONFIG_HAVE_MOVE_PMD
 static bool move_normal_pmd(struct pagetable_move_control *pmc,
 			pmd_t *old_pmd, pmd_t *new_pmd)
@@ -335,6 +354,8 @@ static bool move_normal_pmd(struct paget
 
 	if (!arch_supports_page_table_move())
 		return false;
+	if (!uffd_supports_page_table_move(pmc))
+		return false;
 	/*
 	 * The destination pmd shouldn't be established, free_pgtables()
 	 * should have released it.
@@ -361,15 +382,6 @@ static bool move_normal_pmd(struct paget
 	if (WARN_ON_ONCE(!pmd_none(*new_pmd)))
 		return false;
 
-	/* If this pmd belongs to a uffd vma with remap events disabled, we need
-	 * to ensure that the uffd-wp state is cleared from all pgtables. This
-	 * means recursing into lower page tables in move_page_tables(), and we
-	 * can reuse the existing code if we simply treat the entry as "not
-	 * moved".
-	 */
-	if (vma_has_uffd_without_event_remap(vma))
-		return false;
-
 	/*
 	 * We don't have to worry about the ordering of src and dst
 	 * ptlocks because exclusive mmap_lock prevents deadlock.
@@ -418,6 +430,8 @@ static bool move_normal_pud(struct paget
 
 	if (!arch_supports_page_table_move())
 		return false;
+	if (!uffd_supports_page_table_move(pmc))
+		return false;
 	/*
 	 * The destination pud shouldn't be established, free_pgtables()
 	 * should have released it.
@@ -425,15 +439,6 @@ static bool move_normal_pud(struct paget
 	if (WARN_ON_ONCE(!pud_none(*new_pud)))
 		return false;
 
-	/* If this pud belongs to a uffd vma with remap events disabled, we need
-	 * to ensure that the uffd-wp state is cleared from all pgtables. This
-	 * means recursing into lower page tables in move_page_tables(), and we
-	 * can reuse the existing code if we simply treat the entry as "not
-	 * moved".
-	 */
-	if (vma_has_uffd_without_event_remap(vma))
-		return false;
-
 	/*
 	 * We don't have to worry about the ordering of src and dst
 	 * ptlocks because exclusive mmap_lock prevents deadlock.
_

Patches currently in -mm which might be from david@redhat.com are

mm-mremap-fix-warn-with-uffd-that-has-remap-events-disabled.patch
mm-migrate-remove-migratepage_unmap.patch
treewide-remove-migratepage_success.patch
mm-huge_memory-move-more-common-code-into-insert_pmd.patch
mm-huge_memory-move-more-common-code-into-insert_pud.patch
mm-huge_memory-support-huge-zero-folio-in-vmf_insert_folio_pmd.patch
fs-dax-use-vmf_insert_folio_pmd-to-insert-the-huge-zero-folio.patch
mm-huge_memory-mark-pmd-mappings-of-the-huge-zero-folio-special.patch
powerpc-ptdump-rename-struct-pgtable_level-to-struct-ptdump_pglevel.patch
mm-rmap-convert-enum-rmap_level-to-enum-pgtable_level.patch
mm-memory-convert-print_bad_pte-to-print_bad_page_map.patch
mm-memory-factor-out-common-code-from-vm_normal_page_.patch
mm-introduce-and-use-vm_normal_page_pud.patch
mm-rename-vm_ops-find_special_page-to-vm_ops-find_normal_page.patch
prctl-extend-pr_set_thp_disable-to-optionally-exclude-vm_hugepage.patch
mm-huge_memory-convert-tva_flags-to-enum-tva_type.patch
mm-huge_memory-respect-madv_collapse-with-pr_thp_disable_except_advised.patch

