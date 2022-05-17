Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6923AC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 17 May 2022 19:13:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349339AbiEQTNi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 17 May 2022 15:13:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352736AbiEQTNK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 May 2022 15:13:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C0134991D
        for <mm-commits@vger.kernel.org>; Tue, 17 May 2022 12:12:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A15E761631
        for <mm-commits@vger.kernel.org>; Tue, 17 May 2022 19:12:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1B93C385B8;
        Tue, 17 May 2022 19:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652814774;
        bh=1MIEPAZvFZWYOJBrGu25YnuUckxNpdl2yuOScJcyrbE=;
        h=Date:To:From:Subject:From;
        b=jotcJ1KT31Onfmfx7aZorNiRrEDFnOI0RG3uJVaqFrFhUPd4T4ypkNyDfIp9ZBUCm
         /XEoOJhK9aDHwuRyj71IQWxvONqfjj7NlRbuH/uaCgjHHsp8mxjdfQPp6Y6IKK/UXR
         l2i5B6gOwbBBDn7Lt7SokQLYMi3QckrLBh9qIVa8=
Date:   Tue, 17 May 2022 12:12:53 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rostedt@goodmis.org, joe@perches.com, vvs@openvz.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + cleanup-for-tracing-incorrect-gfp_t-conversion.patch added to mm-unstable branch
Message-Id: <20220517191253.F1B93C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/trace/events/mmflags.h: cleanup for "tracing: incorrect gfp_t conversion"
has been added to the -mm mm-unstable branch.  Its filename is
     cleanup-for-tracing-incorrect-gfp_t-conversion.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/cleanup-for-tracing-incorrect-gfp_t-conversion.patch

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
From: Vasily Averin <vvs@openvz.org>
Subject: include/trace/events/mmflags.h: cleanup for "tracing: incorrect gfp_t conversion"
Date: Tue, 17 May 2022 09:58:14 +0300

Redefines __def_gfpflag_names array according to akpm@, willy@ and Joe
Perches recommendations.

Link: https://lkml.kernel.org/r/6f811e19-41c6-f3e8-fca6-23a19a62e313@openvz.org
Fixes: fe573327ffb1 ("tracing: incorrect gfp_t conversion")
Signed-off-by: Vasily Averin <vvs@openvz.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Joe Perches <joe@perches.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/mmflags.h |   84 +++++++++++++++----------------
 1 file changed, 43 insertions(+), 41 deletions(-)

--- a/include/trace/events/mmflags.h~cleanup-for-tracing-incorrect-gfp_t-conversion
+++ a/include/trace/events/mmflags.h
@@ -13,49 +13,51 @@
  * Thus most bits set go first.
  */
 
