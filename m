Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCFA0CDB486
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:37:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344716AbjJRVhi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235331AbjJRVgw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:36:52 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35242D5D
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:35:59 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D05C433C7;
        Wed, 18 Oct 2023 21:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664958;
        bh=F3vShaq29XLRsjoBoV/+5zDe0BcwHsp70Uu5oKaTOsQ=;
        h=Date:To:From:Subject:From;
        b=zgQ7XlNtGD3Y9c2xUkdJOXxvea4jjjoEkVo38olFXN6hSKqXQ82ZfYphu+yjTHCCe
         1tXptSyLV6LxDtrjG2tJzyU6dQPLQWQdhrGzviZx7SMIjKTBxvy4+ALAznr588kRMj
         frgpJihgYbV9q+nEc10QYT0upasN8ICZLVP0G424=
Date:   Wed, 18 Oct 2023 14:35:58 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, rppt@kernel.org,
        Liam.Howlett@oracle.com, david@redhat.com, lstoakes@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mprotect-allow-unfaulted-vmas-to-be-unaccounted-on-mprotect.patch removed from -mm tree
Message-Id: <20231018213558.C7D05C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mprotect: allow unfaulted VMAs to be unaccounted on mprotect()
has been removed from the -mm tree.  Its filename was
     mm-mprotect-allow-unfaulted-vmas-to-be-unaccounted-on-mprotect.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: mm/mprotect: allow unfaulted VMAs to be unaccounted on mprotect()
Date: Tue, 10 Oct 2023 08:25:02 +0100

When mprotect() is used to make unwritable VMAs writable, they have the
VM_ACCOUNT flag applied and memory accounted accordingly.

If the VMA has had no pages faulted in and is then made unwritable once
again, it will remain accounted for, despite not being capable of
extending memory usage.

Consider:-

ptr = mmap(NULL, page_size * 3, PROT_READ, MAP_ANON | MAP_PRIVATE, -1, 0);
mprotect(ptr + page_size, page_size, PROT_READ | PROT_WRITE);
mprotect(ptr + page_size, page_size, PROT_READ);

The first mprotect() splits the range into 3 VMAs and the second fails to
merge the three as the middle VMA has VM_ACCOUNT set and the others do
not, rendering them unmergeable.

This is unnecessary, since no pages have actually been allocated and the
middle VMA is not capable of utilising more memory, thereby introducing
unnecessary VMA fragmentation (and accounting for more memory than is
necessary).

Since we cannot efficiently determine which pages map to an anonymous VMA,
we have to be very conservative - determining whether any pages at all
have been faulted in, by checking whether vma->anon_vma is NULL.

We can see that the lack of anon_vma implies that no anonymous pages are
present as evidenced by vma_needs_copy() utilising this on fork to
determine whether page tables need to be copied.

The only place where anon_vma is set NULL explicitly is on fork with
VM_WIPEONFORK set, however since this flag is intended to cause the child
process to not CoW on a given memory range, it is right to interpret this
as indicating the VMA has no faulted-in anonymous memory mapped.

If the VMA was forked without VM_WIPEONFORK set, then anon_vma_fork() will
have ensured that a new anon_vma is assigned (and correctly related to its
parent anon_vma) should any pages be CoW-mapped.

The overall operation is safe against races as we hold a write lock against
mm->mmap_lock.

If we could efficiently look up the VMA's faulted-in pages then we would
unaccount all those pages not yet faulted in.  However as the original
comment alludes this simply isn't currently possible, so we are
conservative and account all pages or none at all.

Link: https://lkml.kernel.org/r/ad5540371a16623a069f03f4db1739f33cde1fab.1696921767.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/mm/mprotect.c~mm-mprotect-allow-unfaulted-vmas-to-be-unaccounted-on-mprotect
+++ a/mm/mprotect.c
@@ -608,8 +608,11 @@ mprotect_fixup(struct vma_iterator *vmi,
 	/*
 	 * If we make a private mapping writable we increase our commit;
 	 * but (without finer accounting) cannot reduce our commit if we
-	 * make it unwritable again. hugetlb mapping were accounted for
-	 * even if read-only so there is no need to account for them here
+	 * make it unwritable again except in the anonymous case where no
+	 * anon_vma has yet to be assigned.
+	 *
+	 * hugetlb mapping were accounted for even if read-only so there is
+	 * no need to account for them here.
 	 */
 	if (newflags & VM_WRITE) {
 		/* Check space limits when area turns into data. */
@@ -623,6 +626,9 @@ mprotect_fixup(struct vma_iterator *vmi,
 				return -ENOMEM;
 			newflags |= VM_ACCOUNT;
 		}
+	} else if ((oldflags & VM_ACCOUNT) && vma_is_anonymous(vma) &&
+		   !vma->anon_vma) {
+		newflags &= ~VM_ACCOUNT;
 	}
 
 	/*
@@ -665,6 +671,9 @@ success:
 
 	change_protection(tlb, vma, start, end, mm_cp_flags);
 
+	if ((oldflags & VM_ACCOUNT) && !(newflags & VM_ACCOUNT))
+		vm_unacct_memory(nrpages);
+
 	/*
 	 * Private VM_LOCKED VMA becoming writable: trigger COW to avoid major
 	 * fault on access.
_

Patches currently in -mm which might be from lstoakes@gmail.com are


