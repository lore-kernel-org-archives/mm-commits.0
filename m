Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70FCFC433B4
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:05:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52DB1610FA
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:05:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234120AbhEGBGG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:06:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:46974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231489AbhEGBGF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:06:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2C6561041;
        Fri,  7 May 2021 01:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349507;
        bh=mWFqzWJ/7OwkdUlPU/ZNUwIZE8n7Ufwotwmc+gk+Rs0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=GUfJ4A/NnCVhO3T9TEPZQ43LkGX7JGjJY8oulbfvKpI3XrC+x0bBFxh/KGugqwTJG
         O9jEwpHsjTQpWf8EF5SnO5yQ6z3MR5rmhN4aKI27zyp/1d4jRHfBEY7KLWkhOD5NW0
         Cb3Gc7iJHMLJww0PHsdaI/py5sr2OSH3uLO/RLWk=
Date:   Thu, 06 May 2021 18:05:06 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, corbet@lwn.net, jan.kiszka@siemens.com,
        kbingham@kernel.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, song.bao.hua@hisilicon.com,
        torvalds@linux-foundation.org
Subject:  [patch 59/91] scripts/gdb: document lx_current is only
 supported by x86
Message-ID: <20210507010506.ERpsHuXWD%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
