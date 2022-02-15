Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18469C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 15 Feb 2022 22:00:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234664AbiBOWAW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Feb 2022 17:00:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232018AbiBOWAV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Feb 2022 17:00:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 945837678
        for <mm-commits@vger.kernel.org>; Tue, 15 Feb 2022 14:00:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20ACAB81D0A
        for <mm-commits@vger.kernel.org>; Tue, 15 Feb 2022 22:00:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC9C7C340EB;
        Tue, 15 Feb 2022 22:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644962406;
        bh=JpaGdyBqWLtKON4/h/OMSZQqe4BFA0+ENCVFUzbwkmE=;
        h=Date:To:From:Subject:From;
        b=WqAgVPQvC2fO50efIUOTlcQv0pVwlYcB8kh+X1l+eCLMQItfkFfRhZcE20yU7kPop
         bbh6sz1S8QjaGPAVARTukYxPQ9A1lbmAkuaFCDdDh6vaiZ+IAOYYk+fftkkyjp4hgF
         TfUSgD/Ahwwc0m9RbNIOWDdS3/dTD3cTqh8wa+YY=
Date:   Tue, 15 Feb 2022 14:00:06 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, lmark@codeaurora.org,
        iamjoonsoo.kim@lge.com, georgi.djakov@linaro.org,
        songmuchun@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-vm-page_owner-filter-out-pid-and-timestamp.patch added to -mm tree
Message-Id: <20220215220006.AC9C7C340EB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/page_owner: filter out pid and timestamp
has been added to the -mm tree.  Its filename is
     tools-vm-page_owner-filter-out-pid-and-timestamp.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/tools-vm-page_owner-filter-out-pid-and-timestamp.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/tools-vm-page_owner-filter-out-pid-and-timestamp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

tools-vm-page_owner-filter-out-pid-and-timestamp.patch
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

