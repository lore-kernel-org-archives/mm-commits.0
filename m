From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-replace-pud_write-with-pud_access_permitted-in-fault-gup-paths-v3.patch
 removed from -mm tree
Date: Wed, 29 Nov 2017 16:05:52 -0800
Message-ID: <5a1f4b60.sgGt7z7Y5kXWU3JV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60002 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752682AbdK3AFx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Nov 2017 19:05:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-replace-pud_write-with-pud_access_permitted-in-fault-gup-paths-v3
has been removed from the -mm tree.  Its filename was
     mm-replace-pud_write-with-pud_access_permitted-in-fault-gup-paths-v3.patch

This patch was dropped because it was folded into mm-replace-pud_write-with-pud_access_permitted-in-fault-gup-paths.patch

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm-replace-pud_write-with-pud_access_permitted-in-fault-gup-paths-v3

* Switch from the "#define __HAVE_ARCH_PUD_WRITE" to "#define
  pud_write". This incidentally fixes a powerpc compile error.
  (Stephen)

Link: http://lkml.kernel.org/r/151129127237.37405.16073414520854722485.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/pgtable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/s390/include/asm/pgtable.h~mm-replace-pud_write-with-pud_access_permitted-in-fault-gup-paths-v3 arch/s390/include/asm/pgtable.h
--- a/arch/s390/include/asm/pgtable.h~mm-replace-pud_write-with-pud_access_permitted-in-fault-gup-paths-v3
+++ a/arch/s390/include/asm/pgtable.h
@@ -1264,7 +1264,7 @@ static inline pud_t pud_mkwrite(pud_t pu
 	return pud;
 }
 
-#define __HAVE_ARCH_PUD_WRITE
+#define pud_write pud_write
 static inline int pud_write(pud_t pud)
 {
 	return (pud_val(pud) & _REGION3_ENTRY_WRITE) != 0;
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
mm-fail-get_vaddr_frames-for-filesystem-dax-mappings-v3.patch
v4l2-disable-filesystem-dax-mapping-support.patch
ib-core-disable-memory-registration-of-fileystem-dax-vmas.patch

