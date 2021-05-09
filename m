Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FDAAC433B4
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 04:10:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E681461401
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 04:10:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbhEIELk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 May 2021 00:11:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:33782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229605AbhEIELk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 May 2021 00:11:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2718B613FA;
        Sun,  9 May 2021 04:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620533436;
        bh=6htsc76DujtbxVzd5KH6febSZQlqwZ+pSZSycgIgzRI=;
        h=Date:From:To:Subject:From;
        b=SaWTCAdUQVlZpGAwIkZ2CdZe/H6Qb374d71ws1OBE0DhKZoHK7isyMp3cUbtE3lXD
         72B80bn/WQ8ZiUuGtJwTS2WXQBaqkjZZZbpfo9KFWXPGmPGz8jDih0t4plAOXFAI63
         RT/zcghnagix6daXCPHaF/6vM5EYp/ROkoN5polo=
Date:   Sat, 08 May 2021 21:10:35 -0700
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
 userfaultfd-shmem-support-minor-fault-registration-for-shmem.patch added to
 -mm tree
Message-ID: <20210509041035.scNywgHgn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd/shmem: support minor fault registration for shmem
has been added to the -mm tree.  Its filename is
     userfaultfd-shmem-support-minor-fault-registration-for-shmem.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-shmem-support-minor-fault-registration-for-shmem.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-shmem-support-minor-fault-registration-for-shmem.patch

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
Subject: userfaultfd/shmem: support minor fault registration for shmem

This patch allows shmem-backed VMAs to be registered for minor faults. 
Minor faults are appropriately relayed to userspace in the fault path, for
VMAs with the relevant flag.

This commit doesn't hook up the UFFDIO_CONTINUE ioctl for shmem-backed
minor faults, though, so userspace doesn't yet have a way to resolve such
faults.

Because of this, we also don't yet advertise this as a supported feature. 
That will be done in a separate commit when the feature is fully
implemented.

Link: https://lkml.kernel.org/r/20210503180737.2487560-4-axelrasmussen@google.com
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Acked-by: Peter Xu <peterx@redhat.com>
Acked-by: Hugh Dickins <hughd@google.com>
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

 fs/userfaultfd.c |    3 +--
 mm/memory.c      |    8 +++++---
 mm/shmem.c       |   12 +++++++++++-
 3 files changed, 17 insertions(+), 6 deletions(-)

--- a/fs/userfaultfd.c~userfaultfd-shmem-support-minor-fault-registration-for-shmem
+++ a/fs/userfaultfd.c
@@ -1267,8 +1267,7 @@ static inline bool vma_can_userfault(str
 	}
 
 	if (vm_flags & VM_UFFD_MINOR) {
-		/* FIXME: Add minor fault interception for shmem. */
-		if (!is_vm_hugetlb_page(vma))
+		if (!(is_vm_hugetlb_page(vma) || vma_is_shmem(vma)))
 			return false;
 	}
 
--- a/mm/memory.c~userfaultfd-shmem-support-minor-fault-registration-for-shmem
+++ a/mm/memory.c
@@ -3973,9 +3973,11 @@ static vm_fault_t do_read_fault(struct v
 	 * something).
 	 */
 	if (vma->vm_ops->map_pages && fault_around_bytes >> PAGE_SHIFT > 1) {
-		ret = do_fault_around(vmf);
-		if (ret)
-			return ret;
+		if (likely(!userfaultfd_minor(vmf->vma))) {
+			ret = do_fault_around(vmf);
+			if (ret)
+				return ret;
+		}
 	}
 
 	ret = __do_fault(vmf);
--- a/mm/shmem.c~userfaultfd-shmem-support-minor-fault-registration-for-shmem
+++ a/mm/shmem.c
@@ -1785,7 +1785,7 @@ unlock:
  * vm. If we swap it in we mark it dirty since we also free the swap
  * entry since a page cannot live in both the swap and page cache.
  *
- * vmf and fault_type are only supplied by shmem_fault:
+ * vma, vmf, and fault_type are only supplied by shmem_fault:
  * otherwise they are NULL.
  */
 static int shmem_getpage_gfp(struct inode *inode, pgoff_t index,
@@ -1820,6 +1820,16 @@ repeat:
 
 	page = pagecache_get_page(mapping, index,
 					FGP_ENTRY | FGP_HEAD | FGP_LOCK, 0);
+
+	if (page && vma && userfaultfd_minor(vma)) {
+		if (!xa_is_value(page)) {
+			unlock_page(page);
+			put_page(page);
+		}
+		*fault_type = handle_userfault(vmf, VM_UFFD_MINOR);
+		return 0;
+	}
+
 	if (xa_is_value(page)) {
 		error = shmem_swapin_page(inode, index, &page,
 					  sgp, gfp, vma, fault_type);
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

