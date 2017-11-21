From: akpm@linux-foundation.org
Subject: +
 mm-replace-pud_write-with-pud_access_permitted-in-fault-gup-paths-v3.patch
 added to -mm tree
Date: Tue, 21 Nov 2017 12:47:56 -0800
Message-ID: <5a1490fc.PflO1EkBGqhqquQ7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57806 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751067AbdKUUr5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Nov 2017 15:47:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-replace-pud_write-with-pud_access_permitted-in-fault-gup-paths-v3
has been added to the -mm tree.  Its filename is
     mm-replace-pud_write-with-pud_access_permitted-in-fault-gup-paths-v3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-replace-pud_write-with-pud_access_permitted-in-fault-gup-paths-v3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-replace-pud_write-with-pud_access_permitted-in-fault-gup-paths-v3.patch

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
mm-fix-device-dax-pud-write-faults-triggered-by-get_user_pages-v3.patch
mm-switch-to-define-pmd_write-instead-of-__have_arch_pmd_write.patch
mm-replace-pud_write-with-pud_access_permitted-in-fault-gup-paths.patch
mm-replace-pud_write-with-pud_access_permitted-in-fault-gup-paths-v3.patch
mm-replace-pmd_write-with-pmd_access_permitted-in-fault-gup-paths.patch
mm-replace-pte_write-with-pte_access_permitted-in-fault-gup-paths.patch

