From: akpm@linux-foundation.org
Subject: + intel-iommu-fix-__init-section-missmatch-of-dmar_parse_rmrr_atsr_dev.patch added to -mm tree
Date: Tue, 22 Nov 2011 15:17:36 -0800
Message-ID: <201111222317.pAMNHawn020998@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:50745 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab1KVXRm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2011 18:17:42 -0500
Received: by fabs1 with SMTP id s1so32974fab.1
        for <mm-commits@vger.kernel.org>; Tue, 22 Nov 2011 15:17:41 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: baryluk@smp.if.uj.edu.pl, allen.m.kay@intel.com, dwmw2@infradead.org, suresh.b.siddha@intel.com


The patch titled
     Subject: intel-iommu: Fix __init section missmatch of dmar_parse_rmrr_atsr_dev
has been added to the -mm tree.  Its filename is
     intel-iommu-fix-__init-section-missmatch-of-dmar_parse_rmrr_atsr_dev.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
Subject: intel-iommu: Fix __init section missmatch of dmar_parse_rmrr_atsr_dev

dmar_parse_rmrr_atsr_dev() (drivers/iommu/dmar.c) is called from
dmar_dev_scope_init() (drivers/iommu/intel-iommu.c), but
dmar_dev_scope_init() is annotated with __init, when
dmar_parse_rmrr_atsr_dev() is not, causing full section missmatch
analsysis to abort compilation.

Fix problem by adding __init annotation to dmar_parse_rmrr_atsr_dev.

Signed-off-by: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Allen Kay <allen.m.kay@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/iommu/intel-iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/iommu/intel-iommu.c~intel-iommu-fix-__init-section-missmatch-of-dmar_parse_rmrr_atsr_dev drivers/iommu/intel-iommu.c
--- a/drivers/iommu/intel-iommu.c~intel-iommu-fix-__init-section-missmatch-of-dmar_parse_rmrr_atsr_dev
+++ a/drivers/iommu/intel-iommu.c
@@ -3542,7 +3542,7 @@ found:
 	return 0;
 }
 
-int dmar_parse_rmrr_atsr_dev(void)
+int __init dmar_parse_rmrr_atsr_dev(void)
 {
 	struct dmar_rmrr_unit *rmrr, *rmrr_n;
 	struct dmar_atsr_unit *atsr, *atsr_n;
_
Subject: Subject: intel-iommu: Fix __init section missmatch of dmar_parse_rmrr_atsr_dev

Patches currently in -mm which might be from baryluk@smp.if.uj.edu.pl are

intel-iommu-fix-__init-section-missmatch-of-dmar_parse_rmrr_atsr_dev.patch

