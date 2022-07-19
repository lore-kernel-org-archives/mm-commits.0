Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DDFCC43334
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jul 2022 22:48:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232110AbiGSWsB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Jul 2022 18:48:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231350AbiGSWsB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jul 2022 18:48:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE174E62F
        for <mm-commits@vger.kernel.org>; Tue, 19 Jul 2022 15:48:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EDA45B81B94
        for <mm-commits@vger.kernel.org>; Tue, 19 Jul 2022 22:47:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4D7BC341C6;
        Tue, 19 Jul 2022 22:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658270877;
        bh=ad+dj3jIs0I0n1LhsRTNJLQ1ufTRM8FWUeqfqvdKJyg=;
        h=Date:To:From:Subject:From;
        b=WNAWSotzv5gImWiOFCPL7DFdqAVVWJIisUX3mRjmVuOrxbJAyY3bN4mjcdnxfNioU
         IK/rhYy/9DSy2Ni+wch8GJbpxgSWTUkriyquCBudZs3Zg7bEEVojDthV7y5B0baf/r
         Xid9vDOuu4QdZSxlMl6evsFW0GgcFmhiPLzdURTg=
Date:   Tue, 19 Jul 2022 15:47:56 -0700
To:     mm-commits@vger.kernel.org, yi.zhang@huawei.com,
        viro@zeniv.linux.org.uk, vbabka@suse.cz, surenb@google.com,
        skhan@linuxfoundation.org, rppt@kernel.org, peterx@redhat.com,
        namit@vmware.com, mike.kravetz@oracle.com,
        mgorman@techsingularity.net, ldv@altlinux.org, jack@suse.cz,
        hughd@google.com, glebfm@altlinux.org, dave.hansen@linux.intel.com,
        corbet@lwn.net, charante@codeaurora.org, axelrasmussen@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-vm-add-hugetlb_shared-userfaultfd-test-to-run_vmtestssh.patch removed from -mm tree
Message-Id: <20220719224757.A4D7BC341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests: vm: add hugetlb_shared userfaultfd test to run_vmtests.sh
has been removed from the -mm tree.  Its filename was
     selftests-vm-add-hugetlb_shared-userfaultfd-test-to-run_vmtestssh.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Axel Rasmussen <axelrasmussen@google.com>
Subject: selftests: vm: add hugetlb_shared userfaultfd test to run_vmtests.sh
Date: Wed, 1 Jun 2022 14:09:46 -0700

Patch series "userfaultfd: add /dev/userfaultfd for fine grained access
control", v3.


This patch (of 6):

This not being included was just a simple oversight.  There are certain
features (like minor fault support) which are only enabled on shared
mappings, so without including hugetlb_shared we actually lose a
significant amount of test coverage.

Link: https://lkml.kernel.org/r/20220601210951.3916598-1-axelrasmussen@google.com
Link: https://lkml.kernel.org/r/20220601210951.3916598-2-axelrasmussen@google.com
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Reviewed-by: Peter Xu <peterx@redhat.com>
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
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zhang Yi <yi.zhang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/run_vmtests.sh |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/vm/run_vmtests.sh~selftests-vm-add-hugetlb_shared-userfaultfd-test-to-run_vmtestssh
+++ a/tools/testing/selftests/vm/run_vmtests.sh
@@ -121,9 +121,11 @@ run_test ./gup_test -a
 run_test ./gup_test -ct -F 0x1 0 19 0x1000
 
 run_test ./userfaultfd anon 20 16
-# Test requires source and destination huge pages.  Size of source
-# (half_ufd_size_MB) is passed as argument to test.
+# Hugetlb tests require source and destination huge pages. Pass in half the
+# size ($half_ufd_size_MB), which is used for *each*.
 run_test ./userfaultfd hugetlb "$half_ufd_size_MB" 32
+run_test ./userfaultfd hugetlb_shared "$half_ufd_size_MB" 32 "$mnt"/uffd-test
+rm -f "$mnt"/uffd-test
 run_test ./userfaultfd shmem 20 16
 
 #cleanup
_

Patches currently in -mm which might be from axelrasmussen@google.com are

userfaultfd-add-dev-userfaultfd-for-fine-grained-access-control.patch
userfaultfd-selftests-modify-selftest-to-use-dev-userfaultfd.patch
userfaultfd-update-documentation-to-describe-dev-userfaultfd.patch
userfaultfd-selftests-make-dev-userfaultfd-testing-configurable.patch
selftests-vm-add-dev-userfaultfd-test-cases-to-run_vmtestssh.patch

