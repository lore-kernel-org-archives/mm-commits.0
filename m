Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87BC7C4167B
	for <mm-commits@archiver.kernel.org>; Thu,  7 Dec 2023 00:08:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbjLGAI0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Dec 2023 19:08:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232043AbjLGAIZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Dec 2023 19:08:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56ED4C9
        for <mm-commits@vger.kernel.org>; Wed,  6 Dec 2023 16:08:32 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD411C433C8;
        Thu,  7 Dec 2023 00:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701907712;
        bh=wi+fMbvcHIbIdm8+FvMz/+d52xGqZH/uvquBNrGJpaQ=;
        h=Date:To:From:Subject:From;
        b=vldstjInWXaIotbA2xjcyGLetk029m9GJPX6f/zC3O4cD9r/LEdk+cF7Pw+0updpS
         kOgQV5R0Q+o36tiFGJhn7UFc0Dlddu4+hQ2baMEc+dBFsDy9OAFv/3gFtIqxXM/8T2
         5fBzYGoUAcaHOs0ie/RJKyIDjiXPeI3zC+lQzowQ=
Date:   Wed, 06 Dec 2023 16:08:30 -0800
To:     mm-commits@vger.kernel.org, qun-wei.lin@mediatek.com,
        oleg@redhat.com, matthias.bgg@gmail.com,
        chinwen.chang@mediatek.com,
        angelogioacchino.delregno@collabora.com, andreyknvl@google.com,
        Kuan-Ying.Lee@mediatek.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] scripts-gdb-tasks-fix-lx-ps-command-error-v2.patch removed from -mm tree
Message-Id: <20231207000831.DD411C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: scripts-gdb-tasks-fix-lx-ps-command-error-v2
has been removed from the -mm tree.  Its filename was
     scripts-gdb-tasks-fix-lx-ps-command-error-v2.patch

This patch was dropped because it was folded into scripts-gdb-tasks-fix-lx-ps-command-error.patch

------------------------------------------------------
From: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Subject: scripts-gdb-tasks-fix-lx-ps-command-error-v2
Date: Wed, 29 Nov 2023 14:51:38 +0800

Link: https://lkml.kernel.org/r/20231129065142.13375-2-Kuan-Ying.Lee@mediatek.com
Fixes: 8e1f385104ac ("kill task_struct->thread_group")
Signed-off-by: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: Chinwen Chang <chinwen.chang@mediatek.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Qun-Wei Lin <qun-wei.lin@mediatek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/tasks.py |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/scripts/gdb/linux/tasks.py~scripts-gdb-tasks-fix-lx-ps-command-error-v2
+++ a/scripts/gdb/linux/tasks.py
@@ -22,15 +22,15 @@ task_type = utils.CachedType("struct tas
 def task_lists():
     task_ptr_type = task_type.get_type().pointer()
     init_task = gdb.parse_and_eval("init_task").address
-    t = g = init_task
+    t = init_task
 
     while True:
         thread_head = t['signal']['thread_head']
         for thread in lists.list_for_each_entry(thread_head, task_ptr_type, 'thread_node'):
             yield thread
 
-        t = g = utils.container_of(g['tasks']['next'],
-                                   task_ptr_type, "tasks")
+        t = utils.container_of(t['tasks']['next'],
+                               task_ptr_type, "tasks")
         if t == init_task:
             return
 
_

Patches currently in -mm which might be from Kuan-Ying.Lee@mediatek.com are

scripts-gdb-tasks-fix-lx-ps-command-error.patch
scripts-gdb-stackdepot-rename-pool_index-to-pools_num.patch
scripts-gdb-remove-exception-handling-and-refine-print-format.patch

