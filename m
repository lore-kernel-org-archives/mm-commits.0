Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2920428F4
	for <mm-commits@vger.kernel.org>; Sun, 23 Feb 2025 01:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740275471; cv=none; b=hW2g7aBRbcsJZAquXdVUyDU1Y+V349Acy2et5UTjYgrApqMGHBkLWMR35/UIdhhaZGxTFblQzvyxBJlmRPFScXlXD60kXz9nVADETPe+M2eyogVFa0oEgdugkoynx5SC2KiOL7ZlWWCPdjHO68QvqgVB64wIT7iumyA9S6AFHHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740275471; c=relaxed/simple;
	bh=UxPZbR6Z5dTW5oudFUCDEKAMT83lV5bQeGq7d5OlJi8=;
	h=Date:To:From:Subject:Message-Id; b=u+4nnSFIn3+S/RkLSRejlkXq3ANWNwlBZJPW13uQDdGJTo5vormUWeHefu63Awd+ARXnyyKTfD0Id5vGRV8tUJyUHuvl0oIUS6YLJY3sXK/or1QHq8/Ik+QZ6d2faGNregiJajww28e+dpkJCZV4uy11yUYVjB57mOGowWhbrKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TA9p+eZr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TA9p+eZr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D68C4CED1;
	Sun, 23 Feb 2025 01:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740275470;
	bh=UxPZbR6Z5dTW5oudFUCDEKAMT83lV5bQeGq7d5OlJi8=;
	h=Date:To:From:Subject:From;
	b=TA9p+eZrdhlTZCm9erG0ta4BvG2WO9iI31hTSJLqCT0EKzTDVfEYyGxC4gSvnXmbf
	 taARiEV2Ex3GzLMpqOBkn5ofb7Q49hcvkO4Bbq5o0+f/6nCitCy8tfHB0wBvidhu3M
	 2Q++P6OfKAxJE5uN1uIxiqEnhVyP4bllLPqhn5o8=
Date: Sat, 22 Feb 2025 17:51:10 -0800
To: mm-commits@vger.kernel.org,mail@florommel.de,kbingham@kernel.org,jan.kiszka@siemens.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-add-lx_per_cpu_ptr.patch added to mm-nonmm-unstable branch
Message-Id: <20250223015110.D6D68C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/gdb: add $lx_per_cpu_ptr()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-add-lx_per_cpu_ptr.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-add-lx_per_cpu_ptr.patch

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

mm-mmu_gather-update-comment-on-rcu-freeing.patch
selftests-mm-report-errno-when-things-fail-in-gup_longterm.patch
selftests-mm-fix-assumption-that-sudo-is-present.patch
selftests-mm-skip-uffd-stress-if-userfaultfd-not-available.patch
selftests-mm-skip-uffd-wp-mremap-if-userfaultfd-not-available.patch
selftests-mm-uffd-rename-nr_cpus-nr_threads.patch
selftests-mm-print-some-details-when-uffd-stress-gets-bad-params.patch
selftests-mm-dont-fail-uffd-stress-if-too-many-cpus.patch
selftests-mm-skip-map_populate-on-weird-filesystems.patch
selftests-mm-skip-gup_longerm-tests-on-weird-filesystems.patch
scripts-gdb-add-lx_per_cpu_ptr.patch

