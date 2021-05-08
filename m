Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 839B6C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:48:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 623CB61430
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:48:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbhEHWtS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:49:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:33638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229616AbhEHWtS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:49:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6A2B6100C;
        Sat,  8 May 2021 22:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514096;
        bh=4G/WimrDpOrgIKw9CGesea8pjLVd2lV3uNhxWUJHnws=;
        h=Date:From:To:Subject:From;
        b=j1aZ+gigxLGPv7NcWUlNmCxe59RtO1XlCkZOAT4PgF3Jc0RWZHKibHQiLRz5xSu77
         LoauK41lgJkHeTDz0zkBUgWSUEvpMb1COM036n5gv3D8RcGju/y3LG9N1q5MAup3xU
         Ts/9ZB9qxOsMOyXvHIf1h5jZsG8Rkso3tXy+ZRhw=
Date:   Sat, 08 May 2021 15:48:15 -0700
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, ben.widawsky@intel.com, cai@lca.pw,
        cl@linux.com, dan.j.williams@intel.com,
        dave.hansen@linux.intel.com, dwagner@suse.de,
        mm-commits@vger.kernel.org, osalvador@suse.de, rientjes@google.com,
        tobin@kernel.org, ying.huang@intel.com
Subject:  [merged] mm-vmscan-move-reclaim-bits-to-uapi-header.patch
 removed from -mm tree
Message-ID: <20210508224815._loiMu_Bo%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: move RECLAIM* bits to uapi header
has been removed from the -mm tree.  Its filename was
     mm-vmscan-move-reclaim-bits-to-uapi-header.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -4087,14 +4087,6 @@ module_init(kswapd_init)
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


