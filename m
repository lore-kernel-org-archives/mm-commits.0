Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18C5CC64ED6
	for <mm-commits@archiver.kernel.org>; Mon, 27 Feb 2023 22:21:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbjB0WVT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Feb 2023 17:21:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbjB0WVS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2023 17:21:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 741F21D929
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2023 14:21:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FD2A60DE0
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2023 22:21:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68188C433D2;
        Mon, 27 Feb 2023 22:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677536476;
        bh=QVJc/Q4axg5CGTkX3QLoCaIeKphglbDU/SHLTEqH5k4=;
        h=Date:To:From:Subject:From;
        b=jJOf24hPClxqp1wL2AZoH3oaAmTrsM5T99jQP1EyjAUQQCD8Kgp+UuEF+HZcLP7PR
         zP9eQ3VNFgKG1NeHy2HosaqeErETuShBVeAtwCM+/CQkUQCQuvD6i/b8isot5hWZKK
         BkMGPEolUqfIhnrDlvHL5ktVVMaF1eqP1pKAwel4=
Date:   Mon, 27 Feb 2023 14:21:15 -0800
To:     mm-commits@vger.kernel.org, richard@nod.at, kbingham@kernel.org,
        johannes@sipsolutions.net, jan.kiszka@siemens.com,
        anton.ivanov@kot-begemot.co.uk, development@efficientek.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-support-getting-current-task-struct-in-uml.patch added to mm-nonmm-unstable branch
Message-Id: <20230227222116.68188C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: support getting current task struct in UML
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-support-getting-current-task-struct-in-uml.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-support-getting-current-task-struct-in-uml.patch

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
Subject: scripts/gdb: support getting current task struct in UML
Date: Sun, 26 Feb 2023 22:06:00 -0600

A running x86 UML kernel reports with architecture "i386:x86-64" as it is
a sub-architecture.  However, a difference with bare-metal x86 kernels is
in how it manages tasks and the current task struct.  To identify that the
inferior is a UML kernel and not bare-metal, check for the existence of
the UML specific symbol "cpu_tasks" which contains the current task
struct.

Link: https://lkml.kernel.org/r/b839d611e2906ccef2725c34d8e353fab35fe75e.1677469905.git.development@efficientek.com
Signed-off-by: Glenn Washburn <development@efficientek.com>
Reviewed-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Anton Ivanov <anton.ivanov@kot-begemot.co.uk>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/scripts/gdb/linux/cpus.py~scripts-gdb-support-getting-current-task-struct-in-uml
+++ a/scripts/gdb/linux/cpus.py
@@ -163,8 +163,14 @@ def get_current_task(cpu):
     task_ptr_type = task_type.get_type().pointer()
 
     if utils.is_target_arch("x86"):
-        var_ptr = gdb.parse_and_eval("&pcpu_hot.current_task")
-        return per_cpu(var_ptr, cpu).dereference()
+        if gdb.lookup_global_symbol("cpu_tasks"):
+            # This is a UML kernel, which stores the current task
+            # differently than other x86 sub architectures
+            var_ptr = gdb.parse_and_eval("(struct task_struct *)cpu_tasks[0].task")
+            return var_ptr.dereference()
+        else:
+            var_ptr = gdb.parse_and_eval("&pcpu_hot.current_task")
+            return per_cpu(var_ptr, cpu).dereference()
     elif utils.is_target_arch("aarch64"):
         current_task_addr = gdb.parse_and_eval("$SP_EL0")
         if (current_task_addr >> 63) != 0:
_

Patches currently in -mm which might be from development@efficientek.com are

scripts-gdb-correct-indentation-in-get_current_task.patch
scripts-gdb-support-getting-current-task-struct-in-uml.patch

