Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12B69EB64DB
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:20:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbjFSXU0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbjFSXUX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:20:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D67D1BE
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:20:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8C1460F3A
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27F38C433C9;
        Mon, 19 Jun 2023 23:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216821;
        bh=9wsHPzHl+gHSFN3sjpz+20aoaoSlFkmxq/ftP7lJd6A=;
        h=Date:To:From:Subject:From;
        b=p+dsw5fzyDZzI9PwSXadqrs7QkkDKvHVNtIKraGRR+U+SkqzU/rHNDUcICZpe+Pkj
         tzPtETNLpxLqNsYEddkQuCXUUdIQk44A2X25A2yMsaMeX5kPJ4INOzcqVIphhfudCF
         GgfobYQ/Q/ImiQkNK5phMwSPYb0NcjQxXJfg3CyE=
Date:   Mon, 19 Jun 2023 16:20:20 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, david@redhat.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-mark-kswapd_run-and-kswapd_stop-__meminit.patch removed from -mm tree
Message-Id: <20230619232021.27F38C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: vmscan: mark kswapd_run() and kswapd_stop() __meminit
has been removed from the -mm tree.  Its filename was
     mm-vmscan-mark-kswapd_run-and-kswapd_stop-__meminit.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: vmscan: mark kswapd_run() and kswapd_stop() __meminit
Date: Tue, 6 Jun 2023 20:18:13 +0800

Add __meminit to kswapd_run() and kswapd_stop() to ensure they're default
to __init when memory hotplug is not enabled.

Link: https://lkml.kernel.org/r/20230606121813.242163-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Yu Zhao <yuzhao@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    4 ++--
 mm/vmscan.c          |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/swap.h~mm-vmscan-mark-kswapd_run-and-kswapd_stop-__meminit
+++ a/include/linux/swap.h
@@ -460,8 +460,8 @@ static inline bool node_reclaim_enabled(
 void check_move_unevictable_folios(struct folio_batch *fbatch);
 void check_move_unevictable_pages(struct pagevec *pvec);
 
-extern void kswapd_run(int nid);
-extern void kswapd_stop(int nid);
+extern void __meminit kswapd_run(int nid);
+extern void __meminit kswapd_stop(int nid);
 
 #ifdef CONFIG_SWAP
 
--- a/mm/vmscan.c~mm-vmscan-mark-kswapd_run-and-kswapd_stop-__meminit
+++ a/mm/vmscan.c
@@ -7871,7 +7871,7 @@ unsigned long shrink_all_memory(unsigned
 /*
  * This kswapd start function will be called by init and node-hot-add.
  */
-void kswapd_run(int nid)
+void __meminit kswapd_run(int nid)
 {
 	pg_data_t *pgdat = NODE_DATA(nid);
 
@@ -7892,7 +7892,7 @@ void kswapd_run(int nid)
  * Called by memory hotplug when all memory in a node is offlined.  Caller must
  * be holding mem_hotplug_begin/done().
  */
-void kswapd_stop(int nid)
+void __meminit kswapd_stop(int nid)
 {
 	pg_data_t *pgdat = NODE_DATA(nid);
 	struct task_struct *kswapd;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


