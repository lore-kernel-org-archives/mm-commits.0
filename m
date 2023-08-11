Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6746C04A6A
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:01:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236980AbjHKXBt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236988AbjHKXA3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:00:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 915CA3A8C
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:00:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2527F67B6B
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B416C433C7;
        Fri, 11 Aug 2023 23:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794811;
        bh=MgPvibBezvkKeDTocqtLbzAJO9LJCdGkmm3NzAuFcZY=;
        h=Date:To:From:Subject:From;
        b=YRZQKk6cPI3c5Tfvm8cHUF2xG3WslsAKVllRmC69tF0EijKvOTJpgvXtDKCgcU+lt
         RxkDi+Th+IdUJR8kf9E9CkTjWSwDN7qzlj9MlaM0Hb6Ok/GgxkVQvTKRqtfsIlhT9U
         qpjCQ5SDud3xJakefcG5lteiDUceyf/tqk1HTTaY=
Date:   Fri, 11 Aug 2023 16:00:11 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-minor-cleanup-for-comments-and-codestyle.patch removed from -mm tree
Message-Id: <20230811230011.7B416C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memory-failure: minor cleanup for comments and codestyle
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-minor-cleanup-for-comments-and-codestyle.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: memory-failure: minor cleanup for comments and codestyle
Date: Tue, 11 Jul 2023 13:50:14 +0800

Fix some wrong function names and grammar error in comments. Also remove
unneeded space after for_each_process. No functional change intended.

Link: https://lkml.kernel.org/r/20230711055016.2286677-7-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-minor-cleanup-for-comments-and-codestyle
+++ a/mm/memory-failure.c
@@ -608,7 +608,7 @@ static void collect_procs_anon(struct pa
 
 	pgoff = page_to_pgoff(page);
 	read_lock(&tasklist_lock);
-	for_each_process (tsk) {
+	for_each_process(tsk) {
 		struct anon_vma_chain *vmac;
 		struct task_struct *t = task_early_kill(tsk, force_early);
 
@@ -652,7 +652,7 @@ static void collect_procs_file(struct pa
 			/*
 			 * Send early kill signal to tasks where a vma covers
 			 * the page but the corrupted page is not necessarily
-			 * mapped it in its pte.
+			 * mapped in its pte.
 			 * Assume applications who requested early kill want
 			 * to be informed of all such data corruptions.
 			 */
@@ -2117,7 +2117,7 @@ static DEFINE_MUTEX(mf_mutex);
  * detected by a background scrubber)
  *
  * Must run in process context (e.g. a work queue) with interrupts
- * enabled and no spinlocks hold.
+ * enabled and no spinlocks held.
  *
  * Return: 0 for successfully handled the memory error,
  *         -EOPNOTSUPP for hwpoison_filter() filtered the error event,
@@ -2221,7 +2221,7 @@ try_again:
 		 * otherwise it may race with THP split.
 		 * And the flag can't be set in get_hwpoison_page() since
 		 * it is called by soft offline too and it is just called
-		 * for !MF_COUNT_INCREASE.  So here seems to be the best
+		 * for !MF_COUNT_INCREASED.  So here seems to be the best
 		 * place.
 		 *
 		 * Don't need care about the above error handling paths for
@@ -2578,10 +2578,10 @@ static bool isolate_page(struct page *pa
 
 	/*
 	 * If we succeed to isolate the page, we grabbed another refcount on
-	 * the page, so we can safely drop the one we got from get_any_pages().
+	 * the page, so we can safely drop the one we got from get_any_page().
 	 * If we failed to isolate the page, it means that we cannot go further
 	 * and we will return an error, so drop the reference we got from
-	 * get_any_pages() as well.
+	 * get_any_page() as well.
 	 */
 	put_page(page);
 	return isolated;
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

