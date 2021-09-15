Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 342D5C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 01:58:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F47561242
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 01:58:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233061AbhIOB73 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Sep 2021 21:59:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:42964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231979AbhIOB73 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 14 Sep 2021 21:59:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 865956121E;
        Wed, 15 Sep 2021 01:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631671091;
        bh=w3y6HyKA4HupirJDz/gqmRI4oFYQRS6kNblsp2JxyaE=;
        h=Date:From:To:Subject:From;
        b=ca11fJLr/CBMrZo1r3aoSPxypRiR39DWYM1oQJS631C2qJXYMu/DhoaP13rO4RbVZ
         r53OyoKh9SLC0D7dGt/NalEN2iHV8gFzwJiCXikxR9vjOZyPJB415nUQr6U6vTJmEs
         IQuVwtCzKeXQzX81LwnQrz0P0i14nJDoklWDhpPA=
Date:   Tue, 14 Sep 2021 18:58:09 -0700
From:   akpm@linux-foundation.org
To:     airlied@linux.ie, andreyknvl@gmail.com, daniel@ffwll.ch,
        dvyukov@google.com, geert@linux-m68k.org, glider@google.com,
        imran.f.khan@oracle.com, maarten.lankhorst@linux.intel.com,
        mm-commits@vger.kernel.org, mripard@kernel.org,
        ryabinin.a.a@gmail.com, tzimmermann@suse.de, vbabka@suse.cz
Subject:  +
 lib-stackdepot-check-stackdepot-handle-before-accessing-slabs.patch added
 to -mm tree
Message-ID: <20210915015809.sdaEPVF_U%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib, stackdepot: check stackdepot handle before accessing slabs
has been added to the -mm tree.  Its filename is
     lib-stackdepot-check-stackdepot-handle-before-accessing-slabs.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-stackdepot-check-stackdepot-handle-before-accessing-slabs.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-stackdepot-check-stackdepot-handle-before-accessing-slabs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Imran Khan <imran.f.khan@oracle.com>
Subject: lib, stackdepot: check stackdepot handle before accessing slabs

Patch series "lib, stackdepot: check stackdepot handle before accessing slabs".

PATCH-1: Checks validity of a stackdepot handle before proceeding to
access stackdepot slab/objects.

PATCH-2: Adds a helper in stackdepot, to allow users to print stack
entries just by specifying the stackdepot handle.  It also changes such
users to use this new interface.  

PATCH-3: Adds a helper in stackdepot, to allow users to print stack
entries into buffers just by specifying the stackdepot handle and
destination buffer.  It also changes such users to use this new interface.


This patch (of 3):

stack_depot_save allocates slabs that will be used for storing objects in
future.If this slab allocation fails we may get to a situation where space
allocation for a new stack_record fails, causing stack_depot_save to
return 0 as handle.  If user of this handle ends up invoking
stack_depot_fetch with this handle value, current implementation of
stack_depot_fetch will end up using slab from wrong index.  To avoid this
check handle value at the beginning.

Link: https://lkml.kernel.org/r/20210915014806.3206938-1-imran.f.khan@oracle.com
Link: https://lkml.kernel.org/r/20210915014806.3206938-2-imran.f.khan@oracle.com
Signed-off-by: Imran Khan <imran.f.khan@oracle.com>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/lib/stackdepot.c~lib-stackdepot-check-stackdepot-handle-before-accessing-slabs
+++ a/lib/stackdepot.c
@@ -232,6 +232,9 @@ unsigned int stack_depot_fetch(depot_sta
 	struct stack_record *stack;
 
 	*entries = NULL;
+	if (!handle)
+		return 0;
+
 	if (parts.slabindex > depot_index) {
 		WARN(1, "slab index %d out of bounds (%d) for stack id %08x\n",
 			parts.slabindex, depot_index, handle);
_

Patches currently in -mm which might be from imran.f.khan@oracle.com are

lib-stackdepot-check-stackdepot-handle-before-accessing-slabs.patch
lib-stackdepot-add-helper-to-print-stack-entries.patch
lib-stackdepot-add-helper-to-print-stack-entries-into-buffer.patch

