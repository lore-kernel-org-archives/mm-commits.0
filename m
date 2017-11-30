From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-fail-get_vaddr_frames-for-filesystem-dax-mappings-v3.patch removed from
 -mm tree
Date: Wed, 29 Nov 2017 16:06:56 -0800
Message-ID: <5a1f4ba0.ZnJxklnVo7d1CNtt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60018 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752106AbdK3AG6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Nov 2017 19:06:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fail-get_vaddr_frames-for-filesystem-dax-mappings-v3
has been removed from the -mm tree.  Its filename was
     mm-fail-get_vaddr_frames-for-filesystem-dax-mappings-v3.patch

This patch was dropped because it was folded into mm-fail-get_vaddr_frames-for-filesystem-dax-mappings.patch

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm-fail-get_vaddr_frames-for-filesystem-dax-mappings-v3

add comment for vma_is_fsdax() check in get_vaddr_frames(), per Jan

Link: http://lkml.kernel.org/r/151197874035.26211.4061781453123083667.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/frame_vector.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN mm/frame_vector.c~mm-fail-get_vaddr_frames-for-filesystem-dax-mappings-v3 mm/frame_vector.c
--- a/mm/frame_vector.c~mm-fail-get_vaddr_frames-for-filesystem-dax-mappings-v3
+++ a/mm/frame_vector.c
@@ -54,6 +54,14 @@ int get_vaddr_frames(unsigned long start
 		goto out;
 	}
 
+	/*
+	 * While get_vaddr_frames() could be used for transient (kernel
+	 * controlled lifetime) pinning of memory pages all current
+	 * users establish long term (userspace controlled lifetime)
+	 * page pinning. Treat get_vaddr_frames() like
+	 * get_user_pages_longterm() and disallow it for filesystem-dax
+	 * mappings.
+	 */
 	if (vma_is_fsdax(vma))
 		return -EOPNOTSUPP;
 
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

mm-fix-device-dax-pud-write-faults-triggered-by-get_user_pages.patch
mm-switch-to-define-pmd_write-instead-of-__have_arch_pmd_write.patch
mm-replace-pud_write-with-pud_access_permitted-in-fault-gup-paths.patch
mm-replace-pmd_write-with-pmd_access_permitted-in-fault-gup-paths.patch
mm-replace-pte_write-with-pte_access_permitted-in-fault-gup-paths.patch
mm-hugetlbfs-introduce-split-to-vm_operations_struct.patch
device-dax-implement-split-to-catch-invalid-munmap-attempts.patch
mm-introduce-get_user_pages_longterm.patch
mm-fail-get_vaddr_frames-for-filesystem-dax-mappings.patch
v4l2-disable-filesystem-dax-mapping-support.patch
ib-core-disable-memory-registration-of-fileystem-dax-vmas.patch

