Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E500AC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Feb 2022 04:05:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbiBVEF7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Feb 2022 23:05:59 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:44990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiBVEF6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Feb 2022 23:05:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3828F6580C
        for <mm-commits@vger.kernel.org>; Mon, 21 Feb 2022 20:05:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E383B81851
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 04:04:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF7D6C340E8;
        Tue, 22 Feb 2022 04:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645502654;
        bh=wnSmeTxmgUots6lN0ipWL/v7Gu7atJVseihZQuH3K/8=;
        h=Date:To:From:Subject:From;
        b=ngEpwAHbRGk1M3tQxQNlA6nTLWPr8CxFPtx7Pw3QK979an8UFtoOxWL7pkHNUvHHk
         wubBIwyVSnkX0YhitBHw7nkeW9Mw2STi9h4TDCtDB+Q2tXRYyb+KReN4Q983pZTYmq
         a7iSSNx4+GMTJgPFfWN+kI1flHJ9fiTtCBe0uhl8=
Date:   Mon, 21 Feb 2022 20:04:14 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, lmark@codeaurora.org,
        iamjoonsoo.kim@lge.com, georgi.djakov@linaro.org,
        songmuchun@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] tools-vm-page_owner-filter-out-pid-and-timestamp.patch removed from -mm tree
Message-Id: <20220222040414.AF7D6C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/page_owner: filter out pid and timestamp
has been removed from the -mm tree.  Its filename was
     tools-vm-page_owner-filter-out-pid-and-timestamp.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: tools/vm/page_owner: filter out pid and timestamp

Commit 9cc7e96aa846 ("mm/page_owner: record timestamp and pid") introduces
timestamp and pid for page owner.  However, it is hard to aggregate the
stack since those are specific (especially timestamp).  Filter out those
information when aggregating.

Link: https://lkml.kernel.org/r/20220215134045.12004-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Liam Mark <lmark@codeaurora.org>
Cc: Georgi Djakov <georgi.djakov@linaro.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/page_owner_sort.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/tools/vm/page_owner_sort.c~tools-vm-page_owner-filter-out-pid-and-timestamp
+++ a/tools/vm/page_owner_sort.c
@@ -50,6 +50,12 @@ int read_block(char *buf, int buf_size,
 			return curr - buf;
 		if (!strncmp(curr, "PFN", 3))
 			continue;
+		if (!strncmp(curr, "Page allocated via order", 24)) {
+			char *end = strstr(curr, ", pid ");
+
+			if (end)
+				memcpy(end, "\n", 2);
+		}
 		curr += strlen(curr);
 	}
 
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-thp-fix-wrong-cache-flush-in-remove_migration_pmd.patch
mm-fix-missing-cache-flush-for-all-tail-pages-of-compound-page.patch
mm-hugetlb-fix-missing-cache-flush-in-copy_huge_page_from_user.patch
mm-hugetlb-fix-missing-cache-flush-in-hugetlb_mcopy_atomic_pte.patch
mm-shmem-fix-missing-cache-flush-in-shmem_mfill_atomic_pte.patch
mm-userfaultfd-fix-missing-cache-flush-in-mcopy_atomic_pte-and-__mcopy_atomic.patch
mm-replace-multiple-dcache-flush-with-flush_dcache_folio.patch
mm-hugetlb-free-the-2nd-vmemmap-page-associated-with-each-hugetlb-page.patch
mm-hugetlb-replace-hugetlb_free_vmemmap_enabled-with-a-static_key.patch
mm-sparsemem-use-page-table-lock-to-protect-kernel-pmd-operations.patch
selftests-vm-add-a-hugetlb-test-case.patch
mm-sparsemem-move-vmemmap-related-to-hugetlb-to-config_hugetlb_page_free_vmemmap.patch

