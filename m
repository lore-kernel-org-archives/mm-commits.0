From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-disable-numa-migration-faults-for-dax-vmas-fix.patch removed from -mm
 tree
Date: Mon, 12 Dec 2016 16:22:38 -0800
Message-ID: <584f3f4e.6hUF3Ilz9vJHI0Dk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37874 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751615AbcLMAVz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:21:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com, dan.j.williams@intel.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-disable-numa-migration-faults-for-dax-vmas-fix
has been removed from the -mm tree.  Its filename was
     mm-disable-numa-migration-faults-for-dax-vmas-fix.patch

This patch was dropped because it was folded into mm-disable-numa-migration-faults-for-dax-vmas.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-disable-numa-migration-faults-for-dax-vmas-fix

add comment

Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN include/linux/mempolicy.h~mm-disable-numa-migration-faults-for-dax-vmas-fix include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mm-disable-numa-migration-faults-for-dax-vmas-fix
+++ a/include/linux/mempolicy.h
@@ -178,6 +178,10 @@ static inline bool vma_migratable(struct
 	if (vma->vm_flags & (VM_IO | VM_PFNMAP))
 		return false;
 
+	/*
+	 * DAX device mappings require predictable access latency, so avoid
+	 * incurring periodic faults.
+	 */
 	if (vma_is_dax(vma))
 		return false;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-disable-numa-migration-faults-for-dax-vmas.patch
filemap-add-comment-for-confusing-logic-in-page_cache_tree_insert-fix.patch
include-linux-backing-dev-defsh-shrink-struct-backing_dev_info.patch
mm-add-vfree_atomic-fix-fix.patch
mm-thp-page-cache-support-for-ppc64-fix.patch
mm-rmap-handle-anon_vma_prepare-common-case-inline-checkpatch-fixes.patch
scripts-checkpatchpl-fix-spelling.patch
init-reduce-rootwait-polling-interval-time-to-5ms-fix.patch

