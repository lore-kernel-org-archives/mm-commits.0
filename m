Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 713F3C2BB48
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:16:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38A3022D2B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:16:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730984AbgLOXQi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:16:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:56700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731029AbgLOXQd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:16:33 -0500
Date:   Tue, 15 Dec 2020 15:15:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074154;
        bh=8TYy0+wJVKhVJYjPuiYSoVkbzZeLRQ7tSEyk6RHeBRA=;
        h=From:To:Subject:From;
        b=akPRY2IARLbzFX7ZLUvCrUUWShtfVrP+MkE83Pav2I94hK6WyGA2WTgCMygdPCiEG
         LzVc8JZDvVUZp6Js9tmel1P/Mk/elh0WqBN4MIYmiHyVni9av8Q2bRV4rMk55cAQ4G
         j8CdeN8p7ACumEhBHM/e0kI035FB3yrxTNZ9XWmc=
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, anton@tuxera.com,
        mm-commits@vger.kernel.org
Subject:  [merged] fs-ntfs-remove-unused-varible-attr_len.patch
 removed from -mm tree
Message-ID: <20201215231554.4CkFQl41q%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ntfs: remove unused variable attr_len
has been removed from the -mm tree.  Its filename was
     fs-ntfs-remove-unused-varible-attr_len.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: fs/ntfs: remove unused variable attr_len

This variable isn't used anymore, remove it to skip W=1 warning:
fs/ntfs/inode.c:2350:6: warning: variable `attr_len' set but not used
[-Wunused-but-set-variable]

Link: https://lkml.kernel.org/r/4194376f-898b-b602-81c3-210567712092@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Acked-by: Anton Altaparmakov <anton@tuxera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/inode.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/ntfs/inode.c~fs-ntfs-remove-unused-varible-attr_len
+++ a/fs/ntfs/inode.c
@@ -2347,7 +2347,6 @@ int ntfs_truncate(struct inode *vi)
 	ATTR_RECORD *a;
 	const char *te = "  Leaving file length out of sync with i_size.";
 	int err, mp_size, size_change, alloc_change;
-	u32 attr_len;
 
 	ntfs_debug("Entering for inode 0x%lx.", vi->i_ino);
 	BUG_ON(NInoAttr(ni));
@@ -2721,7 +2720,6 @@ do_non_resident_truncate:
 	 * this cannot fail since we are making the attribute smaller thus by
 	 * definition there is enough space to do so.
 	 */
-	attr_len = le32_to_cpu(a->length);
 	err = ntfs_attr_record_resize(m, a, mp_size +
 			le16_to_cpu(a->data.non_resident.mapping_pairs_offset));
 	BUG_ON(err);
_

Patches currently in -mm which might be from alex.shi@linux.alibaba.com are

mm-thp-move-lru_add_page_tail-func-to-huge_memoryc.patch
mm-thp-use-head-for-head-page-in-lru_add_page_tail.patch
mm-thp-simplify-lru_add_page_tail.patch
mm-thp-narrow-lru-locking.patch
mm-vmscan-remove-unnecessary-lruvec-adding.patch
mm-rmap-stop-store-reordering-issue-on-page-mapping.patch
mm-memcg-add-debug-checking-in-lock_page_memcg.patch
mm-swapc-fold-vm-event-pgrotated-into-pagevec_move_tail_fn.patch
mm-lru-move-lock-into-lru_note_cost.patch
mm-vmscan-remove-lruvec-reget-in-move_pages_to_lru.patch
mm-mlock-remove-lru_lock-on-testclearpagemlocked.patch
mm-mlock-remove-__munlock_isolate_lru_page.patch
mm-lru-introduce-testclearpagelru.patch
mm-compaction-do-page-isolation-first-in-compaction.patch
mm-swapc-serialize-memcg-changes-in-pagevec_lru_move_fn.patch
mm-lru-replace-pgdat-lru_lock-with-lruvec-lock.patch
mm-vmscan-__isolate_lru_page_prepare-clean-up.patch
fs-nilfs2-remove-some-unused-macros-to-tame-gcc.patch
gcov-fix-kernel-doc-markup-issue.patch
mm-memcg-bail-early-from-swap-accounting-if-memcg-disabled.patch
mm-memcg-warning-on-memcg-after-readahead-page-charged.patch
mm-memcontrol-rewrite-mem_cgroup_page_lruvec-fix.patch

