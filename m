Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C41FEE49A6
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:44:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbjHUUoX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbjHUUni (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:43:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F513CED
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:42:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41645616F5
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:42:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98856C433C8;
        Mon, 21 Aug 2023 20:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650529;
        bh=By7mcO2iCx3TxMEoMMEzgMZeLsbgZcJtuMfm6SwkKzI=;
        h=Date:To:From:Subject:From;
        b=jl2kDxtgF1TfkshZZ6oO/qGC+UJaBrkxBJB64CMerUXSNCkCjeyNAHOid01hMg/4M
         PkfVRji7/THXZCBM+6E21TvgWdLfQk0mBaj8GeGFshq4YbZWby1B2KswmQgwvB2jy7
         e1oOPPVLyfA2/Yzhfye880MwiNw+S+qFHfc/tQLI=
Date:   Mon, 21 Aug 2023 13:42:09 -0700
To:     mm-commits@vger.kernel.org, zhaoyang.huang@unisoc.com,
        vbabka@suse.cz, glider@google.com, catalin.marinas@arm.com,
        andreyknvl@gmail.com, xiaolei.wang@windriver.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kmemleak-use-object_cache-instead-of-kmemleak_initialized-to-check-in-set_track_prepare.patch removed from -mm tree
Message-Id: <20230821204209.98856C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/kmemleak: use object_cache instead of kmemleak_initialized to check in set_track_prepare()
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-use-object_cache-instead-of-kmemleak_initialized-to-check-in-set_track_prepare.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Xiaolei Wang <xiaolei.wang@windriver.com>
Subject: mm/kmemleak: use object_cache instead of kmemleak_initialized to check in set_track_prepare()
Date: Tue, 15 Aug 2023 22:41:27 +0800

Patch series "mm/kmemleak: use object_cache instead of
kmemleak_initialized", v3.

Use object_cache instead of kmemleak_initialized to check in
set_track_prepare(), so that memory leaks after kmemleak_init() can be
recorded and Rename kmemleak_initialized to kmemleak_late_initialized

unreferenced object 0xc674ca80 (size 64):
 comm "swapper/0", pid 1, jiffies 4294938337 (age 204.880s)
 hex dump (first 32 bytes):
  80 55 75 c6 80 54 75 c6 00 55 75 c6 80 52 75 c6 .Uu..Tu..Uu..Ru.
  00 53 75 c6 00 00 00 00 00 00 00 00 00 00 00 00 .Su..........


This patch (of 2):

kmemleak_initialized is set in kmemleak_late_init(), which also means that
there is no call trace which object's memory leak is before
kmemleak_late_init(), so use object_cache instead of kmemleak_initialized
to check in set_track_prepare() to avoid no call trace records when there
is a memory leak in the code between kmemleak_init() and
kmemleak_late_init().

unreferenced object 0xc674ca80 (size 64):
 comm "swapper/0", pid 1, jiffies 4294938337 (age 204.880s)
 hex dump (first 32 bytes):
  80 55 75 c6 80 54 75 c6 00 55 75 c6 80 52 75 c6 .Uu..Tu..Uu..Ru.
  00 53 75 c6 00 00 00 00 00 00 00 00 00 00 00 00 .Su..........

Link: https://lkml.kernel.org/r/20230815144128.3623103-1-xiaolei.wang@windriver.com
Link: https://lkml.kernel.org/r/20230815144128.3623103-2-xiaolei.wang@windriver.com
Fixes: 56a61617dd22 ("mm: use stack_depot for recording kmemleak's backtrace")
Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/kmemleak.c~mm-kmemleak-use-object_cache-instead-of-kmemleak_initialized-to-check-in-set_track_prepare
+++ a/mm/kmemleak.c
@@ -610,7 +610,12 @@ static noinline depot_stack_handle_t set
 	unsigned long entries[MAX_TRACE];
 	unsigned int nr_entries;
 
-	if (!kmemleak_initialized)
+	/*
+	 * Use object_cache to determine whether kmemleak_init() has
+	 * been invoked. stack_depot_early_init() is called before
+	 * kmemleak_init() in mm_core_init().
+	 */
+	if (!object_cache)
 		return 0;
 	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 3);
 	trace_handle = stack_depot_save(entries, nr_entries, GFP_NOWAIT);
_

Patches currently in -mm which might be from xiaolei.wang@windriver.com are


