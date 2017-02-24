From: akpm@linux-foundation.org
Subject: [folded-merged]
 userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found-fix-2-fix.patch removed from -mm tree
Date: Fri, 24 Feb 2017 14:38:44 -0800
Message-ID: <58b0b5f4.A1Nr5q8/HbWG01Io%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34104 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751356AbdBXWip (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:38:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found-fix-2-fix
has been removed from the -mm tree.  Its filename was
     userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found-fix-2-fix.patch

This patch was dropped because it was folded into userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found-fix-2-fix

fix the merge fix

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/userfaultfd.c~userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found-fix-2-fix mm/userfaultfd.c
--- a/mm/userfaultfd.c~userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found-fix-2-fix
+++ a/mm/userfaultfd.c
@@ -219,6 +219,7 @@ retry:
 			goto out_unlock;
 	}
 
+	err = -EINVAL;
 	if (WARN_ON(dst_addr & (vma_hpagesize - 1) ||
 		    (len - copied) & (vma_hpagesize - 1)))
 		goto out_unlock;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memory_hotplugc-unexport-__remove_pages.patch
z3fold-add-kref-refcounting-checkpatch-fixes.patch
userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found.patch
mm-autonuma-dont-use-set_pte_at-when-updating-protnone-ptes-fix.patch
linux-kernelh-fix-div_round_closest-to-support-negative-divisors-fix.patch
lib-update-lz4-compressor-module.patch
lib-update-lz4-compressor-module-fix-fix.patch
lib-update-lz4-compressor-module-fix-fix-fix.patch

