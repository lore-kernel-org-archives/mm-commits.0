Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C72BC433F5
	for <mm-commits@archiver.kernel.org>; Tue,  4 Oct 2022 19:42:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbiJDTmC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 Oct 2022 15:42:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbiJDTlv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 4 Oct 2022 15:41:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B393B659E8
        for <mm-commits@vger.kernel.org>; Tue,  4 Oct 2022 12:41:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D4B6614EF
        for <mm-commits@vger.kernel.org>; Tue,  4 Oct 2022 19:41:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0325C433C1;
        Tue,  4 Oct 2022 19:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664912509;
        bh=bdaPifnf4CLovgrykzcrmHiajVvxlLjb6uTx14Qq1bU=;
        h=Date:To:From:Subject:From;
        b=fUohv97B59undtNjtnqfwo1gQGPvx4f6c2Sb5iEShN1ZmJ618UzSXzKHl5Byi2xvx
         9ORNbLyg2w4GUHlPS3W93eblImPlvusXX6lnuevJF8Y+fblUOkzLVOTp9SD5jWAVuq
         lZYJN/9MrEV876EoCs2gZIJ33G7ThCLPAqa+8lQE=
Date:   Tue, 04 Oct 2022 12:41:48 -0700
To:     mm-commits@vger.kernel.org, rppt@linux.vnet.ibm.com,
        nadav.amit@gmail.com, mike.kravetz@oracle.com, david@redhat.com,
        axelrasmussen@google.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-selftest-uffd-explain-the-write-missing-fault-check.patch added to mm-unstable branch
Message-Id: <20221004194149.A0325C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/selftest: uffd: explain the write missing fault check
has been added to the -mm mm-unstable branch.  Its filename is
     mm-selftest-uffd-explain-the-write-missing-fault-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-selftest-uffd-explain-the-write-missing-fault-check.patch

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
From: Peter Xu <peterx@redhat.com>
Subject: mm/selftest: uffd: explain the write missing fault check
Date: Tue, 4 Oct 2022 15:34:00 -0400

It's not obvious why we had a write check for each of the missing
messages, especially when it should be a locking op.  Add a rich comment
for that, and also try to explain its good side and limitations, so that
if someone hit it again for either a bug or a different glibc impl
there'll be some clue to start with.

Link: https://lkml.kernel.org/r/20221004193400.110155-4-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |   22 ++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/userfaultfd.c~mm-selftest-uffd-explain-the-write-missing-fault-check
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -774,7 +774,27 @@ static void uffd_handle_page_fault(struc
 		continue_range(uffd, msg->arg.pagefault.address, page_size);
 		stats->minor_faults++;
 	} else {
-		/* Missing page faults */
+		/*
+		 * Missing page faults.
+		 *
+		 * Here we force a write check for each of the missing mode
+		 * faults.  It's guaranteed because the only threads that
+		 * will trigger uffd faults are the locking threads, and
+		 * their first instruction to touch the missing page will
+		 * always be pthread_mutex_lock().
+		 *
+		 * Note that here we relied on an NPTL glibc impl detail to
+		 * always read the lock type at the entry of the lock op
+		 * (pthread_mutex_t.__data.__type, offset 0x10) before
+		 * doing any locking operations to guarantee that.  It's
+		 * actually not good to rely on this impl detail because
+		 * logically a pthread-compatible lib can implement the
+		 * locks without types and we can fail when linking with
+		 * them.  However since we used to find bugs with this
+		 * strict check we still keep it around.  Hopefully this
+		 * could be a good hint when it fails again.  If one day
+		 * it'll break on some other impl of glibc we'll revisit.
+		 */
 		if (msg->arg.pagefault.flags & UFFD_PAGEFAULT_FLAG_WRITE)
 			err("unexpected write fault");
 
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-uffd-fix-warning-without-pte_marker_uffd_wp-compiled-in.patch
mm-hugetlb-fix-race-condition-of-uffd-missing-minor-handling.patch
mm-hugetlb-use-hugetlb_pte_stable-in-migration-race-check.patch
mm-selftest-uffd-explain-the-write-missing-fault-check.patch

