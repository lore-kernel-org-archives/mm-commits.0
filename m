Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 128F0C00140
	for <mm-commits@archiver.kernel.org>; Thu, 11 Aug 2022 00:42:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbiHKAmm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Aug 2022 20:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231434AbiHKAml (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 10 Aug 2022 20:42:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58181844C6
        for <mm-commits@vger.kernel.org>; Wed, 10 Aug 2022 17:42:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E72A8610AA
        for <mm-commits@vger.kernel.org>; Thu, 11 Aug 2022 00:42:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DFCBC433C1;
        Thu, 11 Aug 2022 00:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660178559;
        bh=BAbvBgsWk6lIfr9jZRi6DwG2RJQ6IzKN60CSQwfHGMg=;
        h=Date:To:From:Subject:From;
        b=J+9gWh9K9XMo79eZAVZwCYHwHcME8iAk5R9fvFS1mTOAsgnIRT9uYxOP/Vt7g0i9d
         kpfFnkbWaEurE4TNMeJ2pNAlBpncAOSDeSZM6iHDvPNudz91xc0tI17H+YeGKJJK3E
         dJWeeaSR+1ZxFDXQpGJDwZWCP0H+a5sYmjHEPUQo=
Date:   Wed, 10 Aug 2022 17:42:38 -0700
To:     mm-commits@vger.kernel.org, yi.zhang@huawei.com,
        viro@zeniv.linux.org.uk, vbabka@suse.cz, surenb@google.com,
        skhan@linuxfoundation.org, shuah@kernel.org, rppt@kernel.org,
        peterx@redhat.com, namit@vmware.com, mike.kravetz@oracle.com,
        mgorman@techsingularity.net, ldv@altlinux.org, jack@suse.cz,
        hughd@google.com, glebfm@altlinux.org, dave.hansen@linux.intel.com,
        corbet@lwn.net, axelrasmussen@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vm-add-hugetlb_shared-userfaultfd-test-to-run_vmtestssh.patch added to mm-unstable branch
Message-Id: <20220811004239.3DFCBC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: vm: add hugetlb_shared userfaultfd test to run_vmtests.sh
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-vm-add-hugetlb_shared-userfaultfd-test-to-run_vmtestssh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-vm-add-hugetlb_shared-userfaultfd-test-to-run_vmtestssh.patch

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
Subject: selftests: vm: add hugetlb_shared userfaultfd test to run_vmtests.sh
Date: Mon, 8 Aug 2022 10:56:10 -0700

Patch series "userfaultfd: add /dev/userfaultfd for fine grained access
control", v5.

Why not ...?
============

- Why not /proc/[pid]/userfaultfd? Two main points (additional discussion [1]):

    - /proc/[pid]/* files are all owned by the user/group of the process, and
      they don't really support chmod/chown. So, without extending procfs it
      doesn't solve the problem this series is trying to solve.

    - The main argument *for* this was to support creating UFFDs for remote
      processes. But, that use case clearly calls for CAP_SYS_PTRACE, so to
      support this we could just use the UFFD syscall as-is.

- Why not use a syscall? Access to syscalls is generally controlled by
  capabilities. We don't have a capability which is used for userfaultfd access
  without also granting more / other permissions as well, and adding a new
  capability was rejected [2].

    - It's possible a LSM could be used to control access instead, but I have
      some concerns. I don't think this approach would be as easy to use,
      particularly if we were to try to solve this with something heavyweight
      like SELinux. Maybe we could pursue adding a new LSM specifically for
      this user case, but it may be too narrow of a case to justify that.

[1]: https://patchwork.kernel.org/project/linux-mm/cover/20220719195628.3415852-1-axelrasmussen@google.com/
[2]: https://lore.kernel.org/lkml/686276b9-4530-2045-6bd8-170e5943abe4@schaufler-ca.com/T/


This patch (of 5):

This not being included was just a simple oversight.  There are certain
features (like minor fault support) which are only enabled on shared
mappings, so without including hugetlb_shared we actually lose a
significant amount of test coverage.

Link: https://lkml.kernel.org/r/20220808175614.3885028-1-axelrasmussen@google.com
Link: https://lkml.kernel.org/r/20220808175614.3885028-2-axelrasmussen@google.com
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
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
Cc: Shuah Khan <shuah@kernel.org>
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

selftests-vm-add-hugetlb_shared-userfaultfd-test-to-run_vmtestssh.patch
userfaultfd-add-dev-userfaultfd-for-fine-grained-access-control.patch
userfaultfd-selftests-modify-selftest-to-use-dev-userfaultfd.patch
userfaultfd-update-documentation-to-describe-dev-userfaultfd.patch
selftests-vm-add-dev-userfaultfd-test-cases-to-run_vmtestssh.patch

