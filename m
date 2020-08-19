Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50F38C433E1
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 19:39:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34E1C2083B
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 19:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597865949;
	bh=DxbS27PjcrGq47Jy2vOo4fq71i7SBBqm9acMLvSGxHA=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=jtlWrMbSPhBnAtsjcwIFXQhtdKDNlhXxmuwBdi18BR68lso0OWNno5SzXIyIoQ/Zs
	 y4D5moeQgT0Oe14EHUpVo+5PS2Urdv1onUd944FpCTtXPBWPmoiZR4yk6xXQuyuRYQ
	 HFT4A/hBFQJLC5RWXg89McGzQNMmmL3nR3Dz7wXM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgHSTjI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Aug 2020 15:39:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:49152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726466AbgHSTjH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Aug 2020 15:39:07 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CA08207BB;
        Wed, 19 Aug 2020 19:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597865946;
        bh=DxbS27PjcrGq47Jy2vOo4fq71i7SBBqm9acMLvSGxHA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=PaNNzIE2SBzinZaOKckMxMr020dXpzS0v0gril98Xh/NEbdeqKKLAelOfLwuJa33I
         /cWDYJ4AATKBlDXtPBTnEOPyz2Xqndd7CrysMmvwwHiryrgV/EQtOmCP+ubEU+OLhj
         fedKocMgR0tPKC3D8jxk86aJOrx7r+tSDHtokU2c=
Date:   Wed, 19 Aug 2020 12:39:06 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     dan.j.williams@intel.com, ira.weiny@intel.com,
        mm-commits@vger.kernel.org, vishal.l.verma@intel.com,
        william.kucharski@oracle.com
Subject:  + memremap-convert-devmap-static-branch-to-incdec.patch
 added to -mm tree
Message-ID: <20200819193906.w1nj95HjC%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memremap.c: convert devmap static branch to {inc,dec}
has been added to the -mm tree.  Its filename is
     memremap-convert-devmap-static-branch-to-incdec.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memremap-convert-devmap-static-branch-to-incdec.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memremap-convert-devmap-static-branch-to-incdec.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

memremap-convert-devmap-static-branch-to-incdec.patch
mm-highmem-clean-up-endif-comments.patch

