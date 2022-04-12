Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58BDCC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 12 Apr 2022 04:20:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344701AbiDLEWO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Apr 2022 00:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245601AbiDLEWM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 12 Apr 2022 00:22:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BBB426120
        for <mm-commits@vger.kernel.org>; Mon, 11 Apr 2022 21:19:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0FC53B81B16
        for <mm-commits@vger.kernel.org>; Tue, 12 Apr 2022 04:19:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 979E8C385A6;
        Tue, 12 Apr 2022 04:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649737192;
        bh=PwzTZWa9SRqCUw9fyxp0Ajy7aZ8Ez5x20Ygp4YNCGZk=;
        h=Date:To:From:Subject:From;
        b=lynnMK7uvGZaYTId1RINs58RD4DbuIGZOoYNdw+VEFVar82rKJFSSofgBL7rlzGry
         zK1uGyuJtJvucbhHrNTRmN6QAKhierNMDg1u3zr1zLsIUOynmAi8cd3Aev9EDLG/CX
         kneH8racDCMCj7TQfELfoGjI4kypunCPvqk+YNNs=
Date:   Mon, 11 Apr 2022 21:19:49 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, vaibhav@linux.ibm.com,
        szhai2@cs.rochester.edu, suleiman@google.com, steven@liquorix.net,
        sofia.trinh@edi.works, shy828301@gmail.com,
        oleksandr@natalenko.name, mgorman@techsingularity.net,
        holger@applied-asynchrony.com, Hi-Angel@yandex.ru,
        heftig@archlinux.org, hannes@cmpxchg.org, djbyrne@mtu.edu,
        d@chaos-reins.com, bgeffon@google.com, baohua@kernel.org,
        yuzhao@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-include-linux-mm_inlineh-fold-__update_lru_size-into-its-sole-caller.patch added to -mm tree
Message-Id: <20220412041952.979E8C385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "include/linux/mm_inline.h: fold __update_lru_size() into its sole caller"
has been added to the -mm tree.  Its filename is
     revert-include-linux-mm_inlineh-fold-__update_lru_size-into-its-sole-caller.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/revert-include-linux-mm_inlineh-fold-__update_lru_size-into-its-sole-caller.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/revert-include-linux-mm_inlineh-fold-__update_lru_size-into-its-sole-caller.patch

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
Subject: Revert "include/linux/mm_inline.h: fold __update_lru_size() into its sole caller"

This patch undoes the following refactor: commit 289ccba18af4
("include/linux/mm_inline.h: fold __update_lru_size() into its sole
caller")

The upcoming changes to include/linux/mm_inline.h will reuse
__update_lru_size().

Link: https://lkml.kernel.org/r/20220407031525.2368067-5-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Acked-by: Brian Geffon <bgeffon@google.com>
Acked-by: Jan Alexander Steffens (heftig) <heftig@archlinux.org>
Acked-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Acked-by: Steven Barrett <steven@liquorix.net>
Acked-by: Suleiman Souhlal <suleiman@google.com>
Tested-by: Daniel Byrne <djbyrne@mtu.edu>
Tested-by: Donald Carr <d@chaos-reins.com>
Tested-by: Holger Hoffstätte <holger@applied-asynchrony.com>
Tested-by: Konstantin Kharlamov <Hi-Angel@yandex.ru>
Tested-by: Shuang Zhai <szhai2@cs.rochester.edu>
Tested-by: Sofia Trinh <sofia.trinh@edi.works>
Tested-by: Vaibhav Jain <vaibhav@linux.ibm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/mm_inline.h~revert-include-linux-mm_inlineh-fold-__update_lru_size-into-its-sole-caller
+++ a/include/linux/mm_inline.h
@@ -34,7 +34,7 @@ static inline int page_is_file_lru(struc
 	return folio_is_file_lru(page_folio(page));
 }
 
-static __always_inline void update_lru_size(struct lruvec *lruvec,
+static __always_inline void __update_lru_size(struct lruvec *lruvec,
 				enum lru_list lru, enum zone_type zid,
 				long nr_pages)
 {
@@ -43,6 +43,13 @@ static __always_inline void update_lru_s
 	__mod_lruvec_state(lruvec, NR_LRU_BASE + lru, nr_pages);
 	__mod_zone_page_state(&pgdat->node_zones[zid],
 				NR_ZONE_LRU_BASE + lru, nr_pages);
+}
+
+static __always_inline void update_lru_size(struct lruvec *lruvec,
+				enum lru_list lru, enum zone_type zid,
+				int nr_pages)
+{
+	__update_lru_size(lruvec, lru, zid, nr_pages);
 #ifdef CONFIG_MEMCG
 	mem_cgroup_update_lru_size(lruvec, lru, zid, nr_pages);
 #endif
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-x86-arm64-add-arch_has_hw_pte_young.patch
mm-x86-add-config_arch_has_nonleaf_pmd_young.patch
mm-vmscanc-refactor-shrink_node.patch
revert-include-linux-mm_inlineh-fold-__update_lru_size-into-its-sole-caller.patch
mm-multi-gen-lru-groundwork.patch
mm-multi-gen-lru-minimal-implementation.patch
mm-multi-gen-lru-exploit-locality-in-rmap.patch
mm-multi-gen-lru-support-page-table-walks.patch
mm-multi-gen-lru-optimize-multiple-memcgs.patch
mm-multi-gen-lru-kill-switch.patch
mm-multi-gen-lru-thrashing-prevention.patch
mm-multi-gen-lru-debugfs-interface.patch
mm-multi-gen-lru-admin-guide.patch
mm-multi-gen-lru-design-doc.patch

