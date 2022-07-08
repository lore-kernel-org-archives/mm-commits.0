Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 535C3CCA480
	for <mm-commits@archiver.kernel.org>; Fri,  8 Jul 2022 21:05:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239718AbiGHVFk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 8 Jul 2022 17:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239498AbiGHVFX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2022 17:05:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3241A0279
        for <mm-commits@vger.kernel.org>; Fri,  8 Jul 2022 14:05:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A13462916
        for <mm-commits@vger.kernel.org>; Fri,  8 Jul 2022 21:05:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B086AC341C0;
        Fri,  8 Jul 2022 21:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657314321;
        bh=8bUmu/bzml+ORnv6/Fma60bs1yq/vtYudKqmk+oj3kM=;
        h=Date:To:From:Subject:From;
        b=bo+FRspVfV6+YIPm+fG8oAO974gc0iE3jmq0ntSX4+ttHu7YUwJLPeWAuP/++5Ov5
         F9fMMge/PjA8Dj+bRfAjMVXOR0VqLPezNK/qKedXA7GrJmz/PeVxZud6vt2G/bKEjJ
         l39IA6qONhtT81vkIeUPbYS13YryOGfHidQ1d+K8=
Date:   Fri, 08 Jul 2022 14:05:21 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, willy@infradead.org,
        vbabka@suse.cz, tsbogend@alpha.franken.de, songliubraving@fb.com,
        sj@kernel.org, shy828301@gmail.com, rongwei.wang@linux.alibaba.com,
        rientjes@google.com, peterx@redhat.com, pasha.tatashin@soleen.com,
        minchan@kernel.org, mhocko@suse.com, mattst88@gmail.com,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        jcmvbkbc@gmail.com, James.Bottomley@HansenPartnership.com,
        ink@jurassic.park.msu.ru, hughd@google.com, deller@gmx.de,
        david@redhat.com, ckennelly@google.com, chris@zankel.net,
        axelrasmussen@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        arnd@arndb.de, alex.shi@linux.alibaba.com, aarcange@redhat.com,
        zokeefe@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vm-add-selftest-to-verify-recollapse-of-thps.patch added to mm-unstable branch
Message-Id: <20220708210521.B086AC341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: add selftest to verify recollapse of THPs
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-vm-add-selftest-to-verify-recollapse-of-thps.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-vm-add-selftest-to-verify-recollapse-of-thps.patch

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

mm-khugepaged-remove-redundant-transhuge_vma_suitable-check.patch
mm-khugepaged-add-struct-collapse_control.patch
mm-khugepaged-dedup-and-simplify-hugepage-alloc-and-charging.patch
mm-khugepaged-pipe-enum-scan_result-codes-back-to-callers.patch
mm-khugepaged-add-flag-to-predicate-khugepaged-only-behavior.patch
mm-thp-add-flag-to-enforce-sysfs-thp-in-hugepage_vma_check.patch
mm-khugepaged-record-scan_pmd_mapped-when-scan_pmd-finds-hugepage.patch
mm-madvise-introduce-madv_collapse-sync-hugepage-collapse.patch
mm-khugepaged-rename-prefix-of-shared-collapse-functions.patch
mm-madvise-add-huge_memory-mm_madvise_collapse-tracepoint.patch
mm-madvise-add-madv_collapse-to-process_madvise.patch
proc-smaps-add-pmdmappable-field-to-smaps.patch
selftests-vm-modularize-collapse-selftests.patch
selftests-vm-dedup-hugepage-allocation-logic.patch
selftests-vm-add-madv_collapse-collapse-context-to-selftests.patch
selftests-vm-add-selftest-to-verify-recollapse-of-thps.patch
selftests-vm-add-selftest-to-verify-multi-thp-collapse.patch

