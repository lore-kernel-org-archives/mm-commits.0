Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D985814B077
	for <mm-commits@vger.kernel.org>; Thu, 25 Apr 2024 17:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714065697; cv=none; b=m+2LaHtJg7vI2Sk/+hblkPRfn0FEjneJBQ7Zu7OpCdj5PBP7vPJbqSMkiN3TftbaW4TGVKclKKe+Z6jUWXGfP1Vl0AJ9WMFUJoZgaWf/fDnpyfzl3I12EHFTfd7Q5Ku1+YceCtnPUf/plyciTPNNnM2jZNaf4eL4CdN6lFHvE7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714065697; c=relaxed/simple;
	bh=A4dvd3/faeKQINO11XK5APR21o72NsWW/xbRr+61Uj4=;
	h=Date:To:From:Subject:Message-Id; b=G0Q0/ofxty+xJe5Sk2Q4tZ8+nfTM9v8XJUCmU6pQNFwNrRo8KMOJlqmzfzJkPa3F0AJF3+TBLyPnYPxPuovGNLwtqtBBp9gXZe8U7S3xq94XwZRbdpPp8R4FErQAkxzEQ5RNhqGMQtNZZVroFiR3xu3rNBQXoRIVLtnhRNYO+bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FYN/hPY9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FYN/hPY9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C9DAC113CC;
	Thu, 25 Apr 2024 17:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714065697;
	bh=A4dvd3/faeKQINO11XK5APR21o72NsWW/xbRr+61Uj4=;
	h=Date:To:From:Subject:From;
	b=FYN/hPY9xTNpXA06rsZhW1MUxQFu1EVolcNAcGFjw1TmSJMwROEVAnV7bDZR/XVc1
	 FElkB4CJ/MMpgjiuO0ogbh84yDddIW2gMfg306/ZIJJSnetRrHowGpz6tAcs6OF17q
	 FoT7v6zBmyoloFbQqo1Cx4sJWDDDKr9GJ5BxHfl0=
Date: Thu, 25 Apr 2024 10:21:37 -0700
To: mm-commits@vger.kernel.org,palmer@rivosinc.com,Kuan-Ying.Lee@mediatek.com,kbingham@kernel.org,jan.kiszka@siemens.com,debug@rivosinc.com,ajones@ventanamicro.com,mail@florommel.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-fix-detection-of-current-cpu-in-kgdb.patch added to mm-nonmm-unstable branch
Message-Id: <20240425172137.9C9DAC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/gdb: fix detection of current CPU in KGDB
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-fix-detection-of-current-cpu-in-kgdb.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-fix-detection-of-current-cpu-in-kgdb.patch

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
Subject: scripts/gdb: fix detection of current CPU in KGDB
Date: Thu, 25 Apr 2024 17:35:01 +0200

Directly read the current CPU number from the kgdb_active variable.

Before, the active CPU was obtained through the current task, which
required searching the task list for the pid of GDB's selected thread. 
Obtaining the pid was buggy: GDB may use selected_thread().ptid[1] (LWPID)
instead of .ptid[2] (TID) to store the threads pid; see
https://sourceware.org/gdb/current/onlinedocs/gdb.html/Threads-In-Python.html
As a result, the detection could return the wrong CPU number, leading to
incorrect results for $lx_per_cpu and $lx_current.

As a side effect, the patch significantly speeds up $lx_per_cpu and
$lx_current in KGDB by avoiding the task-list iteration.

Link: https://lkml.kernel.org/r/20240425153501.749966-5-mail@florommel.de
Signed-off-by: Florian Rommel <mail@florommel.de>
Cc: Andrew Jones <ajones@ventanamicro.com>
Cc: Deepak Gupta <debug@rivosinc.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Cc: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/cpus.py |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/scripts/gdb/linux/cpus.py~scripts-gdb-fix-detection-of-current-cpu-in-kgdb
+++ a/scripts/gdb/linux/cpus.py
@@ -26,11 +26,7 @@ def get_current_cpu():
     if utils.get_gdbserver_type() == utils.GDBSERVER_QEMU:
         return gdb.selected_thread().num - 1
     elif utils.get_gdbserver_type() == utils.GDBSERVER_KGDB:
-        tid = gdb.selected_thread().ptid[2]
-        if tid > (0x100000000 - MAX_CPUS - 2):
-            return 0x100000000 - tid - 2
-        else:
-            return tasks.get_thread_info(tasks.get_task_by_pid(tid))['cpu']
+        return gdb.parse_and_eval("kgdb_active.counter")
     else:
         raise gdb.GdbError("Sorry, obtaining the current CPU is not yet "
                            "supported with this gdb server.")
_

Patches currently in -mm which might be from mail@florommel.de are

scripts-gdb-fix-failing-kgdb-detection-during-probe.patch
scripts-gdb-fix-parameter-handling-in-lx_per_cpu.patch
scripts-gdb-make-get_thread_info-accept-pointers.patch
scripts-gdb-fix-detection-of-current-cpu-in-kgdb.patch

