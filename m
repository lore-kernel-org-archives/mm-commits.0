Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FC1EC43334
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jul 2022 22:48:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240391AbiGSWsN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Jul 2022 18:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236237AbiGSWsG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jul 2022 18:48:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 300274E62F
        for <mm-commits@vger.kernel.org>; Tue, 19 Jul 2022 15:48:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A211B81DA2
        for <mm-commits@vger.kernel.org>; Tue, 19 Jul 2022 22:48:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94040C341CA;
        Tue, 19 Jul 2022 22:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658270881;
        bh=j5om20Gj5Tp587v+VYVMc3moOJ9Lu9efQ239YMl10fE=;
        h=Date:To:From:Subject:From;
        b=CMxcvzK99RisFg3VIEGjmneKNKUjq5fL9lz+50V3ZEm7WrjV2ez/MELGGCB+q9T4F
         cI8H0Na9lFyfGU+W0uCNExChkQDDslJJTfU2o53jrmaz7LFizriWIV8cHqbM74tncZ
         tBem2I0M9SUc2T3eFe1Jqi0GI8x570oqapMqsynM=
Date:   Tue, 19 Jul 2022 15:48:00 -0700
To:     mm-commits@vger.kernel.org, yi.zhang@huawei.com,
        viro@zeniv.linux.org.uk, vbabka@suse.cz, surenb@google.com,
        skhan@linuxfoundation.org, rppt@kernel.org, peterx@redhat.com,
        namit@vmware.com, mike.kravetz@oracle.com,
        mgorman@techsingularity.net, ldv@altlinux.org, jack@suse.cz,
        hughd@google.com, glebfm@altlinux.org, dave.hansen@linux.intel.com,
        corbet@lwn.net, charante@codeaurora.org, axelrasmussen@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] userfaultfd-update-documentation-to-describe-dev-userfaultfd.patch removed from -mm tree
Message-Id: <20220719224801.94040C341CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: userfaultfd: update documentation to describe /dev/userfaultfd
has been removed from the -mm tree.  Its filename was
     userfaultfd-update-documentation-to-describe-dev-userfaultfd.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Axel Rasmussen <axelrasmussen@google.com>
Subject: userfaultfd: update documentation to describe /dev/userfaultfd
Date: Wed, 1 Jun 2022 14:09:49 -0700

Explain the different ways to create a new userfaultfd, and how access
control works for each way.

Link: https://lkml.kernel.org/r/20220601210951.3916598-5-axelrasmussen@google.com
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
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
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zhang Yi <yi.zhang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/userfaultfd.rst |   40 +++++++++++++++--
 Documentation/admin-guide/sysctl/vm.rst      |    3 +
 2 files changed, 40 insertions(+), 3 deletions(-)

--- a/Documentation/admin-guide/mm/userfaultfd.rst~userfaultfd-update-documentation-to-describe-dev-userfaultfd
+++ a/Documentation/admin-guide/mm/userfaultfd.rst
@@ -17,7 +17,10 @@ of the ``PROT_NONE+SIGSEGV`` trick.
 Design
 ======
 
-Userfaults are delivered and resolved through the ``userfaultfd`` syscall.
+Userspace creates a new userfaultfd, initializes it, and registers one or more
+regions of virtual memory with it. Then, any page faults which occur within the
+region(s) result in a message being delivered to the userfaultfd, notifying
+userspace of the fault.
 
 The ``userfaultfd`` (aside from registering and unregistering virtual
 memory ranges) provides two primary functionalities:
@@ -34,12 +37,11 @@ The real advantage of userfaults if comp
 management of mremap/mprotect is that the userfaults in all their
 operations never involve heavyweight structures like vmas (in fact the
 ``userfaultfd`` runtime load never takes the mmap_lock for writing).
-
 Vmas are not suitable for page- (or hugepage) granular fault tracking
 when dealing with virtual address spaces that could span
 Terabytes. Too many vmas would be needed for that.
 
-The ``userfaultfd`` once opened by invoking the syscall, can also be
+The ``userfaultfd``, once created, can also be
 passed using unix domain sockets to a manager process, so the same
 manager process could handle the userfaults of a multitude of
 different processes without them being aware about what is going on
@@ -50,6 +52,38 @@ is a corner case that would currently re
 API
 ===
 
+Creating a userfaultfd
+----------------------
+
+There are two ways to create a new userfaultfd, each of which provide ways to
+restrict access to this functionality (since historically userfaultfds which
+handle kernel page faults have been a useful tool for exploiting the kernel).
+
+The first way, supported by older kernels, is the userfaultfd(2) syscall.
+Access to this is controlled in several ways:
+
+- By default, the userfaultfd will be able to handle kernel page faults. This
+  can be disabled by passing in UFFD_USER_MODE_ONLY.
+
+- If vm.unprivileged_userfaultfd is 0, then the caller must *either* have
+  CAP_SYS_PTRACE, or pass in UFFD_USER_MODE_ONLY.
+
+- If vm.unprivileged_userfaultfd is 1, then no particular privilege is needed to
+  use this syscall, even if UFFD_USER_MODE_ONLY is *not* set.
+
+The second way, added to the kernel more recently, is by opening and issuing a
+USERFAULTFD_IOC_NEW ioctl to /dev/userfaultfd. This method yields equivalent
+userfaultfds to the userfaultfd(2) syscall; its benefit is in how access to
+creating userfaultfds is controlled.
+
+Access to /dev/userfaultfd is controlled via normal filesystem permissions
+(user/group/mode for example), which gives fine grained access to userfaultfd
+specifically, without also granting other unrelated privileges at the same time
+(as e.g. granting CAP_SYS_PTRACE would do).
+
+Initializing up a userfaultfd
+-----------------------------
+
 When first opened the ``userfaultfd`` must be enabled invoking the
 ``UFFDIO_API`` ioctl specifying a ``uffdio_api.api`` value set to ``UFFD_API`` (or
 a later API version) which will specify the ``read/POLLIN`` protocol
--- a/Documentation/admin-guide/sysctl/vm.rst~userfaultfd-update-documentation-to-describe-dev-userfaultfd
+++ a/Documentation/admin-guide/sysctl/vm.rst
@@ -926,6 +926,9 @@ calls without any restrictions.
 
 The default value is 0.
 
+An alternative to this sysctl / the userfaultfd(2) syscall is to create
+userfaultfds via /dev/userfaultfd. See
+Documentation/admin-guide/mm/userfaultfd.rst.
 
 user_reserve_kbytes
 ===================
_

Patches currently in -mm which might be from axelrasmussen@google.com are

userfaultfd-selftests-make-dev-userfaultfd-testing-configurable.patch
selftests-vm-add-dev-userfaultfd-test-cases-to-run_vmtestssh.patch

