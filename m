Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96C60C64ED6
	for <mm-commits@archiver.kernel.org>; Sun, 26 Feb 2023 19:36:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbjBZTgF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Feb 2023 14:36:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjBZTgE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Feb 2023 14:36:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C6A010414
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 11:35:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 199A6B80C83
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 19:35:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEA0BC433D2;
        Sun, 26 Feb 2023 19:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677440156;
        bh=ZgR4Lm9YFjrIxi5P2KHqsjCbfWPQbR+HxiAkiWuIhko=;
        h=Date:To:From:Subject:From;
        b=CkQXBlu6TiZnNEgBMER3g3oPYm2Eag4zp3YS0dreXdFA0p8uZqEnA22m5yONYKggf
         moO03vCVIYaPxY7rIcAa+99PGqoedNz/GKNYGMro75OikZA395P2gwUtt7ZbtPqPXq
         URZIIMSiQm+NGQaCyWAFPQMnz8Kq8HII92pV35CU=
Date:   Sun, 26 Feb 2023 11:35:56 -0800
To:     mm-commits@vger.kernel.org, richard@nod.at, kbingham@kernel.org,
        johannes@sipsolutions.net, jan.kiszka@siemens.com,
        anton.ivanov@kot-begemot.co.uk, development@efficientek.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] scripts-gdb-correct-indentation-in-get_current_task.patch removed from -mm tree
Message-Id: <20230226193556.AEA0BC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: scripts/gdb: correct indentation in get_current_task
has been removed from the -mm tree.  Its filename was
     scripts-gdb-correct-indentation-in-get_current_task.patch

This patch was dropped because an updated version will be merged

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
+        if((current_task_addr >> 63) != 0):
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


