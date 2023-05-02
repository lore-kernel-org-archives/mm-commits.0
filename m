Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AA90C77B78
	for <mm-commits@archiver.kernel.org>; Tue,  2 May 2023 23:53:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbjEBXxQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 2 May 2023 19:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbjEBXxP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 2 May 2023 19:53:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD4E3AB6
        for <mm-commits@vger.kernel.org>; Tue,  2 May 2023 16:52:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99BB762526
        for <mm-commits@vger.kernel.org>; Tue,  2 May 2023 23:52:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB044C433D2;
        Tue,  2 May 2023 23:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683071567;
        bh=JIXb7Ac1CrLAoqrfvHNnvZvWZqWDUp66xkEFZ6fp9EY=;
        h=Date:To:From:Subject:From;
        b=VHM5O8nX98bVK1O4Umx9wWO9SMp15LEOWM98Hhro7h8KOKkO3Wn8Qv7Jl8v8x3EIa
         p4Moxy1d2nLgaFUDSMONgFMu29sxNDBGeEcovdJl+juqETqUNSLvS2vVs4X9jO5i6/
         wxXhiSusxjioaDlehw/KeSjSBn1EehFxhuv2iFao=
Date:   Tue, 02 May 2023 16:52:46 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, tytso@mit.edu,
        richardcochran@gmail.com, peterz@infradead.org, peterx@redhat.com,
        paulmck@kernel.org, pabeni@redhat.com, oleg@redhat.com,
        neescoba@cisco.com, namhyung@kernel.org, mpenttil@redhat.com,
        mjrosato@linux.ibm.com, mingo@redhat.com, mark.rutland@arm.com,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        leon@kernel.org, kuba@kernel.org, kirill@shutemov.name,
        jonathan.lemon@gmail.com, jolsa@kernel.org,
        john.fastabend@gmail.com, jhubbard@nvidia.com, jgg@nvidia.com,
        jack@suse.cz, irogers@google.com, hawk@kernel.org,
        edumazet@google.com, dennis.dalessandro@cornelisnetworks.com,
        david@redhat.com, david@fromorbit.com, davem@davemloft.net,
        daniel@iogearbox.net, brauner@kernel.org,
        borntraeger@linux.ibm.com, bmt@zurich.ibm.com, bjorn@kernel.org,
        benve@cisco.com, axboe@kernel.dk, ast@kernel.org,
        asml.silence@gmail.com, alexander.shishkin@linux.intel.com,
        adrian.hunter@intel.com, acme@kernel.org, lstoakes@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-separate-writenotify-and-dirty-tracking-logic.patch added to mm-unstable branch
Message-Id: <20230502235246.DB044C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: separate writenotify and dirty tracking logic
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-separate-writenotify-and-dirty-tracking-logic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-separate-writenotify-and-dirty-tracking-logic.patch

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
Subject: mm/mmap: separate writenotify and dirty tracking logic
Date: Tue, 2 May 2023 23:51:33 +0100

Patch series "mm/gup: disallow GUP writing to file-backed mappings by
default", v8.

Writing to file-backed mappings which require folio dirty tracking using
GUP is a fundamentally broken operation, as kernel write access to GUP
mappings do not adhere to the semantics expected by a file system.

A GUP caller uses the direct mapping to access the folio, which does not
cause write notify to trigger, nor does it enforce that the caller marks
the folio dirty.

The problem arises when, after an initial write to the folio, writeback
results in the folio being cleaned and then the caller, via the GUP
interface, writes to the folio again.

As a result of the use of this secondary, direct, mapping to the folio no
write notify will occur, and if the caller does mark the folio dirty, this
will be done so unexpectedly.

For example, consider the following scenario:-

1. A folio is written to via GUP which write-faults the memory, notifying
   the file system and dirtying the folio.
2. Later, writeback is triggered, resulting in the folio being cleaned and
   the PTE being marked read-only.
3. The GUP caller writes to the folio, as it is mapped read/write via the
   direct mapping.
4. The GUP caller, now done with the page, unpins it and sets it dirty
   (though it does not have to).

This change updates both the PUP FOLL_LONGTERM slow and fast APIs.  As
pin_user_pages_fast_only() does not exist, we can rely on a slightly
imperfect whitelisting in the PUP-fast case and fall back to the slow case
should this fail.


This patch (of 3):

vma_wants_writenotify() is specifically intended for setting PTE page
table flags, accounting for existing page table flag state and whether the
filesystem performs dirty tracking.

Separate out the notions of dirty tracking and PTE write notify checking
in order that we can invoke the dirty tracking check from elsewhere.

Note that this change introduces a very small duplicate check of the
separated out vm_ops_needs_writenotify() and vma_is_shared_writable()
functions.  This is necessary to avoid making vma_needs_dirty_tracking()
needlessly complicated (e.g.  passing flags or having it assume checks
were already performed).  This is small enough that it doesn't seem too
egregious.

We check to ensure the mapping is shared writable, as any GUP caller will
be safe - MAP_PRIVATE mappings will be CoW'd and read-only file-backed
shared mappings are not permitted access, even with FOLL_FORCE.

