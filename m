Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECD07C4332F
	for <mm-commits@archiver.kernel.org>; Wed, 25 May 2022 17:49:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343510AbiEYRtD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 May 2022 13:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343505AbiEYRs7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 May 2022 13:48:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC572018E
        for <mm-commits@vger.kernel.org>; Wed, 25 May 2022 10:48:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF966B81E88
        for <mm-commits@vger.kernel.org>; Wed, 25 May 2022 17:48:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AB4FC385B8;
        Wed, 25 May 2022 17:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653500933;
        bh=o0JbUPYwhk9ZlyzWhKwLNtVUgFlIwS5IgOs2G0BhORQ=;
        h=Date:To:From:Subject:From;
        b=IYUf7xlwoFC2sKXK8xcAT1u3lsPYz2GMuFOaa3uBbClyzEyp3Dp+NUrM0ZobILBoh
         71kKwGUWMBg3+8hE236dt/0k6zQLZhA6WomWswTuG21bTji2bS0qnQbq4Nj6WZVtT5
         0ha2GHk97dlsMLvjLr7SJzX06vXa+TQlHmkIihIQ=
Date:   Wed, 25 May 2022 10:48:52 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rostedt@goodmis.org, joe@perches.com, vvs@openvz.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] cleanup-for-tracing-incorrect-gfp_t-conversion.patch removed from -mm tree
Message-Id: <20220525174853.7AB4FC385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: include/trace/events/mmflags.h: cleanup for "tracing: incorrect gfp_t conversion"
has been removed from the -mm tree.  Its filename was
     cleanup-for-tracing-incorrect-gfp_t-conversion.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


