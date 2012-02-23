From: akpm@linux-foundation.org
Subject: + x86-pci-increase-the-number-of-iommus-supported-to-be-max_io_apics-v2.patch added to -mm tree
Date: Thu, 23 Feb 2012 12:31:19 -0800
Message-ID: <20120223203120.707E6A0295@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:59062 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751346Ab2BWUbX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Feb 2012 15:31:23 -0500
Received: by lahl5 with SMTP id l5so56369lah.1
        for <mm-commits@vger.kernel.org>; Thu, 23 Feb 2012 12:31:21 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: travis@sgi.com, chrisw@sous-sol.org, drahn@suse.com, dwmw2@infradead.org, jbarnes@virtuousgeek.org, mingo@elte.hu, steiner@sgi.com


The patch titled
     Subject: x86-pci-increase-the-number-of-iommus-supported-to-be-max_io_apics-v2
has been added to the -mm tree.  Its filename is
     x86-pci-increase-the-number-of-iommus-supported-to-be-max_io_apics-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Travis <travis@sgi.com>
Subject: x86-pci-increase-the-number-of-iommus-supported-to-be-max_io_apics-v2

Version 2: Fix compile error on ia64 (it uses the DMAR logic but does not
define MAX_IO_APICS.)  Check to insure that iommu_bmp does not overflow.

Signed-off-by: Mike Travis <travis@sgi.com>
Signed-off-by: Jack Steiner <steiner@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jack Steiner <steiner@sgi.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Daniel Rahn <drahn@suse.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/iommu/intel-iommu.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff -puN drivers/iommu/intel-iommu.c~x86-pci-increase-the-number-of-iommus-supported-to-be-max_io_apics-v2 drivers/iommu/intel-iommu.c
--- a/drivers/iommu/intel-iommu.c~x86-pci-increase-the-number-of-iommus-supported-to-be-max_io_apics-v2
+++ a/drivers/iommu/intel-iommu.c
@@ -354,10 +354,17 @@ static int hw_pass_through = 1;
 /* si_domain contains mulitple devices */
 #define DOMAIN_FLAG_STATIC_IDENTITY	(1 << 2)
 
+/* define the limit of IOMMUs supported in each domain */
+#ifdef	CONFIG_X86
+#define	IOMMU_UNITS_SUPPORTED	MAX_IO_APICS
+#else
+#define	IOMMU_UNITS_SUPPORTED	64
+#endif
+
 struct dmar_domain {
 	int	id;			/* domain id */
 	int	nid;			/* node id */
-	DECLARE_BITMAP(iommu_bmp, MAX_IO_APICS);
+	DECLARE_BITMAP(iommu_bmp, IOMMU_UNITS_SUPPORTED);
 					/* bitmap of iommus this domain uses*/
 
 	struct list_head devices; 	/* all devices' list */
@@ -2401,12 +2408,17 @@ static int __init init_dmars(void)
 	 * endfor
 	 */
 	for_each_drhd_unit(drhd) {
-		g_num_of_iommus++;
 		/*
 		 * lock not needed as this is only incremented in the single
 		 * threaded kernel __init code path all other access are read
 		 * only
 		 */
+		if (g_num_of_iommus < IOMMU_UNITS_SUPPORTED)
+			g_num_of_iommus++;
+		else
+			printk_once(KERN_ERR,
+			  "MAX number (%d) of IOMMUs supported exceeded\n",
+			  IOMMU_UNITS_SUPPORTED);
 	}
 
 	g_iommus = kcalloc(g_num_of_iommus, sizeof(struct intel_iommu *),
_
Subject: Subject: x86-pci-increase-the-number-of-iommus-supported-to-be-max_io_apics-v2

Patches currently in -mm which might be from travis@sgi.com are

x86-pci-fix-identity-mapping-for-sandy-bridge.patch
x86-pci-increase-the-number-of-iommus-supported-to-be-max_io_apics.patch
x86-pci-increase-the-number-of-iommus-supported-to-be-max_io_apics-v2.patch
x86-pci-increase-the-number-of-iommus-supported-to-be-max_io_apics-v2-fix.patch

