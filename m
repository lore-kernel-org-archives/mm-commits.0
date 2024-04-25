Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF7E14B077
	for <mm-commits@vger.kernel.org>; Thu, 25 Apr 2024 17:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714065696; cv=none; b=SJ1UtyirHk1rJmgCJOOWLHj2Uw4ElFIDzsfTOM3A8JLvDgNQajW+YONt5bXTOCp51cleH953Bh1MjSHbGnCwZ/nQkN7DWq3op0iqOv5NdAocX9QISI8hG5CJHBoDV6RlFjA0f8ipHr+bBHIvPZFbx3sBCE+EzTap/DO5cay9BDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714065696; c=relaxed/simple;
	bh=nplv5u4G8DHdPrmLxyYJ3mS+3BU78KXkHrt0dKzOnpI=;
	h=Date:To:From:Subject:Message-Id; b=Wcsu8dVia0rBvtWOOV6NCRuHpN6T6c11uLxh+zXXeXLHPzLYWpXJlbXPDimAEGt1x4N72XSOUvwI6n1dTZGxAttDHlWgBwSaQfreHqIYSAl6masLrohkePYklI0BS3i1FfUYc+R/lCEKlCbezBhlFBcOLxjftn//b6srvuHKH+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pvADQUin; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pvADQUin"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB699C113CC;
	Thu, 25 Apr 2024 17:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714065695;
	bh=nplv5u4G8DHdPrmLxyYJ3mS+3BU78KXkHrt0dKzOnpI=;
	h=Date:To:From:Subject:From;
	b=pvADQUinF03oTRNa9WLY1k+vXfeuXFAN7lyg91RMw4RZlJOPs3Fvsr2uSIkumDq8t
	 9FQbxy1de2Ql1gxYm5IFQKBu4KYP/mtsDuqr9i3Fh2iS04VwZw8mXONVD4RMCmEZdx
	 TjvHiD+YQeRF9YrgNZq/TEu7GnnuRTGxNOtxb0/E=
Date: Thu, 25 Apr 2024 10:21:35 -0700
To: mm-commits@vger.kernel.org,palmer@rivosinc.com,Kuan-Ying.Lee@mediatek.com,kbingham@kernel.org,jan.kiszka@siemens.com,debug@rivosinc.com,ajones@ventanamicro.com,mail@florommel.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-make-get_thread_info-accept-pointers.patch added to mm-nonmm-unstable branch
Message-Id: <20240425172135.BB699C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/gdb: make get_thread_info accept pointers
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-make-get_thread_info-accept-pointers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-make-get_thread_info-accept-pointers.patch

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
Subject: scripts/gdb: make get_thread_info accept pointers
Date: Thu, 25 Apr 2024 17:35:00 +0200

get_thread_info ($lx_thread_info) only accepted a dereferenced task
parameter.  Passing a pointer to a task_struct (like $lx_per_cpu does with
KGDB) threw an exception.

With this patch, both (dereferenced values and pointers) are accepted.

Before (on x86, KGDB):
>>> p $lx_per_cpu(cpu_info)
Traceback (most recent call last):
  File "./scripts/gdb/linux/cpus.py", line 158, in invoke
    return per_cpu(var_ptr, cpu)
           ^^^^^^^^^^^^^^^^^^^^^
  File "./scripts/gdb/linux/cpus.py", line 42, in per_cpu
    cpu = get_current_cpu()
          ^^^^^^^^^^^^^^^^^
  File "./scripts/gdb/linux/cpus.py", line 33, in get_current_cpu
    return tasks.get_thread_info(tasks.get_task_by_pid(tid))['cpu']
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "./scripts/gdb/linux/tasks.py", line 88, in get_thread_info
    if task.type.fields()[0].type == thread_info_type.get_type():
       ~~~~~~~~~~~~~~~~~~^^^
IndexError: list index out of range

Link: https://lkml.kernel.org/r/20240425153501.749966-4-mail@florommel.de
Signed-off-by: Florian Rommel <mail@florommel.de>
Cc: Andrew Jones <ajones@ventanamicro.com>
Cc: Deepak Gupta <debug@rivosinc.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Cc: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/tasks.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/gdb/linux/tasks.py~scripts-gdb-make-get_thread_info-accept-pointers
+++ a/scripts/gdb/linux/tasks.py
@@ -85,7 +85,7 @@ thread_info_type = utils.CachedType("str
 
 def get_thread_info(task):
     thread_info_ptr_type = thread_info_type.get_type().pointer()
-    if task.type.fields()[0].type == thread_info_type.get_type():
+    if task_type.get_type().fields()[0].type == thread_info_type.get_type():
         return task['thread_info']
     thread_info = task['stack'].cast(thread_info_ptr_type)
     return thread_info.dereference()
_

Patches currently in -mm which might be from mail@florommel.de are

scripts-gdb-fix-failing-kgdb-detection-during-probe.patch
scripts-gdb-fix-parameter-handling-in-lx_per_cpu.patch
scripts-gdb-make-get_thread_info-accept-pointers.patch
scripts-gdb-fix-detection-of-current-cpu-in-kgdb.patch

