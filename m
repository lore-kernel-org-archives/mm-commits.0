Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93AE5C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:54:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66C486142D
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:54:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbhEHWzB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:55:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:42876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhEHWzA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:55:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8678610FA;
        Sat,  8 May 2021 22:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514437;
        bh=vU33LnxSPHp8oW1YxcLCNjEaBG97JTObIilig0wuD4c=;
        h=Date:From:To:Subject:From;
        b=FyGy75xfd5X/0/M1ZGM8Yb7g5vKU7RVF88gGBDopVpmb63L9kZgGHCkMm/G3aMcdv
         LIvyWnqOW6xarvbySeFWla1/3Tg66GJEJ21YvxZfP4M5M02SH/HxsWVNat/JHArHHA
         em4cFFbXJe2ZZbdjztHxzGQkJjjalGuL0M2GoT/A=
Date:   Sat, 08 May 2021 15:53:57 -0700
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, jan.kiszka@siemens.com, kbingham@kernel.org,
        mm-commits@vger.kernel.org, song.bao.hua@hisilicon.com
Subject:  [merged]
 scripts-gdb-document-lx_current-is-only-supported-by-x86.patch removed from
 -mm tree
Message-ID: <20210508225357.gfSrP8Kw5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: document lx_current is only supported by x86
has been removed from the -mm tree.  Its filename was
     scripts-gdb-document-lx_current-is-only-supported-by-x86.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Barry Song <song.bao.hua@hisilicon.com>
Subject: scripts/gdb: document lx_current is only supported by x86

Patch series "scripts/gdb: clarify the platforms supporting lx_current and add arm64 support", v2.

lx_current depends on per_cpu current_task variable which exists on x86
only.  so it actually works on x86 only.  the 1st patch documents this
clearly; the 2nd patch adds support for arm64.


This patch (of 2):

x86 is the only architecture which has per_cpu current_task:
arch$ git grep current_task | grep -i per_cpu
x86/include/asm/current.h:DECLARE_PER_CPU(struct task_struct *, current_task);
x86/kernel/cpu/common.c:DEFINE_PER_CPU(struct task_struct *, current_task) ____cacheline_aligned =
x86/kernel/cpu/common.c:EXPORT_PER_CPU_SYMBOL(current_task);
x86/kernel/cpu/common.c:DEFINE_PER_CPU(struct task_struct *, current_task) = &init_task;
x86/kernel/cpu/common.c:EXPORT_PER_CPU_SYMBOL(current_task);
x86/kernel/smpboot.c:	per_cpu(current_task, cpu) = idle;

On other architectures, lx_current() will lead to a python exception:
(gdb) p $lx_current().pid
Python Exception <class 'gdb.error'> No symbol "current_task" in current context.:
Error occurred in Python: No symbol "current_task" in current context.

To avoid more people struggling and wasting time in other architectures,
document it.

Link: https://lkml.kernel.org/r/20210314203444.15188-1-song.bao.hua@hisilicon.com
Link: https://lkml.kernel.org/r/20210314203444.15188-2-song.bao.hua@hisilicon.com
Signed-off-by: Barry Song <song.bao.hua@hisilicon.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/gdb-kernel-debugging.rst |    2 +-
 scripts/gdb/linux/cpus.py                        |   10 ++++++++--
 2 files changed, 9 insertions(+), 3 deletions(-)

--- a/Documentation/dev-tools/gdb-kernel-debugging.rst~scripts-gdb-document-lx_current-is-only-supported-by-x86
+++ a/Documentation/dev-tools/gdb-kernel-debugging.rst
@@ -114,7 +114,7 @@ Examples of using the Linux-provided gdb
     [     0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
     ....
 
-- Examine fields of the current task struct::
+- Examine fields of the current task struct(supported by x86 only)::
 
     (gdb) p $lx_current().pid
     $1 = 4998
--- a/scripts/gdb/linux/cpus.py~scripts-gdb-document-lx_current-is-only-supported-by-x86
+++ a/scripts/gdb/linux/cpus.py
@@ -156,6 +156,13 @@ Note that VAR has to be quoted as string
 
 PerCpu()
 
+def get_current_task(cpu):
+    if utils.is_target_arch("x86"):
+         var_ptr = gdb.parse_and_eval("&current_task")
+         return per_cpu(var_ptr, cpu).dereference()
+    else:
+        raise gdb.GdbError("Sorry, obtaining the current task is not yet "
+                           "supported with this arch")
 
 class LxCurrentFunc(gdb.Function):
     """Return current task.
@@ -167,8 +174,7 @@ number. If CPU is omitted, the CPU of th
         super(LxCurrentFunc, self).__init__("lx_current")
 
     def invoke(self, cpu=-1):
-        var_ptr = gdb.parse_and_eval("&current_task")
-        return per_cpu(var_ptr, cpu).dereference()
+        return get_current_task(cpu)
 
 
 LxCurrentFunc()
_

Patches currently in -mm which might be from song.bao.hua@hisilicon.com are


