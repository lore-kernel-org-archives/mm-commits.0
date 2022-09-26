Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9513EC07E9D
	for <mm-commits@archiver.kernel.org>; Mon, 26 Sep 2022 20:57:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbiIZU5V (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 16:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231153AbiIZU5V (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 16:57:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12AD7A030E
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 13:57:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8730761372
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 20:57:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA0CEC433D6;
        Mon, 26 Sep 2022 20:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664225838;
        bh=sqEbbvfU6KYSgqvvnMXn7AR1jI+BhXeXcKmp5LBwJx0=;
        h=Date:To:From:Subject:From;
        b=SoMnXkiaqW2tGYAbHgJlb5g8T1DlXZ33fCVrlwVg6LDRcLuuh8DRdVjsSijDcQrwF
         AnAWz+0uo2MXUfYZGHlj5/hSxq+PzFx+0NkM00gVUU/m3/RsCA/0lnYzRHbcCmwbqz
         IKJUwh6HYcqHla+iHdABh9FRtnGePTCcCFsdGN9s=
Date:   Mon, 26 Sep 2022 13:57:18 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        weixugc@google.com, tim.c.chen@intel.com, sj@kernel.org,
        shy828301@gmail.com, mhocko@kernel.org, jvgediya.oss@gmail.com,
        Jonathan.Cameron@huawei.com, hesham.almatary@huawei.com,
        hannes@cmpxchg.org, dave@stgolabs.net, dave.hansen@intel.com,
        dan.j.williams@intel.com, bharata@amd.com, apopple@nvidia.com,
        aneesh.kumar@linux.ibm.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-demotion-add-support-for-explicit-memory-tiers-fix.patch removed from -mm tree
Message-Id: <20220926205718.CA0CEC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-demotion-add-support-for-explicit-memory-tiers-fix
has been removed from the -mm tree.  Its filename was
     mm-demotion-add-support-for-explicit-memory-tiers-fix.patch

This patch was dropped because it was folded into mm-demotion-add-support-for-explicit-memory-tiers.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-demotion-add-support-for-explicit-memory-tiers-fix
Date: Thu Aug 18 04:52:00 PM PDT 2022

fix comment, per Aneesh

Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Bharata B Rao <bharata@amd.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hesham Almatary <hesham.almatary@huawei.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Jagdish Gediya <jvgediya.oss@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Tim Chen <tim.c.chen@intel.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory-tiers.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/memory-tiers.h~mm-demotion-add-support-for-explicit-memory-tiers-fix
+++ a/include/linux/memory-tiers.h
@@ -8,9 +8,9 @@
 #define MEMTIER_CHUNK_BITS	7
 #define MEMTIER_CHUNK_SIZE	(1 << MEMTIER_CHUNK_BITS)
 /*
- * Smaller abstract distance values imply faster(higher) memory tiers. Offset
+ * Smaller abstract distance values imply faster (higher) memory tiers. Offset
  * the DRAM adistance so that we can accommodate devices with a slightly lower
- * adistance value (slightly slower) than default DRAM adistance to be part of
+ * adistance value (slightly faster) than default DRAM adistance to be part of
  * the same memory tier.
  */
 #define MEMTIER_ADISTANCE_DRAM	((4 * MEMTIER_CHUNK_SIZE) + (MEMTIER_CHUNK_SIZE >> 1))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-demotion-add-support-for-explicit-memory-tiers.patch
mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix-2.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
mm-delete-unused-mmf_oom_victim-flag-fix.patch
mm-add-merging-after-mremap-resize-checkpatch-fixes.patch
mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree.patch
mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree-fix.patch
mm-vmscan-fix-a-lot-of-comments-vs-mglru.patch
swap-add-swap_cache_get_folio-fix.patch
memcg-reduce-size-of-memcg-vmstats-structures-fix.patch
mm-damon-vaddr-add-a-comment-for-default-case-in-damon_va_apply_scheme-fix.patch
mm-page_allocc-rename-check_free_page-to-free_page_is_bad.patch
mm-page_allocc-rename-check_free_page-to-free_page_is_bad-fix.patch
mm-page_allocc-document-bulkfree_pcp_prepare-return-value.patch
fs-uninline-inode_maybe_inc_iversion.patch
ipc-msg-mitigate-the-lock-contention-with-percpu-counter-checkpatch-fixes.patch
ipc-msg-mitigate-the-lock-contention-with-percpu-counter-fix-fix.patch