-#define __def_gfpflag_names						\
-	{(__force unsigned long)GFP_TRANSHUGE,		"GFP_TRANSHUGE"},	\
-	{(__force unsigned long)GFP_TRANSHUGE_LIGHT,	"GFP_TRANSHUGE_LIGHT"}, \
-	{(__force unsigned long)GFP_HIGHUSER_MOVABLE,	"GFP_HIGHUSER_MOVABLE"},\
-	{(__force unsigned long)GFP_HIGHUSER,		"GFP_HIGHUSER"},	\
-	{(__force unsigned long)GFP_USER,		"GFP_USER"},		\
-	{(__force unsigned long)GFP_KERNEL_ACCOUNT,	"GFP_KERNEL_ACCOUNT"},	\
-	{(__force unsigned long)GFP_KERNEL,		"GFP_KERNEL"},		\
-	{(__force unsigned long)GFP_NOFS,		"GFP_NOFS"},		\
-	{(__force unsigned long)GFP_ATOMIC,		"GFP_ATOMIC"},		\
-	{(__force unsigned long)GFP_NOIO,		"GFP_NOIO"},		\
-	{(__force unsigned long)GFP_NOWAIT,		"GFP_NOWAIT"},		\
-	{(__force unsigned long)GFP_DMA,		"GFP_DMA"},		\
-	{(__force unsigned long)__GFP_HIGHMEM,		"__GFP_HIGHMEM"},	\
-	{(__force unsigned long)GFP_DMA32,		"GFP_DMA32"},		\
-	{(__force unsigned long)__GFP_HIGH,		"__GFP_HIGH"},		\
-	{(__force unsigned long)__GFP_ATOMIC,		"__GFP_ATOMIC"},	\
-	{(__force unsigned long)__GFP_IO,		"__GFP_IO"},		\
-	{(__force unsigned long)__GFP_FS,		"__GFP_FS"},		\
-	{(__force unsigned long)__GFP_NOWARN,		"__GFP_NOWARN"},	\
-	{(__force unsigned long)__GFP_RETRY_MAYFAIL,	"__GFP_RETRY_MAYFAIL"},	\
-	{(__force unsigned long)__GFP_NOFAIL,		"__GFP_NOFAIL"},	\
-	{(__force unsigned long)__GFP_NORETRY,		"__GFP_NORETRY"},	\
-	{(__force unsigned long)__GFP_COMP,		"__GFP_COMP"},		\
-	{(__force unsigned long)__GFP_ZERO,		"__GFP_ZERO"},		\
-	{(__force unsigned long)__GFP_NOMEMALLOC,	"__GFP_NOMEMALLOC"},	\
-	{(__force unsigned long)__GFP_MEMALLOC,		"__GFP_MEMALLOC"},	\
-	{(__force unsigned long)__GFP_HARDWALL,		"__GFP_HARDWALL"},	\
-	{(__force unsigned long)__GFP_THISNODE,		"__GFP_THISNODE"},	\
-	{(__force unsigned long)__GFP_RECLAIMABLE,	"__GFP_RECLAIMABLE"},	\
-	{(__force unsigned long)__GFP_MOVABLE,		"__GFP_MOVABLE"},	\
-	{(__force unsigned long)__GFP_ACCOUNT,		"__GFP_ACCOUNT"},	\
-	{(__force unsigned long)__GFP_WRITE,		"__GFP_WRITE"},		\
-	{(__force unsigned long)__GFP_RECLAIM,		"__GFP_RECLAIM"},	\
-	{(__force unsigned long)__GFP_DIRECT_RECLAIM,	"__GFP_DIRECT_RECLAIM"},\
-	{(__force unsigned long)__GFP_KSWAPD_RECLAIM,	"__GFP_KSWAPD_RECLAIM"},\
-	{(__force unsigned long)__GFP_ZEROTAGS,		"__GFP_ZEROTAGS"}	\
+#define gfpflag_string(flag) {(__force unsigned long)flag, #flag}
+
+#define __def_gfpflag_names			\
+	gfpflag_string(GFP_TRANSHUGE),		\
+	gfpflag_string(GFP_TRANSHUGE_LIGHT),	\
+	gfpflag_string(GFP_HIGHUSER_MOVABLE),	\
+	gfpflag_string(GFP_HIGHUSER),		\
+	gfpflag_string(GFP_USER),		\
+	gfpflag_string(GFP_KERNEL_ACCOUNT),	\
+	gfpflag_string(GFP_KERNEL),		\
+	gfpflag_string(GFP_NOFS),		\
+	gfpflag_string(GFP_ATOMIC),		\
+	gfpflag_string(GFP_NOIO),		\
+	gfpflag_string(GFP_NOWAIT),		\
+	gfpflag_string(GFP_DMA),		\
+	gfpflag_string(__GFP_HIGHMEM),		\
+	gfpflag_string(GFP_DMA32),		\
+	gfpflag_string(__GFP_HIGH),		\
+	gfpflag_string(__GFP_ATOMIC),		\
+	gfpflag_string(__GFP_IO),		\
+	gfpflag_string(__GFP_FS),		\
+	gfpflag_string(__GFP_NOWARN),		\
+	gfpflag_string(__GFP_RETRY_MAYFAIL),	\
+	gfpflag_string(__GFP_NOFAIL),		\
+	gfpflag_string(__GFP_NORETRY),		\
+	gfpflag_string(__GFP_COMP),		\
+	gfpflag_string(__GFP_ZERO),		\
+	gfpflag_string(__GFP_NOMEMALLOC),	\
+	gfpflag_string(__GFP_MEMALLOC),		\
+	gfpflag_string(__GFP_HARDWALL),		\
+	gfpflag_string(__GFP_THISNODE),		\
+	gfpflag_string(__GFP_RECLAIMABLE),	\
+	gfpflag_string(__GFP_MOVABLE),		\
+	gfpflag_string(__GFP_ACCOUNT),		\
+	gfpflag_string(__GFP_WRITE),		\
+	gfpflag_string(__GFP_RECLAIM),		\
+	gfpflag_string(__GFP_DIRECT_RECLAIM),	\
+	gfpflag_string(__GFP_KSWAPD_RECLAIM),	\
+	gfpflag_string(__GFP_ZEROTAGS)
 
 #ifdef CONFIG_KASAN_HW_TAGS
-#define __def_gfpflag_names_kasan ,					       \
-	{(__force unsigned long)__GFP_SKIP_ZERO,	   "__GFP_SKIP_ZERO"},	       \
-	{(__force unsigned long)__GFP_SKIP_KASAN_POISON,   "__GFP_SKIP_KASAN_POISON"}, \
-	{(__force unsigned long)__GFP_SKIP_KASAN_UNPOISON, "__GFP_SKIP_KASAN_UNPOISON"}
+#define __def_gfpflag_names_kasan ,			\
+	gfpflag_string(__GFP_SKIP_ZERO),		\
+	gfpflag_string(__GFP_SKIP_KASAN_POISON),	\
+	gfpflag_string(__GFP_SKIP_KASAN_UNPOISON)
 #else
 #define __def_gfpflag_names_kasan
 #endif
_

Patches currently in -mm which might be from vvs@openvz.org are

tracing-incorrect-isolate_mote_t-cast-in-mm_vmscan_lru_isolate.patch
cleanup-for-tracing-incorrect-gfp_t-conversion.patch

