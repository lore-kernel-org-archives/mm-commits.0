Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5744DC71153
	for <mm-commits@archiver.kernel.org>; Mon,  4 Sep 2023 19:54:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235119AbjIDTyO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Sep 2023 15:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235847AbjIDTyM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Sep 2023 15:54:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD469E41
        for <mm-commits@vger.kernel.org>; Mon,  4 Sep 2023 12:54:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33DA5B80EF4
        for <mm-commits@vger.kernel.org>; Mon,  4 Sep 2023 19:54:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C32DDC433C9;
        Mon,  4 Sep 2023 19:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693857240;
        bh=W+zd35PpQ6NIePIgXNf4jFAxgC8grvodv7F+m3PmD+0=;
        h=Date:To:From:Subject:From;
        b=mu7iEu0B+7AF6MS7iqOkAtCufz7w74jPnlJDgN62o1JfznZ3WPiVuC4+bIpHpyWyS
         Cx9Wj5lafmYZBTdhIa3Cb9b5w0KBUj6snol5oK0vcbTuPgkRvnIqPvop3Ai3Ij5biP
         qjY4aSQBbEgG9tuj/J8Uh/Gs6HF8tPXEaAFnJ00w=
Date:   Mon, 04 Sep 2023 12:53:59 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        paulmck@kernel.org, oleksiy.avramchenko@sony.com,
        lstoakes@gmail.com, Liam.Howlett@oracle.com,
        joel@joelfernandes.org, hch@lst.de, david@fromorbit.com,
        bhe@redhat.com, urezki@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-remove-global-vmap_area_root-rb-tree-fix.patch added to mm-unstable branch
Message-Id: <20230904195400.C32DDC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmalloc-remove-global-vmap_area_root-rb-tree-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-remove-global-vmap_area_root-rb-tree-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-remove-global-vmap_area_root-rb-tree-fix.patch

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
From: Uladzislau Rezki <urezki@gmail.com>
Subject: mm-vmalloc-remove-global-vmap_area_root-rb-tree-fix
Date: Mon, 4 Sep 2023 16:55:38 +0200

fix build warning

Link: https://lkml.kernel.org/r/ZPXv6o3a43xisdmc@pc636
Signed-off-by: Uladzislau Rezki <urezki@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-remove-global-vmap_area_root-rb-tree-fix
+++ a/mm/vmalloc.c
@@ -4521,7 +4521,7 @@ static void vmap_init_free_space(void)
 	 *  |<--------------------------------->|
 	 */
 	for (busy = vmlist; busy; busy = busy->next) {
-		if (busy->addr - vmap_start > 0) {
+		if ((unsigned long) busy->addr - vmap_start > 0) {
 			free = kmem_cache_zalloc(vmap_area_cachep, GFP_NOWAIT);
 			if (!WARN_ON_ONCE(!free)) {
 				free->va_start = vmap_start;
_

Patches currently in -mm which might be from urezki@gmail.com are

mm-vmalloc-add-va_alloc-helper.patch
mm-vmalloc-rename-adjust_va_to_fit_type-function.patch
mm-vmalloc-move-vmap_init_free_space-down-in-vmallocc.patch
mm-vmalloc-remove-global-vmap_area_root-rb-tree.patch
mm-vmalloc-remove-global-vmap_area_root-rb-tree-fix.patch
mm-vmalloc-remove-global-purge_vmap_area_root-rb-tree.patch
mm-vmalloc-offload-free_vmap_area_lock-lock.patch
mm-vmalloc-support-multiple-nodes-in-vread_iter.patch
mm-vmalloc-support-multiple-nodes-in-vmallocinfo.patch
mm-vmalloc-set-nr_nodes-node_size-based-on-cpu-cores.patch

