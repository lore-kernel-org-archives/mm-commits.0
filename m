Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8159ACA0FFA
	for <mm-commits@archiver.kernel.org>; Tue,  5 Sep 2023 18:21:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbjIESVk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Sep 2023 14:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbjIESVj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Sep 2023 14:21:39 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 731A91707
        for <mm-commits@vger.kernel.org>; Tue,  5 Sep 2023 11:21:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2CA2CCE11D9
        for <mm-commits@vger.kernel.org>; Tue,  5 Sep 2023 16:02:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AB77C433C8;
        Tue,  5 Sep 2023 16:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693929760;
        bh=wPvbNd5dVYQVArPS3It4HCNoeQDBKSBI/bnTei4NMkU=;
        h=Date:To:From:Subject:From;
        b=Ulh1gqqYcp6hBIrpZMXuCC7QI0Q0Dwru7lILI6dk2JxOGcwZmQkdypWIqInQIxrAP
         SPWzvp35j/M+kYSSaYeFvurFQmOcpTLuG4IxN1bjP9VsepAMp1gMSmdq0B5PdoGJOJ
         20cKAFLDlkdM14/0p5sC/W02PenrZay3ypdY6tJw=
Date:   Tue, 05 Sep 2023 09:02:39 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        torvalds@linux-foundation.org, surenb@google.com, shuah@kernel.org,
        paulmck@kernel.org, mhocko@suse.com, lstoakes@gmail.com,
        lokeshgidra@google.com, Liam.Howlett@oracle.com,
        kirill@shutemov.name, kaleshsingh@google.com,
        joel@joelfernandes.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-allow-moves-within-the-same-vma-for-stack-moves.patch added to mm-unstable branch
Message-Id: <20230905160240.4AB77C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mremap: allow moves within the same VMA for stack moves
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mremap-allow-moves-within-the-same-vma-for-stack-moves.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-allow-moves-within-the-same-vma-for-stack-moves.patch

This patch will later appear in the mm-unstable branch at
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
From: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Subject: mm/mremap: allow moves within the same VMA for stack moves
Date: Sun, 3 Sep 2023 15:13:23 +0000

For the stack move happening in shift_arg_pages(), the move is happening
within the same VMA which spans the old and new ranges.

In case the aligned address happens to fall within that VMA, allow such
moves and don't abort the mremap alignment optimization.

In the regular non-stack mremap case, we cannot allow any such moves as
will end up destroying some part of the mapping (either the source of the
move, or part of the existing mapping).  So just avoid it for stack moves.

Link: https://lkml.kernel.org/r/20230903151328.2981432-3-joel@joelfernandes.org
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c          |    2 +-
 include/linux/mm.h |    2 +-
 mm/mremap.c        |   33 +++++++++++++++++++--------------
 3 files changed, 21 insertions(+), 16 deletions(-)

--- a/fs/exec.c~mm-mremap-allow-moves-within-the-same-vma-for-stack-moves
+++ a/fs/exec.c
@@ -713,7 +713,7 @@ static int shift_arg_pages(struct vm_are
 	 * process cleanup to remove whatever mess we made.
 	 */
 	if (length != move_page_tables(vma, old_start,
-				       vma, new_start, length, false))
+				       vma, new_start, length, false, true))
 		return -ENOMEM;
 
 	lru_add_drain();
