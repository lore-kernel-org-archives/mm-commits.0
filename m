Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94A3CC433ED
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 18:47:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61DC2613D6
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 18:47:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbhEMSsf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 May 2021 14:48:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:40702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230314AbhEMSsf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 13 May 2021 14:48:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A35061206;
        Thu, 13 May 2021 18:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620931645;
        bh=+QITl3+3x44bTcwZ7I4qRJADpCXw+uDJ+cfV0q/JFMI=;
        h=Date:From:To:Subject:From;
        b=2oPILSUAbXdqJ29n3PSkHWHrlK/DyKoFvsax1dVvOC8+SOg3B5b8DWP1QB2hjhNb5
         9GjWohq25rPeQxyRr6PNTv/tjm2azeF6kVNU1bcQ7gwBfTT2rt7U76f/BxBD+fKnIz
         YKNM5L0F3sMfeALnPsfs8HLYz0jX6B4BjpFzfHAQ=
Date:   Thu, 13 May 2021 11:47:24 -0700
From:   akpm@linux-foundation.org
To:     glittao@gmail.com, mm-commits@vger.kernel.org,
        rdunlap@infradead.org
Subject:  +
 mm-slub-use-stackdepot-to-save-stack-trace-in-objects-fix.patch added to
 -mm tree
Message-ID: <20210513184724.99FuVYM3N%akpm@linux-foundation.org>
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

