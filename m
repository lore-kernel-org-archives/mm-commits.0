Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7443C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:27:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377865AbiATV1F (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:27:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347757AbiATV1E (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:27:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DEA0C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:27:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1869FB81E6C
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:27:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FEB6C340E0;
        Thu, 20 Jan 2022 21:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714021;
        bh=xwVSVfMGpiOM+NdIGrYDQERvclPvmVHLS/5Y/2RLm7g=;
        h=Date:From:To:Subject:From;
        b=sM2+hjNvzxEYLQaTj/zMORApiiJ7p4WSbEx4+Xc8l3/6aPyUstQISNuT5sHkDp/Lz
         JkI2WrFo+VZWlDGKBbIshZIS1JSN8qhyt038XxaUZX2knKs2U18zy15wxhSMUlqO+R
         L10xR2mud/aqLOO0BDQviiyUAvcDZY/YEz7rOp8o=
Date:   Thu, 20 Jan 2022 13:27:01 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, ligang.bdlg@bytedance.com,
        mm-commits@vger.kernel.org, songmuchun@bytedance.com
Subject:  [merged] vmscan-make-drop_slab_node-static.patch removed
 from -mm tree
Message-ID: <20220120212701.S9HL1B-B2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: vmscan: make drop_slab_node static
has been removed from the -mm tree.  Its filename was
     vmscan-make-drop_slab_node-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gang Li <ligang.bdlg@bytedance.com>
Subject: vmscan: make drop_slab_node static

drop_slab_node is only used in drop_slab.  So remove it's declaration from
header file and add keyword static for it's definition.

Link: https://lkml.kernel.org/r/20211111062445.5236-1-ligang.bdlg@bytedance.com
Signed-off-by: Gang Li <ligang.bdlg@bytedance.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 -
 mm/vmscan.c        |    2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

--- a/include/linux/mm.h~vmscan-make-drop_slab_node-static
+++ a/include/linux/mm.h
@@ -3122,7 +3122,6 @@ int drop_caches_sysctl_handler(struct ct
 #endif
 
 void drop_slab(void);
-void drop_slab_node(int nid);
 
 #ifndef CONFIG_MMU
 #define randomize_va_space 0
--- a/mm/vmscan.c~vmscan-make-drop_slab_node-static
+++ a/mm/vmscan.c
@@ -951,7 +951,7 @@ out:
 	return freed;
 }
 
-void drop_slab_node(int nid)
+static void drop_slab_node(int nid)
 {
 	unsigned long freed;
 	int shift = 0;
_

Patches currently in -mm which might be from ligang.bdlg@bytedance.com are


