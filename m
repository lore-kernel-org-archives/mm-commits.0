Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C142FC678D5
	for <mm-commits@archiver.kernel.org>; Sat,  4 Mar 2023 19:29:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbjCDT35 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 4 Mar 2023 14:29:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbjCDT34 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 4 Mar 2023 14:29:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763A9E07F
        for <mm-commits@vger.kernel.org>; Sat,  4 Mar 2023 11:29:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 234C2B801BB
        for <mm-commits@vger.kernel.org>; Sat,  4 Mar 2023 19:29:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1566C433D2;
        Sat,  4 Mar 2023 19:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677958192;
        bh=sStPj8lTxoAPKTI8RMqEttjyomfwzeY0DxH0fTzPR4c=;
        h=Date:To:From:Subject:From;
        b=nQebVkjzptm7vTd3SvNsJaioTsz9aijxSSDc5e0W85TQHa+/7KJvpn9e2Al8X59wy
         NofJ+hcUg8xS36AspW3YqT3RAMgzeZ3DIqCast3NP3yOwOEb5++0oM5pslTUjlYKce
         tqMqzT+QRoNjHkZKH/181TJ1yj1uQnKkMWMoOs7w=
Date:   Sat, 04 Mar 2023 11:29:51 -0800
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        senozhatsky@chromium.org, minchan@kernel.org,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping-fix-fix-fix.patch added to mm-unstable branch
Message-Id: <20230304192952.B1566C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping-fix-fix-fix
has been added to the -mm mm-unstable branch.  Its filename is
     zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping-fix-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping-fix-fix-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping-fix-fix-fix
Date: Sat Mar  4 11:29:08 AM PST 2023

initialize class_almost_full and class_almost_empty

Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/zsmalloc.c~zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping-fix-fix-fix
+++ a/mm/zsmalloc.c
@@ -625,7 +625,7 @@ static int zs_stats_size_show(struct seq
 	struct zs_pool *pool = s->private;
 	struct size_class *class;
 	int objs_per_zspage;
-	unsigned long class_almost_full, class_almost_empty;
+	unsigned long class_almost_full = 0, class_almost_empty = 0;
 	unsigned long obj_allocated, obj_used, pages_used, freeable;
 	unsigned long total_class_almost_full = 0, total_class_almost_empty = 0;
 	unsigned long total_objs = 0, total_used_objs = 0, total_pages = 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-reduce-page-alloc-free-sanity-checks-checkpatch-fixes.patch
mm-page_alloc-reduce-page-alloc-free-sanity-checks-fix.patch
mm-userfaultfd-support-wp-on-multiple-vmas-fix.patch
zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping-fix.patch
zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping-fix-fix.patch
zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping-fix-fix-fix.patch

