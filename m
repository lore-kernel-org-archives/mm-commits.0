Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FFF7C001DB
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:14:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237200AbjHKXOM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237191AbjHKXNa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:13:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC15044AE
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:02:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C39367B10
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:02:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B32CEC433C7;
        Fri, 11 Aug 2023 23:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794942;
        bh=y0Rz2xZBLAhESTBDlwkdPTMUJ0yOa0t6Ew4N0mq3x80=;
        h=Date:To:From:Subject:From;
        b=oC7o8RXJjDovN1GIAUwuASoRhnF+OTs3zUV6o5Lcu97oBsv1ywfb92O+1OvVu7ICI
         Urket3FqPrnTp3M1DJAiX285pVnceR+QoobMxqfN0kkZjYLYiyBeu7LCkx6Ji/47qD
         fbET6OCgWXfuT3lVRKslXnveseHcXpqHpbzi3Si8=
Date:   Fri, 11 Aug 2023 16:02:22 -0700
To:     mm-commits@vger.kernel.org, david@redhat.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mprotect-fix-obsolete-function-name-in-change_pte_range.patch removed from -mm tree
Message-Id: <20230811230222.B32CEC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mprotect: fix obsolete function name in change_pte_range()
has been removed from the -mm tree.  Its filename was
     mm-mprotect-fix-obsolete-function-name-in-change_pte_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/mprotect: fix obsolete function name in change_pte_range()
Date: Sun, 23 Jul 2023 11:31:14 +0800

Since commit 79a1971c5f14 ("mm: move the copy_one_pte() pte_present check
into the caller"), the explanation of preserving soft-dirtiness is moved
into copy_nonpresent_pte().  Update corresponding comment.

Link: https://lkml.kernel.org/r/20230723033114.3224409-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mprotect.c~mm-mprotect-fix-obsolete-function-name-in-change_pte_range
+++ a/mm/mprotect.c
@@ -213,7 +213,7 @@ static long change_pte_range(struct mmu_
 			} else if (is_writable_device_private_entry(entry)) {
 				/*
 				 * We do not preserve soft-dirtiness. See
-				 * copy_one_pte() for explanation.
+				 * copy_nonpresent_pte() for explanation.
 				 */
 				entry = make_readable_device_private_entry(
 							swp_offset(entry));
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

