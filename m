Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C3C2C4338F
	for <mm-commits@archiver.kernel.org>; Tue, 10 Aug 2021 00:23:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F81561004
	for <mm-commits@archiver.kernel.org>; Tue, 10 Aug 2021 00:23:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235977AbhHJAXu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 Aug 2021 20:23:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:52022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231439AbhHJAXs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 9 Aug 2021 20:23:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C7A160F6F;
        Tue, 10 Aug 2021 00:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628555007;
        bh=pH0NBF4LSODfFpjn1Zl00WPUooOUPZasC0ctOgtxM3A=;
        h=Date:From:To:Subject:From;
        b=Pr29PHGbu3+AeMabQNGWOKsqvQOFmqeqO17vLBhSQ+FGMZSr+ao/JCH5TiWNWoKCo
         7mVc/Us4V2gz4M4N0T3RyjerYSv0rlsdbHT2S+wy8Ws9MSyrBpR/LNhUu71OFvGdco
         EGJdb0CwmRwv269uKx4FkpKsCIlb7vHvgaBNZhEE=
Date:   Mon, 09 Aug 2021 17:23:26 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-rejects-fix.patch added to -mm tree
Message-ID: <20210810002326.n-IxxdKD-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects-fix
has been added to the -mm tree.  Its filename is
     linux-next-rejects-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/linux-next-rejects-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/linux-next-rejects-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects-fix


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    1 -
 mm/page_alloc.c            |    4 ++--
 2 files changed, 2 insertions(+), 3 deletions(-)

--- a/include/linux/memcontrol.h~linux-next-rejects-fix
+++ a/include/linux/memcontrol.h
@@ -369,7 +369,6 @@ enum page_memcg_data_flags {
 
 #define MEMCG_DATA_FLAGS_MASK (__NR_MEMCG_DATA_FLAGS - 1)
 
-static inline bool PageMemcgKmem(struct page *page);
 static inline bool folio_memcg_kmem(struct folio *folio);
 
 /*
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
mm-damon-implement-primitives-for-the-virtual-memory-address-spaces-fix.patch
mm-damon-implement-a-debugfs-based-user-space-interface-fix.patch
mm-damon-implement-a-debugfs-based-user-space-interface-fix-fix.patch
fs-epoll-use-a-per-cpu-counter-for-users-watches-count-fix-fix.patch
log-if-a-core-dump-is-aborted-due-to-changed-file-permissions-fix.patch
linux-next-rejects.patch
linux-next-rejects-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
a.patch

