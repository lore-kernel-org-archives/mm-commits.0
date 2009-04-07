From: akpm@linux-foundation.org
Subject: + include-linux-dmarh-fix-build-with-config_profile_all_branches.patch added to -mm tree
Date: Mon, 06 Apr 2009 17:41:12 -0700
Message-ID: <200904070059.n370xawf012761@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50358 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753226AbZDGBCN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 21:02:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, dwmw2@infradead.org, mingo@elte.hu, rostedt@goodmis.org


The patch titled
     include/linux/dmar.h: fix build with CONFIG_PROFILE_ALL_BRANCHES
has been added to the -mm tree.  Its filename is
     include-linux-dmarh-fix-build-with-config_profile_all_branches.patch

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
Subject: include/linux/dmar.h: fix build with CONFIG_PROFILE_ALL_BRANCHES
From: Andrew Morton <akpm@linux-foundation.org>

i386 allmodconfig:

drivers/pci/intel-iommu.c:2637:35: error: macro "if" passed 2 arguments, but takes just 1
drivers/pci/intel-iommu.c: In function 'init_iommu_hw':
drivers/pci/intel-iommu.c:2637: error: expected '(' before '{' token
drivers/pci/intel-iommu.c:2638: error: '______r' undeclared (first use in this function)
drivers/pci/intel-iommu.c:2638: error: (Each undeclared identifier is reported only once
drivers/pci/intel-iommu.c:2638: error: for each function it appears in.)
drivers/pci/intel-iommu.c:2641:35: error: macro "if" passed 2 arguments, but takes just 1
drivers/pci/intel-iommu.c:2641: error: expected '(' before '{' token
drivers/pci/intel-iommu.c:2662:35: error: macro "if" passed 2 arguments, but takes just 1
drivers/pci/intel-iommu.c: In function 'iommu_flush_all':
drivers/pci/intel-iommu.c:2662: error: expected '(' before '{' token
drivers/pci/intel-iommu.c:2676:35: error: macro "if" passed 2 arguments, but takes just 1
drivers/pci/intel-iommu.c: In function 'iommu_suspend':
drivers/pci/intel-iommu.c:2676: error: expected '(' before '{' token
drivers/pci/intel-iommu.c:2678: error: too few arguments to function 'kzalloc'
drivers/pci/intel-iommu.c:2685:35: error: macro "if" passed 2 arguments, but takes just 1
drivers/pci/intel-iommu.c:2685: error: expected '(' before '{' token
drivers/pci/intel-iommu.c:2688: error: '__dummy' undeclared (first use in this function)
drivers/pci/intel-iommu.c:2704:35: error: macro "if" passed 2 arguments, but takes just 1
drivers/pci/intel-iommu.c:2704: error: expected '(' before '{' token
drivers/pci/intel-iommu.c:2721:35: error: macro "if" passed 2 arguments, but takes just 1
drivers/pci/intel-iommu.c:2737:35: error: macro "if" passed 2 arguments, but takes just 1
drivers/pci/intel-iommu.c: At top level:
drivers/pci/intel-iommu.c:2745: error: 'iommu_resume' undeclared here (not in a function)

Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/dmar.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/dmar.h~include-linux-dmarh-fix-build-with-config_profile_all_branches include/linux/dmar.h
--- a/include/linux/dmar.h~include-linux-dmarh-fix-build-with-config_profile_all_branches
+++ a/include/linux/dmar.h
@@ -47,11 +47,11 @@ extern struct list_head dmar_drhd_units;
 
 #define for_each_active_iommu(i, drhd)					\
 	list_for_each_entry(drhd, &dmar_drhd_units, list)		\
-		if (i=drhd->iommu, drhd->ignored) {} else
+		if ((i=drhd->iommu, drhd->ignored)) {} else
 
 #define for_each_iommu(i, drhd)						\
 	list_for_each_entry(drhd, &dmar_drhd_units, list)		\
-		if (i=drhd->iommu, 0) {} else 
+		if ((i=drhd->iommu, 0)) {} else
 
 extern int dmar_table_init(void);
 extern int dmar_dev_scope_init(void);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
include-linux-dmarh-fix-build-with-config_profile_all_branches.patch
mm-add-proc-controls-for-pdflush-threads.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas.patch
namespaces-mqueue-namespace-adapt-sysctl.patch
nilfs2-integrated-block-mapping.patch
nilfs2-segment-buffer.patch