Link: https://lkml.kernel.org/r/cover.1683067198.git.lstoakes@gmail.com
Link: https://lkml.kernel.org/r/7ac8bb557517bcdc9225b4e4893a2ca7f603fcc4.1683067198.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Mika Penttilä <mpenttil@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Bernard Metzler <bmt@zurich.ibm.com>
Cc: Björn Töpel <bjorn@kernel.org>
Cc: Christian Benvenuti <benve@cisco.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jesper Dangaard Brouer <hawk@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Jonathan Lemon <jonathan.lemon@gmail.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc: Magnus Karlsson <magnus.karlsson@intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Rosato <mjrosato@linux.ibm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Nelson Escobar <neescoba@cisco.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 
 mm/mmap.c          |   53 ++++++++++++++++++++++++++++++++-----------
 2 files changed, 41 insertions(+), 13 deletions(-)

--- a/include/linux/mm.h~mm-mmap-separate-writenotify-and-dirty-tracking-logic
+++ a/include/linux/mm.h
@@ -2422,6 +2422,7 @@ extern unsigned long move_page_tables(st
 #define  MM_CP_UFFD_WP_ALL                 (MM_CP_UFFD_WP | \
 					    MM_CP_UFFD_WP_RESOLVE)
 
+bool vma_needs_dirty_tracking(struct vm_area_struct *vma);
 int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot);
 static inline bool vma_wants_manual_pte_write_upgrade(struct vm_area_struct *vma)
 {
--- a/mm/mmap.c~mm-mmap-separate-writenotify-and-dirty-tracking-logic
+++ a/mm/mmap.c
@@ -1475,6 +1475,42 @@ SYSCALL_DEFINE1(old_mmap, struct mmap_ar
 }
 #endif /* __ARCH_WANT_SYS_OLD_MMAP */
 
+/* Do VMA operations imply write notify is required? */
+static bool vm_ops_needs_writenotify(const struct vm_operations_struct *vm_ops)
+{
+	return vm_ops && (vm_ops->page_mkwrite || vm_ops->pfn_mkwrite);
+}
+
+/* Is this VMA shared and writable? */
+static bool vma_is_shared_writable(struct vm_area_struct *vma)
+{
+	return (vma->vm_flags & (VM_WRITE | VM_SHARED)) ==
+		(VM_WRITE | VM_SHARED);
+}
+
+/*
+ * Does this VMA require the underlying folios to have their dirty state
+ * tracked?
+ */
+bool vma_needs_dirty_tracking(struct vm_area_struct *vma)
+{
+	/* Only shared, writable VMAs require dirty tracking. */
+	if (!vma_is_shared_writable(vma))
+		return false;
+
+	/* Does the filesystem need to be notified? */
+	if (vm_ops_needs_writenotify(vma->vm_ops))
+		return true;
+
+	/* Specialty mapping? */
+	if (vma->vm_flags & VM_PFNMAP)
+		return false;
+
+	/* Can the mapping track the dirty pages? */
+	return vma->vm_file && vma->vm_file->f_mapping &&
+		mapping_can_writeback(vma->vm_file->f_mapping);
+}
+
 /*
  * Some shared mappings will want the pages marked read-only
  * to track write events. If so, we'll downgrade vm_page_prot
@@ -1483,21 +1519,18 @@ SYSCALL_DEFINE1(old_mmap, struct mmap_ar
  */
 int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot)
 {
-	vm_flags_t vm_flags = vma->vm_flags;
-	const struct vm_operations_struct *vm_ops = vma->vm_ops;
-
 	/* If it was private or non-writable, the write bit is already clear */
-	if ((vm_flags & (VM_WRITE|VM_SHARED)) != ((VM_WRITE|VM_SHARED)))
+	if (!vma_is_shared_writable(vma))
 		return 0;
 
 	/* The backer wishes to know when pages are first written to? */
-	if (vm_ops && (vm_ops->page_mkwrite || vm_ops->pfn_mkwrite))
+	if (vm_ops_needs_writenotify(vma->vm_ops))
 		return 1;
 
 	/* The open routine did something to the protections that pgprot_modify
 	 * won't preserve? */
 	if (pgprot_val(vm_page_prot) !=
-	    pgprot_val(vm_pgprot_modify(vm_page_prot, vm_flags)))
+	    pgprot_val(vm_pgprot_modify(vm_page_prot, vma->vm_flags)))
 		return 0;
 
 	/*
@@ -1511,13 +1544,7 @@ int vma_wants_writenotify(struct vm_area
 	if (userfaultfd_wp(vma))
 		return 1;
 
-	/* Specialty mapping? */
-	if (vm_flags & VM_PFNMAP)
-		return 0;
-
-	/* Can the mapping track the dirty pages? */
-	return vma->vm_file && vma->vm_file->f_mapping &&
-		mapping_can_writeback(vma->vm_file->f_mapping);
+	return vma_needs_dirty_tracking(vma);
 }
 
 /*
_

Patches currently in -mm which might be from lstoakes@gmail.com are

mm-mempolicy-correctly-update-prev-when-policy-is-equal-on-mbind.patch
mm-mmap-vma_merge-always-check-invariants.patch
mm-mmap-separate-writenotify-and-dirty-tracking-logic.patch
mm-gup-disallow-foll_longterm-gup-nonfast-writing-to-file-backed-mappings.patch
mm-gup-disallow-foll_longterm-gup-fast-writing-to-file-backed-mappings.patch

