Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 728B0C4708D
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:02:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbiLAACd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:02:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbiLAABN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:01:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D76558930C
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:00:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 867C0B81AD6
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:00:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3033CC433D7;
        Thu,  1 Dec 2022 00:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852851;
        bh=mE7cYLvNvvVM93QU5D6rHa/D+JMfLeV8cJvCcc9lF0w=;
        h=Date:To:From:Subject:From;
        b=lpazKGy/eMUaVnxxD0r+F79MWN57CX0wtUzWQxSZ5tsIp2rbl6edVfl/tP2AhROho
         V+rVCwvafDO1E60dz/fICqr+2v3npvaUVczsPxWP24gLjge+7AYFbymi/PbBqiKKFb
         8OmpnNpTHlJOCa+EIOp8FkpncGitijox3T3+wbJY=
Date:   Wed, 30 Nov 2022 16:00:50 -0800
To:     mm-commits@vger.kernel.org, riel@surriel.com,
        oliver.sang@intel.com, david@redhat.com, mike.kravetz@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-vm-update-hugetlb-madvise.patch removed from -mm tree
Message-Id: <20221201000051.3033CC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/vm: update hugetlb madvise
has been removed from the -mm tree.  Its filename was
     selftests-vm-update-hugetlb-madvise.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: selftests/vm: update hugetlb madvise
Date: Thu, 3 Nov 2022 18:16:32 -0700

Commit 8ebe0a5eaaeb ("mm,madvise,hugetlb: fix unexpected data loss with
MADV_DONTNEED on hugetlbfs") changed how the passed length was interpreted
for hugetlb mappings.  It was changed from align up to align down.  The
hugetlb-madvise test explicitly tests this behavior.  Change test to
expect new behavior.

Link: https://lkml.kernel.org/r/20221104011632.357049-1-mike.kravetz@oracle.com
Link: https://lore.kernel.org/oe-lkp/202211040619.2ec447d7-oliver.sang@intel.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/hugetlb-madvise.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/vm/hugetlb-madvise.c~selftests-vm-update-hugetlb-madvise
+++ a/tools/testing/selftests/vm/hugetlb-madvise.c
@@ -195,7 +195,7 @@ int main(int argc, char **argv)
 			exit(1);
 	}
 
-	/* addr + length should be aligned up to huge page size */
+	/* addr + length should be aligned down to huge page size */
 	if (madvise(addr,
 			((NR_HUGE_PAGES - 1) * huge_page_size) + base_page_size,
 			MADV_DONTNEED)) {
@@ -203,10 +203,11 @@ int main(int argc, char **argv)
 		exit(1);
 	}
 
-	/* should free all pages in mapping */
-	validate_free_pages(free_hugepages);
+	/* should free all but last page in mapping */
+	validate_free_pages(free_hugepages - 1);
 
 	(void)munmap(addr, NR_HUGE_PAGES * huge_page_size);
+	validate_free_pages(free_hugepages);
 
 	/*
 	 * Test MADV_DONTNEED on anonymous private mapping
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are


