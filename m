Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C88FDC433F5
	for <mm-commits@archiver.kernel.org>; Mon, 31 Jan 2022 23:06:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235258AbiAaXGq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Jan 2022 18:06:46 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54578 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234556AbiAaXGp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 31 Jan 2022 18:06:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05E99B82CBD
        for <mm-commits@vger.kernel.org>; Mon, 31 Jan 2022 23:06:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACB96C340E8;
        Mon, 31 Jan 2022 23:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643670403;
        bh=a2Y//OVHiJ/W4P/auHaOeTFa7ngipoXnArQ+g+imFGE=;
        h=Date:To:From:Subject:From;
        b=s5l3WwQAK9tzOA/mp4MaMuTEgH7BatGiFAwLPasi3vH6Uu967cKNlvl0G1dmPu5lf
         qGD9eSMv4VOs7qEj+Nb9UDEX/pisbUx/SCzUgxMSkv9BOvJoWrLQN56/zOq021vnYW
         GKsMYrR20xV1rR7/puSDj6JlXEKx5gQY64DPK+HE=
Received: by hp1 (sSMTP sendmail emulation); Mon, 31 Jan 2022 15:06:42 -0800
Date:   Mon, 31 Jan 2022 15:06:42 -0800
To:     mm-commits@vger.kernel.org, abaci@linux.alibaba.com,
        jiapeng.chong@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmallocc-fix-unused-function-warning.patch added to -mm tree
Message-Id: <20220131230642.ACB96C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc.c: fix "unused function" warning
has been added to the -mm tree.  Its filename is
     mm-vmallocc-fix-unused-function-warning.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmallocc-fix-unused-function-warning.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmallocc-fix-unused-function-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: mm/vmalloc.c: fix "unused function" warning

compute_subtree_max_size() is unused, when building with
DEBUG_AUGMENT_PROPAGATE_CHECK=y.

mm/vmalloc.c:785:1: warning: unused function 'compute_subtree_max_size'
[-Wunused-function].

Link: https://lkml.kernel.org/r/20220129034652.75359-1-jiapeng.chong@linux.alibaba.com
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/mm/vmalloc.c~mm-vmallocc-fix-unused-function-warning
+++ a/mm/vmalloc.c
@@ -776,17 +776,6 @@ get_subtree_max_size(struct rb_node *nod
 	return va ? va->subtree_max_size : 0;
 }
 
-/*
- * Gets called when remove the node and rotate.
- */
-static __always_inline unsigned long
-compute_subtree_max_size(struct vmap_area *va)
-{
-	return max3(va_size(va),
-		get_subtree_max_size(va->rb_node.rb_left),
-		get_subtree_max_size(va->rb_node.rb_right));
-}
-
 RB_DECLARE_CALLBACKS_MAX(static, free_vmap_area_rb_augment_cb,
 	struct vmap_area, rb_node, unsigned long, subtree_max_size, va_size)
 
@@ -978,6 +967,17 @@ unlink_va(struct vmap_area *va, struct r
 }
 
 #if DEBUG_AUGMENT_PROPAGATE_CHECK
+/*
+ * Gets called when remove the node and rotate.
+ */
+static __always_inline unsigned long
+compute_subtree_max_size(struct vmap_area *va)
+{
+	return max3(va_size(va),
+		get_subtree_max_size(va->rb_node.rb_left),
+		get_subtree_max_size(va->rb_node.rb_right));
+}
+
 static void
 augment_tree_propagate_check(void)
 {
_

Patches currently in -mm which might be from jiapeng.chong@linux.alibaba.com are

mm-vmallocc-fix-unused-function-warning.patch

