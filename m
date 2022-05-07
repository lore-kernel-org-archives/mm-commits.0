Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 771D1C433EF
	for <mm-commits@archiver.kernel.org>; Sat,  7 May 2022 23:00:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344491AbiEGXEN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 7 May 2022 19:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbiEGXEM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 7 May 2022 19:04:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32DB21011
        for <mm-commits@vger.kernel.org>; Sat,  7 May 2022 16:00:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7B0DB8015B
        for <mm-commits@vger.kernel.org>; Sat,  7 May 2022 23:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39880C385AF;
        Sat,  7 May 2022 23:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651964420;
        bh=OBXcRU+3Fd0x3plMzDSYCg2/sTu1IyYM8s6nmF7MhfI=;
        h=Date:To:From:Subject:From;
        b=v4PgjT1SDOCSPHpmxcfPK1R8Kc0uNwghJObAu5jCcjPDxoC8MXYsGg3IR93QZuuuj
         1yyIF9+IKcCzQ50hMxhZ56wVdfkFe1ZVfWMbx/P7cTuJ3awF6GFDSdnN68FaDQHkNa
         m/ei6267HkXFyH16Ekfse9voIALe9QMu6jDVt6/8=
Date:   Sat, 07 May 2022 16:00:19 -0700
To:     mm-commits@vger.kernel.org, vvs@openvz.org, rostedt@goodmis.org,
        mingo@redhat.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] tracing-incorrect-gfp_t-conversion-fix.patch removed from -mm tree
Message-Id: <20220507230020.39880C385AF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: tracing-incorrect-gfp_t-conversion-fix
has been removed from the -mm tree.  Its filename was
     tracing-incorrect-gfp_t-conversion-fix.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: tracing-incorrect-gfp_t-conversion-fix

add FUL macro for readability

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Vasily Averin <vvs@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/mmflags.h |   84 ++++++++++++++++---------------
 1 file changed, 44 insertions(+), 40 deletions(-)

--- a/include/trace/events/mmflags.h~tracing-incorrect-gfp_t-conversion-fix
+++ a/include/trace/events/mmflags.h
@@ -13,53 +13,57 @@
  * Thus most bits set go first.
  */
 
+#define FUL __force unsigned long
+
 #define __def_gfpflag_names						\
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
+	{(FUL)GFP_TRANSHUGE,		"GFP_TRANSHUGE"},		\
+	{(FUL)GFP_TRANSHUGE_LIGHT,	"GFP_TRANSHUGE_LIGHT"}, 	\
+	{(FUL)GFP_HIGHUSER_MOVABLE,	"GFP_HIGHUSER_MOVABLE"},	\
+	{(FUL)GFP_HIGHUSER,		"GFP_HIGHUSER"},		\
+	{(FUL)GFP_USER,			"GFP_USER"},			\
+	{(FUL)GFP_KERNEL_ACCOUNT,	"GFP_KERNEL_ACCOUNT"},		\
+	{(FUL)GFP_KERNEL,		"GFP_KERNEL"},			\
+	{(FUL)GFP_NOFS,			"GFP_NOFS"},			\
+	{(FUL)GFP_ATOMIC,		"GFP_ATOMIC"},			\
+	{(FUL)GFP_NOIO,			"GFP_NOIO"},			\
+	{(FUL)GFP_NOWAIT,		"GFP_NOWAIT"},			\
+	{(FUL)GFP_DMA,			"GFP_DMA"},			\
+	{(FUL)__GFP_HIGHMEM,		"__GFP_HIGHMEM"},		\
+	{(FUL)GFP_DMA32,		"GFP_DMA32"},			\
+	{(FUL)__GFP_HIGH,		"__GFP_HIGH"},			\
+	{(FUL)__GFP_ATOMIC,		"__GFP_ATOMIC"},		\
+	{(FUL)__GFP_IO,			"__GFP_IO"},			\
+	{(FUL)__GFP_FS,			"__GFP_FS"},			\
+	{(FUL)__GFP_NOWARN,		"__GFP_NOWARN"},		\
+	{(FUL)__GFP_RETRY_MAYFAIL,	"__GFP_RETRY_MAYFAIL"},		\
+	{(FUL)__GFP_NOFAIL,		"__GFP_NOFAIL"},		\
+	{(FUL)__GFP_NORETRY,		"__GFP_NORETRY"},		\
+	{(FUL)__GFP_COMP,		"__GFP_COMP"},			\
+	{(FUL)__GFP_ZERO,		"__GFP_ZERO"},			\
+	{(FUL)__GFP_NOMEMALLOC,		"__GFP_NOMEMALLOC"},		\
+	{(FUL)__GFP_MEMALLOC,		"__GFP_MEMALLOC"},		\
+	{(FUL)__GFP_HARDWALL,		"__GFP_HARDWALL"},		\
+	{(FUL)__GFP_THISNODE,		"__GFP_THISNODE"},		\
+	{(FUL)__GFP_RECLAIMABLE,	"__GFP_RECLAIMABLE"},		\
+	{(FUL)__GFP_MOVABLE,		"__GFP_MOVABLE"},		\
+	{(FUL)__GFP_ACCOUNT,		"__GFP_ACCOUNT"},		\
+	{(FUL)__GFP_WRITE,		"__GFP_WRITE"},			\
+	{(FUL)__GFP_RECLAIM,		"__GFP_RECLAIM"},		\
+	{(FUL)__GFP_DIRECT_RECLAIM,	"__GFP_DIRECT_RECLAIM"},	\
+	{(FUL)__GFP_KSWAPD_RECLAIM,	"__GFP_KSWAPD_RECLAIM"},	\
+	{(FUL)__GFP_ZEROTAGS,		"__GFP_ZEROTAGS"}		\
 
 #ifdef CONFIG_KASAN_HW_TAGS
-#define __def_gfpflag_names_kasan ,					       \
-	{(__force unsigned long)__GFP_SKIP_ZERO,	   "__GFP_SKIP_ZERO"},	       \
-	{(__force unsigned long)__GFP_SKIP_KASAN_POISON,   "__GFP_SKIP_KASAN_POISON"}, \
-	{(__force unsigned long)__GFP_SKIP_KASAN_UNPOISON, "__GFP_SKIP_KASAN_UNPOISON"}
+#define __def_gfpflag_names_kasan ,					\
+	{(FUL)__GFP_SKIP_ZERO,		"__GFP_SKIP_ZERO"},		\
+	{(FUL)__GFP_SKIP_KASAN_POISON,	"__GFP_SKIP_KASAN_POISON"},	\
+	{(FUL)__GFP_SKIP_KASAN_UNPOISON,"__GFP_SKIP_KASAN_UNPOISON"}
 #else
 #define __def_gfpflag_names_kasan
 #endif
 
+#undef FUL
+
 #define show_gfp_flags(flags)						\
 	(flags) ? __print_flags(flags, "|",				\
 	__def_gfpflag_names __def_gfpflag_names_kasan			\
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-create-new-mm-swaph-header-file-fix.patch
mm-page_alloc-cache-the-result-of-node_dirty_ok-fix.patch
mm-check-against-orig_pte-for-finish_fault-fix-checkpatch-fixes.patch
mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix-fix.patch
kfence-enable-check-kfence-canary-on-panic-via-boot-param-fix.patch
lib-kstrtoxc-add-false-true-support-to-kstrtobool-fix.patch
mm-vmscan-not-necessary-to-re-init-the-list-for-each-iteration-fix.patch
mm-make-minimum-slab-alignment-a-runtime-property-fix.patch
proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

