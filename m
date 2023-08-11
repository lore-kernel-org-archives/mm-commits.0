Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D805AC04A6A
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:14:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237194AbjHKXOJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:14:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237162AbjHKXNa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:13:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9EFA4494
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:02:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7185262BDB
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:02:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB3E7C433C7;
        Fri, 11 Aug 2023 23:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794931;
        bh=17/FU0maPZ5cx8+s6lacxpbEnzoQhwBiIF2W8X5tDDI=;
        h=Date:To:From:Subject:From;
        b=hhtj/Jy7v59f1PtVUF+3ULCMkMO9q0ujfODEMk30OCwKHfJNboGp58vYMi4iWZycu
         5OgjgqisQebxnCj7G4brYjqGZ2TIeN/XdZ26eEYRhnJrL2Xh0WXzQ8Qh5Ce848NLGv
         V+o9twmRtSjlbo7b21JDBbQ8nrOQB3HcXYwbOMIg=
Date:   Fri, 11 Aug 2023 16:02:11 -0700
To:     mm-commits@vger.kernel.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-fix-obsolete-function-name-above-debug_pagealloc_enabled_static.patch removed from -mm tree
Message-Id: <20230811230211.CB3E7C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: fix obsolete function name above debug_pagealloc_enabled_static()
has been removed from the -mm tree.  Its filename was
     mm-fix-obsolete-function-name-above-debug_pagealloc_enabled_static.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: fix obsolete function name above debug_pagealloc_enabled_static()
Date: Thu, 20 Jul 2023 19:28:06 +0800

Since commit 04013513cc84 ("mm, page_alloc: do not rely on the order of
page_poison and init_on_alloc/free parameters"), init_debug_pagealloc() is
converted to init_mem_debugging_and_hardening().  Later it's renamed to
mem_debugging_and_hardening_init() via commit f2fc4b44ec2b ("mm: move
init_mem_debugging_and_hardening() to mm/mm_init.c").

Link: https://lkml.kernel.org/r/20230720112806.3851893-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/mm.h~mm-fix-obsolete-function-name-above-debug_pagealloc_enabled_static
+++ a/include/linux/mm.h
@@ -3465,8 +3465,8 @@ static inline bool debug_pagealloc_enabl
 }
 
 /*
- * For use in fast paths after init_debug_pagealloc() has run, or when a
- * false negative result is not harmful when called too early.
+ * For use in fast paths after mem_debugging_and_hardening_init() has run,
+ * or when a false negative result is not harmful when called too early.
  */
 static inline bool debug_pagealloc_enabled_static(void)
 {
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

