Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D44DC61DA4
	for <mm-commits@archiver.kernel.org>; Thu,  9 Feb 2023 23:51:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbjBIXvT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 18:51:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjBIXvS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 18:51:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E7FD392BC
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 15:51:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 060A661BAC
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 23:51:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 571A5C433D2;
        Thu,  9 Feb 2023 23:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675986676;
        bh=nGGsaCr4I8+s5e5vLcKOf91iTuWu9sDBeykKAqEv0Os=;
        h=Date:To:From:Subject:From;
        b=jcFwT3NuOOh3YadFA2q3DO0pyyAlc2EAUEqOtLK5uEhC4pK9V1c1UKFH/tb2qg5T5
         Y3Gd2YZ1g/fF3ctZyfrc25XCK3TlLIYV2k15AlvLI04NeYaBpCynZYe0++yRD5Jm+W
         a9b2872IE08m3DagXCVk74/k3vT5xUi5UeQaX8Gk=
Date:   Thu, 09 Feb 2023 15:51:15 -0800
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        songmuchun@bytedance.com, roman.gushchin@linux.dev,
        kent.overstreet@gmail.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-shrinkers-fix-deadlock-in-shrinker-debugfs-fix.patch removed from -mm tree
Message-Id: <20230209235116.571A5C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-shrinkers-fix-deadlock-in-shrinker-debugfs-fix
has been removed from the -mm tree.  Its filename was
     mm-shrinkers-fix-deadlock-in-shrinker-debugfs-fix.patch

This patch was dropped because it was folded into mm-shrinkers-fix-deadlock-in-shrinker-debugfs.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-shrinkers-fix-deadlock-in-shrinker-debugfs-fix
Date: Thu Feb  2 04:31:34 PM PST 2023

fix CONFIG_SHRINKER_DEBUG=n stub

Cc: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/shrinker.h~mm-shrinkers-fix-deadlock-in-shrinker-debugfs-fix
+++ a/include/linux/shrinker.h
@@ -117,6 +117,7 @@ static inline int shrinker_debugfs_add(s
 }
 static inline struct dentry *shrinker_debugfs_remove(struct shrinker *shrinker)
 {
+	return NULL;
 }
 static inline __printf(2, 3)
 int shrinker_debugfs_rename(struct shrinker *shrinker, const char *fmt, ...)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shrinkers-fix-deadlock-in-shrinker-debugfs.patch
mm-replace-vma-vm_flags-direct-modifications-with-modifier-calls-fix.patch
kasan-infer-allocation-size-by-scanning-metadata-fix.patch
shmem-add-shmem_read_folio-and-shmem_read_folio_gfp-fix.patch
lib-stackdepot-mm-rename-stack_depot_want_early_init-fix.patch
lib-stackdepot-annotate-racy-slab_index-accesses-fix.patch

