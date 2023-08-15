Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69A8BC04A94
	for <mm-commits@archiver.kernel.org>; Tue, 15 Aug 2023 20:44:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239099AbjHOUnm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Aug 2023 16:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239618AbjHOUn3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Aug 2023 16:43:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 210361FD4
        for <mm-commits@vger.kernel.org>; Tue, 15 Aug 2023 13:43:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A83B65389
        for <mm-commits@vger.kernel.org>; Tue, 15 Aug 2023 20:41:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5195C433C7;
        Tue, 15 Aug 2023 20:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692132102;
        bh=fhNFaqAdjTcg4ALRDhDv9BR9UixVYCHV+BEaOUDwNmk=;
        h=Date:To:From:Subject:From;
        b=YYyxOTFIHu4bhrnqZJuexgzvocrGYhG/xA81BJD0lVuJ1aYa49x9IV+Dc+FtydT0Z
         B+276qmEmuQT9WqniQwDX+5iaOK0RGfEAeVOEvjip0s4Tmc/+DegENTH7m+z3pjUtx
         vnmGOOasbMMmpCCHDe83Bdtmr6gH/GakjlK0LukM=
Date:   Tue, 15 Aug 2023 13:41:42 -0700
To:     mm-commits@vger.kernel.org, zhaoyang.huang@unisoc.com,
        vbabka@suse.cz, glider@google.com, catalin.marinas@arm.com,
        andreyknvl@gmail.com, xiaolei.wang@windriver.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-use-object_cache-instead-of-kmemleak_initialized-to-check-in-set_track_prepare.patch added to mm-unstable branch
Message-Id: <20230815204142.C5195C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kmemleak: use object_cache instead of kmemleak_initialized to check in set_track_prepare()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kmemleak-use-object_cache-instead-of-kmemleak_initialized-to-check-in-set_track_prepare.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmemleak-use-object_cache-instead-of-kmemleak_initialized-to-check-in-set_track_prepare.patch

This patch will later appear in the mm-unstable branch at
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

mm-kmemleak-use-object_cache-instead-of-kmemleak_initialized-to-check-in-set_track_prepare.patch
rename-kmemleak_initialized-to-kmemleak_late_initialized.patch

