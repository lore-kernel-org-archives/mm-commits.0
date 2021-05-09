Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4804FC43461
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 04:10:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AAFD61421
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 04:10:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbhEIELh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 May 2021 00:11:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:33434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229605AbhEIELe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 May 2021 00:11:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3716A613FA;
        Sun,  9 May 2021 04:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620533430;
        bh=jc9pUrEHo9ye9NNSrMPE8SqG5j4JAjkuToVH38wxHl4=;
        h=Date:From:To:Subject:From;
        b=2NODIcCZean/lU8Tr6GU10YHUiOjZ1fVMbM9uqbg7lbpg1AkkDLVswrdtBNfGueIs
         YMZZSgyDkHjvPTdfTT7hbmV3s5B6hXwKOCLUDZf2P2YNQtGbmBXmE4DfkYugOXC5lw
         7ND4nCcCHefZ+tMrLGwyi0WMRdS/0VjLrYlk/pFU=
Date:   Sat, 08 May 2021 21:10:29 -0700
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
 userfaultfd-hugetlbfs-avoid-including-userfaultfd_kh-in-hugetlbh.patch
 added to -mm tree
Message-ID: <20210509041029.PxEzlu4gy%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd/hugetlbfs: avoid including userfaultfd_k.h in hugetlb.h
has been added to the -mm tree.  Its filename is
     userfaultfd-hugetlbfs-avoid-including-userfaultfd_kh-in-hugetlbh.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-hugetlbfs-avoid-including-userfaultfd_kh-in-hugetlbh.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-hugetlbfs-avoid-including-userfaultfd_kh-in-hugetlbh.patch

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
Subject: userfaultfd/hugetlbfs: avoid including userfaultfd_k.h in hugetlb.h

Patch series "userfaultfd: add minor fault handling for shmem", v6.

Overview
========

See the series which added minor faults for hugetlbfs [3] for a detailed
overview of minor fault handling in general.  This series adds the same
support for shmem-backed areas.

This series is structured as follows:

- Commits 1 and 2 are cleanups.
- Commits 3 and 4 implement the new feature (minor fault handling for shmem).
- Commit 5 advertises that the feature is now available since at this point it's
  fully implemented.
- Commit 6 is a final cleanup, modifying an existing code path to re-use a new
  helper we've introduced.
- Commits 7, 8, 9, 10 update the userfaultfd selftest to exercise the feature.

Use Case
========

In some cases it is useful to have VM memory backed by tmpfs instead of
hugetlbfs.  So, this feature will be used to support the same VM live
migration use case described in my original series.

Additionally, Android folks (Lokesh Gidra <lokeshgidra@google.com>) hope
to optimize the Android Runtime garbage collector using this feature:

"The plan is to use userfaultfd for concurrently compacting the heap. 
With this feature, the heap can be shared-mapped at another location where
the GC-thread(s) could continue the compaction operation without the need
to invoke userfault ioctl(UFFDIO_COPY) each time.  OTOH, if and when Java
threads get faults on the heap, UFFDIO_CONTINUE can be used to resume
execution.  Furthermore, this feature enables updating references in the
'non-moving' portion of the heap efficiently.  Without this feature,
uneccessary page copying (ioctl(UFFDIO_COPY)) would be required."

[1] https://lore.kernel.org/patchwork/cover/1388144/
[2] https://lore.kernel.org/patchwork/patch/1408161/
[3] https://lore.kernel.org/linux-fsdevel/20210301222728.176417-1-axelrasmussen@google.com/T/#t


This patch (of 10):

Minimizing header file inclusion is desirable.  In this case, we can do so
just by forward declaring the enumeration our signature relies upon.

Link: https://lkml.kernel.org/r/20210503180737.2487560-1-axelrasmussen@google.com
Link: https://lkml.kernel.org/r/20210503180737.2487560-2-axelrasmussen@google.com
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Joe Perches <joe@perches.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Shaohua Li <shli@fb.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Wang Qing <wangqing@vivo.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Oliver Upton <oupton@google.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    2 +-
 mm/hugetlb.c            |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/hugetlb.h~userfaultfd-hugetlbfs-avoid-including-userfaultfd_kh-in-hugetlbh
+++ a/include/linux/hugetlb.h
@@ -11,11 +11,11 @@
 #include <linux/kref.h>
 #include <linux/pgtable.h>
 #include <linux/gfp.h>
-#include <linux/userfaultfd_k.h>
 
 struct ctl_table;
 struct user_struct;
 struct mmu_gather;
+enum mcopy_atomic_mode;
 
 #ifndef is_hugepd
 typedef struct { unsigned long pd; } hugepd_t;
--- a/mm/hugetlb.c~userfaultfd-hugetlbfs-avoid-including-userfaultfd_kh-in-hugetlbh
+++ a/mm/hugetlb.c
@@ -40,6 +40,7 @@
 #include <linux/hugetlb_cgroup.h>
 #include <linux/node.h>
 #include <linux/page_owner.h>
+#include <linux/userfaultfd_k.h>
 #include "internal.h"
 
 int hugetlb_max_hstate __read_mostly;
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

