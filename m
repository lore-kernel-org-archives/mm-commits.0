Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC5ECC433E6
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 19:09:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75F24601FB
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 19:09:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235327AbhBXTJD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 14:09:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:39682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235931AbhBXTIw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 14:08:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B25964DA1;
        Wed, 24 Feb 2021 19:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614193224;
        bh=MUybmIZtpBPllUr+0LDFBmEQXp4WRzXDzldXjvn2zVQ=;
        h=Date:From:To:Subject:From;
        b=xcrQEH6Sztni0vwVfJhDyozUBs5A0q06/SGU34d53K+eKXSOC/537zQfEEHaEu5bM
         Ubg7tAIjobG0uU33wJ5YsZePMEMqSEgtrYhW9h6UthZdNU0CJnGdj2ZM2I6CClOHwd
         rOL2ghjVS9XYYN01DV+/jjyADIWPLntxZve40+Mw=
Date:   Wed, 24 Feb 2021 11:00:23 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, rdunlap@infradead.org,
        shakeelb@google.com, shy828301@gmail.com, songmuchun@bytedance.com
Subject:  [folded-merged]
 mm-memcg-add-swapcache-stat-for-memcg-v2-fix.patch removed from -mm tree
Message-ID: <20210224190023.05a7mGv4T%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcg-add-swapcache-stat-for-memcg-v2-fix
has been removed from the -mm tree.  Its filename was
     mm-memcg-add-swapcache-stat-for-memcg-v2-fix.patch

This patch was dropped because it was folded into mm-memcg-add-swapcache-stat-for-memcg-v2.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memcg-add-swapcache-stat-for-memcg-v2-fix

fix CONFIG_SWAP=n build

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 ++
 mm/migrate.c    |    2 ++
 2 files changed, 4 insertions(+)

--- a/mm/memcontrol.c~mm-memcg-add-swapcache-stat-for-memcg-v2-fix
+++ a/mm/memcontrol.c
@@ -1521,7 +1521,9 @@ static const struct memory_stat memory_s
 	{ "file_mapped",		NR_FILE_MAPPED			},
 	{ "file_dirty",			NR_FILE_DIRTY			},
 	{ "file_writeback",		NR_WRITEBACK			},
+#ifdef CONFIG_SWAP
 	{ "swapcached",			NR_SWAPCACHE			},
+#endif
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	{ "anon_thp",			NR_ANON_THPS			},
 	{ "file_thp",			NR_FILE_THPS			},
--- a/mm/migrate.c~mm-memcg-add-swapcache-stat-for-memcg-v2-fix
+++ a/mm/migrate.c
@@ -500,10 +500,12 @@ int migrate_page_move_mapping(struct add
 			__mod_lruvec_state(old_lruvec, NR_SHMEM, -nr);
 			__mod_lruvec_state(new_lruvec, NR_SHMEM, nr);
 		}
+#ifdef CONFIG_SWAP
 		if (PageSwapCache(page)) {
 			__mod_lruvec_state(old_lruvec, NR_SWAPCACHE, -nr);
 			__mod_lruvec_state(new_lruvec, NR_SWAPCACHE, nr);
 		}
+#endif
 		if (dirty && mapping_can_writeback(mapping)) {
 			__mod_lruvec_state(old_lruvec, NR_FILE_DIRTY, -nr);
 			__mod_zone_page_state(oldzone, NR_ZONE_WRITE_PENDING, -nr);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memcg-add-swapcache-stat-for-memcg-v2.patch
kasan-add-match-all-tag-tests-fix-fix.patch
mm.patch
mm-cma-allocate-cma-areas-bottom-up-fix-3-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
mm-memory_hotplug-prevalidate-the-address-range-being-added-with-platform-fix.patch
bdi-use-might_alloc-fix.patch
kfence-kasan-make-kfence-compatible-with-kasan-fix.patch
lib-stackdepot-add-support-to-disable-stack-depot-fix.patch
seq_file-document-how-per-entry-resources-are-managed-fix.patch
initramfs-panic-with-memory-information-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

