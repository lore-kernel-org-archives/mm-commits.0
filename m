Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65CA6C43334
	for <mm-commits@archiver.kernel.org>; Thu,  2 Jun 2022 18:42:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238243AbiFBSmW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Jun 2022 14:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238244AbiFBSmT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jun 2022 14:42:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97590A471
        for <mm-commits@vger.kernel.org>; Thu,  2 Jun 2022 11:42:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E5FCB807E7
        for <mm-commits@vger.kernel.org>; Thu,  2 Jun 2022 18:42:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 085EDC385A5;
        Thu,  2 Jun 2022 18:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654195336;
        bh=OunK5HIRjFyOxgjxB9rq3d5NephWH2EqPDU0JhVJllE=;
        h=Date:To:From:Subject:From;
        b=Pspip1fxgqRfJ0FP5hFJBP4NZJK2YG2tKwXMVkwpfrylm0gTTGpDzWzwQuTKZcClu
         MLod7S3t25WhxPOBkX1d5p8YaSNQNN1mrFpVUhADzEzfnnp0xwI9/bUp1fUL4j9WJC
         G48dMopnQkmpssYxWZsE0ob+f1CYTg/t8ModcdmQ=
Date:   Thu, 02 Jun 2022 11:42:13 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        roman.gushchin@linux.dev, kent.overstreet@gmail.com,
        hdanton@sina.com, dchinner@redhat.com,
        christophe.jaillet@wanadoo.fr, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shrinkers-add-scan-interface-for-shrinker-debugfs-fix-fix.patch added to mm-unstable branch
Message-Id: <20220602184216.085EDC385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-shrinkers-add-scan-interface-for-shrinker-debugfs-fix-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shrinkers-add-scan-interface-for-shrinker-debugfs-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shrinkers-add-scan-interface-for-shrinker-debugfs-fix-fix.patch

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

mm-page_alloc-remotely-drain-per-cpu-lists-checkpatch-fixes.patch
mm-start-tracking-vmas-with-maple-tree-fix.patch
damon-convert-__damon_va_three_regions-to-use-the-vma-iterator-fix.patch
mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix-checkpatch-fixes.patch
mm-remove-the-vma-linked-list-fix-fix.patch
mm-handling-non-lru-pages-returned-by-vm_normal_pages-fix.patch
mm-introduce-clear_highpage_tagged-fix.patch
kasan-fix-zeroing-vmalloc-memory-with-hw_tags-fix.patch
mm-shrinkers-add-scan-interface-for-shrinker-debugfs-fix-fix.patch
mm-drop-oom-code-from-exit_mmap-fix.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
squashfs-implement-readahead-checkpatch-fixes.patch

