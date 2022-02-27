Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C59C5C433F5
	for <mm-commits@archiver.kernel.org>; Sun, 27 Feb 2022 22:00:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbiB0WB1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 27 Feb 2022 17:01:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230458AbiB0WB0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 27 Feb 2022 17:01:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77FA06C1E7
        for <mm-commits@vger.kernel.org>; Sun, 27 Feb 2022 14:00:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1067D61198
        for <mm-commits@vger.kernel.org>; Sun, 27 Feb 2022 22:00:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD74C340F0;
        Sun, 27 Feb 2022 22:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645999248;
        bh=5lVkDhjlVvJ4P8voQR59KMTDdZJy46JPyb7PK6XZZWU=;
        h=Date:To:From:Subject:From;
        b=peadiMPZRO2eAm/v7tbSYMHcuobCSjhDUiG9d2Lq/21uGw6y1zwI50pRdWVMJ7aVm
         Kfi8ubY5eDI2erILh+lQ8AN5JbrmmmOZHoEzHHn8Saj0sQObNcbNxy52qUmn0MCTK1
         43iJbpOgU4Mv6IIFVH3tCovy/blACMp82q0t8jtc=
Date:   Sun, 27 Feb 2022 14:00:47 -0800
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org,
        caoyixuan2019@email.szu.edu.cn, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmallocc-fix-a-comment-fix.patch added to -mm tree
Message-Id: <20220227220048.6DD74C340F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmallocc-fix-a-comment-fix
has been added to the -mm tree.  Its filename is
     mm-vmallocc-fix-a-comment-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmallocc-fix-a-comment-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmallocc-fix-a-comment-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmallocc-fix-a-comment-fix

a/want/wants/, per Randy

Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmallocc-fix-a-comment-fix
+++ a/mm/vmalloc.c
@@ -2886,7 +2886,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 			/* memory allocation should consider mempolicy, we can't
 			 * wrongly use nearest node when nid == NUMA_NO_NODE,
 			 * otherwise memory may be allocated in only one node,
-			 * but mempolicy want to alloc memory by interleaving.
+			 * but mempolicy wants to alloc memory by interleaving.
 			 */
 			if (IS_ENABLED(CONFIG_NUMA) && nid == NUMA_NO_NODE)
 				nr = alloc_pages_bulk_array_mempolicy(bulk_gfp,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

remove-bdi_congested-and-wb_congested-and-related-functions-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
x86-mm-enable-arch_has_vm_get_page_prot-fix.patch
mm-vmallocc-fix-a-comment-fix.patch
mm-hwpoison-inject-support-injecting-hwpoison-to-free-page-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-handle-uninitialized-numa-nodes-gracefully-fix.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix.patch
proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
drivers-gpu-drm-dp-drm_dpc-fix-build.patch
kasan-improve-vmalloc-tests-fix-3-fix.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

