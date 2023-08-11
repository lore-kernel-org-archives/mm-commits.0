Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1DC2C04FDF
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 22:59:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236047AbjHKW7O (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 18:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236812AbjHKW67 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:58:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47CFD358C
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:58:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA1B4672B1
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:58:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D2ABC433C8;
        Fri, 11 Aug 2023 22:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794738;
        bh=T5QH/NAkVuxWWEPLUwUeMVA8HLX57KSNmqS6eBZg5ms=;
        h=Date:To:From:Subject:From;
        b=NNYA9gWrjW1+6iwxktegEcW7q3phg9km9fqtmpRt2+lGm8X1+qh+BeIVJZXY14G6G
         OK5/rnWvBjfGIXAS4eCHXi4ikqaIZlrx4B3oXq9o5s/PKx0hZLCBViiB3ZDxqsUDJR
         YLxnqAOU3gpAv+jKt1v0HkwK9AtDlaJK2ciZckI4=
Date:   Fri, 11 Aug 2023 15:58:57 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-remove-unneeded-inline-annotation.patch removed from -mm tree
Message-Id: <20230811225858.3D2ABC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memory-failure: remove unneeded 'inline' annotation
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-remove-unneeded-inline-annotation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: memory-failure: remove unneeded 'inline' annotation
Date: Mon, 26 Jun 2023 19:43:43 +0800

Remove unneeded 'inline' annotation from num_poisoned_pages_inc() and
num_poisoned_pages_sub().  No functional change intended.

Link: https://lkml.kernel.org/r/20230626114343.1846587-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-remove-unneeded-inline-annotation
+++ a/mm/memory-failure.c
@@ -75,13 +75,13 @@ atomic_long_t num_poisoned_pages __read_
 
 static bool hw_memory_failure __read_mostly = false;
 
-inline void num_poisoned_pages_inc(unsigned long pfn)
+void num_poisoned_pages_inc(unsigned long pfn)
 {
 	atomic_long_inc(&num_poisoned_pages);
 	memblk_nr_poison_inc(pfn);
 }
 
-inline void num_poisoned_pages_sub(unsigned long pfn, long i)
+void num_poisoned_pages_sub(unsigned long pfn, long i)
 {
 	atomic_long_sub(i, &num_poisoned_pages);
 	if (pfn != -1UL)
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

