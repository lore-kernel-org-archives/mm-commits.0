From: akpm@linux-foundation.org
Subject: + mm-fail-get_vaddr_frames-for-filesystem-dax-mappings-v3.patch
 added to -mm tree
Date: Wed, 29 Nov 2017 13:37:23 -0800
Message-ID: <5a1f2893.Sxl7cnnQiNg96gLh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34802 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752324AbdK2VhZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Nov 2017 16:37:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fail-get_vaddr_frames-for-filesystem-dax-mappings-v3
has been added to the -mm tree.  Its filename is
     mm-fail-get_vaddr_frames-for-filesystem-dax-mappings-v3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fail-get_vaddr_frames-for-filesystem-dax-mappings-v3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fail-get_vaddr_frames-for-filesystem-dax-mappings-v3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-fix-device-dax-pud-write-faults-triggered-by-get_user_pages-v3.patch
mm-switch-to-define-pmd_write-instead-of-__have_arch_pmd_write.patch
mm-replace-pud_write-with-pud_access_permitted-in-fault-gup-paths.patch
mm-replace-pud_write-with-pud_access_permitted-in-fault-gup-paths-v3.patch
mm-replace-pmd_write-with-pmd_access_permitted-in-fault-gup-paths.patch
mm-replace-pte_write-with-pte_access_permitted-in-fault-gup-paths.patch
mm-hugetlbfs-introduce-split-to-vm_operations_struct.patch
device-dax-implement-split-to-catch-invalid-munmap-attempts.patch
mm-introduce-get_user_pages_longterm.patch
mm-fail-get_vaddr_frames-for-filesystem-dax-mappings.patch
mm-fail-get_vaddr_frames-for-filesystem-dax-mappings-v3.patch
v4l2-disable-filesystem-dax-mapping-support.patch
ib-core-disable-memory-registration-of-fileystem-dax-vmas.patch

