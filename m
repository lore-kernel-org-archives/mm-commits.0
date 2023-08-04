Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07972C001DE
	for <mm-commits@archiver.kernel.org>; Fri,  4 Aug 2023 18:12:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbjHDSMo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Aug 2023 14:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbjHDSMY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Aug 2023 14:12:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 873A849E0
        for <mm-commits@vger.kernel.org>; Fri,  4 Aug 2023 11:12:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19399620E3
        for <mm-commits@vger.kernel.org>; Fri,  4 Aug 2023 18:12:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD54C433C8;
        Fri,  4 Aug 2023 18:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691172729;
        bh=4X67b1L111iioRcwMXkAnxQLn/OlBPHmbCX8d6xZklo=;
        h=Date:To:From:Subject:From;
        b=To6kzfgWmx5rwd73/Lp/KAznZ9CgPVs5oxxoQHVpo6VKJI5jvvm8zUTzTzkLlYkUn
         DiF5KV2J9hg81+ee38XQoMLyWtRUf8knz19zzmfA0D31PUHL9dMJS4N1TH7yWrA9Na
         BR/oy3sI5e08FVI8wMUiDd1XhD9kacDI+JNqzSvE=
Date:   Fri, 04 Aug 2023 11:12:08 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, sunnanyong@huawei.com,
        zhangpeng362@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-redundant-k-macro-definition.patch added to mm-unstable branch
Message-Id: <20230804181209.6AD54C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove redundant K() macro definition
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-redundant-k-macro-definition.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-redundant-k-macro-definition.patch

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
From: ZhangPeng <zhangpeng362@huawei.com>
Subject: mm: remove redundant K() macro definition
Date: Fri, 4 Aug 2023 09:25:53 +0800

Patch series "cleanup with helper macro K()".

Use helper macro K() to improve code readability.  No functional
modification involved.  Remove redundant K() macro definition.


This patch (of 7):

Since commit eb8589b4f8c1 ("mm: move mem_init_print_info() to mm_init.c"),
the K() macro definition has been moved to mm/internal.h.  Therefore, the
definitions in mm/memcontrol.c, mm/backing-dev.c and mm/oom_kill.c are
redundant.  Drop redundant definitions.

Link: https://lkml.kernel.org/r/20230804012559.2617515-1-zhangpeng362@huawei.com
Link: https://lkml.kernel.org/r/20230804012559.2617515-2-zhangpeng362@huawei.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |    3 +--
 mm/memcontrol.c  |    1 -
 mm/oom_kill.c    |    2 --
 3 files changed, 1 insertion(+), 5 deletions(-)

--- a/mm/backing-dev.c~mm-remove-redundant-k-macro-definition
+++ a/mm/backing-dev.c
@@ -16,6 +16,7 @@
 #include <linux/writeback.h>
 #include <linux/device.h>
 #include <trace/events/writeback.h>
+#include "internal.h"
 
 struct backing_dev_info noop_backing_dev_info;
 EXPORT_SYMBOL_GPL(noop_backing_dev_info);
@@ -34,8 +35,6 @@ LIST_HEAD(bdi_list);
 /* bdi_wq serves all asynchronous writeback tasks */
 struct workqueue_struct *bdi_wq;
 
-#define K(x) ((x) << (PAGE_SHIFT - 10))
-
 #ifdef CONFIG_DEBUG_FS
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
--- a/mm/memcontrol.c~mm-remove-redundant-k-macro-definition
+++ a/mm/memcontrol.c
@@ -1626,7 +1626,6 @@ static void memory_stat_format(struct me
 	WARN_ON_ONCE(seq_buf_has_overflowed(s));
 }
 
-#define K(x) ((x) << (PAGE_SHIFT-10))
 /**
  * mem_cgroup_print_oom_context: Print OOM information relevant to
  * memory controller.
--- a/mm/oom_kill.c~mm-remove-redundant-k-macro-definition
+++ a/mm/oom_kill.c
@@ -479,8 +479,6 @@ static DECLARE_WAIT_QUEUE_HEAD(oom_victi
 
 static bool oom_killer_disabled __read_mostly;
 
-#define K(x) ((x) << (PAGE_SHIFT-10))
-
 /*
  * task->mm can be NULL if the task is the exited group leader.  So to
  * determine whether the task is using a particular mm, we examine all the
_

Patches currently in -mm which might be from zhangpeng362@huawei.com are

mm-use-a-folio-in-fault_dirty_shared_page.patch
mm-remove-page_rmapping.patch
mm-page_io-remove-unneeded-clearpageuptodate.patch
mm-page_io-remove-unneeded-setpageerror.patch
mm-page_io-introduce-bio_first_folio_all.patch
mm-page_io-use-a-folio-in-__end_swap_bio_write.patch
mm-page_io-use-a-folio-in-__end_swap_bio_read.patch
mm-page_io-use-a-folio-in-sio_read_complete.patch
mm-page_io-use-a-folio-in-swap_writepage_bdev_sync.patch
mm-page_io-use-a-folio-in-swap_writepage_bdev_async.patch
mm-page_io-convert-count_swpout_vm_event-to-take-in-a-folio.patch
mm-page_io-convert-bio_associate_blkg_from_page-to-take-in-a-folio.patch
mm-kmsan-use-helper-function-page_size.patch
mm-kmsan-use-helper-macro-offset_in_page.patch
mm-kmsan-use-helper-macros-page_align-and-page_align_down.patch
mm-remove-redundant-k-macro-definition.patch
mm-swapfilec-use-helper-macro-k.patch
mm-swap_statec-use-helper-macro-k.patch
mm-shmemc-use-helper-macro-k.patch
mm-nommuc-use-helper-macro-k.patch
mm-mmapc-use-helper-macro-k.patch
mm-hugetlbc-use-helper-macro-k.patch

