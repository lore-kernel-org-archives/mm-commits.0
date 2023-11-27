Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5556C4167B
	for <mm-commits@archiver.kernel.org>; Mon, 27 Nov 2023 18:49:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbjK0Stk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Nov 2023 13:49:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbjK0Stk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Nov 2023 13:49:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 490831A1
        for <mm-commits@vger.kernel.org>; Mon, 27 Nov 2023 10:49:46 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5695C433C7;
        Mon, 27 Nov 2023 18:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701110985;
        bh=eDD4RiFZ/2PuQHKi7IYy3i2cl6GWj12gtqEoBidSLMc=;
        h=Date:To:From:Subject:From;
        b=UUUVuk9bAC2ErZ84PRpy/pBdoKI7fLApWobHdLthPPwWiyNLwVGnLSJUn7/khpo4b
         xtDW8IK/3kXua/OpZ8t86F/tInw6VQoAA8W/GKuEeZGXIG2rJhpSkrzI06JW2H2LPO
         KlS3CKtBHKKzM441slVa5cdk9FiQbU1IS1PLxx88=
Date:   Mon, 27 Nov 2023 10:49:45 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        qun-wei.lin@mediatek.com, oleg@redhat.com, matthias.bgg@gmail.com,
        chinwen.chang@mediatek.com,
        angelogioacchino.delregno@collabora.com, andreyknvl@google.com,
        Kuan-Ying.Lee@mediatek.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-tasks-fix-lx-ps-command-error.patch added to mm-hotfixes-unstable branch
Message-Id: <20231127184945.D5695C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb/tasks: fix lx-ps command error
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     scripts-gdb-tasks-fix-lx-ps-command-error.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-tasks-fix-lx-ps-command-error.patch

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

Link: https://lkml.kernel.org/r/20231127070404.4192-2-Kuan-Ying.Lee@mediatek.com
Fixes: 8e1f385104ac ("kill task_struct->thread_group")
Signed-off-by: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: Chinwen Chang <chinwen.chang@mediatek.com>
Cc: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Qun-Wei Lin <qun-wei.lin@mediatek.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: <stable@vger.kernel.org>
Cc: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/tasks.py |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/scripts/gdb/linux/tasks.py~scripts-gdb-tasks-fix-lx-ps-command-error
+++ a/scripts/gdb/linux/tasks.py
@@ -13,7 +13,7 @@
 
 import gdb
 
-from linux import utils
+from linux import utils, lists
 
 
 task_type = utils.CachedType("struct task_struct")
@@ -25,13 +25,9 @@ def task_lists():
     t = g = init_task
 
     while True:
-        while True:
-            yield t
-
-            t = utils.container_of(t['thread_group']['next'],
-                                   task_ptr_type, "thread_group")
-            if t == g:
-                break
+        thread_head = t['signal']['thread_head']
+        for thread in lists.list_for_each_entry(thread_head, task_ptr_type, 'thread_node'):
+            yield thread
 
         t = g = utils.container_of(g['tasks']['next'],
                                    task_ptr_type, "tasks")
_

Patches currently in -mm which might be from Kuan-Ying.Lee@mediatek.com are

scripts-gdb-tasks-fix-lx-ps-command-error.patch
scripts-gdb-stackdepot-rename-pool_index_cached-to-pools_num.patch
scripts-gdb-remove-exception-handling-and-refine-print-format.patch

