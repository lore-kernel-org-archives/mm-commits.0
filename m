Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FB01C0018A
	for <mm-commits@archiver.kernel.org>; Wed,  1 Nov 2023 19:47:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347403AbjKATrr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Nov 2023 15:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348061AbjKATri (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Nov 2023 15:47:38 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0E9011F
        for <mm-commits@vger.kernel.org>; Wed,  1 Nov 2023 12:47:31 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 805C5C433CD;
        Wed,  1 Nov 2023 19:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698868051;
        bh=fokU/VzcbSQJaohsUxNOIbMACDKi0JUuIoaGxWdbSic=;
        h=Date:To:From:Subject:From;
        b=V8tXPwy5O6HVB8vkf9+75PCHn18nawRwP2mSP0nMcy2BIHCoBrZPqnNx5EOx82zG0
         KKYx10YGJ2jVu6bBM9G49xwtWhbnR1Wn4YhSlO0W88/jC4RRd8r8LtpseTnb1ZrkRc
         1i9b6WNGDRMnyb36gGo5TmiBa6r1U7jNlGrcgGxk=
Date:   Wed, 01 Nov 2023 12:47:30 -0700
To:     mm-commits@vger.kernel.org, xiehuan09@gmail.com,
        woodrow.shen@sifive.com, paul.walmsley@sifive.com,
        palmer@rivosinc.com, kbingham@kernel.org, jan.kiszka@siemens.com,
        development@efficientek.com, aou@eecs.berkeley.edu,
        ajones@ventanamicro.com, debug@rivosinc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-gdb-add-lx_current-support-for-riscv.patch removed from -mm tree
Message-Id: <20231101194731.805C5C433CD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: scripts/gdb: add lx_current support for riscv
has been removed from the -mm tree.  Its filename was
     scripts-gdb-add-lx_current-support-for-riscv.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


