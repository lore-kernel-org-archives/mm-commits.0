Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A609C433EF
	for <mm-commits@archiver.kernel.org>; Sun,  3 Jul 2022 23:59:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbiGCX7u (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 19:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbiGCX7t (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 19:59:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D5711168
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 16:59:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0A8161261
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 23:59:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CF52C341C6;
        Sun,  3 Jul 2022 23:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656892787;
        bh=A+902srRGOmU7la1uQB3hCwdQSe0HeckCRG9zw4tWsg=;
        h=Date:To:From:Subject:From;
        b=yxUQ+PVncCrP6hfHAPJuKJUNiaBtL+VVHRzCSBv15x3pFZoOX06XFCc3pvSu7WSKn
         6HJtm7hJJhnJaNAnyqlKW2yvU2Xt2PABAj0iTrQcE4viRNIglLAZtVm3kT2bgKxzPm
         ozJWBugl2Waeldkbs6uSG5mk37WAT0lDqYfaUGcE=
Date:   Sun, 03 Jul 2022 16:59:46 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        roman.gushchin@linux.dev, kent.overstreet@gmail.com,
        hdanton@sina.com, dchinner@redhat.com,
        christophe.jaillet@wanadoo.fr, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-shrinkers-introduce-debugfs-interface-for-memory-shrinkers-fix.patch removed from -mm tree
Message-Id: <20220703235947.1CF52C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-shrinkers-introduce-debugfs-interface-for-memory-shrinkers-fix
has been removed from the -mm tree.  Its filename was
     mm-shrinkers-introduce-debugfs-interface-for-memory-shrinkers-fix.patch

This patch was dropped because it was folded into mm-shrinkers-introduce-debugfs-interface-for-memory-shrinkers.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-shrinkers-introduce-debugfs-interface-for-memory-shrinkers-fix
Date: Mon Jun  6 05:46:42 PM PDT 2022

remove WARN_ON_ONCE(), per Roman

Reported-by: syzbot+300d27c79fe6d4cbcc39@syzkaller.appspotmail.com
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-shrinkers-introduce-debugfs-interface-for-memory-shrinkers-fix
+++ a/mm/vmscan.c
@@ -650,7 +650,7 @@ void register_shrinker_prepared(struct s
 	down_write(&shrinker_rwsem);
 	list_add_tail(&shrinker->list, &shrinker_list);
 	shrinker->flags |= SHRINKER_REGISTERED;
-	WARN_ON_ONCE(shrinker_debugfs_add(shrinker));
+	shrinker_debugfs_add(shrinker);
 	up_write(&shrinker_rwsem);
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shrinkers-introduce-debugfs-interface-for-memory-shrinkers.patch
mm-shrinkers-add-scan-interface-for-shrinker-debugfs-fix-fix.patch
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

