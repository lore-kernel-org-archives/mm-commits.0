Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3BBDC4167B
	for <mm-commits@archiver.kernel.org>; Wed, 29 Nov 2023 22:14:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234874AbjK2WN5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 29 Nov 2023 17:13:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234975AbjK2WNo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Nov 2023 17:13:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40A9B193
        for <mm-commits@vger.kernel.org>; Wed, 29 Nov 2023 14:13:31 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2907C433C7;
        Wed, 29 Nov 2023 22:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701296010;
        bh=olXrfs1oOYXPrIYFLo9IOUiFtwFfEWPOarrKq3XXchk=;
        h=Date:To:From:Subject:From;
        b=CvydyJw1k0txFCdGC8SOHvOvVX+RnJXB/slqhJV+6/94Sq4MorPHk0Sonrtyj/hRX
         YWFzOJqrcdS8xIWBOlePCsoZwA4hq/ppsAPf+Ac7E2jpRi2KoMrYLwYJKJ/8lGXbZW
         kTBelYNwhxHHVDBP3WFr1TTlq557pHUfNZfN1wTo=
Date:   Wed, 29 Nov 2023 14:13:29 -0800
To:     mm-commits@vger.kernel.org, qun-wei.lin@mediatek.com,
        oleg@redhat.com, matthias.bgg@gmail.com,
        chinwen.chang@mediatek.com,
        angelogioacchino.delregno@collabora.com, andreyknvl@google.com,
        Kuan-Ying.Lee@mediatek.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-tasks-fix-lx-ps-command-error-v2.patch added to mm-hotfixes-unstable branch
Message-Id: <20231129221330.A2907C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts-gdb-tasks-fix-lx-ps-command-error-v2
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     scripts-gdb-tasks-fix-lx-ps-command-error-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-tasks-fix-lx-ps-command-error-v2.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
scripts-gdb-tasks-fix-lx-ps-command-error-v2.patch
scripts-gdb-stackdepot-rename-pool_index_cached-to-pools_num.patch
scripts-gdb-remove-exception-handling-and-refine-print-format.patch

