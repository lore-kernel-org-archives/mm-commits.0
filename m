Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEB99C43217
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:18:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbiJCVRv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbiJCVPm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:15:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4133550BB
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:10:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50C4A611EC
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A89BEC433D7;
        Mon,  3 Oct 2022 21:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831411;
        bh=AM0CYkttniML5h7fssnHsPxCvAtAA7S7cAbfBRYxeu0=;
        h=Date:To:From:Subject:From;
        b=YC74TWPBx5MrwjTidZBtvy56JD1HoejllmzJyvI/3lHE1zBtduegpPU0/aSPsayLd
         WfWuhO5ATkzK5fobqKo7x54hWBwX5BsUwBCW3ysoEnYXvXTNdSSHgFe0IFMNkh057c
         2L77vXFaEic2sYgyZ0/TUzWBaO6dOTjSrrNNNinA=
Date:   Mon, 03 Oct 2022 14:10:11 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        songliubraving@fb.com, sj@kernel.org, shy828301@gmail.com,
        rongwei.wang@linux.alibaba.com, rientjes@google.com,
        peterx@redhat.com, pasha.tatashin@soleen.com, minchan@kernel.org,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        jthoughton@google.com, hughd@google.com, david@redhat.com,
        ckennelly@google.com, axelrasmussen@google.com, zokeefe@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-vm-add-file-shmem-madv_collapse-selftest-for-cleared-pmd.patch removed from -mm tree
Message-Id: <20221003211011.A89BEC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/vm: add file/shmem MADV_COLLAPSE selftest for cleared pmd
has been removed from the -mm tree.  Its filename was
     selftests-vm-add-file-shmem-madv_collapse-selftest-for-cleared-pmd.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

 tools/testing/selftests/vm/khugepaged.c |   30 ++++++++++++++++++++++
 1 file changed, 30 insertions(+)

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


