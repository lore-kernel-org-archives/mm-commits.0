Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43EC7C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 28 Feb 2022 00:48:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231982AbiB1Ate (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 27 Feb 2022 19:49:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232077AbiB1Ata (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 27 Feb 2022 19:49:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B8E43DDCA
        for <mm-commits@vger.kernel.org>; Sun, 27 Feb 2022 16:48:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A2B0B80D6B
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 00:48:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF01C340EE;
        Mon, 28 Feb 2022 00:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646009330;
        bh=fbMhrL9OCJO/onCU7RrfKIzRmWScPwXHRf6gDf4GTuI=;
        h=Date:To:From:Subject:From;
        b=jhlRUPG0sxNBDJTLAlZjcw3Ub1LzDxwQYOc1xNCz3cEyGPz1sq+Bic9+Gs0D7AKml
         xii601NTTmLS2llaErbYgbXbKK5sxlQ6ApiogI9V/5iU+iG59KrQEdCspT+iQLDjEC
         5m4pKHRjbCuVe/vunK4lJEoRI9v4bWT+VY0TV84s=
Date:   Sun, 27 Feb 2022 16:48:50 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org,
        joel@joelfernandes.org, mike.kravetz@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] selftests-memfd-clean-up-mapping-in-mfd_fail_write.patch removed from -mm tree
Message-Id: <20220228004850.9FF01C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/memfd: clean up mapping in mfd_fail_write
has been removed from the -mm tree.  Its filename was
     selftests-memfd-clean-up-mapping-in-mfd_fail_write.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: selftests/memfd: clean up mapping in mfd_fail_write

Running the memfd script ./run_hugetlbfs_test.sh will often end in error
as follows:

memfd-hugetlb: CREATE
memfd-hugetlb: BASIC
memfd-hugetlb: SEAL-WRITE
memfd-hugetlb: SEAL-FUTURE-WRITE
memfd-hugetlb: SEAL-SHRINK
fallocate(ALLOC) failed: No space left on device
./run_hugetlbfs_test.sh: line 60: 166855 Aborted                 (core dumped) ./memfd_test hugetlbfs
opening: ./mnt/memfd
fuse: DONE

If no hugetlb pages have been preallocated, run_hugetlbfs_test.sh will
allocate 'just enough' pages to run the test.  In the SEAL-FUTURE-WRITE
test the mfd_fail_write routine maps the file, but does not unmap.  As a
result, two hugetlb pages remain reserved for the mapping.  When the
fallocate call in the SEAL-SHRINK test attempts allocate all hugetlb
pages, it is short by the two reserved pages.

Fix by making sure to unmap in mfd_fail_write.

Link: https://lkml.kernel.org/r/20220219004340.56478-1-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/memfd/memfd_test.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/memfd/memfd_test.c~selftests-memfd-clean-up-mapping-in-mfd_fail_write
+++ a/tools/testing/selftests/memfd/memfd_test.c
@@ -455,6 +455,7 @@ static void mfd_fail_write(int fd)
 			printf("mmap()+mprotect() didn't fail as expected\n");
 			abort();
 		}
+		munmap(p, mfd_def_size);
 	}
 
 	/* verify PUNCH_HOLE fails */
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

selftests-vm-cleanup-hugetlb-file-after-mremap-test.patch
hugetlb-clean-up-potential-spectre-issue-warnings.patch
hugetlb-clean-up-potential-spectre-issue-warnings-v2.patch
mm-enable-madv_dontneed-for-hugetlb-mappings.patch
selftests-vm-add-hugetlb-madvise-madv_dontneed-madv_remove-test.patch
userfaultfd-selftests-enable-hugetlb-remap-and-remove-event-testing.patch

