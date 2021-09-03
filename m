Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE35FC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:55:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5B63610C8
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:55:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235926AbhICU4P (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:56:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:55408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236039AbhICU4P (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:56:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9911B610CC;
        Fri,  3 Sep 2021 20:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702514;
        bh=1wLlGOXkXk5feshfxBkdQs5pcxTpFMotps1fcXvWhpc=;
        h=Date:From:To:Subject:From;
        b=JT2VJ0aCaP/UBIlD5DDgcobBsQXBavex5BxYSvdlzChMSLhaiw3/DEvFFbCCZVW4b
         j4EKFOFOXGYsZBAKBG1R6uLMOrPO8tSv0mcJ81zTZ0xHfsfbW8sr8XySV60RcBevi/
         Gr3ePXpzNT06DMPLbWWQkxJWkkj0tEYgQqX5B2xo=
Date:   Fri, 03 Sep 2021 13:55:14 -0700
From:   akpm@linux-foundation.org
To:     frowand.list@gmail.com, geert+renesas@glider.be,
        horms@verge.net.au, jlan@sgi.com, magnus.damm@gmail.com,
        mm-commits@vger.kernel.org, robh+dt@kernel.org,
        rppt@linux.vnet.ibm.com, tony.luck@intel.com
Subject:  [merged] ia64-make-num_rsvd_regions-static.patch removed
 from -mm tree
Message-ID: <20210903205514.bzcRcesQy%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: make num_rsvd_regions static
has been removed from the -mm tree.  Its filename was
     ia64-make-num_rsvd_regions-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: ia64: make num_rsvd_regions static

Commit f62800992e5917f2 ("ia64: switch to NO_BOOTMEM") removed the last
user of num_rsvd_regions outside arch/ia64/kernel/setup.c.

Link: https://lkml.kernel.org/r/a377b5437e3e9da93d02f996fe06a2b956cb0990.1629884459.git.geert+renesas@glider.be
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Frank Rowand <frowand.list@gmail.com>
Cc: Jay Lan <jlan@sgi.com>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Simon Horman <horms@verge.net.au>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/meminit.h |    1 -
 arch/ia64/kernel/setup.c        |    2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

--- a/arch/ia64/include/asm/meminit.h~ia64-make-num_rsvd_regions-static
+++ a/arch/ia64/include/asm/meminit.h
@@ -29,7 +29,6 @@ struct rsvd_region {
 };
 
 extern struct rsvd_region rsvd_region[IA64_MAX_RSVD_REGIONS + 1];
-extern int num_rsvd_regions;
 
 extern void find_memory (void);
 extern void reserve_memory (void);
--- a/arch/ia64/kernel/setup.c~ia64-make-num_rsvd_regions-static
+++ a/arch/ia64/kernel/setup.c
@@ -131,7 +131,7 @@ unsigned long ia64_cache_stride_shift =
  * We use a special marker for the end of memory and it uses the extra (+1) slot
  */
 struct rsvd_region rsvd_region[IA64_MAX_RSVD_REGIONS + 1] __initdata;
-int num_rsvd_regions __initdata;
+static int num_rsvd_regions __initdata;
 
 
 /*
_

Patches currently in -mm which might be from geert+renesas@glider.be are


