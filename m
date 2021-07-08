Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B16B8C07E95
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 00:29:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87C2B61C91
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 00:29:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhGHAc1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jul 2021 20:32:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:39924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230000AbhGHAc1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 7 Jul 2021 20:32:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA2EF61CAA;
        Thu,  8 Jul 2021 00:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625704186;
        bh=0CI9oP9NL5PLOvjW4RR+WIigLyR6wF0C5Hhb07CTSZ0=;
        h=Date:From:To:Subject:From;
        b=uZH4fW8+Z0fMKB/OSNJOPPuVW/Y8NN5D/WvwpUE2F++NGj0UQsE3tgojC+rRkqvdp
         1HN/OKvteV+ABRqnxR4hnuUlUWfedue8fNavu7G0jB0reeBRZ5rQjkh2UFEpwV9iu3
         rmdGqjkg/9xA1hMpOfmZFx/21Trc1S9+HYh5clRk=
Date:   Wed, 07 Jul 2021 17:29:45 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        glittao@gmail.com, rdunlap@infradead.org
Subject:  [folded-merged]
 mm-slub-use-stackdepot-to-save-stack-trace-in-objects-fix.patch removed from
 -mm tree
Message-ID: <20210708002945.V8Yv6%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: slub: STACKDEPOT: rename save_stack_trace()
has been removed from the -mm tree.  Its filename was
     mm-slub-use-stackdepot-to-save-stack-trace-in-objects-fix.patch

This patch was dropped because it was folded into mm-slub-use-stackdepot-to-save-stack-trace-in-objects.patch

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
@@ -627,7 +627,7 @@ static struct track *get_track(struct km
 }
 
 #ifdef CONFIG_STACKDEPOT
-static depot_stack_handle_t save_stack_trace(gfp_t flags)
+static depot_stack_handle_t save_stack_depot_trace(gfp_t flags)
 {
 	unsigned long entries[TRACK_ADDRS_COUNT];
 	depot_stack_handle_t handle;
@@ -646,7 +646,7 @@ static void set_track(struct kmem_cache
 
 	if (addr) {
 #ifdef CONFIG_STACKDEPOT
-		p->handle = save_stack_trace(GFP_KERNEL);
+		p->handle = save_stack_depot_trace(GFP_KERNEL);
 #endif
 		p->addr = addr;
 		p->cpu = smp_processor_id();
_

Patches currently in -mm which might be from rdunlap@infradead.org are

mm-slub-use-stackdepot-to-save-stack-trace-in-objects.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-2.patch

