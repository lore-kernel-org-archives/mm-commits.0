Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E968C43334
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 00:00:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbiGDAAz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 20:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbiGDAAx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 20:00:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2299960D4
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 17:00:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5C2A61280
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 00:00:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 150C2C341CA;
        Mon,  4 Jul 2022 00:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656892852;
        bh=MHMwHzAiM+A6me16z9UE7EmOzJv7HmKyyUQJcNj7yRI=;
        h=Date:To:From:Subject:From;
        b=jHgOfhTz/FhtDjMpNLKcQ/ANGn7QHW2kdp7XYRUhMu1yt1wm8iAdg3rUGB08OZwa2
         xUXT6ofsrxlXiN1R5Ll0zhqZVCUlqVtAQypQFhCE50lBrkJ45qSXmpaPgXHIHrUBY2
         JvvColSpVH0h5rpI/c/zlrUeANv3Mw3huQVvSCnc=
Date:   Sun, 03 Jul 2022 17:00:51 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        roman.gushchin@linux.dev, kent.overstreet@gmail.com,
        hdanton@sina.com, dchinner@redhat.com,
        christophe.jaillet@wanadoo.fr, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-shrinkers-add-scan-interface-for-shrinker-debugfs-fix-fix.patch removed from -mm tree
Message-Id: <20220704000052.150C2C341CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-shrinkers-add-scan-interface-for-shrinker-debugfs-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-shrinkers-add-scan-interface-for-shrinker-debugfs-fix-fix.patch

This patch was dropped because it was folded into mm-shrinkers-add-scan-interface-for-shrinker-debugfs.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-shrinkers-add-scan-interface-for-shrinker-debugfs-fix-fix
Date: Thu Jun  2 11:41:39 AM PDT 2022

fix arg count checking

Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shrinker_debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shrinker_debug.c~mm-shrinkers-add-scan-interface-for-shrinker-debugfs-fix-fix
+++ a/mm/shrinker_debug.c
@@ -124,7 +124,7 @@ static ssize_t shrinker_debugfs_scan_wri
 		return -EFAULT;
 	kbuf[read_len] = '\0';
 
-	if (sscanf(kbuf, "%lu %d %lu", &ino, &nid, &nr_to_scan) != 2)
+	if (sscanf(kbuf, "%lu %d %lu", &ino, &nid, &nr_to_scan) != 3)
 		return -EINVAL;
 
 	if (nid < 0 || nid >= nr_node_ids)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shrinkers-add-scan-interface-for-shrinker-debugfs.patch
mm-convert-destroy_compound_page-to-destroy_large_folio-fix.patch
mm-madvise-minor-cleanup-for-swapin_walk_pmd_entry-fix.patch
mm-docs-fix-comments-that-mention-mem_hotplug_end-fix.patch
android-binder-stop-saving-a-pointer-to-the-vma-fix.patch
mm-remove-the-vma-linked-list-fix-2-fix.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
mm-add-merging-after-mremap-resize-checkpatch-fixes.patch
mm-handling-non-lru-pages-returned-by-vm_normal_pages-fix.patch
mm-factor-helpers-for-memory_failure_dev_pagemap-fix.patch
xfs-support-cow-in-fsdax-mode-fix.patch
mm-thp-kill-transparent_hugepage_active-fix.patch
mm-thp-kill-transparent_hugepage_active-fix-fix.patch
x86-mm-move-protection_map-inside-the-platform-fix.patch

