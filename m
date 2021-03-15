Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4620C433DB
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 21:25:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8109D64F26
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 21:25:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbhCOVZW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Mar 2021 17:25:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:56048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231371AbhCOVY5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Mar 2021 17:24:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2F6764EED;
        Mon, 15 Mar 2021 21:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615843497;
        bh=kz1lekoS8OgwxCad3RKUvUoalgb4JcSbQuu7pu1tEQM=;
        h=Date:From:To:Subject:From;
        b=upxr33f2cfQhAcXiHsR9l5UEQRvdg7gYwLx3hg9RSvIUNz27juk5pJRviB3vEXy1D
         w3+/J96tagONGZ0UMJnXPu04phxQubl3jy65BdWvShjjVMcrsZS85lL9NAqdHw3W22
         HGPdl5Hve2+2tAaFzDBtke1Y4zYl25mwHBFYI/JE=
Date:   Mon, 15 Mar 2021 14:24:56 -0700
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, jan.kiszka@siemens.com, kbingham@kernel.org,
        mm-commits@vger.kernel.org, song.bao.hua@hisilicon.com
Subject:  + scripts-gdb-add-lx_current-support-for-arm64.patch
 added to -mm tree
Message-ID: <20210315212456.aH3BcFa5f%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: add lx_current support for arm64
has been added to the -mm tree.  Its filename is
     scripts-gdb-add-lx_current-support-for-arm64.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/scripts-gdb-add-lx_current-support-for-arm64.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/scripts-gdb-add-lx_current-support-for-arm64.patch

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

scripts-gdb-document-lx_current-is-only-supported-by-x86.patch
scripts-gdb-add-lx_current-support-for-arm64.patch

