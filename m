Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA344CCA480
	for <mm-commits@archiver.kernel.org>; Mon, 13 Jun 2022 21:57:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240975AbiFMV5F (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Jun 2022 17:57:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344104AbiFMV5E (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Jun 2022 17:57:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8515120F71
        for <mm-commits@vger.kernel.org>; Mon, 13 Jun 2022 14:57:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D57E614CE
        for <mm-commits@vger.kernel.org>; Mon, 13 Jun 2022 21:57:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B08FC3411C;
        Mon, 13 Jun 2022 21:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655157421;
        bh=eFDrE0RumxHVhd6iGwmCgz26kiM343nHrEaT556dGLw=;
        h=Date:To:From:Subject:From;
        b=ESJRzoU4eiTeIeZ2g2uJMiWnTssgXVP7hR+gFzsSgu6wt7uutmy6XbfIODg0np7Gb
         zuVrNGKmGMx2r2sImPhOO8lIvnU9ArxSMAb4gtj3Pwlj/xde4fjxZSYW+VyGbuXRoz
         qxTroRVCJqKIdGdi2fCMicDM5HLx6Ch+cIpo/+hM=
Date:   Mon, 13 Jun 2022 14:57:00 -0700
To:     mm-commits@vger.kernel.org, yi.zhang@huawei.com,
        viro@zeniv.linux.org.uk, vbabka@suse.cz, surenb@google.com,
        skhan@linuxfoundation.org, rppt@kernel.org, peterx@redhat.com,
        namit@vmware.com, mike.kravetz@oracle.com,
        mgorman@techsingularity.net, ldv@altlinux.org, jack@suse.cz,
        hughd@google.com, glebfm@altlinux.org, dave.hansen@linux.intel.com,
        corbet@lwn.net, charante@codeaurora.org, axelrasmussen@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vm-add-dev-userfaultfd-test-cases-to-run_vmtestssh.patch added to mm-unstable branch
Message-Id: <20220613215701.5B08FC3411C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: vm: add /dev/userfaultfd test cases to run_vmtests.sh
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-vm-add-dev-userfaultfd-test-cases-to-run_vmtestssh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-vm-add-dev-userfaultfd-test-cases-to-run_vmtestssh.patch

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
From: Axel Rasmussen <axelrasmussen@google.com>
Subject: selftests: vm: add /dev/userfaultfd test cases to run_vmtests.sh
Date: Wed, 1 Jun 2022 14:09:51 -0700

This new mode was recently added to the userfaultfd selftest.  We want to
exercise both userfaultfd(2) as well as /dev/userfaultfd, so add both test
cases to the script.

Link: https://lkml.kernel.org/r/20220601210951.3916598-7-axelrasmussen@google.com
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Charan Teja Kalla <charante@codeaurora.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dmitry V. Levin <ldv@altlinux.org>
Cc: Gleb Fotengauer-Malinovskiy <glebfm@altlinux.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nadav Amit <namit@vmware.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zhang Yi <yi.zhang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/run_vmtests.sh |    5 +++++
 1 file changed, 5 insertions(+)

--- a/tools/testing/selftests/vm/run_vmtests.sh~selftests-vm-add-dev-userfaultfd-test-cases-to-run_vmtestssh
+++ a/tools/testing/selftests/vm/run_vmtests.sh
@@ -121,12 +121,17 @@ run_test ./gup_test -a
 run_test ./gup_test -ct -F 0x1 0 19 0x1000
 
 run_test ./userfaultfd anon 20 16
+run_test ./userfaultfd anon:dev 20 16
 # Hugetlb tests require source and destination huge pages. Pass in half the
 # size ($half_ufd_size_MB), which is used for *each*.
 run_test ./userfaultfd hugetlb "$half_ufd_size_MB" 32
+run_test ./userfaultfd hugetlb:dev "$half_ufd_size_MB" 32
 run_test ./userfaultfd hugetlb_shared "$half_ufd_size_MB" 32 "$mnt"/uffd-test
 rm -f "$mnt"/uffd-test
+run_test ./userfaultfd hugetlb_shared:dev "$half_ufd_size_MB" 32 "$mnt"/uffd-test
+rm -f "$mnt"/uffd-test
 run_test ./userfaultfd shmem 20 16
+run_test ./userfaultfd shmem:dev 20 16
 
 #cleanup
 umount "$mnt"
_

Patches currently in -mm which might be from axelrasmussen@google.com are

mm-userfaultfd-fix-uffdio_continue-on-fallocated-shmem-pages.patch
selftests-vm-add-hugetlb_shared-userfaultfd-test-to-run_vmtestssh.patch
userfaultfd-add-dev-userfaultfd-for-fine-grained-access-control.patch
userfaultfd-selftests-modify-selftest-to-use-dev-userfaultfd.patch
userfaultfd-update-documentation-to-describe-dev-userfaultfd.patch
userfaultfd-selftests-make-dev-userfaultfd-testing-configurable.patch
selftests-vm-add-dev-userfaultfd-test-cases-to-run_vmtestssh.patch

