Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9005C761A6
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:53:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234656AbjDFCxt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234800AbjDFCx3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:53:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72FF593C1
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:53:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8698C64174
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:53:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD081C433D2;
        Thu,  6 Apr 2023 02:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749583;
        bh=2bTAo3lw/MjBWYC+1dC+6VZdEIDHv9D2F84OwnhNrpI=;
        h=Date:To:From:Subject:From;
        b=APKq44qY/1D/SNOK+FMPJPpsS8YuMChTwpF2gwTuXBJ1VuoqakrdVUoG6sA2ZRcpb
         hILqaU02a42TZdOExbayT4joXoNSFyA0fyZzA5b5f0ESfDRdK++F01aqd9n9b/iX73
         3GCRPlfbUPKPwXATiHRxELSsIVnUhvld5USJ2tlA=
Date:   Wed, 05 Apr 2023 19:53:02 -0700
To:     mm-commits@vger.kernel.org, richard@nod.at, kbingham@kernel.org,
        johannes@sipsolutions.net, jan.kiszka@siemens.com,
        anton.ivanov@kot-begemot.co.uk, development@efficientek.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-gdb-correct-indentation-in-get_current_task.patch removed from -mm tree
Message-Id: <20230406025302.DD081C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: scripts/gdb: correct indentation in get_current_task
has been removed from the -mm tree.  Its filename was
     scripts-gdb-correct-indentation-in-get_current_task.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Glenn Washburn <development@efficientek.com>
Subject: scripts/gdb: correct indentation in get_current_task
Date: Sun, 26 Feb 2023 22:05:59 -0600

Patch series "scripts/gdb: Support getting current task struct in UML",
v3.

A running x86 UML kernel reports with architecture "i386:x86-64" as it is
a sub-architecture.  However, a difference with bare-metal x86 kernels is
in how it manages tasks and the current task struct.  To identify that the
inferior is a UML kernel and not bare-metal, check for the existence of
the UML specific symbol "cpu_tasks" which contains the current task
struct.


This patch (of 3):

There is an extra space in a couple blocks in get_current_task.  Though
python does not care, let's make the spacing consistent.  Also, format
better an if expression, removing unneeded parenthesis.

Link: https://lkml.kernel.org/r/cover.1677469905.git.development@efficientek.com
Link: https://lkml.kernel.org/r/2e117b82240de6893f27cb6507242ce455ed7b5b.1677469905.git.development@efficientek.com
Signed-off-by: Glenn Washburn <development@efficientek.com>
Reviewed-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Anton Ivanov <anton.ivanov@kot-begemot.co.uk>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/cpus.py |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/scripts/gdb/linux/cpus.py~scripts-gdb-correct-indentation-in-get_current_task
+++ a/scripts/gdb/linux/cpus.py
@@ -163,16 +163,16 @@ def get_current_task(cpu):
     task_ptr_type = task_type.get_type().pointer()
 
     if utils.is_target_arch("x86"):
-         var_ptr = gdb.parse_and_eval("&pcpu_hot.current_task")
-         return per_cpu(var_ptr, cpu).dereference()
+        var_ptr = gdb.parse_and_eval("&pcpu_hot.current_task")
+        return per_cpu(var_ptr, cpu).dereference()
     elif utils.is_target_arch("aarch64"):
-         current_task_addr = gdb.parse_and_eval("$SP_EL0")
-         if((current_task_addr >> 63) != 0):
-             current_task = current_task_addr.cast(task_ptr_type)
-             return current_task.dereference()
-         else:
-             raise gdb.GdbError("Sorry, obtaining the current task is not allowed "
-                                "while running in userspace(EL0)")
+        current_task_addr = gdb.parse_and_eval("$SP_EL0")
+        if (current_task_addr >> 63) != 0:
+            current_task = current_task_addr.cast(task_ptr_type)
+            return current_task.dereference()
+        else:
+            raise gdb.GdbError("Sorry, obtaining the current task is not allowed "
+                               "while running in userspace(EL0)")
     else:
         raise gdb.GdbError("Sorry, obtaining the current task is not yet "
                            "supported with this arch")
_

Patches currently in -mm which might be from development@efficientek.com are


