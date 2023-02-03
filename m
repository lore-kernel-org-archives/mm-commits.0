Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DB8BC636D3
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 00:32:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232020AbjBCAcT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Feb 2023 19:32:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232240AbjBCAcQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Feb 2023 19:32:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D2AF233D8
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 16:32:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A92BB828DE
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 00:32:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A91C9C4339B;
        Fri,  3 Feb 2023 00:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675384332;
        bh=ZmSBeHgcJoWaK4PzDetjsiEl79iVMrJgNRh15HSH+zA=;
        h=Date:To:From:Subject:From;
        b=2OMe48LfFnan8nUQRyAqDlxZ/pIVIClWxQDt/9vKknIkTDbyw6GtLNFk3ZRocOePQ
         6jOXMieO7sfgoTgkmyUO/s6gIHPKce/e8Bt4OmZ60kcpsyodqW5cTSwvbdPCasL6Gn
         L6mpi1pPjpNa+XDPfX5KgHxfmjAx5Nj/sE9LOJhs=
Date:   Thu, 02 Feb 2023 16:32:12 -0800
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        songmuchun@bytedance.com, roman.gushchin@linux.dev,
        kent.overstreet@gmail.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shrinkers-fix-deadlock-in-shrinker-debugfs-fix.patch added to mm-unstable branch
Message-Id: <20230203003212.A91C9C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-shrinkers-fix-deadlock-in-shrinker-debugfs-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shrinkers-fix-deadlock-in-shrinker-debugfs-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shrinkers-fix-deadlock-in-shrinker-debugfs-fix.patch

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

fsdax-dax_unshare_iter-should-return-a-valid-length-fix.patch
mm-add-folio_add_new_anon_rmap-fix.patch
mm-remove-page_evictable-fix.patch
mm-remove-the-swap_readpage-return-value-fix.patch
block-remove-rw_page-fix.patch
mm-add-memcpy_from_file_folio-fix.patch
mm-replace-vma-vm_flags-direct-modifications-with-modifier-calls-fix.patch
kasan-infer-allocation-size-by-scanning-metadata-fix.patch
mm-shrinkers-fix-deadlock-in-shrinker-debugfs-fix.patch
error-injection-remove-ei_etype_none-fix.patch
hfsplus-remove-unnecessary-variable-initialization-fix.patch
scripts-gdb-add-mm-introspection-utils-fix.patch
lib-stackdepot-mm-rename-stack_depot_want_early_init-fix.patch
lib-stackdepot-annotate-racy-slab_index-accesses-fix.patch

