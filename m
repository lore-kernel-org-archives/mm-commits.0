Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38989C433B4
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 18:51:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 382A461206
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 18:51:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbhEMSwK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 May 2021 14:52:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:43700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230366AbhEMSwK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 13 May 2021 14:52:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC802613E6;
        Thu, 13 May 2021 18:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620931859;
        bh=6f1nI/4VK5r97eQ9HiVwECG/ZsG5cRIr9Wo+8QFXrQI=;
        h=Date:From:To:Subject:From;
        b=vlPDorBinLY89NnPk3M+yOq2/BCQl2taSvTOcL4OjT0igOe/nFIA1GdwGBQLFwXa0
         ZE6CHr4TZn4mSvpR+CQCKQ7jkl4HxH517OL5JLiupsNGX1g5Pz3cY+gMNYYxsAa8Xk
         ZxLJzv4PDh7dfNA9GALMQJpH6gq9e6Z03xrF5L6k=
Date:   Thu, 13 May 2021 11:50:58 -0700
From:   akpm@linux-foundation.org
To:     glittao@gmail.com, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, sfr@canb.auug.org.au
Subject:  +
 mm-slub-use-stackdepot-to-save-stack-trace-in-objects-fix.patch added to
 -mm tree
Message-ID: <20210513185058.W3nvLc40z%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: slub: STACKDEPOT: rename save_stack_trace()
has been added to the -mm tree.  Its filename is
     mm-slub-use-stackdepot-to-save-stack-trace-in-objects-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slub-use-stackdepot-to-save-stack-trace-in-objects-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-use-stackdepot-to-save-stack-trace-in-objects-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: slub: STACKDEPOT: rename save_stack_trace()

save_stack_trace() already exists, so change the one in
CONFIG_STACKDEPOT to be save_stack_depot_trace().

Fixes this build error:

../mm/slub.c:607:29: error: conflicting types for `save_stack_trace'
 static depot_stack_handle_t save_stack_trace(gfp_t flags)
                             ^~~~~~~~~~~~~~~~
In file included from ../include/linux/page_ext.h:6:0,
                 from ../include/linux/mm.h:25,
                 from ../mm/slub.c:13:
../include/linux/stacktrace.h:86:13: note: previous declaration of `save_stack_trace' was here
 extern void save_stack_trace(struct stack_trace *trace);
             ^~~~~~~~~~~~~~~~

from this patch in mmotm:
  Subject: mm/slub: use stackdepot to save stack trace in objects

Link: https://lkml.kernel.org/r/20210513051920.29320-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Oliver Glitta <glittao@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/slub.c~mm-slub-use-stackdepot-to-save-stack-trace-in-objects-fix
+++ a/mm/slub.c
@@ -604,7 +604,7 @@ static struct track *get_track(struct km
 }
 
 #ifdef CONFIG_STACKDEPOT
-static depot_stack_handle_t save_stack_trace(gfp_t flags)
+static depot_stack_handle_t save_stack_depot_trace(gfp_t flags)
 {
 	unsigned long entries[TRACK_ADDRS_COUNT];
 	depot_stack_handle_t handle;
@@ -623,7 +623,7 @@ static void set_track(struct kmem_cache
 
 	if (addr) {
 #ifdef CONFIG_STACKDEPOT
-		p->handle = save_stack_trace(GFP_KERNEL);
+		p->handle = save_stack_depot_trace(GFP_KERNEL);
 #endif
 		p->addr = addr;
 		p->cpu = smp_processor_id();
_

Patches currently in -mm which might be from rdunlap@infradead.org are

ia64-headers-drop-duplicated-words.patch
mm-slub-use-stackdepot-to-save-stack-trace-in-objects-fix.patch

