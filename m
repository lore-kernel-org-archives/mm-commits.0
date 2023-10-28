Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E372C25B67
	for <mm-commits@archiver.kernel.org>; Sat, 28 Oct 2023 03:08:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233093AbjJ1DIb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 27 Oct 2023 23:08:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjJ1DI0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 27 Oct 2023 23:08:26 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 997A893
        for <mm-commits@vger.kernel.org>; Fri, 27 Oct 2023 20:08:24 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F467C433C8;
        Sat, 28 Oct 2023 03:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698462504;
        bh=TS7rUDadNxVId5ddOH6YmuEkJLYgK5yfKA4iuzcQ17w=;
        h=Date:To:From:Subject:From;
        b=UDk5wWorwVPaaQ0zjkVmAnlK+TnKrj8X0t1JS20NNPvuSoLJyEj1tn0CeZ0op0gZn
         tc5sqOZ+5taNAQ5E1T91Qb69UNd+udBEFtF+64Bnjp1fWX8QV/USIgIUfXrSWdPy8M
         xEop7IljU5YPGCM3m6wQxJyTBj68bxA8f5OaO7hI=
Date:   Fri, 27 Oct 2023 20:08:22 -0700
To:     mm-commits@vger.kernel.org, xiehuan09@gmail.com,
        woodrow.shen@sifive.com, paul.walmsley@sifive.com,
        palmer@rivosinc.com, kbingham@kernel.org, jan.kiszka@siemens.com,
        development@efficientek.com, aou@eecs.berkeley.edu,
        ajones@ventanamicro.com, debug@rivosinc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-add-lx_current-support-for-riscv.patch added to mm-nonmm-unstable branch
Message-Id: <20231028030824.1F467C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: add lx_current support for riscv
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-add-lx_current-support-for-riscv.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-add-lx_current-support-for-riscv.patch

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
From: Deepak Gupta <debug@rivosinc.com>
Subject: scripts/gdb: add lx_current support for riscv
Date: Thu, 26 Oct 2023 16:38:23 -0700

csr_sscratch CSR holds current task_struct address when hart is in user
space.  Trap handler on entry spills csr_sscratch into "tp" (x2) register
and zeroes out csr_sscratch CSR.  Trap handler on exit reloads "tp" with
expected user mode value and place current task_struct address again in
csr_sscratch CSR.

This patch assumes "tp" is pointing to task_struct. If value in
csr_sscratch is numerically greater than "tp" then it assumes csr_sscratch
is correct address of current task_struct. This logic holds when
   - hart is in user space, "tp" will be less than csr_sscratch.
   - hart is in kernel space but not in trap handler, "tp" will be more
     than csr_sscratch (csr_sscratch being equal to 0).
   - hart is executing trap handler
       - "tp" is still pointing to user mode but csr_sscratch contains
          ptr to task_struct. Thus numerically higher.
       - "tp" is  pointing to task_struct but csr_sscratch now contains
          either 0 or numerically smaller value (transiently holds
          user mode tp)

Link: https://lkml.kernel.org/r/20231026233837.612405-1-debug@rivosinc.com
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
Tested-by: Hsieh-Tseng Shen <woodrow.shen@sifive.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Glenn Washburn <development@efficientek.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Jeff Xie <xiehuan09@gmail.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Palmer Dabbelt <palmer@rivosinc.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/cpus.py |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/scripts/gdb/linux/cpus.py~scripts-gdb-add-lx_current-support-for-riscv
+++ a/scripts/gdb/linux/cpus.py
@@ -179,6 +179,21 @@ def get_current_task(cpu):
         else:
             raise gdb.GdbError("Sorry, obtaining the current task is not allowed "
                                "while running in userspace(EL0)")
+    elif utils.is_target_arch("riscv"):
+        current_tp = gdb.parse_and_eval("$tp")
+        scratch_reg = gdb.parse_and_eval("$sscratch")
+
+        # by default tp points to current task
+        current_task = current_tp.cast(task_ptr_type)
+
+        # scratch register is set 0 in trap handler after entering kernel.
+        # When hart is in user mode, scratch register is pointing to task_struct.
+        # and tp is used by user mode. So when scratch register holds larger value
+        # (negative address as ulong is larger value) than tp, then use scratch register.
+        if (scratch_reg.cast(utils.get_ulong_type()) > current_tp.cast(utils.get_ulong_type())):
+            current_task = scratch_reg.cast(task_ptr_type)
+
+        return current_task.dereference()
     else:
         raise gdb.GdbError("Sorry, obtaining the current task is not yet "
                            "supported with this arch")
_

Patches currently in -mm which might be from debug@rivosinc.com are

scripts-gdb-add-lx_current-support-for-riscv.patch

