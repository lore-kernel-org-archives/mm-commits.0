Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB02218AA5
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189573; cv=none; b=bjEylCqD79ny3nn3gj6K1LNuAmWhZIjNA0cswBg9zfh9LJpIe8ntjU9rAH5BP43TFKk3Miu8c/mU44x9tiu8+HIoBfS/7CRwbZSfL0jkgVB6nuBVZYPMmKSiZUe6vBhjPaVWhB31Iufu3lwpKIB0NiJRs2wj5zCzVlaw186kxsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189573; c=relaxed/simple;
	bh=tB8Q9wIyBi5Qr+blxmijycqVo3yNdI/2NJHaNQ+2WkY=;
	h=Date:To:From:Subject:Message-Id; b=Rdtrp86sCnidG2ZR7QUNB/PW8miEAlypNvuRXU1/szW+sNmuqbYGCok5Y2rH9f+7J+IJo3HS3i7dF2a+EdSImwwOB902VicmY7AouLnF1UyaiJWIpfataljRXG62PviWPGxeDdi6h8py056wd13KxPqrddBEy5i7m+uyOT/JL7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=y5LlNrZD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y5LlNrZD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42B2BC4CEEC;
	Mon, 17 Mar 2025 05:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189573;
	bh=tB8Q9wIyBi5Qr+blxmijycqVo3yNdI/2NJHaNQ+2WkY=;
	h=Date:To:From:Subject:From;
	b=y5LlNrZDCW+b6HNjOBcTAmKKe0dg5FnPu0UxetehqCT2qe2mIm8u2m4h8M1nFUpP6
	 xFxybHzSSnZWZFhaHYd8116q+Uv6PcsluwxzHCxqBXipaBPfrNzN74wLT+QnR4nlMX
	 99RsnlqPE6qC+zUfTPh/r6ZGY/1JtbJOuYHbyfzo=
Date: Sun, 16 Mar 2025 22:32:52 -0700
To: mm-commits@vger.kernel.org,nsg@linux.ibm.com,kbingham@kernel.org,jan.kiszka@siemens.com,hca@linux.ibm.com,gor@linux.ibm.com,borntraeger@linux.ibm.com,ajd@linux.ibm.com,agordeev@linux.ibm.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-gdb-symbols-determine-kaslr-offset-on-s390.patch removed from -mm tree
Message-Id: <20250317053253.42B2BC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/gdb/symbols: determine KASLR offset on s390
has been removed from the -mm tree.  Its filename was
     scripts-gdb-symbols-determine-kaslr-offset-on-s390.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ilya Leoshkevich <iii@linux.ibm.com>
Subject: scripts/gdb/symbols: determine KASLR offset on s390
Date: Mon, 3 Mar 2025 12:03:58 +0100

Use QEMU's qemu.PhyMemMode [1] functionality to read vmcore from the
physical memory the same way the existing dump tooling does this. 
Gracefully handle non-QEMU targets, early boot, and memory corruptions;
print a warning if such situation is detected.

[1] https://qemu-project.gitlab.io/qemu/system/gdb.html#examining-physical-memory

Link: https://lkml.kernel.org/r/20250303110437.79070-1-iii@linux.ibm.com
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Acked-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andrew Donnellan <ajd@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/symbols.py |   31 ++++++++++++++++++++++++++++-
 scripts/gdb/linux/utils.py   |   35 +++++++++++++++++++++++++++++++++
 2 files changed, 65 insertions(+), 1 deletion(-)

--- a/scripts/gdb/linux/symbols.py~scripts-gdb-symbols-determine-kaslr-offset-on-s390
+++ a/scripts/gdb/linux/symbols.py
@@ -14,6 +14,7 @@
 import gdb
 import os
 import re
+import struct
 
 from itertools import count
 from linux import modules, utils, constants
@@ -54,6 +55,29 @@ if hasattr(gdb, 'Breakpoint'):
             return False
 
 
+def get_vmcore_s390():
+    with utils.qemu_phy_mem_mode():
+        vmcore_info = 0x0e0c
+        paddr_vmcoreinfo_note = gdb.parse_and_eval("*(unsigned long long *)" +
+                                                   hex(vmcore_info))
+        inferior = gdb.selected_inferior()
+        elf_note = inferior.read_memory(paddr_vmcoreinfo_note, 12)
+        n_namesz, n_descsz, n_type = struct.unpack(">III", elf_note)
+        desc_paddr = paddr_vmcoreinfo_note + len(elf_note) + n_namesz + 1
+        return gdb.parse_and_eval("(char *)" + hex(desc_paddr)).string()
+
+
+def get_kerneloffset():
+    if utils.is_target_arch('s390'):
+        try:
+            vmcore_str = get_vmcore_s390()
+        except gdb.error as e:
+            gdb.write("{}\n".format(e))
+            return None
+        return utils.parse_vmcore(vmcore_str).kerneloffset
+    return None
+
+
 class LxSymbols(gdb.Command):
     """(Re-)load symbols of Linux kernel and currently loaded modules.
 
@@ -160,7 +184,12 @@ lx-symbols command."""
                 obj.filename.endswith('vmlinux.debug')):
                 orig_vmlinux = obj.filename
         gdb.execute("symbol-file", to_string=True)
-        gdb.execute("symbol-file {0}".format(orig_vmlinux))
+        kerneloffset = get_kerneloffset()
+        if kerneloffset is None:
+            offset_arg = ""
+        else:
+            offset_arg = " -o " + hex(kerneloffset)
+        gdb.execute("symbol-file {0}{1}".format(orig_vmlinux, offset_arg))
 
         self.loaded_modules = []
         module_list = modules.module_list()
--- a/scripts/gdb/linux/utils.py~scripts-gdb-symbols-determine-kaslr-offset-on-s390
+++ a/scripts/gdb/linux/utils.py
@@ -11,6 +11,11 @@
 # This work is licensed under the terms of the GNU GPL version 2.
 #
 
+import contextlib
+import dataclasses
+import re
+import typing
+
 import gdb
 
 
@@ -216,3 +221,33 @@ def gdb_eval_or_none(expresssion):
         return gdb.parse_and_eval(expresssion)
     except gdb.error:
         return None
+
+
+@contextlib.contextmanager
+def qemu_phy_mem_mode():
+    connection = gdb.selected_inferior().connection
+    orig = connection.send_packet("qqemu.PhyMemMode")
+    if orig not in b"01":
+        raise gdb.error("Unexpected qemu.PhyMemMode")
+    orig = orig.decode()
+    if connection.send_packet("Qqemu.PhyMemMode:1") != b"OK":
+        raise gdb.error("Failed to set qemu.PhyMemMode")
+    try:
+        yield
+    finally:
+        if connection.send_packet("Qqemu.PhyMemMode:" + orig) != b"OK":
+            raise gdb.error("Failed to restore qemu.PhyMemMode")
+
+
+@dataclasses.dataclass
+class VmCore:
+    kerneloffset: typing.Optional[int]
+
+
+def parse_vmcore(s):
+    match = re.search(r"KERNELOFFSET=([0-9a-f]+)", s)
+    if match is None:
+        kerneloffset = None
+    else:
+        kerneloffset = int(match.group(1), 16)
+    return VmCore(kerneloffset=kerneloffset)
_

Patches currently in -mm which might be from iii@linux.ibm.com are


