Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49552CA5
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 01:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714958108; cv=none; b=OzNbsZ3DRB6VjY2wlgD8NTCza1Zlis04ZTTpw+9jfT8XLBozVLUDHQFb6vK9il/j2sikNy85ASzxxiTy0/YpLaTfpMRSqV56KC2q8oq0acJWgXI4Cpd4RYZuUAAzqXg6Oq0pOEYxgLVBr1yPAthD13rMVLC9FfUS+tLlopOJ+8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714958108; c=relaxed/simple;
	bh=wLk3neb+CrW64zVBbKoTMoO7WYZ+pKuHa9umM/ZzKv0=;
	h=Date:To:From:Subject:Message-Id; b=byCv6CkERk7/IbBiYgpZPZY3dzCMxvEucpXsMY/k/JB9zZxZs2evBWuEIhhJZ2wspV2vbsSyH1SdHjdwicmz5ZHV0aK6kCE4mLcWlCi2BImvVB2RqtB+tlDtBZcbBtWg5ixyPZ4ENA9EM8856S4ytEH+K4nUPoOat1/J1ge06cQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZgGfC1KL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZgGfC1KL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9668C116B1;
	Mon,  6 May 2024 01:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714958108;
	bh=wLk3neb+CrW64zVBbKoTMoO7WYZ+pKuHa9umM/ZzKv0=;
	h=Date:To:From:Subject:From;
	b=ZgGfC1KLSd8/st1JKlFeQL+SVED0uS7j6sw7lJhEU4GUY+w3XHwflk4zgd2ZLw3Um
	 kBbsQioLdwIJyUiGj5s4gDW8NUzNxe8k6MXjyuIpP8DrFCmcBVWL1N8nVBBzoaX1J5
	 Ho/gv/lI1+0/aHcMJM470rb7VMJUhOBPoqt2SM+Y=
Date: Sun, 05 May 2024 18:15:08 -0700
To: mm-commits@vger.kernel.org,palmer@rivosinc.com,Kuan-Ying.Lee@mediatek.com,kbingham@kernel.org,jan.kiszka@siemens.com,debug@rivosinc.com,ajones@ventanamicro.com,mail@florommel.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-gdb-fix-detection-of-current-cpu-in-kgdb.patch removed from -mm tree
Message-Id: <20240506011508.A9668C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/gdb: fix detection of current CPU in KGDB
has been removed from the -mm tree.  Its filename was
     scripts-gdb-fix-detection-of-current-cpu-in-kgdb.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


