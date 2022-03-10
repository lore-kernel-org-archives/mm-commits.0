Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF44CC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 10 Mar 2022 01:05:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239075AbiCJBGi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Mar 2022 20:06:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiCJBGh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Mar 2022 20:06:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D56F0121511
        for <mm-commits@vger.kernel.org>; Wed,  9 Mar 2022 17:05:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F430B82446
        for <mm-commits@vger.kernel.org>; Thu, 10 Mar 2022 01:05:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C5CC340E8;
        Thu, 10 Mar 2022 01:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646874335;
        bh=TnZ68+SlkLcAGAdiaMxQW2IBdWYzD0LOUipF/WYBFnI=;
        h=Date:To:From:Subject:From;
        b=Q2znXEaQfjgghpl6EJSLZofY3wCBGoy2pNZK8XRQx0YBqQHeDw0X3H1NKs2yfA/sc
         dCVX/tyLXP2WJl8NcG2bb/1+D5ygRMZe9Q3Ty7PRXSzMeVl0qOVXPQhMefGEpUfchw
         cXUDl8Ug32fNzBGbrLqMrJuQEutAnm3kIaaOFq/4=
Date:   Wed, 09 Mar 2022 17:05:34 -0800
To:     mm-commits@vger.kernel.org, wangjianxing@loongson.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] mm-page_alloc-add-scheduling-point-to-free_unref_page_list.patch removed from -mm tree
Message-Id: <20220310010535.17C5CC340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: add scheduling point to free_unref_page_list
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-add-scheduling-point-to-free_unref_page_list.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: wangjianxing <wangjianxing@loongson.cn>
Subject: mm/page_alloc: add scheduling point to free_unref_page_list

Freeing a large list of pages may cause rcu_sched starvatoin on
non-preemptible kernels

rcu: rcu_sched kthread starved for 5359 jiffies! g454793 f0x0
RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=19
[...]
Call Trace:
  free_unref_page_list+0x19c/0x270
  release_pages+0x3cc/0x498
  tlb_flush_mmu_free+0x44/0x70
  zap_pte_range+0x450/0x738
  unmap_page_range+0x108/0x240
  unmap_vmas+0x74/0xf0
  unmap_region+0xb0/0x120
  do_munmap+0x264/0x438
  vm_munmap+0x58/0xa0
  sys_munmap+0x10/0x20
  syscall_common+0x24/0x38

Link: https://lkml.kernel.org/r/20220302013825.2290315-1-wangjianxing@loongson.cn
Signed-off-by: wangjianxing <wangjianxing@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/page_alloc.c~mm-page_alloc-add-scheduling-point-to-free_unref_page_list
+++ a/mm/page_alloc.c
@@ -3479,6 +3479,9 @@ void free_unref_page_list(struct list_he
 		 */
 		if (++batch_count == SWAP_CLUSTER_MAX) {
 			local_unlock_irqrestore(&pagesets.lock, flags);
+
+			cond_resched();
+
 			batch_count = 0;
 			local_lock_irqsave(&pagesets.lock, flags);
 		}
_

Patches currently in -mm which might be from wangjianxing@loongson.cn are


