Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D253C001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 22:59:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236815AbjHKW7L (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 18:59:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236547AbjHKW67 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:58:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B9402D5B
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:58:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4BD266B5A
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:58:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4708AC433C8;
        Fri, 11 Aug 2023 22:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794737;
        bh=B+oVtaeWHcVwVeRkk4aEUbBqAw6xS/noaqZ/MFVxBbI=;
        h=Date:To:From:Subject:From;
        b=W+dQncyMxJBsGwNPbk19OiYnFpGQwgI2DOW6VkA08v3Ga/mgnt/JpPRsQyPMbCrJN
         F6M5Cey529S4tf/dcqBB/FMKHmffHtmmeQ12gfFlpe2YMmM0GZDTKTAy95k8LzftT+
         l5sFtOQMw5dqMhr9Jldl7xOHspsMUa1QElqx3FPI=
Date:   Fri, 11 Aug 2023 15:58:56 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        weixugc@google.com, aneesh.kumar@linux.ibm.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memory-tier-use-helper-function-destroy_memory_type.patch removed from -mm tree
Message-Id: <20230811225857.4708AC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: memory tier: use helper function destroy_memory_type()
has been removed from the -mm tree.  Its filename was
     memory-tier-use-helper-function-destroy_memory_type.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: memory tier: use helper function destroy_memory_type()
Date: Mon, 26 Jun 2023 20:10:53 +0800

Use helper function destroy_memory_type() to release memtype instead of
open code it to help improve code readability a bit.  No functional change
intended.

Link: https://lkml.kernel.org/r/20230626121053.1916447-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Wei Xu <weixugc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-tiers.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-tiers.c~memory-tier-use-helper-function-destroy_memory_type
+++ a/mm/memory-tiers.c
@@ -586,7 +586,7 @@ void clear_node_memory_type(int node, st
 	 */
 	if (!node_memory_types[node].map_count) {
 		node_memory_types[node].memtype = NULL;
-		kref_put(&memtype->kref, release_memtype);
+		destroy_memory_type(memtype);
 	}
 	mutex_unlock(&memory_tier_lock);
 }
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memory-failure-fix-unexpected-return-value-in-soft_offline_page.patch
mm-memory-failure-fix-potential-page-refcnt-leak-in-memory_failure.patch
mm-memcg-fix-obsolete-function-name-in-mem_cgroup_protection.patch
mm-memory-failure-add-pageoffline-check.patch
mm-page_alloc-avoid-unneeded-alike_pages-calculation.patch
mm-memcg-update-obsolete-comment-above-parent_mem_cgroup.patch
mm-page_alloc-remove-unneeded-variable-base.patch
mm-memcg-fix-wrong-function-name-above-obj_cgroup_charge_zswap.patch
mm-memory-failure-use-helper-macro-llist_for_each_entry_safe.patch
mm-mm_init-use-helper-macro-bits_per_long-and-bits_per_byte.patch

