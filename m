Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E91A7C433E6
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 21:25:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A139164EED
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 21:25:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbhCOVZW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Mar 2021 17:25:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:56018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229608AbhCOVYy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Mar 2021 17:24:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25F4C64F26;
        Mon, 15 Mar 2021 21:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615843494;
        bh=SfcqvK3iGH5PPb9ptd1nujtpJH3/cuzKRJoavTycmms=;
        h=Date:From:To:Subject:From;
        b=UA3CZ8oTdRMsyKyFbiW7/Ig8SKfSSO4Gbmp/raDk6KUwOyDrM397EfOt5KXeBRv6I
         pYaS2UYU4W/OPkkEv31C25RjEsUjKmE5XnTqZT9GKKcQN6XdkpIyJ7TMDeYwCC84Dx
         7Vfo96AaucCwgSe4gTyd3xDxhcWLjoImmPSeQdmc=
Date:   Mon, 15 Mar 2021 14:24:53 -0700
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, jan.kiszka@siemens.com, kbingham@kernel.org,
        mm-commits@vger.kernel.org, song.bao.hua@hisilicon.com
Subject:  +
 scripts-gdb-document-lx_current-is-only-supported-by-x86.patch added to -mm
 tree
Message-ID: <20210315212453.VCfAkTZuO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: document lx_current is only supported by x86
has been added to the -mm tree.  Its filename is
     scripts-gdb-document-lx_current-is-only-supported-by-x86.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/scripts-gdb-document-lx_current-is-only-supported-by-x86.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/scripts-gdb-document-lx_current-is-only-supported-by-x86.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

scripts-gdb-document-lx_current-is-only-supported-by-x86.patch
scripts-gdb-add-lx_current-support-for-arm64.patch

