Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C9741E864
	for <mm-commits@vger.kernel.org>; Thu, 25 Apr 2024 17:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714065694; cv=none; b=DGpQmPMQXBn6Mm677S4CoZB6YvOkaKM0nbMPAQvrnB0k5pJXiVcx5D/r6XE7zkBx3PrlMlr7EWaO4ZctCo1zTyDLbAmWSbUqFlTuXyNBCbk+enryRqQQQXG+ToRQ/20F6ZGHPUbUUwAjcScwzZ5tbnLU5+yhxLov+5r62mSR8ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714065694; c=relaxed/simple;
	bh=nYdWzsBF1ziukwXJovzVvOwmP3nLf9N2c7sAESjfJ70=;
	h=Date:To:From:Subject:Message-Id; b=iIMwRH33Mgu2S82qlT589HeHcsqwzM6iT7gCmT5xP8PE79XPmXV4dmwvLpB+TGue6FAKkwh8QsdiH7KvE6jCU6LUC1vaFpTolZUrj+wM6QbAQZO3O+tIGbRAITGoxlzoy19Ur70i4BgIKds/U9TVwsN+ex6D1IN+l1DZeY8SLdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X08vUOdr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X08vUOdr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D90F8C113CC;
	Thu, 25 Apr 2024 17:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714065693;
	bh=nYdWzsBF1ziukwXJovzVvOwmP3nLf9N2c7sAESjfJ70=;
	h=Date:To:From:Subject:From;
	b=X08vUOdr6bQ0e10Ct9Fe2nyOOQVDgv1pNbmmtn5nh/zBo1FKXH7awmLFkvv97dF+J
	 2EQ1tBDKVJQBguAaWaO0xwhahonc3S61ehgr/Rrd6j78Egt2c+CqUnLTtZBCATqaWM
	 ZhCdayb1gAzByd+ZQ4LikGZfgyVu9dNo/geBt1so=
Date: Thu, 25 Apr 2024 10:21:33 -0700
To: mm-commits@vger.kernel.org,palmer@rivosinc.com,Kuan-Ying.Lee@mediatek.com,kbingham@kernel.org,jan.kiszka@siemens.com,debug@rivosinc.com,ajones@ventanamicro.com,mail@florommel.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-fix-parameter-handling-in-lx_per_cpu.patch added to mm-nonmm-unstable branch
Message-Id: <20240425172133.D90F8C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/gdb: fix parameter handling in $lx_per_cpu
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-fix-parameter-handling-in-lx_per_cpu.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-fix-parameter-handling-in-lx_per_cpu.patch

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
From: Florian Rommel <mail@florommel.de>
Subject: scripts/gdb: fix parameter handling in $lx_per_cpu
Date: Thu, 25 Apr 2024 17:34:59 +0200

Before, the script tried to get the address by constructing a pointer to
the parameter (by name).  However, since GDB now passes the parameter as a
GdbValue, we cannot get its name.  Instead, we retrieve the address
through GdbValue's address attribute.

Before:
>>> p $lx_per_cpu(cpu_info)
Traceback (most recent call last):
  File "./scripts/gdb/linux/cpus.py", line 152, in invoke
    var_ptr = gdb.parse_and_eval("&" + var_name.string())
                                       ^^^^^^^^^^^^^^^^^
gdb.error: Trying to read string with inappropriate type `struct cpuinfo_x86'.

Link: https://lkml.kernel.org/r/20240425153501.749966-3-mail@florommel.de
Signed-off-by: Florian Rommel <mail@florommel.de>
Cc: Andrew Jones <ajones@ventanamicro.com>
Cc: Deepak Gupta <debug@rivosinc.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Cc: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/cpus.py |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/scripts/gdb/linux/cpus.py~scripts-gdb-fix-parameter-handling-in-lx_per_cpu
+++ a/scripts/gdb/linux/cpus.py
@@ -152,9 +152,8 @@ Note that VAR has to be quoted as string
     def __init__(self):
         super(PerCpu, self).__init__("lx_per_cpu")
 
-    def invoke(self, var_name, cpu=-1):
-        var_ptr = gdb.parse_and_eval("&" + var_name.string())
-        return per_cpu(var_ptr, cpu)
+    def invoke(self, var, cpu=-1):
+        return per_cpu(var.address, cpu)
 
 
 PerCpu()
_

Patches currently in -mm which might be from mail@florommel.de are

scripts-gdb-fix-failing-kgdb-detection-during-probe.patch
scripts-gdb-fix-parameter-handling-in-lx_per_cpu.patch
scripts-gdb-make-get_thread_info-accept-pointers.patch
scripts-gdb-fix-detection-of-current-cpu-in-kgdb.patch

