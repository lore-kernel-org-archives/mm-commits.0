Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B002FC433ED
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 04:10:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F6BD6142B
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 04:10:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbhEIELq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 May 2021 00:11:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:33972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229605AbhEIELp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 May 2021 00:11:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E0586135F;
        Sun,  9 May 2021 04:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620533442;
        bh=s+7aaRLS34YqiZFaQUgy1BGxI7HP1uWV5H09JSZHTjg=;
        h=Date:From:To:Subject:From;
        b=0uOAfgKXvhyCb5ap9HALNwxqT7FTKUbfS8kBy9pkhu8noUfpe6xGm5em8VM1XObrY
         pufi4atEckHgYPnBN9ij14ZAwpB4dEZV28O+a08nN/tqqIiNUcOeizbUsfJRC9q3FL
         5N1y1m9Wfa5lHJpe44ET0NjmJ+QIfkQOkysusKXI=
Date:   Sat, 08 May 2021 21:10:41 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, almasrymina@google.com,
        axelrasmussen@google.com, bgeffon@google.com, dgilbert@redhat.com,
        hughd@google.com, jglisse@redhat.com, joe@perches.com,
        kirill@shutemov.name, lokeshgidra@google.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        oupton@google.com, peterx@redhat.com, rppt@linux.vnet.ibm.com,
        sfr@canb.auug.org.au, shli@fb.com, shuah@kernel.org,
        viro@zeniv.linux.org.uk, wangqing@vivo.com
Subject:  +
 userfaultfd-shmem-advertise-shmem-minor-fault-support.patch added to -mm
 tree
Message-ID: <20210509041041.ho11MPtRj%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd/shmem: advertise shmem minor fault support
has been added to the -mm tree.  Its filename is
     userfaultfd-shmem-advertise-shmem-minor-fault-support.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-shmem-advertise-shmem-minor-fault-support.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-shmem-advertise-shmem-minor-fault-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Axel Rasmussen <axelrasmussen@google.com>
Subject: userfaultfd/shmem: advertise shmem minor fault support

Now that the feature is fully implemented (the faulting path hooks exist
so userspace is notified, and the ioctl to resolve such faults is
available), advertise this as a supported feature.

Link: https://lkml.kernel.org/r/20210503180737.2487560-6-axelrasmussen@google.com
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Joe Perches <joe@perches.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Oliver Upton <oupton@google.com>
Cc: Shaohua Li <shli@fb.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Wang Qing <wangqing@vivo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/userfaultfd.rst |    3 ++-
 fs/userfaultfd.c                             |    3 ++-
 include/uapi/linux/userfaultfd.h             |    7 ++++++-
 3 files changed, 10 insertions(+), 3 deletions(-)

--- a/Documentation/admin-guide/mm/userfaultfd.rst~userfaultfd-shmem-advertise-shmem-minor-fault-support
+++ a/Documentation/admin-guide/mm/userfaultfd.rst
@@ -77,7 +77,8 @@ events, except page fault notifications,
 
 - ``UFFD_FEATURE_MINOR_HUGETLBFS`` indicates that the kernel supports
   ``UFFDIO_REGISTER_MODE_MINOR`` registration for hugetlbfs virtual memory
-  areas.
+  areas. ``UFFD_FEATURE_MINOR_SHMEM`` is the analogous feature indicating
+  support for shmem virtual memory areas.
 
 The userland application should set the feature flags it intends to use
 when invoking the ``UFFDIO_API`` ioctl, to request that those features be
--- a/fs/userfaultfd.c~userfaultfd-shmem-advertise-shmem-minor-fault-support
+++ a/fs/userfaultfd.c
@@ -1944,7 +1944,8 @@ static int userfaultfd_api(struct userfa
 	/* report all available features and ioctls to userland */
 	uffdio_api.features = UFFD_API_FEATURES;
 #ifndef CONFIG_HAVE_ARCH_USERFAULTFD_MINOR
-	uffdio_api.features &= ~UFFD_FEATURE_MINOR_HUGETLBFS;
+	uffdio_api.features &=
+		~(UFFD_FEATURE_MINOR_HUGETLBFS | UFFD_FEATURE_MINOR_SHMEM);
 #endif
 #ifndef CONFIG_HAVE_ARCH_USERFAULTFD_WP
 	uffdio_api.features &= ~UFFD_FEATURE_PAGEFAULT_FLAG_WP;
--- a/include/uapi/linux/userfaultfd.h~userfaultfd-shmem-advertise-shmem-minor-fault-support
+++ a/include/uapi/linux/userfaultfd.h
@@ -31,7 +31,8 @@
 			   UFFD_FEATURE_MISSING_SHMEM |		\
 			   UFFD_FEATURE_SIGBUS |		\
 			   UFFD_FEATURE_THREAD_ID |		\
-			   UFFD_FEATURE_MINOR_HUGETLBFS)
+			   UFFD_FEATURE_MINOR_HUGETLBFS |	\
+			   UFFD_FEATURE_MINOR_SHMEM)
 #define UFFD_API_IOCTLS				\
 	((__u64)1 << _UFFDIO_REGISTER |		\
 	 (__u64)1 << _UFFDIO_UNREGISTER |	\
@@ -185,6 +186,9 @@ struct uffdio_api {
 	 * UFFD_FEATURE_MINOR_HUGETLBFS indicates that minor faults
 	 * can be intercepted (via REGISTER_MODE_MINOR) for
 	 * hugetlbfs-backed pages.
+	 *
+	 * UFFD_FEATURE_MINOR_SHMEM indicates the same support as
+	 * UFFD_FEATURE_MINOR_HUGETLBFS, but for shmem-backed pages instead.
 	 */
 #define UFFD_FEATURE_PAGEFAULT_FLAG_WP		(1<<0)
 #define UFFD_FEATURE_EVENT_FORK			(1<<1)
@@ -196,6 +200,7 @@ struct uffdio_api {
 #define UFFD_FEATURE_SIGBUS			(1<<7)
 #define UFFD_FEATURE_THREAD_ID			(1<<8)
 #define UFFD_FEATURE_MINOR_HUGETLBFS		(1<<9)
+#define UFFD_FEATURE_MINOR_SHMEM		(1<<10)
 	__u64 features;
 
 	__u64 ioctls;
_

Patches currently in -mm which might be from axelrasmussen@google.com are

userfaultfd-release-page-in-error-path-to-avoid-bug_on.patch
userfaultfd-hugetlbfs-avoid-including-userfaultfd_kh-in-hugetlbh.patch
userfaultfd-shmem-combine-shmem_mcopy_atomicmfill_zeropage_pte.patch
userfaultfd-shmem-support-minor-fault-registration-for-shmem.patch
userfaultfd-shmem-support-uffdio_continue-for-shmem.patch
userfaultfd-shmem-advertise-shmem-minor-fault-support.patch
userfaultfd-shmem-modify-shmem_mfill_atomic_pte-to-use-install_pte.patch
userfaultfd-selftests-use-memfd_create-for-shmem-test-type.patch
userfaultfd-selftests-create-alias-mappings-in-the-shmem-test.patch
userfaultfd-selftests-reinitialize-test-context-in-each-test.patch
userfaultfd-selftests-exercise-minor-fault-handling-shmem-support.patch

