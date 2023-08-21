Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ABD9EE49A6
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:41:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbjHUUld (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230419AbjHUUkn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:40:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BC2DCC8
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:40:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D89361840
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:40:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1DE5C433C7;
        Mon, 21 Aug 2023 20:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650426;
        bh=RzLEREeomE++ou0YtF8pt6c55jofh/dNhiPODId2rlQ=;
        h=Date:To:From:Subject:From;
        b=OwLHMHsveRFxbM4eXiPc1wUOKHrns49+nSh2HDM+GI13GeRLY7Fo9rE4yXOC7KNae
         XFCWpiw73SvjJ1gNdU2kFNYiiK5XOhxmYmUwD9APPv0AiFM6JHQGmX9Abpms2pS0PJ
         0bYb9l7sDfvtWeBy6cZ4V3wGvLd4eK2zCGOFSO0s=
Date:   Mon, 21 Aug 2023 13:40:25 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, sunnanyong@huawei.com,
        david@redhat.com, zhangpeng362@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-redundant-k-macro-definition.patch removed from -mm tree
Message-Id: <20230821204025.E1DE5C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: remove redundant K() macro definition
has been removed from the -mm tree.  Its filename was
     mm-remove-redundant-k-macro-definition.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[akpm@linux-foundation.org: oom_kill.c: remove "#undef K", per Kefeng]
Link: https://lkml.kernel.org/r/20230804012559.2617515-1-zhangpeng362@huawei.com
Link: https://lkml.kernel.org/r/20230804012559.2617515-2-zhangpeng362@huawei.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |    3 +--
 mm/memcontrol.c  |    1 -
 mm/oom_kill.c    |    3 ---
 3 files changed, 1 insertion(+), 6 deletions(-)

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
@@ -1629,7 +1629,6 @@ static void memory_stat_format(struct me
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
@@ -994,7 +992,6 @@ static void __oom_kill_process(struct ta
 	mmdrop(mm);
 	put_task_struct(victim);
 }
-#undef K
 
 /*
  * Kill provided task unless it's secured by setting
_

Patches currently in -mm which might be from zhangpeng362@huawei.com are


