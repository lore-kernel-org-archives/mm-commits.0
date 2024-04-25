Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE65D1E864
	for <mm-commits@vger.kernel.org>; Thu, 25 Apr 2024 17:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714065692; cv=none; b=RG/MF+8fgLqdxS/SaagwV+h+/Adu2+a4deg4CU+5XkOCcCufxGU9Fa3NvEmXm4dJuV8fvZa8of0SjW3xd2ZfX/1yiDbZ8K1uKRdr35XQFsIgWvjrJYE7wdGEz3U3CgjZpkoMjV+eXBlQ/WeuWAMe1D55iS8/fWR2BK9Z2w3Rg6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714065692; c=relaxed/simple;
	bh=G/TPBVBIQ5/NIhwodUgA2pqiiqxQiYMuBITB/l250pI=;
	h=Date:To:From:Subject:Message-Id; b=eLSz7YmAJZkU2pdePlEiC1dP07+KAZSjWsmLB+r7oLE0PLJvqe13g6k1qpiOl54u9ic/ViotDePsog8cRsht5ubbhx0ov6Ce9V5fT4sMe40cPAtaBPbhc5MoA0Oizo7SZwVIbmbRn+VH1dFtl/WP6p9eGqJm07vi3efcrR4C3sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V1dgdfZo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V1dgdfZo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0972DC113CC;
	Thu, 25 Apr 2024 17:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714065692;
	bh=G/TPBVBIQ5/NIhwodUgA2pqiiqxQiYMuBITB/l250pI=;
	h=Date:To:From:Subject:From;
	b=V1dgdfZouFyxDgjgbI3+8iK3azR8M3LkkbWEGoP0/i2L/scJ6zYXiizR1H17Um0Kp
	 lGuOsKWtceHmRoqUjH07cfdR2BSPnBBg1FPT2UaVPLedjToGP83sWy/+4HzYwnZEQx
	 8b+o9cuG73GV9Tf0uD9XsW5cCOHh5Z2aRUiAcDi0=
Date: Thu, 25 Apr 2024 10:21:31 -0700
To: mm-commits@vger.kernel.org,palmer@rivosinc.com,Kuan-Ying.Lee@mediatek.com,kbingham@kernel.org,jan.kiszka@siemens.com,debug@rivosinc.com,ajones@ventanamicro.com,mail@florommel.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-fix-failing-kgdb-detection-during-probe.patch added to mm-nonmm-unstable branch
Message-Id: <20240425172132.0972DC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/gdb: fix failing KGDB detection during probe
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-fix-failing-kgdb-detection-during-probe.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-fix-failing-kgdb-detection-during-probe.patch

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
Subject: scripts/gdb: fix failing KGDB detection during probe
Date: Thu, 25 Apr 2024 17:34:58 +0200

Patch series "scripts/gdb: Fixes for $lx_current and $lx_per_cpu".

This series fixes several bugs in the GDB scripts related to the
$lx_current and $lx_per_cpu functions.  The changes were tested with GDB
10, 11, 12, 13, and 14.

Patch 1 fixes false-negative results when probing for KGDB

Patch 2 fixes the $lx_per_cpu function, which is currently non-functional
in QEMU-GDB and KGDB.

Patch 3 fixes an additional bug in $lx_per_cpu that occurs with KGDB.

Patch 4 fixes the incorrect detection of the current CPU number in KGDB,
which silently breaks $lx_per_cpu and $lx_current.


This patch (of 4):

The KGDB probe function sometimes failed to detect KGDB for SMP machines
as it assumed that task 2 (kthreadd) is running on CPU 0, which is not
necessarily the case.  Now, the detection is agnostic to kthreadd's CPU.

Link: https://lkml.kernel.org/r/20240425153501.749966-1-mail@florommel.de
Link: https://lkml.kernel.org/r/20240425153501.749966-2-mail@florommel.de
Signed-off-by: Florian Rommel <mail@florommel.de>
Cc: Andrew Jones <ajones@ventanamicro.com>
Cc: Deepak Gupta <debug@rivosinc.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Cc: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/utils.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/gdb/linux/utils.py~scripts-gdb-fix-failing-kgdb-detection-during-probe
+++ a/scripts/gdb/linux/utils.py
@@ -196,7 +196,7 @@ def get_gdbserver_type():
     def probe_kgdb():
         try:
             thread_info = gdb.execute("info thread 2", to_string=True)
-            return "shadowCPU0" in thread_info
+            return "shadowCPU" in thread_info
         except gdb.error:
             return False
 
_

Patches currently in -mm which might be from mail@florommel.de are

scripts-gdb-fix-failing-kgdb-detection-during-probe.patch
scripts-gdb-fix-parameter-handling-in-lx_per_cpu.patch
scripts-gdb-make-get_thread_info-accept-pointers.patch
scripts-gdb-fix-detection-of-current-cpu-in-kgdb.patch

