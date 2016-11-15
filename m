From: akpm@linux-foundation.org
Subject: + mm-disable-numa-migration-faults-for-dax-vmas.patch added to
 -mm tree
Date: Mon, 14 Nov 2016 16:23:36 -0800
Message-ID: <582a5588.15GHw/iI4YipVTRp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60302 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755204AbcKOAXh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Nov 2016 19:23:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, aneesh.kumar@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: disable numa migration faults for dax vmas
has been added to the -mm tree.  Its filename is
     mm-disable-numa-migration-faults-for-dax-vmas.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-disable-numa-migration-faults-for-dax-vmas.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-disable-numa-migration-faults-for-dax-vmas.patch

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
Subject: mm: disable numa migration faults for dax vmas

Mark dax vmas as not migratable to exclude them from task_numa_work(). 
This is especially relevant for device-dax which wants to ensure
predictable access latency and not incur periodic faults.

Link: http://lkml.kernel.org/r/147892450132.22062.16875659431109209179.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN include/linux/mempolicy.h~mm-disable-numa-migration-faults-for-dax-vmas include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mm-disable-numa-migration-faults-for-dax-vmas
+++ a/include/linux/mempolicy.h
@@ -7,6 +7,7 @@
 
 
 #include <linux/mmzone.h>
+#include <linux/dax.h>
 #include <linux/slab.h>
 #include <linux/rbtree.h>
 #include <linux/spinlock.h>
@@ -179,6 +180,9 @@ static inline bool vma_migratable(struct
 	if (vma->vm_flags & (VM_IO | VM_PFNMAP))
 		return false;
 
+	if (vma_is_dax(vma))
+		return false;
+
 #ifndef CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION
 	if (vma->vm_flags & VM_HUGETLB)
 		return false;
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

mm-disable-numa-migration-faults-for-dax-vmas.patch

