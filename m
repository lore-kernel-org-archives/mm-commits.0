Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B41C3C25B08
	for <mm-commits@archiver.kernel.org>; Sat, 20 Aug 2022 05:15:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236400AbiHTFO7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 20 Aug 2022 01:14:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbiHTFO6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 20 Aug 2022 01:14:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7574AA50E8
        for <mm-commits@vger.kernel.org>; Fri, 19 Aug 2022 22:14:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 833BE60BAF
        for <mm-commits@vger.kernel.org>; Sat, 20 Aug 2022 05:14:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB862C433C1;
        Sat, 20 Aug 2022 05:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660972494;
        bh=k+EoxaYmdxnd3mL1Ivp+dfMk6ZjJkf/zpVmi7BiORII=;
        h=Date:To:From:Subject:From;
        b=DLpA2uGqP3JpZiZi+umL24J4jaxaEy3BaasCkb6fLuT8vs74SxpFcW0E2P5KaZ/3o
         TTxwFaJLMt9YdvyLWq16/DwHiAoeMt37IxH4+QEGNsXCrzZCLXQmgy6aEhRLlGQsXI
         jWXykRVh54nvZCARrpfgwYM6RWn51BKi93/MFGlE=
Date:   Fri, 19 Aug 2022 22:14:53 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memory-tiering-hot-page-selection-with-hint-page-fault-latency-fix.patch added to mm-unstable branch
Message-Id: <20220820051454.CB862C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memory-tiering-hot-page-selection-with-hint-page-fault-latency-fix.txt
has been added to the -mm mm-unstable branch.  Its filename is
     memory-tiering-hot-page-selection-with-hint-page-fault-latency-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memory-tiering-hot-page-selection-with-hint-page-fault-latency-fix.patch

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
Subject: memory-tiering-hot-page-selection-with-hint-page-fault-latency-fix.txt
Date: Fri Aug 19 10:06:07 PM PDT 2022

mm/memory.c needs memory-tiers.h

Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memory.c~memory-tiering-hot-page-selection-with-hint-page-fault-latency-fix
+++ a/mm/memory.c
@@ -65,6 +65,7 @@
 #include <linux/elf.h>
 #include <linux/gfp.h>
 #include <linux/migrate.h>
+#include <linux/memory-tiers.h>
 #include <linux/string.h>
 #include <linux/debugfs.h>
 #include <linux/userfaultfd_k.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

asm-generic-sections-refactor-memory_intersects-fix.patch
procfs-add-path-to-proc-pid-fdinfo-fix.patch
zsmalloc-zs_object_copy-add-clarifying-comment-fix.patch
memory-tiering-hot-page-selection-with-hint-page-fault-latency-fix.patch
mm-oom_kill-add-trace-logs-in-process_mrelease-system-call-fix.patch
zsmalloc-zs_object_copy-replace-email-link-to-doc-checkpatch-fixes.patch
mm-demotion-add-support-for-explicit-memory-tiers-fix.patch

