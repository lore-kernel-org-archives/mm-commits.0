Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3FC92CA5
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 01:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714958107; cv=none; b=Rzw3YC9+0GshADr8H8iclnFwMwcTRQfHSbk+TZmx5/Z4rygQ5KHjoCiIKwBIbthWY5qiYYRzvKbZtEmrabxI46MKXt9jrpyMQ9hlqkvrIcqJhYn9ME1jGyFmgvZef6cylS3XtqjmIbGULCVOxAI5R9XGcVklp3PMX/qPmQR5FAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714958107; c=relaxed/simple;
	bh=WT5+90UTEmUqJtDRRwwVwTUtDfgYzVRXSuJw9n5TZwM=;
	h=Date:To:From:Subject:Message-Id; b=AlCTxyDxNmoTZ6MRlnWNCyRcrcoXB/zZdfzLBSPjDxRQ+KiL7G2X2xeMoyH12lq35huDu522GsEEVpfXFl7h7+OFEPhUYarJ2xK4Q4UIbkAQgi383gckpkgExHov1qPETOEVqxuwvMVjp8gZe6+JNNHpsQUZWn9L6mOGkDTJiL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TBv6AuD7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TBv6AuD7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98C3AC113CC;
	Mon,  6 May 2024 01:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714958107;
	bh=WT5+90UTEmUqJtDRRwwVwTUtDfgYzVRXSuJw9n5TZwM=;
	h=Date:To:From:Subject:From;
	b=TBv6AuD7KjCkv/iydrZL1e5byeIG8fP9hwsGmMmvP4nfSRweYNIUlQOM1Ya4+DeAb
	 olQzKd/qJyyUcHOJkBhS13fhmr3iRSI5bbHq1KxUpEdzJfTCgYixl6bKDxr7IJXIRb
	 jvpz0X8cGsiR1j5X6m/BfVhKExC+sWnADQV6PCoQ=
Date: Sun, 05 May 2024 18:15:07 -0700
To: mm-commits@vger.kernel.org,palmer@rivosinc.com,Kuan-Ying.Lee@mediatek.com,kbingham@kernel.org,jan.kiszka@siemens.com,debug@rivosinc.com,ajones@ventanamicro.com,mail@florommel.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-gdb-make-get_thread_info-accept-pointers.patch removed from -mm tree
Message-Id: <20240506011507.98C3AC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/gdb: make get_thread_info accept pointers
has been removed from the -mm tree.  Its filename was
     scripts-gdb-make-get_thread_info-accept-pointers.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


