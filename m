Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86972C4167B
	for <mm-commits@archiver.kernel.org>; Thu,  7 Dec 2023 00:13:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442113AbjLGANl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Dec 2023 19:13:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442017AbjLGANa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Dec 2023 19:13:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31560C9
        for <mm-commits@vger.kernel.org>; Wed,  6 Dec 2023 16:13:37 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD350C433C8;
        Thu,  7 Dec 2023 00:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701908016;
        bh=XprRYbCtTgDXqIAVF8Mi1Y1rOmHgeGnkvPbE3DU9vnw=;
        h=Date:To:From:Subject:From;
        b=R05gxCv7Daquf44aGrBcf5Ay4XIxDkWkdFs/Hbbtalhu4QelxQEz+cUnCOuSHZJzJ
         lCskp6H9BAZSMhBhdXUdIFStMfF9JOf0ModKkEV4FkUFNxfVqzektzCI3fcqMnL6V7
         MJuhk1SCIy6YLda1kbgc5iSDjvZMQRgF3uoOF6JA=
Date:   Wed, 06 Dec 2023 16:13:36 -0800
To:     mm-commits@vger.kernel.org, qun-wei.lin@mediatek.com,
        oleg@redhat.com, matthias.bgg@gmail.com,
        florian.fainelli@broadcom.com, chinwen.chang@mediatek.com,
        angelogioacchino.delregno@collabora.com, andreyknvl@google.com,
        Kuan-Ying.Lee@mediatek.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] scripts-gdb-tasks-fix-lx-ps-command-error.patch removed from -mm tree
Message-Id: <20231207001336.BD350C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: scripts/gdb/tasks: fix lx-ps command error
has been removed from the -mm tree.  Its filename was
     scripts-gdb-tasks-fix-lx-ps-command-error.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Subject: scripts/gdb/tasks: fix lx-ps command error
Date: Mon, 27 Nov 2023 15:04:01 +0800

Since commit 8e1f385104ac ("kill task_struct->thread_group") remove
the thread_group, we will encounter below issue.

(gdb) lx-ps
      TASK          PID    COMM
0xffff800086503340   0   swapper/0
Python Exception <class 'gdb.error'>: There is no member named thread_group.
Error occurred in Python: There is no member named thread_group.

We use signal->thread_head to iterate all threads instead.

[Kuan-Ying.Lee@mediatek.com: v2]
  Link: https://lkml.kernel.org/r/20231129065142.13375-2-Kuan-Ying.Lee@mediatek.com
Link: https://lkml.kernel.org/r/20231127070404.4192-2-Kuan-Ying.Lee@mediatek.com
Fixes: 8e1f385104ac ("kill task_struct->thread_group")
Signed-off-by: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: Chinwen Chang <chinwen.chang@mediatek.com>
Cc: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Qun-Wei Lin <qun-wei.lin@mediatek.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/tasks.py |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

--- a/scripts/gdb/linux/tasks.py~scripts-gdb-tasks-fix-lx-ps-command-error
+++ a/scripts/gdb/linux/tasks.py
@@ -13,7 +13,7 @@
 
 import gdb
 
-from linux import utils
+from linux import utils, lists
 
 
 task_type = utils.CachedType("struct task_struct")
@@ -22,19 +22,15 @@ task_type = utils.CachedType("struct tas
 def task_lists():
     task_ptr_type = task_type.get_type().pointer()
     init_task = gdb.parse_and_eval("init_task").address
-    t = g = init_task
+    t = init_task
 
     while True:
-        while True:
-            yield t
+        thread_head = t['signal']['thread_head']
+        for thread in lists.list_for_each_entry(thread_head, task_ptr_type, 'thread_node'):
+            yield thread
 
-            t = utils.container_of(t['thread_group']['next'],
-                                   task_ptr_type, "thread_group")
-            if t == g:
-                break
-
-        t = g = utils.container_of(g['tasks']['next'],
-                                   task_ptr_type, "tasks")
+        t = utils.container_of(t['tasks']['next'],
+                               task_ptr_type, "tasks")
         if t == init_task:
             return
 
_

Patches currently in -mm which might be from Kuan-Ying.Lee@mediatek.com are

scripts-gdb-stackdepot-rename-pool_index-to-pools_num.patch
scripts-gdb-remove-exception-handling-and-refine-print-format.patch

