Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAFF3C77B7A
	for <mm-commits@archiver.kernel.org>; Wed,  7 Jun 2023 02:17:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240715AbjFGCRp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jun 2023 22:17:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234740AbjFGCRn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jun 2023 22:17:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A04801712
        for <mm-commits@vger.kernel.org>; Tue,  6 Jun 2023 19:17:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FC9263971
        for <mm-commits@vger.kernel.org>; Wed,  7 Jun 2023 02:17:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58578C433D2;
        Wed,  7 Jun 2023 02:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686104261;
        bh=gbbDa52NqeO4k69Hqexv0xX/HyQsRgV9RVib8UXRdDE=;
        h=Date:To:From:Subject:From;
        b=iLpzymcNaQLackt9RRd2GbC0G/NsRtx4rRP6uzlpMHQZMUcFhy/E8oL+Dai9NNRO1
         dylMb/5QKsV0wamtekDG6ZrnRhQF03vJhLMkSGUdJxKq5Wb+TKEEAaIOUyRVavk3PH
         6MpayUTq9/z+uyZKWCdPxYi6JLOPeIQpDpi6ibSU=
Date:   Tue, 06 Jun 2023 19:17:40 -0700
To:     mm-commits@vger.kernel.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-mark-kswapd_run-and-kswapd_stop-__meminit.patch added to mm-unstable branch
Message-Id: <20230607021741.58578C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: mark kswapd_run() and kswapd_stop() __meminit
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-mark-kswapd_run-and-kswapd_stop-__meminit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-mark-kswapd_run-and-kswapd_stop-__meminit.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: vmscan: mark kswapd_run() and kswapd_stop() __meminit
Date: Tue, 6 Jun 2023 20:18:13 +0800

Add __meminit to kswapd_run() and kswapd_stop() to ensure they're default
to __init when memory hotplug is not enabled.

Link: https://lkml.kernel.org/r/20230606121813.242163-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
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

mm-remove-obsolete-alloc_migrate_target.patch
mm-page_alloc-remove-unneeded-header-files.patch
memcg-use-helper-macro-flush_time.patch
mm-vmscan-mark-kswapd_run-and-kswapd_stop-__meminit.patch

