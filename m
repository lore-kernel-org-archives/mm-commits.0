Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AF08CA0FF3
	for <mm-commits@archiver.kernel.org>; Tue,  5 Sep 2023 16:35:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbjIEQfO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Sep 2023 12:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243037AbjIEQLH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Sep 2023 12:11:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E61D4C12
        for <mm-commits@vger.kernel.org>; Tue,  5 Sep 2023 09:04:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DFEC4B8128D
        for <mm-commits@vger.kernel.org>; Tue,  5 Sep 2023 16:02:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EE15C433C7;
        Tue,  5 Sep 2023 16:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693929756;
        bh=DHVbieGa0C9ts0DK43EkKyp9w63vxDgXOlEXaYS9DdM=;
        h=Date:To:From:Subject:From;
        b=mJdwFA2KQ6oh1DD6RjD/8hvMch/DZ5nmUBc1BFAsOP6LCsJHGi8DHqHDhe5ZTEIcP
         jilbzUKg9Jl0fZzg47S2CxgUwf/B2RQkvJcDb1BfTp5ZOkiQMlJs7o5UUdAlDvA/iZ
         gh1B03rDmRT0WgzghfIYs0snpvz7HkTd8sUbLoEI=
Date:   Tue, 05 Sep 2023 09:02:35 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        torvalds@linux-foundation.org, surenb@google.com, shuah@kernel.org,
        paulmck@kernel.org, mhocko@suse.com, lstoakes@gmail.com,
        lokeshgidra@google.com, Liam.Howlett@oracle.com,
        kirill@shutemov.name, kaleshsingh@google.com,
        joel@joelfernandes.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-optimize-the-start-addresses-in-move_page_tables.patch added to mm-unstable branch
Message-Id: <20230905160236.7EE15C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mremap: optimize the start addresses in move_page_tables()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mremap-optimize-the-start-addresses-in-move_page_tables.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-optimize-the-start-addresses-in-move_page_tables.patch

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
Subject: mm/mremap: optimize the start addresses in move_page_tables()
Date: Sun, 3 Sep 2023 15:13:22 +0000

Patch series "Optimize mremap during mutual alignment within PMD", v6.

This patchset optimizes the start addresses in move_page_tables() and
tests the changes.  It addresses a warning [1] that occurs due to a
downward, overlapping move on a mutually-aligned offset within a PMD
during exec.  By initiating the copy process at the PMD level when such
alignment is present, we can prevent this warning and speed up the copying
process at the same time.  Linus Torvalds suggested this idea.  Check the
individual patches for more details.  [1]
https://lore.kernel.org/all/ZB2GTBD%2FLWTrkOiO@dhcp22.suse.cz/


This patch (of 7):

Recently, we see reports [1] of a warning that triggers due to
move_page_tables() doing a downward and overlapping move on a
mutually-aligned offset within a PMD.  By mutual alignment, I mean the
source and destination addresses of the mremap are at the same offset
within a PMD.

This mutual alignment along with the fact that the move is downward is
sufficient to cause a warning related to having an allocated PMD that does
not have PTEs in it.

This warning will only trigger when there is mutual alignment in the move
operation.  A solution, as suggested by Linus Torvalds [2], is to initiate
the copy process at the PMD level whenever such alignment is present. 
Implementing this approach will not only prevent the warning from being
triggered, but it will also optimize the operation as this method should
enhance the speed of the copy process whenever there's a possibility to
start copying at the PMD level.

Some more points:
a. The optimization can be done only when both the source and
destination of the mremap do not have anything mapped below it up to a
PMD boundary. I add support to detect that.

b. #1 is not a problem for the call to move_page_tables() from exec.c as
nothing is expected to be mapped below the source. However, for
non-overlapping mutually aligned moves as triggered by mremap(2), I
added support for checking such cases.

c. I currently only optimize for PMD moves, in the future I/we can build
on this work and do PUD moves as well if there is a need for this. But I
want to take it one step at a time.

