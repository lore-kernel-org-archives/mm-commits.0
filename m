Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05FD6C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:52:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5BB961108
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:52:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234555AbhKKCy7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:54:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:58560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234548AbhKKCy5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:54:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8866960F26;
        Thu, 11 Nov 2021 02:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599128;
        bh=D/m0fV04K9H5/xn2+C2cu7HrJmL1dmsTkp6JSqqrLJc=;
        h=Date:From:To:Subject:From;
        b=oLoaNRO7ZntKcx52lIfKnomEIC+t1dAjFvpsDgs5QswWDqb66jrrcRUcP4WjSswA4
         x1ZDhBhMCgLPICYTOp1VdmLLIXyzYfChyTd1oNx6HG0e420KwzpfM0KvOWXG7Qau+E
         mtVAY/8FKuNyj9Z7/9/Xb6fwgwlK6U5BJalF8L8Q=
Date:   Wed, 10 Nov 2021 18:52:08 -0800
From:   akpm@linux-foundation.org
To:     airlied@linux.ie, andreyknvl@gmail.com, daniel@ffwll.ch,
        dvyukov@google.com, geert@linux-m68k.org, glider@google.com,
        imran.f.khan@oracle.com, maarten.lankhorst@linux.intel.com,
        mm-commits@vger.kernel.org, mripard@kernel.org,
        ryabinin.a.a@gmail.com, tzimmermann@suse.de, vbabka@suse.cz
Subject:  [merged]
 lib-stackdepot-check-stackdepot-handle-before-accessing-slabs.patch removed
 from -mm tree
Message-ID: <20211111025208.ipF9tNUUy%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib, stackdepot: check stackdepot handle before accessing slabs
has been removed from the -mm tree.  Its filename was
     lib-stackdepot-check-stackdepot-handle-before-accessing-slabs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Imran Khan <imran.f.khan@oracle.com>
Subject: lib, stackdepot: check stackdepot handle before accessing slabs

Patch series "lib, stackdepot: check stackdepot handle before accessing slabs", v2.

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

Link: https://lkml.kernel.org/r/20210915175321.3472770-1-imran.f.khan@oracle.com
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
@@ -231,6 +231,9 @@ unsigned int stack_depot_fetch(depot_sta
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