--- a/include/linux/mm.h~mm-mremap-allow-moves-within-the-same-vma-for-stack-moves
+++ a/include/linux/mm.h
@@ -2480,7 +2480,7 @@ int get_cmdline(struct task_struct *task
 extern unsigned long move_page_tables(struct vm_area_struct *vma,
 		unsigned long old_addr, struct vm_area_struct *new_vma,
 		unsigned long new_addr, unsigned long len,
-		bool need_rmap_locks);
+		bool need_rmap_locks, bool for_stack);
 
 /*
  * Flags used by change_protection().  For now we make it a bitmap so
--- a/mm/mremap.c~mm-mremap-allow-moves-within-the-same-vma-for-stack-moves
+++ a/mm/mremap.c
@@ -490,12 +490,13 @@ static bool move_pgt_entry(enum pgt_entr
 }
 
 /*
- * A helper to check if a previous mapping exists. Required for
- * move_page_tables() and realign_addr() to determine if a previous mapping
- * exists before we can do realignment optimizations.
+ * A helper to check if aligning down is OK. The aligned address should fall
+ * on *no mapping*. For the stack moving down, that's a special move within
+ * the VMA that is created to span the source and destination of the move,
+ * so we make an exception for it.
  */
 static bool can_align_down(struct vm_area_struct *vma, unsigned long addr_to_align,
-			       unsigned long mask)
+			    unsigned long mask, bool for_stack)
 {
 	unsigned long addr_masked = addr_to_align & mask;
 
@@ -504,9 +505,13 @@ static bool can_align_down(struct vm_are
 	 * of the corresponding VMA, we can't align down or we will destroy part
 	 * of the current mapping.
 	 */
-	if (vma->vm_start != addr_to_align)
+	if (!for_stack && vma->vm_start != addr_to_align)
 		return false;
 
+	/* In the stack case we explicitly permit in-VMA alignment. */
+	if (for_stack && addr_masked >= vma->vm_start)
+		return true;
+
 	/*
 	 * Make sure the realignment doesn't cause the address to fall on an
 	 * existing mapping.
@@ -517,7 +522,7 @@ static bool can_align_down(struct vm_are
 /* Opportunistically realign to specified boundary for faster copy. */
 static void try_realign_addr(unsigned long *old_addr, struct vm_area_struct *old_vma,
 			     unsigned long *new_addr, struct vm_area_struct *new_vma,
-			     unsigned long mask)
+			     unsigned long mask, bool for_stack)
 {
 	/* Skip if the addresses are already aligned. */
 	if ((*old_addr & ~mask) == 0)
@@ -528,8 +533,8 @@ static void try_realign_addr(unsigned lo
 		return;
 
 	/* Ensure realignment doesn't cause overlap with existing mappings. */
-	if (!can_align_down(old_vma, *old_addr, mask) ||
-	    !can_align_down(new_vma, *new_addr, mask))
+	if (!can_align_down(old_vma, *old_addr, mask, for_stack) ||
+	    !can_align_down(new_vma, *new_addr, mask, for_stack))
 		return;
 
 	*old_addr = *old_addr & mask;
@@ -539,7 +544,7 @@ static void try_realign_addr(unsigned lo
 unsigned long move_page_tables(struct vm_area_struct *vma,
 		unsigned long old_addr, struct vm_area_struct *new_vma,
 		unsigned long new_addr, unsigned long len,
-		bool need_rmap_locks)
+		bool need_rmap_locks, bool for_stack)
 {
 	unsigned long extent, old_end;
 	struct mmu_notifier_range range;
@@ -559,9 +564,9 @@ unsigned long move_page_tables(struct vm
 	 * If possible, realign addresses to PMD boundary for faster copy.
 	 * Only realign if the mremap copying hits a PMD boundary.
 	 */
-	if ((vma != new_vma)
-		&& (len >= PMD_SIZE - (old_addr & ~PMD_MASK)))
-		try_realign_addr(&old_addr, vma, &new_addr, new_vma, PMD_MASK);
+	if (len >= PMD_SIZE - (old_addr & ~PMD_MASK))
+		try_realign_addr(&old_addr, vma, &new_addr, new_vma, PMD_MASK,
+				 for_stack);
 
 	flush_cache_range(vma, old_addr, old_end);
 	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma->vm_mm,
@@ -708,7 +713,7 @@ static unsigned long move_vma(struct vm_
 	}
 
 	moved_len = move_page_tables(vma, old_addr, new_vma, new_addr, old_len,
-				     need_rmap_locks);
+				     need_rmap_locks, false);
 	if (moved_len < old_len) {
 		err = -ENOMEM;
 	} else if (vma->vm_ops && vma->vm_ops->mremap) {
@@ -722,7 +727,7 @@ static unsigned long move_vma(struct vm_
 		 * and then proceed to unmap new area instead of old.
 		 */
 		move_page_tables(new_vma, new_addr, vma, old_addr, moved_len,
-				 true);
+				 true, false);
 		vma = new_vma;
 		old_len = new_len;
 		old_addr = new_addr;
_

Patches currently in -mm which might be from joel@joelfernandes.org are

mm-vmalloc-add-a-safer-version-of-find_vm_area-for-debug.patch
mm-mremap-optimize-the-start-addresses-in-move_page_tables.patch
mm-mremap-allow-moves-within-the-same-vma-for-stack-moves.patch
selftests-mm-fix-failure-case-when-new-remap-region-was-not-found.patch
selftests-mm-add-a-test-for-mutually-aligned-moves-pmd-size.patch
selftests-mm-add-a-test-for-remapping-to-area-immediately-after-existing-mapping.patch
selftests-mm-add-a-test-for-remapping-within-a-range.patch
selftests-mm-add-a-test-for-moving-from-an-offset-from-start-of-mapping.patch

