Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFD6EC64ED8
	for <mm-commits@archiver.kernel.org>; Thu, 23 Feb 2023 21:15:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbjBWVPY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Feb 2023 16:15:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjBWVPW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2023 16:15:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53BBB869D
        for <mm-commits@vger.kernel.org>; Thu, 23 Feb 2023 13:15:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 073F0B81A42
        for <mm-commits@vger.kernel.org>; Thu, 23 Feb 2023 21:15:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FCCAC433EF;
        Thu, 23 Feb 2023 21:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677186918;
        bh=4bvYiR6XDKrsNxAmR+c3hmsXtS3P5ELA0+VDP9cUCgI=;
        h=Date:To:From:Subject:From;
        b=tR0QbUbM81e61rkhi4PD/+FLb6NxR6fyFrolCuFKUQxSDo7YfIcExqQi/3hJgYZI/
         55g8CxtAhvUpkB5/6QNYl6qDKpadH1pq7sTIPten0l9rFrGxz5KERTgY0jiNFccbsN
         GXMQuSfzsJytD6kS9XCicT0u4U1pz6LhHgl2Z2G4=
Date:   Thu, 23 Feb 2023 13:15:18 -0800
To:     mm-commits@vger.kernel.org, richard@nod.at, kbingham@kernel.org,
        johannes@sipsolutions.net, jan.kiszka@siemens.com,
        anton.ivanov@kot-begemot.co.uk, development@efficientek.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-correct-indentation-in-get_current_task.patch added to mm-nonmm-unstable branch
Message-Id: <20230223211518.9FCCAC433EF@smtp.kernel.org>
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
Date: Fri, 17 Feb 2023 19:11:53 -0600

Patch series "GDB: Support getting current task struct in UML", v2.


This patch (of 2):

There is an extra space in a couple blocks in get_current_task.
Though python does not care, let's make the spacing consistent.
Also, format better an if expression, removing unneeded parenthesis.

Link: https://lkml.kernel.org/r/cover.1676532759.git.development@efficientek.com
Link: https://lkml.kernel.org/r/c5a916e094d9c7acd551030b5dd793203046fea5.1676532759.git.development@efficientek.com
Signed-off-by: Glenn Washburn <development@efficientek.com>
Reviewed-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Anton Ivanov <anton.ivanov@kot-begemot.co.uk>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/cpus.py |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/scripts/gdb/linux/cpus.py~scripts-gdb-correct-indentation-in-get_current_task
+++ a/scripts/gdb/linux/cpus.py
@@ -163,15 +163,15 @@ def get_current_task(cpu):
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
+        current_task_addr = gdb.parse_and_eval("$SP_EL0")
+        if((current_task_addr >> 63) != 0):
+            current_task = current_task_addr.cast(task_ptr_type)
+            return current_task.dereference()
+        else:
+            raise gdb.GdbError("Sorry, obtaining the current task is not allowed "
                                 "while running in userspace(EL0)")
     else:
         raise gdb.GdbError("Sorry, obtaining the current task is not yet "
_

Patches currently in -mm which might be from development@efficientek.com are

scripts-gdb-correct-indentation-in-get_current_task.patch
scripts-gdb-support-getting-current-task-struct-in-uml.patch

