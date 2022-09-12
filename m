Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E69CC6FA89
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:28:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbiILD23 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiILD2V (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:28:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 267E626129
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:28:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2B82B80C6D
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:28:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4121CC433D7;
        Mon, 12 Sep 2022 03:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953291;
        bh=z0jvOaveP+6VX8hsKyyJEMOWi1AbwIccmm60m5+HG6M=;
        h=Date:To:From:Subject:From;
        b=sLTDa8Q6IpwR+Y8y3Z0DIV9plX3q/ll/P7zWYNJvqsChAidmf+SzxDlzI1PYDQ7CU
         SPeG0HdwTUS6jINUJoZBfSeNM2NjlTp+IOACQVxuhrQM47WNUFO/tFmRXETh/0nh5O
         mS6iBfOpZzhqaY7CwCkQQwOlSYwGJKpTIuKnY8hk=
Date:   Sun, 11 Sep 2022 20:28:10 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, willy@infradead.org,
        vbabka@suse.cz, tsbogend@alpha.franken.de, songliubraving@fb.com,
        sj@kernel.org, shy828301@gmail.com, rongwei.wang@linux.alibaba.com,
        rientjes@google.com, peterx@redhat.com, pasha.tatashin@soleen.com,
        minchan@kernel.org, mhocko@suse.com, mattst88@gmail.com,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        jrdr.linux@gmail.com, jcmvbkbc@gmail.com,
        James.Bottomley@HansenPartnership.com, ink@jurassic.park.msu.ru,
        hughd@google.com, deller@gmx.de, david@redhat.com,
        dan.carpenter@oracle.com, ckennelly@google.com, chris@zankel.net,
        axelrasmussen@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        arnd@arndb.de, alex.shi@linux.alibaba.com, aarcange@redhat.com,
        zokeefe@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-madvise-add-madv_collapse-to-process_madvise.patch removed from -mm tree
Message-Id: <20220912032811.4121CC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/madvise: add MADV_COLLAPSE to process_madvise()
has been removed from the -mm tree.  Its filename was
     mm-madvise-add-madv_collapse-to-process_madvise.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Zach O'Keefe" <zokeefe@google.com>
Subject: mm/madvise: add MADV_COLLAPSE to process_madvise()
Date: Wed, 6 Jul 2022 16:59:30 -0700

Allow MADV_COLLAPSE behavior for process_madvise(2) if caller has
CAP_SYS_ADMIN or is requesting collapse of it's own memory.

This is useful for the development of userspace agents that seek to
optimize THP utilization system-wide by using userspace signals to
prioritize what memory is most deserving of being THP-backed.

[zokeefe@google.com: remove CAP_SYS_ADMIN requirement for process_madvise(MADV_COLLAPSE)]
  Link: https://lkml.kernel.org/r/20220801210946.3069083-1-zokeefe@google.com
Link: https://lkml.kernel.org/r/20220706235936.2197195-13-zokeefe@google.com
Signed-off-by: Zach O'Keefe <zokeefe@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chris Kennelly <ckennelly@google.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: David Hildenbrand <david@redhat.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rongwei Wang <rongwei.wang@linux.alibaba.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "Souptick Joarder (HPE)" <jrdr.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/madvise.c~mm-madvise-add-madv_collapse-to-process_madvise
+++ a/mm/madvise.c
@@ -1170,13 +1170,13 @@ madvise_behavior_valid(int behavior)
 	}
 }
 
-static bool
-process_madvise_behavior_valid(int behavior)
+static bool process_madvise_behavior_valid(int behavior)
 {
 	switch (behavior) {
 	case MADV_COLD:
 	case MADV_PAGEOUT:
 	case MADV_WILLNEED:
+	case MADV_COLLAPSE:
 		return true;
 	default:
 		return false;
_

Patches currently in -mm which might be from zokeefe@google.com are

mm-shmem-add-flag-to-enforce-shmem-thp-in-hugepage_vma_check.patch
mm-khugepaged-attempt-to-map-file-shmem-backed-pte-mapped-thps-by-pmds.patch
mm-madvise-add-file-and-shmem-support-to-madv_collapse.patch
mm-khugepaged-add-tracepoint-to-hpage_collapse_scan_file.patch
selftests-vm-dedup-thp-helpers.patch
selftests-vm-modularize-thp-collapse-memory-operations.patch
selftests-vm-add-thp-collapse-file-and-tmpfs-testing.patch
selftests-vm-add-thp-collapse-shmem-testing.patch
selftests-vm-add-file-shmem-madv_collapse-selftest-for-cleared-pmd.patch
selftests-vm-add-selftest-for-madv_collapse-of-uffd-minor-memory.patch

