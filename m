Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D461FC04A6A
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 22:58:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233844AbjHKW63 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 18:58:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234007AbjHKW62 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:58:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 010FF2684
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:58:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8ACC96554C
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:58:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD126C433C8;
        Fri, 11 Aug 2023 22:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794707;
        bh=fEHxSwYdlN1hMbto54V+2pwu2Qk17Us2X498Mbd01ak=;
        h=Date:To:From:Subject:From;
        b=PAXv7R1vZjty5aMa4ag0OLCVAw2RQXaP61NNZlyeZIpOSmM7kEDMgoA145+eKN/E9
         8Xh90rGRo3olM94BbUy9oCUKffeohm9vl8hNUnFRMmlzI6BD3Ow3Usg8FCKbt920Zp
         JegyTmHab2MxWvfYqnPOJYyG2LfPTXMeKscqsa/A=
Date:   Fri, 11 Aug 2023 15:58:26 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mm_initc-update-obsolete-comment-in-get_pfn_range_for_nid.patch removed from -mm tree
Message-Id: <20230811225826.DD126C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mm_init.c: update obsolete comment in get_pfn_range_for_nid()
has been removed from the -mm tree.  Its filename was
     mm-mm_initc-update-obsolete-comment-in-get_pfn_range_for_nid.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/mm_init.c: update obsolete comment in get_pfn_range_for_nid()
Date: Sun, 25 Jun 2023 11:33:40 +0800

Since commit 633c0666b5a5 ("Memoryless nodes: drop one memoryless node boot
warning"), the warning for a node with no available memory is removed.
Update the corresponding comment.

Link: https://lkml.kernel.org/r/20230625033340.1054103-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/mm_init.c~mm-mm_initc-update-obsolete-comment-in-get_pfn_range_for_nid
+++ a/mm/mm_init.c
@@ -1681,8 +1681,7 @@ static inline void alloc_node_mem_map(st
  *
  * It returns the start and end page frame of a node based on information
  * provided by memblock_set_node(). If called for a node
- * with no available memory, a warning is printed and the start and end
- * PFNs will be 0.
+ * with no available memory, the start and end PFNs will be 0.
  */
 void __init get_pfn_range_for_nid(unsigned int nid,
 			unsigned long *start_pfn, unsigned long *end_pfn)
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

