Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 310FBCD8CAE
	for <mm-commits@archiver.kernel.org>; Tue, 10 Oct 2023 18:17:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233538AbjJJSRr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Oct 2023 14:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232771AbjJJSRr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Oct 2023 14:17:47 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C315B7
        for <mm-commits@vger.kernel.org>; Tue, 10 Oct 2023 11:17:45 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC889C433C8;
        Tue, 10 Oct 2023 18:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696961864;
        bh=kOoxlJYZPRjovNZgt4eAtjsgH5AYNd25vVUhlH3G2Jc=;
        h=Date:To:From:Subject:From;
        b=tXuTYZxugdtcptj7Hzvbn4VgeY6+uC2cijHPePBKvAP5BzdchrX1ZDmMKAAlW/n3P
         uInY7Hkc8wAOFWvFMoJ3EMmRbgNannvu5onS8tA07ZcPGcRqXf+/jBcA0WOlCE3UrI
         3Q+Kv3f9q5W5EYtFYy4GtINns/l5Kr4Di8JoWbRI=
Date:   Tue, 10 Oct 2023 11:17:32 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, rppt@kernel.org,
        Liam.Howlett@oracle.com, david@redhat.com, lstoakes@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mprotect-allow-unfaulted-vmas-to-be-unaccounted-on-mprotect.patch added to mm-unstable branch
Message-Id: <20231010181740.BC889C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mprotect: allow unfaulted VMAs to be unaccounted on mprotect()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mprotect-allow-unfaulted-vmas-to-be-unaccounted-on-mprotect.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mprotect-allow-unfaulted-vmas-to-be-unaccounted-on-mprotect.patch

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
Cc: David Hildenbrand <david@redhat.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
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
 
 	merged = vma_modify_flags(vmi, *pprev, vma, start, end, newflags);
@@ -638,6 +644,9 @@ mprotect_fixup(struct vma_iterator *vmi,
 		*pprev = vma;
 	}
 
+	if ((oldflags & VM_ACCOUNT) && !(newflags & VM_ACCOUNT))
+		vm_unacct_memory(nrpages);
+
 	/*
 	 * vm_flags and vm_page_prot are protected by the mmap_lock
 	 * held in write mode.
_

Patches currently in -mm which might be from lstoakes@gmail.com are

mm-filemap-clarify-filemap_fault-comments-for-not-uptodate-case.patch
mm-filemap-clarify-filemap_fault-comments-for-not-uptodate-case-fix.patch
mm-make-__access_remote_vm-static.patch
mm-gup-explicitly-define-and-check-internal-gup-flags-disallow-foll_touch.patch
mm-gup-make-failure-to-pin-an-error-if-foll_nowait-not-specified.patch
mm-gup-adapt-get_user_page_vma_remote-to-never-return-null.patch
mm-move-vma_policy-and-anon_vma_name-decls-to-mm_typesh.patch
mm-abstract-the-vma_merge-split_vma-pattern-for-mprotect-et-al.patch
mm-make-vma_merge-and-split_vma-internal.patch
mm-abstract-merge-for-new-vmas-into-vma_merge_new_vma.patch
mm-abstract-vma-merge-and-extend-into-vma_merge_extend-helper.patch
mm-drop-the-assumption-that-vm_shared-always-implies-writable.patch
mm-update-memfd-seal-write-check-to-include-f_seal_write.patch
mm-enforce-the-mapping_map_writable-check-after-call_mmap.patch
mm-mprotect-allow-unfaulted-vmas-to-be-unaccounted-on-mprotect.patch

