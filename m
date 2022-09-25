Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DBBCC6FA8E
	for <mm-commits@archiver.kernel.org>; Sun, 25 Sep 2022 19:14:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbiIYTOF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 25 Sep 2022 15:14:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233202AbiIYTNz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 25 Sep 2022 15:13:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 962D424BD4
        for <mm-commits@vger.kernel.org>; Sun, 25 Sep 2022 12:13:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B877B80CC4
        for <mm-commits@vger.kernel.org>; Sun, 25 Sep 2022 19:13:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2AE0C433D6;
        Sun, 25 Sep 2022 19:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664133232;
        bh=3YxcZFJ7BN1pHqts4DbhxnAYZ1QYhWMkFbkvLGFW82g=;
        h=Date:To:From:Subject:From;
        b=cUjpxTW2lbrQ8LMUMoqbem9FOfNw9PqGQO0skaRSWhKRhhrZTuPudUSTZvckED6f5
         ywVeyZ9WGkBsUUrQwrmV89O2QjtACNbPVos8tuE1dn/UQHwRFhd2iFFI7FdT77GYPG
         Kabc6bmnnKpWBN9P/murE0mRzqF47SnhzmXw0uWM=
Date:   Sun, 25 Sep 2022 12:13:50 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        songliubraving@fb.com, sj@kernel.org, shy828301@gmail.com,
        rongwei.wang@linux.alibaba.com, rientjes@google.com,
        peterx@redhat.com, pasha.tatashin@soleen.com, minchan@kernel.org,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        jthoughton@google.com, hughd@google.com, david@redhat.com,
        ckennelly@google.com, axelrasmussen@google.com, zokeefe@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vm-add-file-shmem-madv_collapse-selftest-for-cleared-pmd.patch added to mm-unstable branch
Message-Id: <20220925191351.D2AE0C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: add file/shmem MADV_COLLAPSE selftest for cleared pmd
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-vm-add-file-shmem-madv_collapse-selftest-for-cleared-pmd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-vm-add-file-shmem-madv_collapse-selftest-for-cleared-pmd.patch

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
Subject: selftests/vm: add file/shmem MADV_COLLAPSE selftest for cleared pmd
Date: Thu, 22 Sep 2022 15:40:45 -0700

This test tests that MADV_COLLAPSE acting on file/shmem memory for which
(1) the file extent mapping by the memory is already a huge page in the
page cache, and (2) the pmd mapping this memory in the target process is
none.

In practice, (1)+(2) is the state left over after khugepaged has
successfully collapsed file/shmem memory for a target VMA, but the memory
has not yet been refaulted.  So, this test in-effect tests MADV_COLLAPSE
racing with khugepaged to collapse the memory first.

Link: https://lkml.kernel.org/r/20220907144521.3115321-10-zokeefe@google.com
Link: https://lkml.kernel.org/r/20220922224046.1143204-10-zokeefe@google.com
Signed-off-by: Zach O'Keefe <zokeefe@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chris Kennelly <ckennelly@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rongwei Wang <rongwei.wang@linux.alibaba.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/tools/testing/selftests/vm/khugepaged.c~selftests-vm-add-file-shmem-madv_collapse-selftest-for-cleared-pmd
+++ a/tools/testing/selftests/vm/khugepaged.c
@@ -1353,6 +1353,33 @@ static void madvise_collapse_existing_th
 	ops->cleanup_area(p, hpage_pmd_size);
 }
 
+/*
+ * Test race with khugepaged where page tables have been retracted and
+ * pmd cleared.
+ */
+static void madvise_retracted_page_tables(struct collapse_context *c,
+					  struct mem_ops *ops)
+{
+	void *p;
+	int nr_hpages = 1;
+	unsigned long size = nr_hpages * hpage_pmd_size;
+
+	p = ops->setup_area(nr_hpages);
+	ops->fault(p, 0, size);
+
+	/* Let khugepaged collapse and leave pmd cleared */
+	if (wait_for_scan("Collapse and leave PMD cleared", p, nr_hpages,
+			  ops)) {
+		fail("Timeout");
+		return;
+	}
+	success("OK");
+	c->collapse("Install huge PMD from page cache", p, nr_hpages, ops,
+		    true);
+	validate_memory(p, 0, size);
+	ops->cleanup_area(p, size);
+}
+
 static void usage(void)
 {
 	fprintf(stderr, "\nUsage: ./khugepaged <test type> [dir]\n\n");
@@ -1524,5 +1551,8 @@ int main(int argc, const char **argv)
 	TEST(madvise_collapse_existing_thps, madvise_context, file_ops);
 	TEST(madvise_collapse_existing_thps, madvise_context, shmem_ops);
 
+	TEST(madvise_retracted_page_tables, madvise_context, file_ops);
+	TEST(madvise_retracted_page_tables, madvise_context, shmem_ops);
+
 	restore_settings(0);
 }
_

Patches currently in -mm which might be from zokeefe@google.com are

mm-khugepaged-check-compound_order-in-collapse_pte_mapped_thp.patch
mm-madvise-madv_collapse-return-eagain-when-page-cannot-be-isolated.patch
selftests-vm-retry-on-eagain-for-madv_collapse-selftest.patch
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

