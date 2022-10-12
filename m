Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2506DC43219
	for <mm-commits@archiver.kernel.org>; Wed, 12 Oct 2022 22:58:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiJLW6z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Oct 2022 18:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbiJLW60 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2022 18:58:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5636312791A
        for <mm-commits@vger.kernel.org>; Wed, 12 Oct 2022 15:57:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CDCAFB81CAB
        for <mm-commits@vger.kernel.org>; Wed, 12 Oct 2022 22:57:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73481C433C1;
        Wed, 12 Oct 2022 22:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665615466;
        bh=rdnhsS8X7+GDQ/6W6X8kfCvaBxWmeKXcIrwEGmzW18Y=;
        h=Date:To:From:Subject:From;
        b=N+vYwp/Iu2id1FYGNjVyDGAF/kha7XsMV+mJYXP5fcAPoH+VNeuJxWFtXYf03jKId
         ihrY80Y1P7oxSTynvmCO2qhx39fDX/OLNvz0x3UchcSD2KrRY/gl75U4mg8Pa/k2yn
         o/d38dX0M7YI/47kdObaMOmSnY/335AAq/M3V82w=
Date:   Wed, 12 Oct 2022 15:57:45 -0700
To:     mm-commits@vger.kernel.org, rppt@linux.vnet.ibm.com,
        nadav.amit@gmail.com, mike.kravetz@oracle.com, david@redhat.com,
        axelrasmussen@google.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-selftest-uffd-explain-the-write-missing-fault-check.patch removed from -mm tree
Message-Id: <20221012225746.73481C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/selftest: uffd: explain the write missing fault check
has been removed from the -mm tree.  Its filename was
     mm-selftest-uffd-explain-the-write-missing-fault-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


