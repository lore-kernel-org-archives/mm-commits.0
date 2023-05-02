Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6B99C77B75
	for <mm-commits@archiver.kernel.org>; Tue,  2 May 2023 23:53:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbjEBXxU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 2 May 2023 19:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjEBXxR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 2 May 2023 19:53:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB2E83AAB
        for <mm-commits@vger.kernel.org>; Tue,  2 May 2023 16:52:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37D02629D2
        for <mm-commits@vger.kernel.org>; Tue,  2 May 2023 23:52:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D504C433D2;
        Tue,  2 May 2023 23:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683071569;
        bh=4857jKqZDjTfMjdzbxPPuhPs+ef5Hg+HhOFrpzQfBYo=;
        h=Date:To:From:Subject:From;
        b=MXUHFtW+jp6a1Vg2PusZOWuglKbXyfDbSat0oP8KHmf5pInR2ohAujcjfTKf1CYbl
         oaolOJgnc6tu53FVuD+C9OLUWJNo9IsRV7Jh4FzwMDLScKJTYsqWGQ+BxARNIWNJT7
         VjnWSCFxzGdXYhaoGGvxv2Zz3Tb62yBTJdfmS7es=
Date:   Tue, 02 May 2023 16:52:48 -0700
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
Subject: + mm-gup-disallow-foll_longterm-gup-nonfast-writing-to-file-backed-mappings.patch added to mm-unstable branch
Message-Id: <20230502235249.7D504C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: disallow FOLL_LONGTERM GUP-nonfast writing to file-backed mappings
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup-disallow-foll_longterm-gup-nonfast-writing-to-file-backed-mappings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-disallow-foll_longterm-gup-nonfast-writing-to-file-backed-mappings.patch

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
Subject: mm/gup: disallow FOLL_LONGTERM GUP-nonfast writing to file-backed mappings
Date: Tue, 2 May 2023 23:51:34 +0100

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

Link: https://lkml.kernel.org/r/f7533317ee29a1a4aa54afe0002367a4cd288a1d.1683067198.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
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

mm-mempolicy-correctly-update-prev-when-policy-is-equal-on-mbind.patch
mm-mmap-vma_merge-always-check-invariants.patch
mm-mmap-separate-writenotify-and-dirty-tracking-logic.patch
mm-gup-disallow-foll_longterm-gup-nonfast-writing-to-file-backed-mappings.patch
mm-gup-disallow-foll_longterm-gup-fast-writing-to-file-backed-mappings.patch

