Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72E47C433F5
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:33:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57F9061279
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:33:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235756AbhKICfz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:35:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:51042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229999AbhKICfz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:35:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF0AC60FC1;
        Tue,  9 Nov 2021 02:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425190;
        bh=0LHtt6hKjULTF8OWDJhcEcC9QHkxNvSszONB67A6Tuo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=njvUSN3fr61JMeY7GQ36jk5XZ6kZi70nytuBiWMx8I3S24MMGoRz/CJS4o0hRQii6
         OOszOa8xuiaPcWSS/fpoyfUrGBELqzLgvK0uRaR8VdVm3BgDphwrzex9JkOjGOjIFr
         DH4L4pPJK6gzX+57QZg4baLpENj20xqxixOKu1mE=
Date:   Mon, 08 Nov 2021 18:33:09 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     airlied@linux.ie, akpm@linux-foundation.org, andreyknvl@gmail.com,
        daniel@ffwll.ch, dvyukov@google.com, geert@linux-m68k.org,
        glider@google.com, imran.f.khan@oracle.com, linux-mm@kvack.org,
        maarten.lankhorst@linux.intel.com, mm-commits@vger.kernel.org,
        mripard@kernel.org, ryabinin.a.a@gmail.com,
        torvalds@linux-foundation.org, tzimmermann@suse.de, vbabka@suse.cz
Subject:  [patch 33/87] lib, stackdepot: check stackdepot handle
 before accessing slabs
Message-ID: <20211109023309.Nr_R0YRU6%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
