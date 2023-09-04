Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99191C71153
	for <mm-commits@archiver.kernel.org>; Mon,  4 Sep 2023 19:54:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbjIDTyC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Sep 2023 15:54:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbjIDTyC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Sep 2023 15:54:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1E1F1BE
        for <mm-commits@vger.kernel.org>; Mon,  4 Sep 2023 12:53:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76D1060204
        for <mm-commits@vger.kernel.org>; Mon,  4 Sep 2023 19:53:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA8BBC433C7;
        Mon,  4 Sep 2023 19:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693857231;
        bh=ITScu3PbVlvbUEm0zemsIDFTiLNApX7BE6VoOYDFirM=;
        h=Date:To:From:Subject:From;
        b=ZJOxq/0r0bcWR3hdZhk6LV6G6bIdH5dC59xNs4UHIYY/RiD5uAksOppvDPzPNsiBG
         uUYyZvbs5piK0wxRt9EZWqub8+KD5uPm7DaMwfEzlBMopzUHUNqQDCAGe2ruBLGiaX
         7PjErXBDiVPRBV3Fbw9ZCYMBaIvXVK6kQ/hPkHcs=
Date:   Mon, 04 Sep 2023 12:53:50 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        paulmck@kernel.org, oleksiy.avramchenko@sony.com,
        lstoakes@gmail.com, Liam.Howlett@oracle.com,
        joel@joelfernandes.org, hch@lst.de, david@fromorbit.com,
        bhe@redhat.com, urezki@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-rename-adjust_va_to_fit_type-function.patch added to mm-unstable branch
Message-Id: <20230904195351.CA8BBC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmalloc: rename adjust_va_to_fit_type() function
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-rename-adjust_va_to_fit_type-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-rename-adjust_va_to_fit_type-function.patch

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
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm: vmalloc: rename adjust_va_to_fit_type() function
Date: Tue, 29 Aug 2023 10:11:35 +0200

This patch renames the adjust_va_to_fit_type() function to va_clip() which
is shorter and more expressive.

There is no a functional change as a result of this patch.

Link: https://lkml.kernel.org/r/20230829081142.3619-3-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-rename-adjust_va_to_fit_type-function
+++ a/mm/vmalloc.c
@@ -1382,9 +1382,9 @@ classify_va_fit_type(struct vmap_area *v
 }
 
 static __always_inline int
-adjust_va_to_fit_type(struct rb_root *root, struct list_head *head,
-		      struct vmap_area *va, unsigned long nva_start_addr,
-		      unsigned long size)
+va_clip(struct rb_root *root, struct list_head *head,
+		struct vmap_area *va, unsigned long nva_start_addr,
+		unsigned long size)
 {
 	struct vmap_area *lva = NULL;
 	enum fit_type type = classify_va_fit_type(va, nva_start_addr, size);
@@ -1500,7 +1500,7 @@ va_alloc(struct vmap_area *va,
 		return vend;
 
 	/* Update the free vmap_area. */
-	ret = adjust_va_to_fit_type(root, head, va, nva_start_addr, size);
+	ret = va_clip(root, head, va, nva_start_addr, size);
 	if (WARN_ON_ONCE(ret))
 		return vend;
 
@@ -4155,9 +4155,8 @@ retry:
 			/* It is a BUG(), but trigger recovery instead. */
 			goto recovery;
 
-		ret = adjust_va_to_fit_type(&free_vmap_area_root,
-					    &free_vmap_area_list,
-					    va, start, size);
+		ret = va_clip(&free_vmap_area_root,
+			&free_vmap_area_list, va, start, size);
 		if (WARN_ON_ONCE(unlikely(ret)))
 			/* It is a BUG(), but trigger recovery instead. */
 			goto recovery;
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

