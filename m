Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D0FFC07E9D
	for <mm-commits@archiver.kernel.org>; Mon, 26 Sep 2022 20:59:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbiIZU73 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 16:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbiIZU71 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 16:59:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AF9BA0331
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 13:59:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1D75612D8
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 20:59:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 069D1C43470;
        Mon, 26 Sep 2022 20:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664225966;
        bh=3bwFzEXQ+VsNIhqLJ29bF52w4mzZqKwJ4Klpqa3W2IU=;
        h=Date:To:From:Subject:From;
        b=TcxUCj3IfgaZS6KT/mNvxzJYrJuNFdiVSb85dZ1XMyfA13STAw5JEkcgb+inXn5EK
         myJ48o7VEf2rKlafyOCaWhNCUDSBYUhyvfd26VPTanTwaScEOb0jmtIard6OUq0HF8
         s2+0ZYlhACin3YWwT9rk3I43MQdNpixj5o4CuqWs=
Date:   Mon, 26 Sep 2022 13:59:25 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        weixugc@google.com, tim.c.chen@intel.com, sj@kernel.org,
        shy828301@gmail.com, mhocko@kernel.org, jvgediya.oss@gmail.com,
        Jonathan.Cameron@huawei.com, hesham.almatary@huawei.com,
        hannes@cmpxchg.org, dave@stgolabs.net, dave.hansen@intel.com,
        dan.j.williams@intel.com, bharata@amd.com, apopple@nvidia.com,
        aneesh.kumar@linux.ibm.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix-2.patch removed from -mm tree
Message-Id: <20220926205926.069D1C43470@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix-2
has been removed from the -mm tree.  Its filename was
     mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix-2.patch

This patch was dropped because it was folded into mm-demotion-update-node_is_toptier-to-work-with-memory-tiers.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix-2
Date: Sat Aug 20 01:42:24 PM PDT 2022

mm/memory.c needs linux/memory-tiers.h

mm/memory.c: In function 'do_numa_page':
mm/memory.c:4723:14: error: implicit declaration of function 'node_is_toptier' [-Werror=implicit-function-declaration]
 4723 |             !node_is_toptier(page_nid))
      |              ^~~~~~~~~~~~~~~

Cc: Alistair Popple <apopple@nvidia.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
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
Cc: Tim Chen <tim.c.chen@intel.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memory.c~mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix-2
+++ a/mm/memory.c
@@ -66,6 +66,7 @@
 #include <linux/gfp.h>
 #include <linux/migrate.h>
 #include <linux/string.h>
+#include <linux/memory-tiers.h>
 #include <linux/debugfs.h>
 #include <linux/userfaultfd_k.h>
 #include <linux/dax.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-demotion-update-node_is_toptier-to-work-with-memory-tiers.patch
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

