Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00587C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:54:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1ACE60E0B
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:54:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbhEHWzD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:55:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:42940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhEHWzC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:55:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FECA61402;
        Sat,  8 May 2021 22:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514440;
        bh=IokssX6zN6NPBt+1FVuKh1xZ2YhPLexNmx+SwAn8ybk=;
        h=Date:From:To:Subject:From;
        b=ihL35M/di9KDumGEHUwyl5ffLHfDFbm/r3um5XAmBRMAYFsfv34eM4+pxAQf6Mutr
         IjIwTXp5dPiIzhrWt7uH3eUZ3UvFI3YcHuF8uPEFrj1cKDTXfKNZf7ePWhMVS+lLPP
         yMNR6GZddv4ebt82XKyGV2IOAaZbhDfTuMJHQAfA=
Date:   Sat, 08 May 2021 15:54:00 -0700
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, jan.kiszka@siemens.com, kbingham@kernel.org,
        mm-commits@vger.kernel.org, song.bao.hua@hisilicon.com
Subject:  [merged]
 scripts-gdb-add-lx_current-support-for-arm64.patch removed from -mm tree
Message-ID: <20210508225400.AOLOD_mjX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: add lx_current support for arm64
has been removed from the -mm tree.  Its filename was
     scripts-gdb-add-lx_current-support-for-arm64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Barry Song <song.bao.hua@hisilicon.com>
Subject: scripts/gdb: add lx_current support for arm64

arm64 uses SP_EL0 to save the current task_struct address.  While running
in EL0, SP_EL0 is clobbered by userspace.  So if the upper bit is not 1
(not TTBR1), the current address is invalid.  This patch checks the upper
bit of SP_EL0, if the upper bit is 1, lx_current() of arm64 will return
the derefrence of current task.  Otherwise, lx_current() will tell users
they are running in userspace(EL0).

While arm64 is running in EL0, it is actually pointless to print current
task as the memory of kernel space is not accessible in EL0.

Link: https://lkml.kernel.org/r/20210314203444.15188-3-song.bao.hua@hisilicon.com
Signed-off-by: Barry Song <song.bao.hua@hisilicon.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kieran Bingham <kbingham@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/gdb-kernel-debugging.rst |    2 +-
 scripts/gdb/linux/cpus.py                        |   13 +++++++++++++
 2 files changed, 14 insertions(+), 1 deletion(-)

--- a/Documentation/dev-tools/gdb-kernel-debugging.rst~scripts-gdb-add-lx_current-support-for-arm64
+++ a/Documentation/dev-tools/gdb-kernel-debugging.rst
@@ -114,7 +114,7 @@ Examples of using the Linux-provided gdb
     [     0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
     ....
 
-- Examine fields of the current task struct(supported by x86 only)::
+- Examine fields of the current task struct(supported by x86 and arm64 only)::
 
     (gdb) p $lx_current().pid
     $1 = 4998
--- a/scripts/gdb/linux/cpus.py~scripts-gdb-add-lx_current-support-for-arm64
+++ a/scripts/gdb/linux/cpus.py
@@ -16,6 +16,9 @@ import gdb
 from linux import tasks, utils
 
 
+task_type = utils.CachedType("struct task_struct")
+
+
 MAX_CPUS = 4096
 
 
@@ -157,9 +160,19 @@ Note that VAR has to be quoted as string
 PerCpu()
 
 def get_current_task(cpu):
+    task_ptr_type = task_type.get_type().pointer()
+
     if utils.is_target_arch("x86"):
          var_ptr = gdb.parse_and_eval("&current_task")
          return per_cpu(var_ptr, cpu).dereference()
+    elif utils.is_target_arch("aarch64"):
+         current_task_addr = gdb.parse_and_eval("$SP_EL0")
+         if((current_task_addr >> 63) != 0):
+             current_task = current_task_addr.cast(task_ptr_type)
+             return current_task.dereference()
+         else:
+             raise gdb.GdbError("Sorry, obtaining the current task is not allowed "
+                                "while running in userspace(EL0)")
     else:
         raise gdb.GdbError("Sorry, obtaining the current task is not yet "
                            "supported with this arch")
_

Patches currently in -mm which might be from song.bao.hua@hisilicon.com are


