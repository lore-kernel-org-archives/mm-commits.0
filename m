Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5B23C6FA90
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:47:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbiI0Crb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbiI0Cr3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:47:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 580DE61706
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:47:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB0316155E
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:47:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AA22C433C1;
        Tue, 27 Sep 2022 02:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246845;
        bh=e94zUytzS1yx4r8MELPVK3+0HSGLD/gmIVCnbv/K0OM=;
        h=Date:To:From:Subject:From;
        b=cKqbDPqk+Aqc99T+9A5Ll0McEBO9XTcwXHepZHfSJV+7TEFzjINTvm46XphhkMa6H
         QRe03Yd4Y8IvZQuFAx1yxG9EUdb5lSiMWurJfJ5hfYoRio1EXHee/uCuB352KMvXfB
         rpnVOZ586QDRUegI+vPZDwdUa2k/os7Q9KTdnvM4=
Date:   Mon, 26 Sep 2022 19:47:24 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hwpoison-cleanup-some-obsolete-comments.patch removed from -mm tree
Message-Id: <20220927024725.3AA22C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm, hwpoison: cleanup some obsolete comments
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-cleanup-some-obsolete-comments.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm, hwpoison: cleanup some obsolete comments
Date: Tue, 30 Aug 2022 20:36:04 +0800

1.Remove meaningless comment in kill_proc(). That doesn't tell anything.
2.Fix the wrong function name get_hwpoison_unless_zero(). It should be
get_page_unless_zero().
3.The gate keeper for free hwpoison page has moved to check_new_page().
Update the corresponding comment.

Link: https://lkml.kernel.org/r/20220830123604.25763-7-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-cleanup-some-obsolete-comments
+++ a/mm/memory-failure.c
@@ -277,7 +277,7 @@ static int kill_proc(struct to_kill *tk,
 		 * to SIG_IGN, but hopefully no one will do that?
 		 */
 		ret = send_sig_mceerr(BUS_MCEERR_AO, (void __user *)tk->addr,
-				      addr_lsb, t);  /* synchronous? */
+				      addr_lsb, t);
 	if (ret < 0)
 		pr_info("Error sending signal to %s:%d: %d\n",
 			t->comm, t->pid, ret);
@@ -1249,9 +1249,9 @@ static int __get_hwpoison_page(struct pa
 		return ret;
 
 	/*
-	 * This check prevents from calling get_hwpoison_unless_zero()
-	 * for any unsupported type of page in order to reduce the risk of
-	 * unexpected races caused by taking a page refcount.
+	 * This check prevents from calling get_page_unless_zero() for any
+	 * unsupported type of page in order to reduce the risk of unexpected
+	 * races caused by taking a page refcount.
 	 */
 	if (!HWPoisonHandlable(head, flags))
 		return -EBUSY;
@@ -2028,7 +2028,7 @@ try_again:
 	/*
 	 * We need/can do nothing about count=0 pages.
 	 * 1) it's a free page, and therefore in safe hand:
-	 *    prep_new_page() will be the gate keeper.
+	 *    check_new_page() will be the gate keeper.
 	 * 2) it's part of a non-compound high order page.
 	 *    Implies some kernel user: cannot stop them from
 	 *    R/W the page; let's pray that the page has been
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

writeback-remove-unused-macro-dirty_full_scope.patch
mm-page_alloc-ensure-kswapd-doesnt-accidentally-go-to-sleep.patch
mm-page_alloc-make-zone_pcp_update-static.patch
mm-remove-obsolete-macro-nr_pcp_order_mask-and-nr_pcp_order_width.patch
mm-page_alloc-remove-obsolete-comment-in-zone_statistics.patch
mm-page_alloc-add-__init-annotations-to-init_mem_debugging_and_hardening.patch
mm-page_alloc-fix-freeing-static-percpu-memory.patch
mm-remove-obsolete-pgdat_is_empty.patch
mm-page_alloc-add-missing-is_migrate_isolate-check-in-set_page_guard.patch
mm-page_alloc-use-local-variable-zone_idx-directly.patch
mm-memory_hotplug-remove-obsolete-generic_free_nodedata.patch
mm-page_alloc-make-boot_nodestats-static.patch
mm-page_alloc-use-helper-macro-sz_1km.patch
mm-page_alloc-init-local-variable-buddy_pfn.patch
mm-page_alloc-use-costly_order-in-warn_on_once_gfp.patch
mm-page_alloc-remove-obsolete-gfpflags_normal_context.patch
mm-page_alloc-remove-obsolete-gfpflags_normal_context-fix.patch
mm-page_alloc-fix-obsolete-comment-in-deferred_pfn_valid.patch

