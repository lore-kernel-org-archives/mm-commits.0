Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A560C433DB
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 01:16:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08FDA64EDB
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 01:16:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232885AbhCDBQY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 20:16:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:40962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238363AbhCDBQJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Mar 2021 20:16:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3CC864F74;
        Thu,  4 Mar 2021 01:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614820529;
        bh=4AupjyWuH+ghxM2YgjVwv3SyLyQQQxPjhK7gsgw3xt0=;
        h=Date:From:To:Subject:From;
        b=ToSzOsHCBnX+qhGrUCnl9+j/l1KpAREjQH8XPrlzwQCPGZxJkygWIV8ejL+f+WLTU
         sbB3u5cvSCG77d5jDt6zUnH1+Jlw7boT7MoPj7HWq55cpUFYCTr0HiZwwO8eRkhaFD
         JwkJRZJzyMn+/p2rFBmCEcK61osepU3WHMBJYaaA=
Date:   Wed, 03 Mar 2021 17:15:28 -0800
From:   akpm@linux-foundation.org
To:     daizhiyuan@phytium.com.cn, mm-commits@vger.kernel.org
Subject:  + mm-mempolicy-minor-coding-style-tweaks.patch added to
 -mm tree
Message-ID: <20210304011528.ry_zB8DW9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy: minor coding style tweaks
has been added to the -mm tree.  Its filename is
     mm-mempolicy-minor-coding-style-tweaks.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-minor-coding-style-tweaks.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-minor-coding-style-tweaks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhiyuan Dai <daizhiyuan@phytium.com.cn>
Subject: mm/mempolicy: minor coding style tweaks

Add whitespace to fix coding style issues, improve code reading.

Link: https://lkml.kernel.org/r/1613972228-25501-1-git-send-email-daizhiyuan@phytium.com.cn
Signed-off-by: Zhiyuan Dai <daizhiyuan@phytium.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-minor-coding-style-tweaks
+++ a/mm/mempolicy.c
@@ -330,7 +330,7 @@ static void mpol_rebind_nodemask(struct
 	else if (pol->flags & MPOL_F_RELATIVE_NODES)
 		mpol_relative_nodemask(&tmp, &pol->w.user_nodemask, nodes);
 	else {
-		nodes_remap(tmp, pol->v.nodes,pol->w.cpuset_mems_allowed,
+		nodes_remap(tmp, pol->v.nodes, pol->w.cpuset_mems_allowed,
 								*nodes);
 		pol->w.cpuset_mems_allowed = *nodes;
 	}
@@ -1161,7 +1161,7 @@ int do_migrate_pages(struct mm_struct *m
 
 	tmp = *from;
 	while (!nodes_empty(tmp)) {
-		int s,d;
+		int s, d;
 		int source = NUMA_NO_NODE;
 		int dest = 0;
 
_

Patches currently in -mm which might be from daizhiyuan@phytium.com.cn are

mm-memremap-fixes-improper-spdx-comment-style.patch
mm-zswap-switch-from-strlcpy-to-strscpy.patch
mm-swapfile-minor-coding-style-tweaks.patch
mm-sparse-minor-coding-style-tweaks.patch
mm-vmscan-minor-coding-style-tweaks.patch
mm-compaction-minor-coding-style-tweaks.patch
mm-oom_kill-minor-coding-style-tweaks.patch
mm-shmem-minor-coding-style-tweaks.patch
mm-page_alloc-minor-coding-style-tweaks.patch
mm-filemap-minor-coding-style-tweaks.patch
mm-mlock-minor-coding-style-tweaks.patch
mm-frontswap-minor-coding-style-tweaks.patch
mm-vmalloc-minor-coding-style-tweaks.patch
mm-memory_hotplug-minor-coding-style-tweaks.patch
mm-mempolicy-minor-coding-style-tweaks.patch

