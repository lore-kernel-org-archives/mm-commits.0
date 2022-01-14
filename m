Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C19A1C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:08:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbiANWIL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:08:11 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:37606 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbiANWIL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:08:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0D7A4CE2497
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:08:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 445A8C36AEC;
        Fri, 14 Jan 2022 22:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642198088;
        bh=x52Bihfq2g5s2vzRz3Ir1EyXlJtuNlkVDsMtcn41xeg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Ww7nwi0PBsyPfFbjx6TJtIBrqIVetFAznEfK7NFE772iF0VbC2gouXh2JrvgTHGCz
         6KcvY7lVgf73JcTG7Gr9H284wAoKZpeOWkt0Y3TdyKW5jFNdk4vifyWRWnBFGj6SAN
         gK47Coinl41Nh1Yc2DsaqRTFV/+AyJUcOTn/wqYE=
Date:   Fri, 14 Jan 2022 14:08:07 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com,
        ligang.bdlg@bytedance.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        torvalds@linux-foundation.org
Subject:  [patch 094/146] vmscan: make drop_slab_node static
Message-ID: <20220114220807.RmWYbLa8H%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
