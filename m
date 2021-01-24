Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B80EC433E6
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 01:23:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4844722BE8
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 01:23:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbhAXBX2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 23 Jan 2021 20:23:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:47176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726459AbhAXBXW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 23 Jan 2021 20:23:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0360622D57;
        Sun, 24 Jan 2021 01:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611451338;
        bh=pVNwYMFBGdXkoGQqFDprnf8VfzolvmKLQPN3ApKkGtc=;
        h=Date:From:To:Subject:From;
        b=xGmz0ShOovXmku5Vhs4dgIgy8OMxjZphFGeyGLV0r3CYq3t1s/KpBO/cTiSl5tchi
         vuhAmPTtNiv+uF70+YIgW07iZYjXRm0e4eY3t5W55k0p0Z4Qku0g1Lt3eAo/frXZmf
         qikg44++eDtpHft+Or2wKLWDzujrm+5qa2QpMLPM=
Date:   Sat, 23 Jan 2021 17:22:17 -0800
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, guro@fb.com, hannes@cmpxchg.org,
        hughd@google.com, mhocko@kernel.org, mm-commits@vger.kernel.org,
        vbabka@suse.cz, vdavydov.dev@gmail.com, willy@infradead.org,
        yuzhao@google.com
Subject:  + mm-fold-__update_lru_size-into-its-sole-caller.patch
 added to -mm tree
Message-ID: <20210124012217.1GttjYrlb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/mm_inline.h: fold __update_lru_size() into its sole caller
has been added to the -mm tree.  Its filename is
     mm-fold-__update_lru_size-into-its-sole-caller.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-fold-__update_lru_size-into-its-sole-caller.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-fold-__update_lru_size-into-its-sole-caller.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: include/linux/mm_inline.h: fold __update_lru_size() into its sole caller

All other references to the function were removed after commit
a892cb6b977f ("mm/vmscan.c: use update_lru_size() in update_lru_sizes()").

Link: https://lore.kernel.org/linux-mm/20201207220949.830352-10-yuzhao@google.com/
Link: https://lkml.kernel.org/r/20210122220600.906146-10-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Reviewed-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/include/linux/mm_inline.h~mm-fold-__update_lru_size-into-its-sole-caller
+++ a/include/linux/mm_inline.h
@@ -24,7 +24,7 @@ static inline int page_is_file_lru(struc
 	return !PageSwapBacked(page);
 }
 
-static __always_inline void __update_lru_size(struct lruvec *lruvec,
+static __always_inline void update_lru_size(struct lruvec *lruvec,
 				enum lru_list lru, enum zone_type zid,
 				int nr_pages)
 {
@@ -33,13 +33,6 @@ static __always_inline void __update_lru
 	__mod_lruvec_state(lruvec, NR_LRU_BASE + lru, nr_pages);
 	__mod_zone_page_state(&pgdat->node_zones[zid],
 				NR_ZONE_LRU_BASE + lru, nr_pages);
-}
-
-static __always_inline void update_lru_size(struct lruvec *lruvec,
-				enum lru_list lru, enum zone_type zid,
-				int nr_pages)
-{
-	__update_lru_size(lruvec, lru, zid, nr_pages);
 #ifdef CONFIG_MEMCG
 	mem_cgroup_update_lru_size(lruvec, lru, zid, nr_pages);
 #endif
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-swap-dont-setpageworkingset-unconditionally-during-swapin.patch
mm-use-add_page_to_lru_list.patch
mm-shuffle-lru-list-addition-and-deletion-functions.patch
mm-dont-pass-enum-lru_list-to-lru-list-addition-functions.patch
mm-dont-pass-enum-lru_list-to-trace_mm_lru_insertion.patch
mm-dont-pass-enum-lru_list-to-del_page_from_lru_list.patch
mm-add-__clear_page_lru_flags-to-replace-page_off_lru.patch
mm-vm_bug_on-lru-page-flags.patch
mm-fold-page_lru_base_type-into-its-sole-caller.patch
mm-fold-__update_lru_size-into-its-sole-caller.patch
mm-make-lruvec_lru_size-static.patch

