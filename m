Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AD8BECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:28:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiILD2w (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiILD2W (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:28:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 440BB26137
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:28:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08BFBB8085E
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:28:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC05FC433D6;
        Mon, 12 Sep 2022 03:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953297;
        bh=nHjfQtwkN08D59LRw7I6at0FV2Cgn7oE76Z6CouFzHs=;
        h=Date:To:From:Subject:From;
        b=mNACcsihzwwU6qsUTBoB9VvooiY+ESN7/2FWOY3fBpvj4ZGiaFMnLb18gmkH5wqox
         +bVONoxstRBKz3ouScVvISthzzSKyVumgWoHjTzLz5xoNZH+aUT6qybvhzoTKaYHzb
         QTRuM4l0pSxKlYYnnkSZW1aCu6SwDIDFMKnhNAug=
Date:   Sun, 11 Sep 2022 20:28:17 -0700
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
Subject: [merged mm-stable] selftests-vm-add-selftest-to-verify-recollapse-of-thps.patch removed from -mm tree
Message-Id: <20220912032817.AC05FC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/vm: add selftest to verify recollapse of THPs
has been removed from the -mm tree.  Its filename was
     selftests-vm-add-selftest-to-verify-recollapse-of-thps.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Zach O'Keefe" <zokeefe@google.com>
Subject: selftests/vm: add selftest to verify recollapse of THPs
Date: Wed, 6 Jul 2022 16:59:35 -0700

Add selftest specific to madvise collapse context that tests MADV_COLLAPSE
is "successful" if a hugepage-aligned/sized region is already pmd-mapped.

This test also verifies that MADV_COLLAPSE can collapse memory into THPs
even in "madvise" THP mode and the memory isn't marked VM_HUGEPAGE.

Link: https://lkml.kernel.org/r/20220706235936.2197195-18-zokeefe@google.com
Signed-off-by: Zach O'Keefe <zokeefe@google.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chris Kennelly <ckennelly@google.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
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

 tools/testing/selftests/vm/khugepaged.c |   31 ++++++++++++++++++++++
 1 file changed, 31 insertions(+)

--- a/tools/testing/selftests/vm/khugepaged.c~selftests-vm-add-selftest-to-verify-recollapse-of-thps
+++ a/tools/testing/selftests/vm/khugepaged.c
@@ -990,6 +990,36 @@ static void collapse_max_ptes_shared(str
 	munmap(p, hpage_pmd_size);
 }
 
+static void madvise_collapse_existing_thps(void)
+{
+	void *p;
+	int err;
+
+	p = alloc_mapping();
+	fill_memory(p, 0, hpage_pmd_size);
+
+	printf("Collapse fully populated PTE table...");
+	/*
+	 * Note that we don't set MADV_HUGEPAGE here, which
+	 * also tests that VM_HUGEPAGE isn't required for
+	 * MADV_COLLAPSE in "madvise" mode.
+	 */
+	err = madvise(p, hpage_pmd_size, MADV_COLLAPSE);
+	if (err == 0 && check_huge(p)) {
+		success("OK");
+		printf("Re-collapse PMD-mapped hugepage");
+		err = madvise(p, hpage_pmd_size, MADV_COLLAPSE);
+		if (err == 0 && check_huge(p))
+			success("OK");
+		else
+			fail("Fail");
+	} else {
+		fail("Fail");
+	}
+	validate_memory(p, 0, hpage_pmd_size);
+	munmap(p, hpage_pmd_size);
+}
+
 int main(int argc, const char **argv)
 {
 	struct collapse_context c;
@@ -1057,6 +1087,7 @@ int main(int argc, const char **argv)
 		collapse_fork(&c);
 		collapse_fork_compound(&c);
 		collapse_max_ptes_shared(&c);
+		madvise_collapse_existing_thps();
 	}
 
 	restore_settings(0);
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

