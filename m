Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7870C001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234730AbjHKXAK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236964AbjHKW7h (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:59:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EC793A8D
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:59:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D93065772
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:59:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 787B9C433C8;
        Fri, 11 Aug 2023 22:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794763;
        bh=W2MqqiAN7zP2UCmy2nKpjr+bufWIHSoseopC5EMKuwc=;
        h=Date:To:From:Subject:From;
        b=P2hRr/931K7GFEPMM4XbzdvG/4Eamqgg8xBWLISZ+jkHIcrIVL+KCE5cad5a43q+O
         2FgbFjwNMLrIkzlSbh0LFJB8LGFo/NnArrQfcHzBgGdB3SYVFFy81bNAA7bH0Tlp1U
         yVVtsqYvFWcVHjNkG+bxvpgE5XGOgp0q5Ix4wMGo=
Date:   Fri, 11 Aug 2023 15:59:22 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        matthias.bgg@gmail.com, brauner@kernel.org,
        angelogioacchino.delregno@collabora.com, andrew.yang@mediatek.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-drop_caches-draining-pages-before-dropping-caches.patch removed from -mm tree
Message-Id: <20230811225923.787B9C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fs: drop_caches: draining pages before dropping caches
has been removed from the -mm tree.  Its filename was
     fs-drop_caches-draining-pages-before-dropping-caches.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Yang <andrew.yang@mediatek.com>
Subject: fs: drop_caches: draining pages before dropping caches
Date: Fri, 30 Jun 2023 17:22:02 +0800

We expect a file page access after dropping caches should be a major
fault, but sometimes it's still a minor fault.  That's because a file page
can't be dropped if it's in a per-cpu pagevec.  Draining all pages from
per-cpu pagevec to lru list before trying to drop caches.

Link: https://lkml.kernel.org/r/20230630092203.16080-1-andrew.yang@mediatek.com
Signed-off-by: Andrew Yang <andrew.yang@mediatek.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/drop_caches.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/drop_caches.c~fs-drop_caches-draining-pages-before-dropping-caches
+++ a/fs/drop_caches.c
@@ -10,6 +10,7 @@
 #include <linux/writeback.h>
 #include <linux/sysctl.h>
 #include <linux/gfp.h>
+#include <linux/swap.h>
 #include "internal.h"
 
 /* A global variable is a bit ugly, but it keeps the code simple */
@@ -59,6 +60,7 @@ int drop_caches_sysctl_handler(struct ct
 		static int stfu;
 
 		if (sysctl_drop_caches & 1) {
+			lru_add_drain_all();
 			iterate_supers(drop_pagecache_sb, NULL);
 			count_vm_event(DROP_PAGECACHE);
 		}
_

Patches currently in -mm which might be from andrew.yang@mediatek.com are


