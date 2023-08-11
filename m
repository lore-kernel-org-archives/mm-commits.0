Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3871FC04FDF
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:01:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232749AbjHKXBt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236980AbjHKXA2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:00:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EE2E3A8B
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:00:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2EA2B67AC6
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88D47C433C8;
        Fri, 11 Aug 2023 23:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794810;
        bh=AgQvsBxEIDL4r0PeYa+h1izgsDTESWeuf7JAB+Epgt8=;
        h=Date:To:From:Subject:From;
        b=DrAAKQo5QlRSdLZJ608E7x2U1nPb9Ma/BPNycnmEq87c/NXFECaKdzeROFppPGjDX
         4DO+34m6x4jmkka/4aK/N8NbyL7Roa+L0NN9tgAz0oXs+Qmyf8cpXoh35Gu6Irvm9t
         fRrxlB9IYfr0u/LsttARuOSqAY6GxmnCRpSFzWO8=
Date:   Fri, 11 Aug 2023 16:00:10 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-remove-unneeded-header-files.patch removed from -mm tree
Message-Id: <20230811230010.88D47C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memory-failure: remove unneeded header files
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-remove-unneeded-header-files.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: memory-failure: remove unneeded header files
Date: Tue, 11 Jul 2023 13:50:13 +0800

Remove some unneeded header files. No functional change intended.

Link: https://lkml.kernel.org/r/20230711055016.2286677-6-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-remove-unneeded-header-files
+++ a/mm/memory-failure.c
@@ -39,7 +39,6 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/page-flags.h>
-#include <linux/kernel-page-flags.h>
 #include <linux/sched/signal.h>
 #include <linux/sched/task.h>
 #include <linux/dax.h>
@@ -50,7 +49,6 @@
 #include <linux/swap.h>
 #include <linux/backing-dev.h>
 #include <linux/migrate.h>
-#include <linux/suspend.h>
 #include <linux/slab.h>
 #include <linux/swapops.h>
 #include <linux/hugetlb.h>
@@ -59,7 +57,6 @@
 #include <linux/memremap.h>
 #include <linux/kfifo.h>
 #include <linux/ratelimit.h>
-#include <linux/page-isolation.h>
 #include <linux/pagewalk.h>
 #include <linux/shmem_fs.h>
 #include <linux/sysctl.h>
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memory-failure-fix-unexpected-return-value-in-soft_offline_page.patch
mm-memory-failure-fix-potential-page-refcnt-leak-in-memory_failure.patch
mm-memcg-fix-obsolete-function-name-in-mem_cgroup_protection.patch
mm-memory-failure-add-pageoffline-check.patch
mm-page_alloc-avoid-unneeded-alike_pages-calculation.patch
mm-memcg-update-obsolete-comment-above-parent_mem_cgroup.patch
mm-page_alloc-remove-unneeded-variable-base.patch
mm-memcg-fix-wrong-function-name-above-obj_cgroup_charge_zswap.patch
mm-memory-failure-use-helper-macro-llist_for_each_entry_safe.patch
mm-mm_init-use-helper-macro-bits_per_long-and-bits_per_byte.patch

