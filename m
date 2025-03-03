Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F185A1F3FF5
	for <mm-commits@vger.kernel.org>; Mon,  3 Mar 2025 23:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741042805; cv=none; b=p+hGwrwPVrCSrFyapXRW+nux3YVHdzwo8DT3HznPPIn5WI681kS59mAZYnxyW+gYR0SlOOwyX3dKzKP/OtpuLRDfv8wVdmMBe1eN4GtOYEJkSobyF24GhALi1IYE7GoCZsb6fIgGW1977fE8CKHE5/lg77TfBt2Q1lwFm9hJiDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741042805; c=relaxed/simple;
	bh=m4BKKz52cB35bV/T3Ek0/2oHnHRAkRsy17M0r9Eu2zM=;
	h=Date:To:From:Subject:Message-Id; b=jKXjh33aw8ldcjnUcwKyS8nBdwC6saCuWPYzaCdcSn9uxvckQxGIh6qpBY19ayGOzLx+NKTDnI5oW30mKVIEnOEFblObY5dLTOEvmJgHC7eGNZUk3hZdMKirqlI+MJeDNdYKtr8NwQCUoOA0UUZwc9yzTvhqMu0EHrxYVRq8OGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cazzVDLG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cazzVDLG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E8FC4CEE8;
	Mon,  3 Mar 2025 23:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741042804;
	bh=m4BKKz52cB35bV/T3Ek0/2oHnHRAkRsy17M0r9Eu2zM=;
	h=Date:To:From:Subject:From;
	b=cazzVDLGuTKXvMb0SR7e4CedNFec42OXiBj90mZNWh9rTdMKC1WYSSyojObxBAH+k
	 gk8IqFvh5ZFcDLk9Ddoho+3l2AZvQVjy8+r6RTSSditdhd0rtRVwvza7aw7qrXdyG9
	 KV5ZvH2dYIjN+F0hvSpzweN2QagRfnPj1lDQTOaw=
Date: Mon, 03 Mar 2025 15:00:04 -0800
To: mm-commits@vger.kernel.org,nsg@linux.ibm.com,kbingham@kernel.org,jan.kiszka@siemens.com,hca@linux.ibm.com,gor@linux.ibm.com,borntraeger@linux.ibm.com,ajd@linux.ibm.com,agordeev@linux.ibm.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-symbols-determine-kaslr-offset-on-s390.patch added to mm-nonmm-unstable branch
Message-Id: <20250303230004.C1E8FC4CEE8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/gdb/symbols: determine KASLR offset on s390
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-symbols-determine-kaslr-offset-on-s390.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-symbols-determine-kaslr-offset-on-s390.patch

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

scripts-gdb-symbols-determine-kaslr-offset-on-s390.patch

