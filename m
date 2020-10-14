Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67516C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:00:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09C5F22248
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709200;
	bh=42PGeCIFSSifOJk/x/e5avGQWA9kDoSu31Re0OVouJI=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=zoQm0R79mcoKegwCOwF5wuJ7uGSYZe3BG6hQiUz50W7RDlcsgUPB9WN/ZDYaHwtMV
	 iV2f2Dc4uUGYHoDMrPCK/8hgqtqS+4vAW6auPdy+PVHo6NuF6jIR6oYorSztjNOf1j
	 D9nePhFHTT2MgwgKRpZqNDHutP/Aup+8TQ2BE1b4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730474AbgJNU77 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:59:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:50366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725923AbgJNU77 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:59:59 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9876D2068E;
        Wed, 14 Oct 2020 20:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709198;
        bh=42PGeCIFSSifOJk/x/e5avGQWA9kDoSu31Re0OVouJI=;
        h=Date:From:To:Subject:From;
        b=eSp21D1P0FJj0UOMpLJ6dazJE6FSNzg+Qs0riMVXd2W+1aBYcZT5pSMHvd1lGEXob
         dZaCCJxMRI58pF2+YwZyjGi9McmYq21QDNKfY0qYvpKaaXSln3Z1+BpcsbCI1LPzVh
         T0w1Z6MI6L6QrVEMqVdceI2KieEjloBikQcxo8d0=
Date:   Wed, 14 Oct 2020 13:59:58 -0700
From:   akpm@linux-foundation.org
To:     dan.j.williams@intel.com, ira.weiny@intel.com,
        mm-commits@vger.kernel.org, vishal.l.verma@intel.com,
        william.kucharski@oracle.com
Subject:  [merged]
 memremap-convert-devmap-static-branch-to-incdec.patch removed from -mm tree
Message-ID: <20201014205958.sdKnVW50x%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memremap.c: convert devmap static branch to {inc,dec}
has been removed from the -mm tree.  Its filename was
     memremap-convert-devmap-static-branch-to-incdec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ira Weiny <ira.weiny@intel.com>
Subject: mm/memremap.c: convert devmap static branch to {inc,dec}

While reviewing Protection Key Supervisor support it was pointed out that
using a counter to track static branch enable was an anti-pattern which
was better solved using the provided static_branch_{inc,dec} functions.[1]

Fix up devmap_managed_key to work the same way.  Also this should be safer
because there is a very small (very unlikely) race when multiple callers
try to enable at the same time.

[1] https://lore.kernel.org/lkml/20200714194031.GI5523@worktop.programming.kicks-ass.net/

Link: https://lkml.kernel.org/r/20200810235319.2796597-1-ira.weiny@intel.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memremap.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/mm/memremap.c~memremap-convert-devmap-static-branch-to-incdec
+++ a/mm/memremap.c
@@ -40,12 +40,10 @@ EXPORT_SYMBOL_GPL(memremap_compat_align)
 #ifdef CONFIG_DEV_PAGEMAP_OPS
 DEFINE_STATIC_KEY_FALSE(devmap_managed_key);
 EXPORT_SYMBOL(devmap_managed_key);
-static atomic_t devmap_managed_enable;
 
 static void devmap_managed_enable_put(void)
 {
-	if (atomic_dec_and_test(&devmap_managed_enable))
-		static_branch_disable(&devmap_managed_key);
+	static_branch_dec(&devmap_managed_key);
 }
 
 static int devmap_managed_enable_get(struct dev_pagemap *pgmap)
@@ -56,8 +54,7 @@ static int devmap_managed_enable_get(str
 		return -EINVAL;
 	}
 
-	if (atomic_inc_return(&devmap_managed_enable) == 1)
-		static_branch_enable(&devmap_managed_key);
+	static_branch_inc(&devmap_managed_key);
 	return 0;
 }
 #else
_

Patches currently in -mm which might be from ira.weiny@intel.com are

mm-highmem-clean-up-endif-comments.patch

