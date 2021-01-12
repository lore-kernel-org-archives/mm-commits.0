Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EC64C43381
	for <mm-commits@archiver.kernel.org>; Tue, 12 Jan 2021 21:51:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05CE920720
	for <mm-commits@archiver.kernel.org>; Tue, 12 Jan 2021 21:51:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725858AbhALVvO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Jan 2021 16:51:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:45502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393556AbhALVvL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 12 Jan 2021 16:51:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B682E23122;
        Tue, 12 Jan 2021 21:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610488229;
        bh=/kGl8837vIMgLysMWNdQLcZTYqyb3hkguRFMlOpvsAc=;
        h=Date:From:To:Subject:From;
        b=VZlEg4vGF6DWvcJToKqnkiMultWiu8vRzKAvSwPoohOtPQs5zRdr5i1PtMImHQ6tO
         I0jmpL2LhIhfwbMmW/qIphBcjhBnQ6DcukVfxqfj6cHLLFbYch8Ksmzz8ZN4jU639c
         kDgkL+gTdE1hA+XG5wM9DVuDEg1JT/xlIokOaANA=
Date:   Tue, 12 Jan 2021 13:50:20 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, rdunlap@infradead.org,
        shakeelb@google.com, shy828301@gmail.com, songmuchun@bytedance.com
Subject:  + mm-memcg-add-swapcache-stat-for-memcg-v2-fix.patch
 added to -mm tree
Message-ID: <20210112215020.1Tk9Ww4lZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcg-add-swapcache-stat-for-memcg-v2-fix
has been added to the -mm tree.  Its filename is
     mm-memcg-add-swapcache-stat-for-memcg-v2-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-add-swapcache-stat-for-memcg-v2-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-add-swapcache-stat-for-memcg-v2-fix.patch

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

mm-page_alloc-add-a-missing-mm_page_alloc_zone_locked-tracepoint-fix.patch
mm-process_vm_accessc-include-compath.patch
mm.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account-fix.patch
mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage-checkpatch-fixes.patch
mm-memcg-add-swapcache-stat-for-memcg-v2-fix.patch
kasan-fix-bug-detection-via-ksize-for-hw_tags-mode-fix.patch
mm-cma-allocate-cma-areas-bottom-up-fix-3-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
kfence-kasan-make-kfence-compatible-with-kasan-fix.patch
linux-next-git-rejects.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

