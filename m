Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF7BEC7619A
	for <mm-commits@archiver.kernel.org>; Wed,  5 Apr 2023 22:00:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbjDEWAt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 18:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231429AbjDEWAr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 18:00:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FD4C7692
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 15:00:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00B8F6419D
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 22:00:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5287EC433D2;
        Wed,  5 Apr 2023 22:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680732045;
        bh=w9GrMCyBjgLWQ3YV/IXWJ3QABSMWq3GZEN2ygQQlENQ=;
        h=Date:To:From:Subject:From;
        b=A0JNN3NXkGcwQ8KrstorI7FJf7vb9oAqDSOIACjtpCXH2CBHFSFrNGReaRl+514IY
         rae93kXSTGgOLknNvymiZT1DSRXKBe5qTPeiQ6agQFCmHRWhNcdzoQGjlSZT98CPwF
         oq74SR7O/UTBjmBCZYEIShVxJt1wr8rM1z4/dZjg=
Date:   Wed, 05 Apr 2023 15:00:44 -0700
To:     mm-commits@vger.kernel.org, walken@google.com,
        goldstein.w.n@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-rbtree-use-instead-of-for-setting-color.patch added to mm-nonmm-unstable branch
Message-Id: <20230405220045.5287EC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/rbtree: use '+' instead of '|' for setting color.
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-rbtree-use-instead-of-for-setting-color.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-rbtree-use-instead-of-for-setting-color.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Cc: Michel Lespinasse <walken@google.com>
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

lib-rbtree-use-instead-of-for-setting-color.patch

