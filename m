Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC546C4167B
	for <mm-commits@archiver.kernel.org>; Wed, 29 Nov 2023 21:54:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234591AbjK2VyP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 29 Nov 2023 16:54:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234607AbjK2VyO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Nov 2023 16:54:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA396B6
        for <mm-commits@vger.kernel.org>; Wed, 29 Nov 2023 13:54:10 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71393C433C7;
        Wed, 29 Nov 2023 21:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701294850;
        bh=rBaSJKWEOfTY8eLpAiarCTk/IS73K64ZPwwuZyg7y/s=;
        h=Date:To:From:Subject:From;
        b=dAN+QEttP51UGcWDF75kV55uuVhuKxjr1G/Yx5Elp19BI9tBk+qcMA9Kh2ccYIB8z
         0QOUVpeQuApvmy5wl4PC9yo/wEvFOH9+ySYnMbzWvNmlzs3V+/jEyLe1NYFsp6PROt
         Ads3BLzjNWKPUfZYKiZ8uyP6QlWdLNZ7In5aRH9Q=
Date:   Wed, 29 Nov 2023 13:54:09 -0800
To:     mm-commits@vger.kernel.org, nphamcs@gmail.com,
        cerasuolodomenico@gmail.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zswap-make-shrinking-memcg-aware-fix.patch added to mm-unstable branch
Message-Id: <20231129215410.71393C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zswap-make-shrinking-memcg-aware-fix
has been added to the -mm mm-unstable branch.  Its filename is
     zswap-make-shrinking-memcg-aware-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zswap-make-shrinking-memcg-aware-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: zswap-make-shrinking-memcg-aware-fix
Date: Wed Nov 29 01:50:40 PM PST 2023

temp build fixes

Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    5 +++++
 mm/zswap.c                 |    3 +++
 2 files changed, 8 insertions(+)

--- a/include/linux/memcontrol.h~zswap-make-shrinking-memcg-aware-fix
+++ a/include/linux/memcontrol.h
@@ -1165,6 +1165,11 @@ unsigned long mem_cgroup_soft_limit_recl
 
 #define MEM_CGROUP_ID_SHIFT	0
 
+static inline struct mem_cgroup *obj_cgroup_memcg(struct obj_cgroup *objcg)
+{
+	return NULL;
+}
+
 static inline struct mem_cgroup *folio_memcg(struct folio *folio)
 {
 	return NULL;
--- a/mm/zswap.c~zswap-make-shrinking-memcg-aware-fix
+++ a/mm/zswap.c
@@ -32,6 +32,7 @@
 #include <linux/mm_types.h>
 #include <linux/page-flags.h>
 #include <linux/swapops.h>
+#include <linux/memcontrol.h>
 #include <linux/writeback.h>
 #include <linux/pagemap.h>
 #include <linux/workqueue.h>
@@ -822,7 +823,9 @@ static void shrink_worker(struct work_st
 		 * Acquire an extra reference to the iterated memcg in case the
 		 * original reference is dropped by the zswap offlining callback.
 		 */
+#ifdef CONFIG_MEMCG
 		css_get(&memcg->css);
+#endif
 		spin_unlock(&zswap_pools_lock);
 
 		ret = shrink_memcg(memcg);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maintainers-add-andrew-morton-for-lib.patch
mm-memoryc-zap_pte_range-print-bad-swap-entry.patch
mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mm-add-folio_zero_tail-and-use-it-in-ext4-fix.patch
mm-add-folio_fill_tail-and-use-it-in-iomap-fix.patch
zswap-make-shrinking-memcg-aware-fix.patch
kernel-reboot-explicitly-notify-if-halt-occurred-instead-of-power-off-fix.patch

