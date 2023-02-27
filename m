Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B0CEC64ED8
	for <mm-commits@archiver.kernel.org>; Mon, 27 Feb 2023 22:21:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbjB0WVS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Feb 2023 17:21:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbjB0WVR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2023 17:21:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D119E244B5
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2023 14:21:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D3BA60D57
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2023 22:21:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6596C433EF;
        Mon, 27 Feb 2023 22:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677536474;
        bh=9usx/hFy72+HSLqfZ74Q4164snkph0hhncg2M5xZ12Q=;
        h=Date:To:From:Subject:From;
        b=fsii50o3OhbJmX6hTA7VV105mzWdTTfYbJiHhLbTuAYMUHfXz8m8H33sneX7UW6wP
         ejUwi+25Fs+q3/8CRW74IcJtVoMf4Ciz8Kf3ywmd1levFLZF80uxfpefsyqNLzLbZr
         mGqj1rqWuYXahIWItbca9B5ylPBS2yiNTq/AGPlE=
Date:   Mon, 27 Feb 2023 14:21:14 -0800
To:     mm-commits@vger.kernel.org, richard@nod.at, kbingham@kernel.org,
        johannes@sipsolutions.net, jan.kiszka@siemens.com,
        anton.ivanov@kot-begemot.co.uk, development@efficientek.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-correct-indentation-in-get_current_task.patch added to mm-nonmm-unstable branch
Message-Id: <20230227222114.C6596C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: correct indentation in get_current_task
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-correct-indentation-in-get_current_task.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-correct-indentation-in-get_current_task.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

scripts-gdb-correct-indentation-in-get_current_task.patch
scripts-gdb-support-getting-current-task-struct-in-uml.patch

