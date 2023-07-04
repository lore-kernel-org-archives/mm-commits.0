Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB834EB64D9
	for <mm-commits@archiver.kernel.org>; Tue,  4 Jul 2023 18:07:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbjGDSHI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 Jul 2023 14:07:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbjGDSHH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 4 Jul 2023 14:07:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD4C10CA
        for <mm-commits@vger.kernel.org>; Tue,  4 Jul 2023 11:07:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A621B61346
        for <mm-commits@vger.kernel.org>; Tue,  4 Jul 2023 18:07:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE86CC433C7;
        Tue,  4 Jul 2023 18:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688494025;
        bh=NT1nNIf8NTxsiBRBiCZzA8ARTNMBbUY+hSLhsOlW5EE=;
        h=Date:To:From:Subject:From;
        b=siERK48NZEzcB4fdkfvXLKp1ChF0ue726IkiltScsdPV7IKy9QciF9vsRc2gpns16
         Pc7Fj+VlJvN8a9VLTxtIsQvvXxPBl+UvcxCMD4vYr5RKUjg0w7nlnuDkplV8vs0yPI
         JAzn7sI7Ehzi5W5Lf6wtx/o1b6aeChAXFu57XGo8=
Date:   Tue, 04 Jul 2023 11:07:04 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        matthias.bgg@gmail.com, brauner@kernel.org,
        angelogioacchino.delregno@collabora.com, andrew.yang@mediatek.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-drop_caches-draining-pages-before-dropping-caches.patch added to mm-unstable branch
Message-Id: <20230704180704.EE86CC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: drop_caches: draining pages before dropping caches
has been added to the -mm mm-unstable branch.  Its filename is
     fs-drop_caches-draining-pages-before-dropping-caches.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-drop_caches-draining-pages-before-dropping-caches.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

fs-drop_caches-draining-pages-before-dropping-caches.patch

