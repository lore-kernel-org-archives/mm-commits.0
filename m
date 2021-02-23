Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28BB1C433DB
	for <mm-commits@archiver.kernel.org>; Tue, 23 Feb 2021 21:07:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED66264E00
	for <mm-commits@archiver.kernel.org>; Tue, 23 Feb 2021 21:07:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233185AbhBWVHl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 23 Feb 2021 16:07:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:51294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232050AbhBWVHh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 23 Feb 2021 16:07:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12B9F64E60;
        Tue, 23 Feb 2021 21:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614114416;
        bh=22ryb/B4GlXmXwTGg7vsSTCyDgba+2MHyFCxKJKWS2E=;
        h=Date:From:To:Subject:From;
        b=LzYo9tMxcaC0CTc+yfqPHdT65uRZw3lV0xibOwQHLH7FoqVjAurEsrR76nkgYlAgF
         KHMdLnkDx0GF05Nvh9ODv5K3WgOyDDYVp28+762qjD9XfYkb+vCJXSFCtdKZ43cUO5
         UTYpUSfVifYtBGouhuR5Tiaah532BXOK08OgQXUM=
Date:   Tue, 23 Feb 2021 13:06:55 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-git-rejects.patch added to -mm tree
Message-ID: <20210223210655.pGMPY4GRT%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwtracing/coresight/coresight-etm4x-core.c |    4 ----
 init/Kconfig                                       |    4 ----
 2 files changed, 8 deletions(-)

--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c~linux-next-git-rejects
+++ a/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -1899,11 +1899,7 @@ static void clear_etmdrvdata(void *info)
 	etmdrvdata[cpu] = NULL;
 }
 
-<<<<<<< HEAD
-static void etm4_remove(struct amba_device *adev)
-=======
 static int __exit etm4_remove_dev(struct etmv4_drvdata *drvdata)
->>>>>>> linux-next/akpm-base
 {
 	etm_perf_symlink(drvdata->csdev, false);
 	/*
--- a/init/Kconfig~linux-next-git-rejects
+++ a/init/Kconfig
@@ -2266,10 +2266,6 @@ config MODULE_ALLOW_MISSING_NAMESPACE_IM
 
 config TRIM_UNUSED_KSYMS
 	bool "Trim unused exported kernel symbols"
-<<<<<<< HEAD
-	depends on BROKEN
-=======
->>>>>>> linux-next/akpm-base
 	help
 	  The kernel and some modules make many symbols available for
 	  other modules to use via EXPORT_SYMBOL() and variants. Depending
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account-fix.patch
mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage-checkpatch-fixes.patch
mm-memcg-add-swapcache-stat-for-memcg-v2-fix.patch
kasan-add-match-all-tag-tests-fix-fix.patch
mm-cma-allocate-cma-areas-bottom-up-fix-3-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
mm-memory_hotplug-prevalidate-the-address-range-being-added-with-platform-fix.patch
bdi-use-might_alloc-fix.patch
kfence-kasan-make-kfence-compatible-with-kasan-fix.patch
lib-stackdepot-add-support-to-disable-stack-depot-fix.patch
seq_file-document-how-per-entry-resources-are-managed-fix.patch
initramfs-panic-with-memory-information-fix.patch
linux-next-rejects.patch
fs-ramfs-inodec-update-inode_operationstmpfile.patch
kernel-forkc-export-kernel_thread-to-modules.patch
linux-next-git-rejects.patch

