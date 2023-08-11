Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8BD8C41513
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:01:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236985AbjHKXBr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbjHKXA1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:00:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D8EE3A88
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:00:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D85167AC6
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:00:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96157C433C7;
        Fri, 11 Aug 2023 23:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794805;
        bh=bfZl2Ls9vFBa91ml6ClZ9u1IazFMEobeyLrQaIWenlg=;
        h=Date:To:From:Subject:From;
        b=yofOxSceUaou2UBk9a4Dk8ajwNhc0wKjsjkt/evn2U5EcYXHBxijJIic4leljMM/D
         jNKxXUdCBXTpIHVn4Ip0d7gIF9BteUQWlqDVAxanDv6u0mTVnUhnGy8syLiRqIto66
         eFsmpdFZci/LLwvd0U8g+JRML2Ewy/loUE7Ybl0k=
Date:   Fri, 11 Aug 2023 16:00:05 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-remove-unneeded-pagehuge-check.patch removed from -mm tree
Message-Id: <20230811230005.96157C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memory-failure: remove unneeded PageHuge() check
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-remove-unneeded-pagehuge-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: memory-failure: remove unneeded PageHuge() check
Date: Tue, 11 Jul 2023 13:50:09 +0800

Patch series "A few fixup and cleanup patches for memory-failure", v2.

This series contains a few fixup patches to fix inaccurate mf_stats, fix
race window when trying to get hugetlb folio and so on.  Also there is
minor cleanup for comments and codestyle.  More details can be found in
the respective changelogs.


This patch (of 8):

PageHuge() check in me_huge_page() is just for potential problems.  Remove
it as it's actually dead code and won't catch anything.

Link: https://lkml.kernel.org/r/20230711055016.2286677-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20230711055016.2286677-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-remove-unneeded-pagehuge-check
+++ a/mm/memory-failure.c
@@ -1187,9 +1187,6 @@ static int me_huge_page(struct page_stat
 	struct address_space *mapping;
 	bool extra_pins = false;
 
-	if (!PageHuge(hpage))
-		return MF_DELAYED;
-
 	mapping = page_mapping(hpage);
 	if (mapping) {
 		res = truncate_error_page(hpage, page_to_pfn(p), mapping);
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

