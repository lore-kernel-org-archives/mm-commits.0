Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7944AC433F5
	for <mm-commits@archiver.kernel.org>; Mon,  7 Mar 2022 03:41:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbiCGDmh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 6 Mar 2022 22:42:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbiCGDmg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 6 Mar 2022 22:42:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB69B4DF5A
        for <mm-commits@vger.kernel.org>; Sun,  6 Mar 2022 19:41:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99826B80F96
        for <mm-commits@vger.kernel.org>; Mon,  7 Mar 2022 03:41:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 256FFC340F4;
        Mon,  7 Mar 2022 03:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646624500;
        bh=UawcFB/ZSalHfMnNBv94eziqhjp7mzHtLicnykyzW1E=;
        h=Date:To:From:Subject:From;
        b=VmjlsauQKM7ZJTqk7OTMHpVy9TLK4t16BS+e3+scoxN5qWQSzPUaDiX52qhaZwYML
         M+qF9L3NqXeRZrpuAqaem2si+gyp+a0kngn68huMxpEagTNpqEHCjKCR/UR7aX7aUP
         Nu48k+BqQz+q2lt8D2QavLs+35NbkMDudp40Wzts=
Date:   Sun, 06 Mar 2022 19:41:39 -0800
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mkoutny@suse.com, mhocko@suse.com,
        ivan@cloudflare.com, hannes@cmpxchg.org, fhofmann@cloudflare.com,
        dqminh@cloudflare.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-sync-flush-only-if-periodic-flush-is-delayed-fix.patch added to -mm tree
Message-Id: <20220307034140.256FFC340F4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg-sync-flush-only-if-periodic-flush-is-delayed-fix
has been added to the -mm tree.  Its filename is
     memcg-sync-flush-only-if-periodic-flush-is-delayed-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memcg-sync-flush-only-if-periodic-flush-is-delayed-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memcg-sync-flush-only-if-periodic-flush-is-delayed-fix.patch

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
Subject: memcg-sync-flush-only-if-periodic-flush-is-delayed-fix

remove leftover rstat_flush_time, per Shakeel

Cc: Daniel Dao <dqminh@cloudflare.com>
Cc: Frank Hofmann <fhofmann@cloudflare.com>
Cc: Ivan Babrou <ivan@cloudflare.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~memcg-sync-flush-only-if-periodic-flush-is-delayed-fix
+++ a/mm/memcontrol.c
@@ -666,7 +666,7 @@ void mem_cgroup_flush_stats(void)
 
 void mem_cgroup_flush_stats_delayed(void)
 {
-	if (rstat_flush_time && time_after64(jiffies_64, flush_next_time))
+	if (time_after64(jiffies_64, flush_next_time))
 		mem_cgroup_flush_stats();
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

memcg-sync-flush-only-if-periodic-flush-is-delayed-fix.patch
remove-bdi_congested-and-wb_congested-and-related-functions-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-list_lru-replace-linear-array-with-xarray-fix.patch
mm-hwpoison-inject-support-injecting-hwpoison-to-free-page-fix.patch
mm-export-pageheadhuge-fix.patch
userfaultfd-provide-unmasked-address-on-page-fault-v3-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-handle-uninitialized-numa-nodes-gracefully-fix.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix.patch
proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
arch-x86-kernel-resourcec-needs-spinlockh.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch
kasan-improve-vmalloc-tests-fix-3-fix.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

