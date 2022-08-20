Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F23EC32792
	for <mm-commits@archiver.kernel.org>; Sat, 20 Aug 2022 00:30:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbiHTAaC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Aug 2022 20:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239022AbiHTAaA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 19 Aug 2022 20:30:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72857B3B17
        for <mm-commits@vger.kernel.org>; Fri, 19 Aug 2022 17:29:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1801D61909
        for <mm-commits@vger.kernel.org>; Sat, 20 Aug 2022 00:29:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E01FC433D6;
        Sat, 20 Aug 2022 00:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660955397;
        bh=6FjpUzGtoEd5f7EA65B52p9TjB4ClkSNLfioMDV9wa4=;
        h=Date:To:From:Subject:From;
        b=vksWyIvsOG+YxPAtFLVLbBMilwbX+Csu7ZfSEJwkFwh+YPSolXEJXlU0k5YJ8GUyC
         g7w5goODJWWdUUr0MGDkAPXOnqKqERCOKtiUT2O0FWDDl6MuQxuE0+CFJ6bWFx6W33
         HKCm3InGR16Y8NKtwX9dpjPXYrZsqEQMZ3pjAP3c=
Date:   Fri, 19 Aug 2022 17:29:56 -0700
To:     mm-commits@vger.kernel.org, yi.zhang@huawei.com,
        viro@zeniv.linux.org.uk, vbabka@suse.cz, surenb@google.com,
        skhan@linuxfoundation.org, rppt@linux.ibm.com, rppt@kernel.org,
        peterx@redhat.com, namit@vmware.com, mike.kravetz@oracle.com,
        mgorman@techsingularity.net, ldv@altlinux.org, jack@suse.cz,
        hughd@google.com, glebfm@altlinux.org, dave.hansen@linux.intel.com,
        corbet@lwn.net, axelrasmussen@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-update-documentation-to-describe-dev-userfaultfd-v7.patch added to mm-unstable branch
Message-Id: <20220820002957.6E01FC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd-update-documentation-to-describe-dev-userfaultfd-v7
has been added to the -mm mm-unstable branch.  Its filename is
     userfaultfd-update-documentation-to-describe-dev-userfaultfd-v7.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-update-documentation-to-describe-dev-userfaultfd-v7.patch

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
Subject: userfaultfd-update-documentation-to-describe-dev-userfaultfd-v7
Date: Fri, 19 Aug 2022 13:52:00 -0700

improve wording in two spots in the documentation, per Mike

Link: https://lkml.kernel.org/r/20220819205201.658693-5-axelrasmussen@google.com
Acked-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
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
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Nadav Amit <namit@vmware.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zhang Yi <yi.zhang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/userfaultfd.rst |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/Documentation/admin-guide/mm/userfaultfd.rst~userfaultfd-update-documentation-to-describe-dev-userfaultfd-v7
+++ a/Documentation/admin-guide/mm/userfaultfd.rst
@@ -66,14 +66,14 @@ userfaultfd(2) syscall. Access to this i
   only. Such a userfaultfd can be created using the userfaultfd(2) syscall
   with the flag UFFD_USER_MODE_ONLY.
 
-- In order to also trap kernel page faults for the address space, then either
-  the process needs the CAP_SYS_PTRACE capability, or the system must have
+- In order to also trap kernel page faults for the address space, either the
+  process needs the CAP_SYS_PTRACE capability, or the system must have
   vm.unprivileged_userfaultfd set to 1. By default, vm.unprivileged_userfaultfd
   is set to 0.
 
-The second way, added to the kernel more recently, is by opening and issuing a
-USERFAULTFD_IOC_NEW ioctl to /dev/userfaultfd. This method yields equivalent
-userfaultfds to the userfaultfd(2) syscall.
+The second way, added to the kernel more recently, is by opening
+/dev/userfaultfd and issuing a USERFAULTFD_IOC_NEW ioctl to it. This method
+yields equivalent userfaultfds to the userfaultfd(2) syscall.
 
 Unlike userfaultfd(2), access to /dev/userfaultfd is controlled via normal
 filesystem permissions (user/group/mode), which gives fine grained access to
_

Patches currently in -mm which might be from axelrasmussen@google.com are

selftests-vm-add-hugetlb_shared-userfaultfd-test-to-run_vmtestssh.patch
userfaultfd-add-dev-userfaultfd-for-fine-grained-access-control.patch
userfaultfd-add-dev-userfaultfd-for-fine-grained-access-control-v7.patch
userfaultfd-selftests-modify-selftest-to-use-dev-userfaultfd.patch
userfaultfd-selftests-modify-selftest-to-use-dev-userfaultfd-v7.patch
userfaultfd-update-documentation-to-describe-dev-userfaultfd.patch
userfaultfd-update-documentation-to-describe-dev-userfaultfd-v7.patch
selftests-vm-add-dev-userfaultfd-test-cases-to-run_vmtestssh.patch

