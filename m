Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62D2DC76196
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:24:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbjC1XYQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:24:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbjC1XW5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:22:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44DDE3C0E
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:22:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8EE1618FE
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:22:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C695C4339B;
        Tue, 28 Mar 2023 23:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045746;
        bh=4vra9SLxC6zQu6516kpewsoXEEBejMt1PBlbMlVjids=;
        h=Date:To:From:Subject:From;
        b=y706lwPiXO/qhLxELr6alV9ZejyHOnjUmEE7LiOaKGKcvn2sutJke4lgDb3s+bSvV
         F8wULLMvptaabczkImmMYPQIO5QEE3krazCJKr/ZgudBJzWGzYiaPhp4ofgakFPv8Q
         6puHZiwxBS0YyDLU2DNCkzV5giVFiTST6tyG7lrY=
Date:   Tue, 28 Mar 2023 16:22:25 -0700
To:     mm-commits@vger.kernel.org, shy828301@gmail.com, david@redhat.com,
        aneesh.kumar@linux.ibm.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-thp-rename-transparent_hugepage_never_dax-to-_unsupported.patch removed from -mm tree
Message-Id: <20230328232226.3C695C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/thp: rename TRANSPARENT_HUGEPAGE_NEVER_DAX to _UNSUPPORTED
has been removed from the -mm tree.  Its filename was
     mm-thp-rename-transparent_hugepage_never_dax-to-_unsupported.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/thp: rename TRANSPARENT_HUGEPAGE_NEVER_DAX to _UNSUPPORTED
Date: Wed, 15 Mar 2023 13:16:42 -0400

TRANSPARENT_HUGEPAGE_NEVER_DAX has nothing to do with DAX.  It's set when
has_transparent_hugepage() returns false, checked in hugepage_vma_check()
and will disable THP completely if false.  Rename it to
TRANSPARENT_HUGEPAGE_UNSUPPORTED to reflect its real purpose.

[peterx@redhat.com: fix comment, per David]
  Link: https://lkml.kernel.org/r/ZBMzQW674oHQJV7F@x1n
Link: https://lkml.kernel.org/r/20230315171642.1244625-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    2 +-
 mm/huge_memory.c        |    8 ++------
 2 files changed, 3 insertions(+), 7 deletions(-)

--- a/include/linux/huge_mm.h~mm-thp-rename-transparent_hugepage_never_dax-to-_unsupported
+++ a/include/linux/huge_mm.h
@@ -79,7 +79,7 @@ static inline vm_fault_t vmf_insert_pfn_
 }
 
 enum transparent_hugepage_flag {
-	TRANSPARENT_HUGEPAGE_NEVER_DAX,
+	TRANSPARENT_HUGEPAGE_UNSUPPORTED,
 	TRANSPARENT_HUGEPAGE_FLAG,
 	TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
 	TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG,
--- a/mm/huge_memory.c~mm-thp-rename-transparent_hugepage_never_dax-to-_unsupported
+++ a/mm/huge_memory.c
@@ -88,7 +88,7 @@ bool hugepage_vma_check(struct vm_area_s
 	/*
 	 * If the hardware/firmware marked hugepage support disabled.
 	 */
-	if (transparent_hugepage_flags & (1 << TRANSPARENT_HUGEPAGE_NEVER_DAX))
+	if (transparent_hugepage_flags & (1 << TRANSPARENT_HUGEPAGE_UNSUPPORTED))
 		return false;
 
 	/* khugepaged doesn't collapse DAX vma, but page fault is fine. */
@@ -460,11 +460,7 @@ static int __init hugepage_init(void)
 	struct kobject *hugepage_kobj;
 
 	if (!has_transparent_hugepage()) {
-		/*
-		 * Hardware doesn't support hugepages, hence disable
-		 * DAX PMD support.
-		 */
-		transparent_hugepage_flags = 1 << TRANSPARENT_HUGEPAGE_NEVER_DAX;
+		transparent_hugepage_flags = 1 << TRANSPARENT_HUGEPAGE_UNSUPPORTED;
 		return -EINVAL;
 	}
 
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-hugetlb-fix-uffd-wr-protection-for-cow-optimization-path.patch
mm-hugetlb-fix-uffd-wr-protection-for-cow-optimization-path-v2.patch
mm-hugetlb-fix-uffd-wr-protection-for-cow-optimization-path-v3.patch
mm-uffd-uffd_feature_wp_unpopulated.patch
mm-uffd-uffd_feature_wp_unpopulated-fix.patch
selftests-mm-smoke-test-uffd_feature_wp_unpopulated.patch

