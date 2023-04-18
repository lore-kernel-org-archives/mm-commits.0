Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 736BCC77B75
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:41:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbjDRXlk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231560AbjDRXlI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:41:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58121BBAA
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:40:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC22F630B3
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32357C4339B;
        Tue, 18 Apr 2023 23:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681861220;
        bh=jT+B1GF1PI+YpbEtX1GKQQTv1puXxFK4I7kpRD6Zzxg=;
        h=Date:To:From:Subject:From;
        b=hfVAwldc6U6rcT1IRUubLYrva1VTbzKtDKbSAW3yD5WPlbKx0vju8BZhXHPoCPzxi
         Lg3wDfdaOTgF5+w8ro4V5Z2lCtT7vzHhw/blNQa9jyOESvWNvnykqq8E2P5PC71HVi
         Sniwz+8vYhPAZF8/RDI74u/l3Ul40iop6olJNH1M=
Date:   Tue, 18 Apr 2023 16:40:19 -0700
To:     mm-commits@vger.kernel.org, michel@lespinasse.org,
        goldstein.w.n@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-rbtree-use-instead-of-for-setting-color.patch removed from -mm tree
Message-Id: <20230418234020.32357C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/rbtree: use '+' instead of '|' for setting color.
has been removed from the -mm tree.  Its filename was
     lib-rbtree-use-instead-of-for-setting-color.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Noah Goldstein <goldstein.w.n@gmail.com>
Subject: lib/rbtree: use '+' instead of '|' for setting color.
Date: Tue, 4 Apr 2023 17:13:51 -0500

This has a slight benefit for x86 and has no effect on other targets.

The benefit to x86 is it change the codegen for setting a node to block
from `mov %r0, %r1; or $RB_BLACK, %r1` to `lea RB_BLACK(%r0), %r1` which
saves an instructions.

In all other cases it just replace ALU with ALU (or -> and) which
perform the same on all machines I am aware of.

Total instructions in rbtree.o:
    Before  - 802
    After   - 782

so it saves about 20 `mov` instructions.

Link: https://lkml.kernel.org/r/20230404221350.3806566-1-goldstein.w.n@gmail.com
Signed-off-by: Noah Goldstein <goldstein.w.n@gmail.com>
Cc: Michel Lespinasse <michel@lespinasse.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rbtree_augmented.h |    4 ++--
 lib/rbtree.c                     |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/rbtree_augmented.h~lib-rbtree-use-instead-of-for-setting-color
+++ a/include/linux/rbtree_augmented.h
@@ -156,13 +156,13 @@ RB_DECLARE_CALLBACKS(RBSTATIC, RBNAME,
 
 static inline void rb_set_parent(struct rb_node *rb, struct rb_node *p)
 {
-	rb->__rb_parent_color = rb_color(rb) | (unsigned long)p;
+	rb->__rb_parent_color = rb_color(rb) + (unsigned long)p;
 }
 
 static inline void rb_set_parent_color(struct rb_node *rb,
 				       struct rb_node *p, int color)
 {
-	rb->__rb_parent_color = (unsigned long)p | color;
+	rb->__rb_parent_color = (unsigned long)p + color;
 }
 
 static inline void
--- a/lib/rbtree.c~lib-rbtree-use-instead-of-for-setting-color
+++ a/lib/rbtree.c
@@ -58,7 +58,7 @@
 
 static inline void rb_set_black(struct rb_node *rb)
 {
-	rb->__rb_parent_color |= RB_BLACK;
+	rb->__rb_parent_color += RB_BLACK;
 }
 
 static inline struct rb_node *rb_red_parent(struct rb_node *red)
_

Patches currently in -mm which might be from goldstein.w.n@gmail.com are


