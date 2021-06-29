Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB670C11F65
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 00:18:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD3E061CFF
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 00:18:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231994AbhF2AU6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 20:20:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:58920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229852AbhF2AU5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 20:20:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B60061CF6;
        Tue, 29 Jun 2021 00:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624925911;
        bh=7tjWQiGttylVnCoNiakrYxvxJ+svHG9xGR3tRxa02yQ=;
        h=Date:From:To:Subject:From;
        b=AFxX7WViVWtPZZ5Bno4pLyP0YeY/g7BxJpBbT+0GJbkIcuh+VIh/i1d9EUWoxZRQK
         BVugJy5okclD7HrTHOOVB+q7gTejB2rnSJAJRbIZJ2Vm6q0vzpM3IAuYAtnD02ujaQ
         2TGjyqtNs3zim97Ob1weGo8HdIDV4lVwru0OzxLA=
Date:   Mon, 28 Jun 2021 17:18:31 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, mm-commits@vger.kernel.org, willy@infradead.org
Subject:  [folded-merged]
 =?US-ASCII?Q?writeback-cgroup-release-dying-cgwbs-by-switching-attache?=
 =?US-ASCII?Q?d-inodes-fix-3.patch?= removed from -mm tree
Message-ID: <20210629001831.RXKmU1qFo%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm writeback,cgroup: fix documentation
has been removed from the -mm tree.  Its filename was
     writeback-cgroup-release-dying-cgwbs-by-switching-attached-inodes-fix-3.patch

This patch was dropped because it was folded into writeback-cgroup-release-dying-cgwbs-by-switching-attached-inodes.patch

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm writeback,cgroup: fix documentation

cleanup_offline_cgwbs_workfn() is a static function, so it doesn't need
kernel-doc.  Also remove the inaccurate comment about the locking.

Link: https://lkml.kernel.org/r/20210615200242.1716568-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/mm/backing-dev.c~writeback-cgroup-release-dying-cgwbs-by-switching-attached-inodes-fix-3
+++ a/mm/backing-dev.c
@@ -645,15 +645,12 @@ static void cgwb_bdi_unregister(struct b
 	mutex_unlock(&bdi->cgwb_release_mutex);
 }
 
-/**
- * cleanup_offline_cgwbs - try to release dying cgwbs
+/*
+ * cleanup_offline_cgwbs_workfn - try to release dying cgwbs
  *
  * Try to release dying cgwbs by switching attached inodes to the nearest
  * living ancestor's writeback. Processed wbs are placed at the end
  * of the list to guarantee the forward progress.
- *
- * Should be called with the acquired cgwb_lock lock, which might
- * be released and re-acquired in the process.
  */
 static void cleanup_offline_cgwbs_workfn(struct work_struct *work)
 {
_

Patches currently in -mm which might be from willy@infradead.org are

writeback-cgroup-release-dying-cgwbs-by-switching-attached-inodes.patch
mm-writeback-move-__set_page_dirty-to-core-mm.patch
mm-writeback-use-__set_page_dirty-in-__set_page_dirty_nobuffers.patch
iomap-use-__set_page_dirty_nobuffers.patch
fs-remove-anon_set_page_dirty.patch
fs-remove-noop_set_page_dirty.patch
mm-move-page-dirtying-prototypes-from-mmh.patch
mm-make-__dump_page-static.patch
mm-debug-factor-pagepoisoned-out-of-__dump_page.patch
mm-page_owner-constify-dump_page_owner.patch
mm-make-compound_head-const-preserving.patch
mm-constify-get_pfnblock_flags_mask-and-get_pfnblock_migratetype.patch
mm-constify-page_count-and-page_ref_count.patch
mm-optimise-nth_page-for-contiguous-memmap.patch
mm-mark-idle-page-tracking-as-broken.patch
mm-hugetlb-free-the-vmemmap-pages-associated-with-each-hugetlb-page-fix.patch
mm-hugetlb-alloc-the-vmemmap-pages-associated-with-each-hugetlb-page-fix-2.patch
mm-thp-fix-strncpy-warning.patch

