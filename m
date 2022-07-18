Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ACFAC43334
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 22:50:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233561AbiGRWuP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 18 Jul 2022 18:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbiGRWuN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 18 Jul 2022 18:50:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37C1D1FCE6
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 15:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD077B817B1
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 22:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 854F6C341C0;
        Mon, 18 Jul 2022 22:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658184610;
        bh=pljMQNTU7ajUHW3Eq6UX3Sa06T5++tjSyra9uYjeER4=;
        h=Date:To:From:Subject:From;
        b=zyTCFs/P9k7OW2Jtv/gx3opb8gL8O0NEP1y9T4eRJi0+O1qdtZlPuKf7dD07irGM+
         vmMjnUDtRyNKqehkahBRdvVmVykUfe9q+F6DDxlcK6o0vLUN9RaYb0xfKfbmriTUK4
         3AGlryAj+ddtvLMGWg4NGAg7Nemo9hu2/uKvt+Zg=
Date:   Mon, 18 Jul 2022 15:50:09 -0700
To:     mm-commits@vger.kernel.org, mark-pk.tsai@mediatek.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-correct-the-wrong-cpuset-file-path-in-comment.patch added to mm-unstable branch
Message-Id: <20220718225010.854F6C341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: correct the wrong cpuset file path in comment
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-correct-the-wrong-cpuset-file-path-in-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-correct-the-wrong-cpuset-file-path-in-comment.patch

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
From: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Subject: mm/page_alloc: correct the wrong cpuset file path in comment
Date: Mon, 18 Jul 2022 20:03:35 +0800

cpuset.c was moved to kernel/cgroup/ in below commit
201af4c0fab0 ("cgroup: move cgroup files under kernel/cgroup/")
Correct the wrong path in comment.

Link: https://lkml.kernel.org/r/20220718120336.5145-1-mark-pk.tsai@mediatek.com
Signed-off-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-correct-the-wrong-cpuset-file-path-in-comment
+++ a/mm/page_alloc.c
@@ -4170,7 +4170,7 @@ get_page_from_freelist(gfp_t gfp_mask, u
 retry:
 	/*
 	 * Scan zonelist, looking for a zone with enough free.
-	 * See also __cpuset_node_allowed() comment in kernel/cpuset.c.
+	 * See also __cpuset_node_allowed() comment in kernel/cgroup/cpuset.c.
 	 */
 	no_fallback = alloc_flags & ALLOC_NOFRAGMENT;
 	z = ac->preferred_zoneref;
_

Patches currently in -mm which might be from mark-pk.tsai@mediatek.com are

mm-page_alloc-correct-the-wrong-cpuset-file-path-in-comment.patch

