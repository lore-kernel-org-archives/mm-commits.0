Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7942EC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 22 Feb 2022 06:01:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbiBVGBy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Feb 2022 01:01:54 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:48678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiBVGBx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Feb 2022 01:01:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9B00B1AA7
        for <mm-commits@vger.kernel.org>; Mon, 21 Feb 2022 22:01:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D1F4615BA
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 04:45:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFC7BC340EB;
        Tue, 22 Feb 2022 04:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645505127;
        bh=6yMefZB5ZbTKJJWbPq0SCclveFcU6LZqmYQW0SQSSzo=;
        h=Date:To:From:Subject:From;
        b=D64cDTq9tsA3HZpL+WOgGNzWNxJ7RvGnyRk4jAzWFs/i8G4HG1mi/68prcmcg+t0C
         jVf0RWdvt4/TRfF5xZaPHzgMUYVpZDNzHe+S3wW30xw99+wqu081PD+AC/X3d//XJG
         pomaI2b8sK4+Oj5YR9dcPexoP8KGZVHVLfEOxqX0=
Date:   Mon, 21 Feb 2022 20:45:27 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org,
        joel@joelfernandes.org, mike.kravetz@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-memfd-clean-up-mapping-in-mfd_fail_write.patch added to -mm tree
Message-Id: <20220222044527.BFC7BC340EB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/memfd: clean up mapping in mfd_fail_write
has been added to the -mm tree.  Its filename is
     selftests-memfd-clean-up-mapping-in-mfd_fail_write.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftests-memfd-clean-up-mapping-in-mfd_fail_write.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftests-memfd-clean-up-mapping-in-mfd_fail_write.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
selftests-memfd-clean-up-mapping-in-mfd_fail_write.patch
mm-enable-madv_dontneed-for-hugetlb-mappings.patch
selftests-vm-add-hugetlb-madvise-madv_dontneed-madv_remove-test.patch
userfaultfd-selftests-enable-hugetlb-remap-and-remove-event-testing.patch
hugetlb-clean-up-potential-spectre-issue-warnings.patch

