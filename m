Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 991CEC432BE
	for <mm-commits@archiver.kernel.org>; Tue, 17 Aug 2021 01:18:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C71C60F35
	for <mm-commits@archiver.kernel.org>; Tue, 17 Aug 2021 01:18:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233167AbhHQBSt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Aug 2021 21:18:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:54442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230304AbhHQBSs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 16 Aug 2021 21:18:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 871EC60ED5;
        Tue, 17 Aug 2021 01:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629163096;
        bh=N3Cz9axEd24V8xWr/SD/1WhSq7SV2DIkd9TwRjdnnbY=;
        h=Date:From:To:Subject:From;
        b=B4cfj1byHbRzs0Udc4YAZcjAzdLB9qSjjsgwr9MpWxfQ9xkrrt3saDA6sxQ5wfnih
         ERCSf0F+G16eF3UDdGwuJwWkO50CFym61I07O2RsldEpr3HHlPzOOa8XEegbC0xdKE
         WbFXeHThsSzHxVehOqsNAIS/rSu05KABzV8+B/tc=
Date:   Mon, 16 Aug 2021 18:18:16 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com
Subject:  + mm-hwpoison-fix-some-obsolete-comments.patch added to -mm
 tree
Message-ID: <20210817011816.w7BT6%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hwpoison: fix some obsolete comments
has been added to the -mm tree.  Its filename is
     mm-hwpoison-fix-some-obsolete-comments.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-fix-some-obsolete-comments.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-fix-some-obsolete-comments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hwpoison: fix some obsolete comments

Since commit cb731d6c62bb ("vmscan: per memory cgroup slab shrinkers"),
shrink_node_slabs is renamed to drop_slab_node.  And doit argument is
changed to forcekill since commit 6751ed65dc66 ("x86/mce: Fix
siginfo_t->si_addr value for non-recoverable memory faults").

Link: https://lkml.kernel.org/r/20210814105131.48814-5-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-fix-some-obsolete-comments
+++ a/mm/memory-failure.c
@@ -296,7 +296,7 @@ void shake_page(struct page *p, int acce
 	}
 
 	/*
-	 * Only call shrink_node_slabs here (which would also shrink
+	 * Only call drop_slab_node here (which would also shrink
 	 * other caches) if access is not potentially fatal.
 	 */
 	if (access)
@@ -391,8 +391,8 @@ static void add_to_kill(struct task_stru
 /*
  * Kill the processes that have been collected earlier.
  *
- * Only do anything when DOIT is set, otherwise just free the list
- * (this is used for clean pages which do not need killing)
+ * Only do anything when FORCEKILL is set, otherwise just free the
+ * list (this is used for clean pages which do not need killing)
  * Also when FAIL is set do a force kill because something went
  * wrong earlier.
  */
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-gup-remove-set-but-unused-local-variable-major.patch
mm-gup-remove-unneed-local-variable-orig_refs.patch
mm-gup-remove-useless-bug_on-in-__get_user_pages.patch
mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge.patch
mm-gup-use-helper-page_aligned-in-populate_vma_page_range.patch
shmem-remove-unneeded-variable-ret.patch
shmem-remove-unneeded-header-file.patch
shmem-remove-unneeded-function-forward-declaration.patch
shmem-include-header-file-to-declare-swap_info.patch
mm-memcg-remove-unused-functions.patch
mm-memcg-save-some-atomic-ops-when-flush-is-already-true.patch
mm-hwpoison-remove-unneeded-variable-unmap_success.patch
mm-hwpoison-fix-potential-pte_unmap_unlock-pte-error.patch
mm-hwpoison-change-argument-struct-page-hpagep-to-hpage.patch
mm-hwpoison-fix-some-obsolete-comments.patch
mm-vmscan-remove-the-pagedirty-check-after-madv_free-pages-are-page_ref_freezed.patch
mm-vmscan-remove-misleading-setting-to-sc-priority.patch
mm-vmscan-remove-unneeded-return-value-of-kswapd_run.patch
mm-vmscan-add-else-to-remove-check_pending-label.patch
mm-vmstat-correct-some-wrong-comments.patch
mm-vmstat-simplify-the-array-size-calculation.patch
mm-vmstat-remove-unneeded-return-value.patch
mm-zsmallocc-close-race-window-between-zs_pool_dec_isolated-and-zs_unregister_migration.patch
mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

