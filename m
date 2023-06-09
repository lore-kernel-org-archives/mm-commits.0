Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B950C7EE43
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:35:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232536AbjFIXfR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:35:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233015AbjFIXda (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:33:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0B4049F4
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:30:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E4FB63EA3
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:30:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7923C433D2;
        Fri,  9 Jun 2023 23:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353434;
        bh=eNbxA6yX0R08+Y9K9bX55aaZw25ivecagS088LkOy/w=;
        h=Date:To:From:Subject:From;
        b=gqYqlPGgFIyLqEWrdG2QR6l2bJ0ivdF5d+gum3VCedlaGROsxwzyc1rceljNVYYtU
         yAT9xA/Q3NMokwSUoJ+RjdGM78B6B0FY0yW7tvg6OaNZJXUr0RvQkMaSV96ehAb6dX
         b8Euldm9OEd1QX3gbj2D7QdKCkf9karbysHS6feM=
Date:   Fri, 09 Jun 2023 16:30:34 -0700
To:     mm-commits@vger.kernel.org, peterz@infradead.org,
        mpenttil@redhat.com, kirill@shutemov.name, jhubbard@nvidia.com,
        jgg@nvidia.com, jack@suse.cz, david@redhat.com, lstoakes@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-disallow-foll_longterm-gup-nonfast-writing-to-file-backed-mappings.patch removed from -mm tree
Message-Id: <20230609233034.B7923C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/gup: disallow FOLL_LONGTERM GUP-nonfast writing to file-backed mappings
has been removed from the -mm tree.  Its filename was
     mm-gup-disallow-foll_longterm-gup-nonfast-writing-to-file-backed-mappings.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: mm/gup: disallow FOLL_LONGTERM GUP-nonfast writing to file-backed mappings
Date: Thu, 4 May 2023 22:27:52 +0100

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

This results in both data being written to a folio without writenotify,
and the folio being dirtied unexpectedly (if the caller decides to do so).

This issue was first reported by Jan Kara [1] in 2018, where the problem
resulted in file system crashes.

This is only relevant when the mappings are file-backed and the underlying
file system requires folio dirty tracking.  File systems which do not,
such as shmem or hugetlb, are not at risk and therefore can be written to
without issue.

Unfortunately this limitation of GUP has been present for some time and
requires future rework of the GUP API in order to provide correct write
access to such mappings.

However, for the time being we introduce this check to prevent the most
egregious case of this occurring, use of the FOLL_LONGTERM pin.

These mappings are considerably more likely to be written to after folios
are cleaned and thus simply must not be permitted to do so.

This patch changes only the slow-path GUP functions, a following patch
adapts the GUP-fast path along similar lines.

[1] https://lore.kernel.org/linux-mm/20180103100430.GE4911@quack2.suse.cz/

Link: https://lkml.kernel.org/r/7282506742d2390c125949c2f9894722750bb68a.1683235180.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Mika Penttilä <mpenttil@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Kirill A . Shutemov <kirill@shutemov.name>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   44 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 43 insertions(+), 1 deletion(-)

--- a/mm/gup.c~mm-gup-disallow-foll_longterm-gup-nonfast-writing-to-file-backed-mappings
+++ a/mm/gup.c
@@ -959,16 +959,54 @@ static int faultin_page(struct vm_area_s
 	return 0;
 }
 
+/*
+ * Writing to file-backed mappings which require folio dirty tracking using GUP
+ * is a fundamentally broken operation, as kernel write access to GUP mappings
+ * do not adhere to the semantics expected by a file system.
+ *
+ * Consider the following scenario:-
+ *
+ * 1. A folio is written to via GUP which write-faults the memory, notifying
+ *    the file system and dirtying the folio.
+ * 2. Later, writeback is triggered, resulting in the folio being cleaned and
+ *    the PTE being marked read-only.
+ * 3. The GUP caller writes to the folio, as it is mapped read/write via the
+ *    direct mapping.
+ * 4. The GUP caller, now done with the page, unpins it and sets it dirty
+ *    (though it does not have to).
+ *
+ * This results in both data being written to a folio without writenotify, and
+ * the folio being dirtied unexpectedly (if the caller decides to do so).
+ */
+static bool writable_file_mapping_allowed(struct vm_area_struct *vma,
+					  unsigned long gup_flags)
+{
+	/*
+	 * If we aren't pinning then no problematic write can occur. A long term
+	 * pin is the most egregious case so this is the case we disallow.
+	 */
+	if ((gup_flags & (FOLL_PIN | FOLL_LONGTERM)) !=
+	    (FOLL_PIN | FOLL_LONGTERM))
+		return true;
+
+	/*
+	 * If the VMA does not require dirty tracking then no problematic write
+	 * can occur either.
+	 */
+	return !vma_needs_dirty_tracking(vma);
+}
+
 static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
 {
 	vm_flags_t vm_flags = vma->vm_flags;
 	int write = (gup_flags & FOLL_WRITE);
 	int foreign = (gup_flags & FOLL_REMOTE);
+	bool vma_anon = vma_is_anonymous(vma);
 
 	if (vm_flags & (VM_IO | VM_PFNMAP))
 		return -EFAULT;
 
-	if (gup_flags & FOLL_ANON && !vma_is_anonymous(vma))
+	if ((gup_flags & FOLL_ANON) && !vma_anon)
 		return -EFAULT;
 
 	if ((gup_flags & FOLL_LONGTERM) && vma_is_fsdax(vma))
@@ -978,6 +1016,10 @@ static int check_vma_flags(struct vm_are
 		return -EFAULT;
 
 	if (write) {
+		if (!vma_anon &&
+		    !writable_file_mapping_allowed(vma, gup_flags))
+			return -EFAULT;
+
 		if (!(vm_flags & VM_WRITE)) {
 			if (!(gup_flags & FOLL_FORCE))
 				return -EFAULT;
_

Patches currently in -mm which might be from lstoakes@gmail.com are

mm-vmalloc-do-not-output-a-spurious-warning-when-huge-vmalloc-fails.patch

