Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1285FC4338F
	for <mm-commits@archiver.kernel.org>; Mon, 16 Aug 2021 20:33:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC9D46024A
	for <mm-commits@archiver.kernel.org>; Mon, 16 Aug 2021 20:33:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbhHPUea (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Aug 2021 16:34:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:59116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231203AbhHPUe3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 16 Aug 2021 16:34:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA1C26024A;
        Mon, 16 Aug 2021 20:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629146037;
        bh=s31ORPGGxAsW7gP8nHHFYLGtMFq+44+/LsWzCB1KbEU=;
        h=Date:From:To:Subject:From;
        b=LGXLgtmV/80BQ/2IsTKEpDN3u9Sc4Ynv+eImFe5usEgMaLN+4Iiwa4ggufD7i2XJU
         nxyqFcAw49TN09w985K8RoO+oZdJ44H9yiucuwwLsL1vOYkjgYmaACxi0jOE+d0ulA
         qHuWzgO0zdWf5QqEVspW9gbs2v4T2zk4Ww0S6Q64=
Date:   Mon, 16 Aug 2021 13:33:57 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [folded-merged] linux-next-rejects-fix.patch removed from
 -mm tree
Message-ID: <20210816203357.JlrGdU-lg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects-fix
has been removed from the -mm tree.  Its filename was
     linux-next-rejects-fix.patch

This patch was dropped because it was folded into linux-next-rejects.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects-fix


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~linux-next-rejects-fix
+++ a/mm/page_alloc.c
@@ -1296,7 +1296,7 @@ static __always_inline bool free_pages_p
 		 * Do not let hwpoison pages hit pcplists/buddy
 		 * Untie memcg state and reset page's owner
 		 */
-		if (memcg_kmem_enabled() && PageMemcgKmem(page))
+		if (memcg_kmem_enabled() && folio_memcg_kmem(page_folio(page)))
 			__memcg_kmem_uncharge_page(page, order);
 		reset_page_owner(page, order);
 		return false;
@@ -1326,7 +1326,7 @@ static __always_inline bool free_pages_p
 	}
 	if (PageMappingFlags(page))
 		page->mapping = NULL;
-	if (memcg_kmem_enabled() && PageMemcgKmem(page))
+	if (memcg_kmem_enabled() && folio_memcg_kmem(page_folio(page)))
 		__memcg_kmem_uncharge_page(page, order);
 	if (check_free)
 		bad += check_free_page(page);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge-fix.patch
mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge-fix-fix.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch
mm-compaction-optimize-proactive-compaction-deferrals-fix.patch
mm-compaction-support-triggering-of-proactive-compaction-by-user-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-idle_page_tracking-make-pg_idle-reusable-fix-fix.patch
mm-damon-implement-primitives-for-the-virtual-memory-address-spaces-fix.patch
mm-damon-implement-a-debugfs-based-user-space-interface-fix.patch
mm-damon-implement-a-debugfs-based-user-space-interface-fix-fix.patch
fs-epoll-use-a-per-cpu-counter-for-users-watches-count-fix-fix.patch
log-if-a-core-dump-is-aborted-due-to-changed-file-permissions-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

