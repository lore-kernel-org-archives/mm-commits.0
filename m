Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7078C636D4
	for <mm-commits@archiver.kernel.org>; Fri, 17 Feb 2023 04:45:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbjBQEpy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Feb 2023 23:45:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbjBQEpD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Feb 2023 23:45:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 615844FCBA
        for <mm-commits@vger.kernel.org>; Thu, 16 Feb 2023 20:44:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F2E65612CA
        for <mm-commits@vger.kernel.org>; Fri, 17 Feb 2023 04:44:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58E2EC433EF;
        Fri, 17 Feb 2023 04:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676609092;
        bh=+URmD5n/qrzSZGYiriUbOOUi1Tosdu6qCDxouoWqYzo=;
        h=Date:To:From:Subject:From;
        b=ZQeK0mngaqpjFc7OA3ihsrEw0aZ+vufZ4dWwO1NeAN/d85Vo02U1/pjUF8St6b1Fr
         z+3AyhcgcIa5cEA6Nix9ezIav2DaF/g34lz6Peti5m1E450xplwTU7pBDuuwqgeI4s
         PhmbK9QHwIDVcgeWDNIsqIPkwVQlo2EjFmqW1zKA=
Date:   Thu, 16 Feb 2023 20:44:51 -0800
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-call-panic-when-memoryless-node-allocation-fails.patch removed from -mm tree
Message-Id: <20230217044452.58E2EC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: page_alloc: call panic() when memoryless node allocation fails
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-call-panic-when-memoryless-node-allocation-fails.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: page_alloc: call panic() when memoryless node allocation fails
Date: Sun, 12 Feb 2023 19:10:27 +0800

In free_area_init(), we will continue to run after allocation of
memoryless node pgdat fails.  However, in the subsequent process (such as
when initializing zonelist), the case that NODE_DATA(nid) is NULL is not
handled, which will cause panic.  Instead of this, it's better to call
panic() directly when the memory allocation fails during system boot.

Link: https://lkml.kernel.org/r/20230212111027.95520-1-zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/page_alloc.c~mm-page_alloc-call-panic-when-memoryless-node-allocation-fails
+++ a/mm/page_alloc.c
@@ -8405,11 +8405,9 @@ void __init free_area_init(unsigned long
 
 			/* Allocator not initialized yet */
 			pgdat = arch_alloc_nodedata(nid);
-			if (!pgdat) {
-				pr_err("Cannot allocate %zuB for node %d.\n",
-						sizeof(*pgdat), nid);
-				continue;
-			}
+			if (!pgdat)
+				panic("Cannot allocate %zuB for node %d.\n",
+				       sizeof(*pgdat), nid);
 			arch_refresh_nodedata(nid, pgdat);
 			free_area_init_memoryless_node(nid);
 
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