d. We need to be careful about mremap of ranges within the VMA itself.
For this purpose, I added checks to determine if the address after
alignment falls within its VMA itself.

[1] https://lore.kernel.org/all/ZB2GTBD%2FLWTrkOiO@dhcp22.suse.cz/
[2] https://lore.kernel.org/all/CAHk-=whd7msp8reJPfeGNyt0LiySMT0egExx3TVZSX3Ok6X=9g@mail.gmail.com/

Link: https://lkml.kernel.org/r/20230903151328.2981432-1-joel@joelfernandes.org
Link: https://lkml.kernel.org/r/20230903151328.2981432-2-joel@joelfernandes.org
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |   62 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

--- a/mm/mremap.c~mm-mremap-optimize-the-start-addresses-in-move_page_tables
+++ a/mm/mremap.c
@@ -489,6 +489,53 @@ static bool move_pgt_entry(enum pgt_entr
 	return moved;
 }
 
+/*
+ * A helper to check if a previous mapping exists. Required for
+ * move_page_tables() and realign_addr() to determine if a previous mapping
+ * exists before we can do realignment optimizations.
+ */
+static bool can_align_down(struct vm_area_struct *vma, unsigned long addr_to_align,
+			       unsigned long mask)
+{
+	unsigned long addr_masked = addr_to_align & mask;
+
+	/*
+	 * If @addr_to_align of either source or destination is not the beginning
+	 * of the corresponding VMA, we can't align down or we will destroy part
+	 * of the current mapping.
+	 */
+	if (vma->vm_start != addr_to_align)
+		return false;
+
+	/*
+	 * Make sure the realignment doesn't cause the address to fall on an
+	 * existing mapping.
+	 */
+	return find_vma_intersection(vma->vm_mm, addr_masked, vma->vm_start) == NULL;
+}
+
+/* Opportunistically realign to specified boundary for faster copy. */
+static void try_realign_addr(unsigned long *old_addr, struct vm_area_struct *old_vma,
+			     unsigned long *new_addr, struct vm_area_struct *new_vma,
+			     unsigned long mask)
+{
+	/* Skip if the addresses are already aligned. */
+	if ((*old_addr & ~mask) == 0)
+		return;
+
+	/* Only realign if the new and old addresses are mutually aligned. */
+	if ((*old_addr & ~mask) != (*new_addr & ~mask))
+		return;
+
+	/* Ensure realignment doesn't cause overlap with existing mappings. */
+	if (!can_align_down(old_vma, *old_addr, mask) ||
+	    !can_align_down(new_vma, *new_addr, mask))
+		return;
+
+	*old_addr = *old_addr & mask;
+	*new_addr = *new_addr & mask;
+}
+
 unsigned long move_page_tables(struct vm_area_struct *vma,
 		unsigned long old_addr, struct vm_area_struct *new_vma,
 		unsigned long new_addr, unsigned long len,
@@ -508,6 +555,14 @@ unsigned long move_page_tables(struct vm
 		return move_hugetlb_page_tables(vma, new_vma, old_addr,
 						new_addr, len);
 
+	/*
+	 * If possible, realign addresses to PMD boundary for faster copy.
+	 * Only realign if the mremap copying hits a PMD boundary.
+	 */
+	if ((vma != new_vma)
+		&& (len >= PMD_SIZE - (old_addr & ~PMD_MASK)))
+		try_realign_addr(&old_addr, vma, &new_addr, new_vma, PMD_MASK);
+
 	flush_cache_range(vma, old_addr, old_end);
 	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma->vm_mm,
 				old_addr, old_end);
@@ -577,6 +632,13 @@ again:
 
 	mmu_notifier_invalidate_range_end(&range);
 
+	/*
+	 * Prevent negative return values when {old,new}_addr was realigned
+	 * but we broke out of the above loop for the first PMD itself.
+	 */
+	if (len + old_addr < old_end)
+		return 0;
+
 	return len + old_addr - old_end;	/* how much done */
 }
 
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

