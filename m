Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A36E140E30
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189535; cv=none; b=YXT8oB2kDd2dXbbqVIflx/McMV+0cz4mE/c3Z+xqxIR1mUad6N18EN+2kMepelMfe5skSIyHc0i68yglMmKJgmu85O55z7MbFen52u6OHNpQzoLtkY+5IGY7dUH+n/kvWSQnTOFLNEFdBwArbENr4oUlAHplAQjvWnVKwv/OBns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189535; c=relaxed/simple;
	bh=bbdGzh6+43lNIzYEJZ9S4nhhYSIveW/WLzqFGE5KTtw=;
	h=Date:To:From:Subject:Message-Id; b=jfRaen7HQ18y/DcPbMz/MAad2Ze00L7ysGqa9ka1rq4/g+23TW7/6OMwpgPCCCTvRzvibv6lsiZCMKl0REXN1o5LYmqlmIFcCbnCLafyW2j7XY+WTQIimxe0w2wxVgKWmM6Ec6E+JxhkJnSyJOF51Lbn/NnD02uh/d9elrh9Qi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0l4Gh18z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0l4Gh18z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E739C4CEEC;
	Mon, 17 Mar 2025 05:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189535;
	bh=bbdGzh6+43lNIzYEJZ9S4nhhYSIveW/WLzqFGE5KTtw=;
	h=Date:To:From:Subject:From;
	b=0l4Gh18zP8sGBEqH4MQ5MSROSPl2srWmb5e52BBru6TARUM0nkaKyDHOcnoIOEaxR
	 TR+QcJY1zrXbsD38UsVMXl9FMjQ3M4AukK0yFw/+A/fsrcTEgxxT1KnmlggcVK7u/s
	 8A6cy4ogGDY3EC4tQzfS1pR+gORYHqa8kAaahJ3Q=
Date: Sun, 16 Mar 2025 22:32:14 -0700
To: mm-commits@vger.kernel.org,mail@florommel.de,kbingham@kernel.org,jan.kiszka@siemens.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-gdb-add-lx_per_cpu_ptr.patch removed from -mm tree
Message-Id: <20250317053215.5E739C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/gdb: add $lx_per_cpu_ptr()
has been removed from the -mm tree.  Its filename was
     scripts-gdb-add-lx_per_cpu_ptr.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Brendan Jackman <jackmanb@google.com>
Subject: scripts/gdb: add $lx_per_cpu_ptr()
Date: Thu, 20 Feb 2025 12:23:40 +0000

We currently have $lx_per_cpu() which works fine for stuff that kernel
code would access via per_cpu().  But this doesn't work for stuff that
kernel code accesses via per_cpu_ptr():

(gdb) p $lx_per_cpu(node_data[1].node_zones[2]->per_cpu_pageset)
Cannot access memory at address 0xffff11105fbd6c28

This is because we take the address of the pointer and use that as the
offset, instead of using the stored value.

Add a GDB version that mirrors the kernel API, which uses the pointer
value.

To be consistent with per_cpu_ptr(), we need to return the pointer value
instead of dereferencing it for the user.  Therefore, move the existing
dereference out of the per_cpu() Python helper and do that only in the
$lx_per_cpu() implementation.

Link: https://lkml.kernel.org/r/20250220-lx-per-cpu-ptr-v2-1-945dee8d8d38@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Reviewed-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Florian Rommel <mail@florommel.de>
Cc: Kieran Bingham <kbingham@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/cpus.py |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

--- a/scripts/gdb/linux/cpus.py~scripts-gdb-add-lx_per_cpu_ptr
+++ a/scripts/gdb/linux/cpus.py
@@ -46,7 +46,7 @@ def per_cpu(var_ptr, cpu):
             # !CONFIG_SMP case
             offset = 0
     pointer = var_ptr.cast(utils.get_long_type()) + offset
-    return pointer.cast(var_ptr.type).dereference()
+    return pointer.cast(var_ptr.type)
 
 
 cpu_mask = {}
@@ -149,11 +149,29 @@ Note that VAR has to be quoted as string
         super(PerCpu, self).__init__("lx_per_cpu")
 
     def invoke(self, var, cpu=-1):
-        return per_cpu(var.address, cpu)
+        return per_cpu(var.address, cpu).dereference()
 
 
 PerCpu()
 
+
+class PerCpuPtr(gdb.Function):
+    """Return per-cpu pointer.
+
+$lx_per_cpu_ptr("VAR"[, CPU]): Return the per-cpu pointer called VAR for the
+given CPU number. If CPU is omitted, the CPU of the current context is used.
+Note that VAR has to be quoted as string."""
+
+    def __init__(self):
+        super(PerCpuPtr, self).__init__("lx_per_cpu_ptr")
+
+    def invoke(self, var, cpu=-1):
+        return per_cpu(var, cpu)
+
+
+PerCpuPtr()
+
+
 def get_current_task(cpu):
     task_ptr_type = task_type.get_type().pointer()
 
_

Patches currently in -mm which might be from jackmanb@google.com are


