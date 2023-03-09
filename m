Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53A5DC61DA4
	for <mm-commits@archiver.kernel.org>; Thu,  9 Mar 2023 20:54:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbjCIUyB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Mar 2023 15:54:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231350AbjCIUxn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Mar 2023 15:53:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0541E3C785
        for <mm-commits@vger.kernel.org>; Thu,  9 Mar 2023 12:53:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5681A61CC3
        for <mm-commits@vger.kernel.org>; Thu,  9 Mar 2023 20:53:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0A53C433D2;
        Thu,  9 Mar 2023 20:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678395194;
        bh=AMbUy73FgnJoB8v0FMSNRJBsmMuJ/xpknoKqiweif3A=;
        h=Date:To:From:Subject:From;
        b=mz59x8rXGNfSJpx+GfF4f4tQdx4J7qFK636YN9AbIF/WMDbnh7WdqQO+uJ5ZknVET
         IVxWh3R9cCAhEQ45pe3r9DVzteCzHAVRt/z4arHTVkuZsoMwTJ3kNLb9KGRBurLAuX
         dI1GOt+RzwZOoDcnsrbHpeqBYm22VLw0D/+UPhg8=
Date:   Thu, 09 Mar 2023 12:53:13 -0800
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        vbabka@suse.cz, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shrinkers-make-count-and-scan-in-shrinker-debugfs-lockless-fix.patch added to mm-unstable branch
Message-Id: <20230309205314.A0A53C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-shrinkers-make-count-and-scan-in-shrinker-debugfs-lockless-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shrinkers-make-count-and-scan-in-shrinker-debugfs-lockless-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shrinkers-make-count-and-scan-in-shrinker-debugfs-lockless-fix.patch

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
Subject: mm-shrinkers-make-count-and-scan-in-shrinker-debugfs-lockless-fix
Date: Thu Mar  9 12:52:15 PM PST 2023

include linux/srcu.h, per Vlaistimil

Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/shrinker_debug.c~mm-shrinkers-make-count-and-scan-in-shrinker-debugfs-lockless-fix
+++ a/mm/shrinker_debug.c
@@ -2,6 +2,7 @@
 #include <linux/idr.h>
 #include <linux/slab.h>
 #include <linux/debugfs.h>
+#include <linux/srcu.h>
 #include <linux/seq_file.h>
 #include <linux/shrinker.h>
 #include <linux/memcontrol.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-reduce-page-alloc-free-sanity-checks-checkpatch-fixes.patch
mm-page_alloc-reduce-page-alloc-free-sanity-checks-fix.patch
mm-userfaultfd-support-wp-on-multiple-vmas-fix.patch
mm-shrinkers-make-count-and-scan-in-shrinker-debugfs-lockless-fix.patch
scripts-link-vmlinuxsh-fix-error-message-presentation.patch

