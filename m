Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98472C433E0
	for <mm-commits@archiver.kernel.org>; Fri,  5 Mar 2021 02:08:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66DD16500F
	for <mm-commits@archiver.kernel.org>; Fri,  5 Mar 2021 02:08:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbhCECIR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 4 Mar 2021 21:08:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:56790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229436AbhCECIQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Mar 2021 21:08:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 043A86500D;
        Fri,  5 Mar 2021 02:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614910096;
        bh=Wh3x73O4qD/mzzmsVcTL1fACLtYO5njQYgpcNVTAGoU=;
        h=Date:From:To:Subject:From;
        b=BCADK9rXJ8p24x0vhm82SZbXcI2nU9HM/sSGAQhaIgLM1K2Mio6697WwXv1LSq8+g
         +BOTVkL43yWeySJfXqU/A/7FXJNQnxzZZp0L0RNMB/FsMlLoatNDxukNDMsNVJ6HCd
         /P624cFe81wCF4RwlXU2yyRNKXbKm76Qim1gmzwo=
Date:   Thu, 04 Mar 2021 18:08:15 -0800
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, ben.widawsky@intel.com, cai@lca.pw,
        cl@linux.com, dan.j.williams@intel.com,
        dave.hansen@linux.intel.com, dwagner@suse.de,
        mm-commits@vger.kernel.org, osalvador@suse.de, rientjes@google.com,
        tobin@kernel.org, ying.huang@intel.com
Subject:  + mm-vmscan-move-reclaim-bits-to-uapi-header.patch added
 to -mm tree
Message-ID: <20210305020815.q9jBRcN6A%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: move RECLAIM* bits to uapi header
has been added to the -mm tree.  Its filename is
     mm-vmscan-move-reclaim-bits-to-uapi-header.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-move-reclaim-bits-to-uapi-header.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-move-reclaim-bits-to-uapi-header.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: mm/vmscan: move RECLAIM* bits to uapi header

It is currently not obvious that the RECLAIM_* bits are part of the uapi
since they are defined in vmscan.c.  Move them to a uapi header to make it
obvious.

This should have no functional impact.

Link: https://lkml.kernel.org/r/20210219172557.08074910@viggo.jf.intel.com
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Ben Widawsky <ben.widawsky@intel.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: "Tobin C. Harding" <tobin@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Qian Cai <cai@lca.pw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/mempolicy.h |    7 +++++++
 mm/vmscan.c                    |    8 --------
 2 files changed, 7 insertions(+), 8 deletions(-)

--- a/include/uapi/linux/mempolicy.h~mm-vmscan-move-reclaim-bits-to-uapi-header
+++ a/include/uapi/linux/mempolicy.h
@@ -64,5 +64,12 @@ enum {
 #define MPOL_F_MOF	(1 << 3) /* this policy wants migrate on fault */
 #define MPOL_F_MORON	(1 << 4) /* Migrate On protnone Reference On Node */
 
+/*
+ * These bit locations are exposed in the vm.zone_reclaim_mode sysctl
+ * ABI.  New bits are OK, but existing bits can never change.
+ */
+#define RECLAIM_ZONE	(1<<0)	/* Run shrink_inactive_list on the zone */
+#define RECLAIM_WRITE	(1<<1)	/* Writeout pages during reclaim */
+#define RECLAIM_UNMAP	(1<<2)	/* Unmap pages during reclaim */
 
 #endif /* _UAPI_LINUX_MEMPOLICY_H */
--- a/mm/vmscan.c~mm-vmscan-move-reclaim-bits-to-uapi-header
+++ a/mm/vmscan.c
@@ -4086,14 +4086,6 @@ module_init(kswapd_init)
 int node_reclaim_mode __read_mostly;
 
 /*
- * These bit locations are exposed in the vm.zone_reclaim_mode sysctl
- * ABI.  New bits are OK, but existing bits can never change.
- */
-#define RECLAIM_ZONE  (1<<0)   /* Run shrink_inactive_list on the zone */
-#define RECLAIM_WRITE (1<<1)   /* Writeout pages during reclaim */
-#define RECLAIM_UNMAP (1<<2)   /* Unmap pages during reclaim */
-
-/*
  * Priority for NODE_RECLAIM. This determines the fraction of pages
  * of a node considered for each zone_reclaim. 4 scans 1/16th of
  * a zone.
_

Patches currently in -mm which might be from dave.hansen@linux.intel.com are

mm-vmscan-move-reclaim-bits-to-uapi-header.patch
mm-vmscan-replace-implicit-reclaim_zone-checks-with-explicit-checks.patch

