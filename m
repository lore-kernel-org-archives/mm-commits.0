Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9060C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 16 Feb 2022 00:30:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234692AbiBPAay (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Feb 2022 19:30:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245162AbiBPAar (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Feb 2022 19:30:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A747F70C7
        for <mm-commits@vger.kernel.org>; Tue, 15 Feb 2022 16:30:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53755B81C02
        for <mm-commits@vger.kernel.org>; Wed, 16 Feb 2022 00:30:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2BFEC340EB;
        Wed, 16 Feb 2022 00:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644971433;
        bh=5+7mD+J3k2zl51Mf0rBkcFnhuT77rYaamAIvo2DNomc=;
        h=Date:To:From:Subject:From;
        b=JtLWRa2Zn4gYg+FC7pcIkP3uit0NR7gxpYTvAGpQuxDah7SQDrLN5xpT+R5qdos6+
         DqrUX0g8vazVLanrpL1G+ZJBNrMs22xSN9zsujscbP++6jax1wLwWT+Bhu5SSH9bHz
         W3+EfOLs84zP9Zg4CcgbghwAH4KSngEhpsPeNq58=
Date:   Tue, 15 Feb 2022 16:30:32 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        vbabka@suse.cz, surenb@google.com, shakeelb@google.com,
        riel@surriel.com, mhocko@suse.com, kirill@shutemov.name,
        hughd@google.com, hannes@cmpxchg.org, gthelen@google.com,
        david@redhat.com, apopple@nvidia.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-munlock-mlock_page-munlock_page-batch-by-pagevec-fix.patch added to -mm tree
Message-Id: <20220216003032.E2BFEC340EB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-munlock-mlock_page-munlock_page-batch-by-pagevec-fix
has been added to the -mm tree.  Its filename is
     mm-munlock-mlock_page-munlock_page-batch-by-pagevec-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-munlock-mlock_page-munlock_page-batch-by-pagevec-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-munlock-mlock_page-munlock_page-batch-by-pagevec-fix.patch

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
Subject: mm-munlock-mlock_page-munlock_page-batch-by-pagevec-fix

implement mlock_lru() and mlock_new() as inlines, per Matthew

Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/mm/mlock.c~mm-munlock-mlock_page-munlock_page-batch-by-pagevec-fix
+++ a/mm/mlock.c
@@ -159,8 +159,15 @@ out:
  */
 #define LRU_PAGE 0x1
 #define NEW_PAGE 0x2
-#define mlock_lru(page) ((struct page *)((unsigned long)page + LRU_PAGE))
-#define mlock_new(page) ((struct page *)((unsigned long)page + NEW_PAGE))
+static inline struct page *mlock_lru(struct page *page)
+{
+	return (struct page *)((unsigned long)page + LRU_PAGE);
+}
+
+static inline struct page *mlock_new(struct page *page)
+{
+	return (struct page *)((unsigned long)page + NEW_PAGE);
+}
 
 /*
  * mlock_pagevec() is derived from pagevec_lru_move_fn():
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

remove-bdi_congested-and-wb_congested-and-related-functions-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-move-page-writeback-sysctls-to-is-own-file-checkpatch-fixes.patch
mm-move-page-writeback-sysctls-to-is-own-file-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
numa-balancing-optimize-page-placement-for-memory-tiering-system-fix.patch
numa-balancing-optimize-page-placement-for-memory-tiering-system-fix-fix.patch
mm-handle-uninitialized-numa-nodes-gracefully-fix.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix.patch
mm-munlock-mlock_page-munlock_page-batch-by-pagevec-fix.patch
mm-dont-include-linux-memremaph-in-linux-mmh-fix.patch
proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch
linux-next-rejects.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

