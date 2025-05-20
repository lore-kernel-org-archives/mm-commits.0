Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83CD0253B7A
	for <mm-commits@vger.kernel.org>; Tue, 20 May 2025 00:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747700377; cv=none; b=lX11gPlUGd4fVnp3ZDcl+RdacewX/KYMjtqZA7dIK76eckzWuMMq1tpITvNYHmHHq4W5DnS9xFGuYs9/DydQpRTywMiP2cYpgFNpGvvpYHPzR7uon8wZgn8ZN0WSojegOP+tt97XaxKgZYAM4+nW8awN5hg5fE4STeP2JVUnN+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747700377; c=relaxed/simple;
	bh=LCCNUisCB4fh03zbmDswjVFde39vZzOuRoWbskIjx3E=;
	h=Date:To:From:Subject:Message-Id; b=PxdAAZPJ2wPt2Wy+2rco7HZKCfYo0/5c+ECExHxRZuRmRCzf+BgxU7Hky8r+7XzTUt767VTpZHAahXb7UdZxsT4I4aFUw7wwc2nrVDP9aQ4yOjaMP/D1aGVVRTZ0bHUTB1RF5Yz4lqAok7kMu3gc2a5Nx9wZpj/48eqPZlwzqx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U9GndY/c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U9GndY/c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF81C4CEE4;
	Tue, 20 May 2025 00:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747700377;
	bh=LCCNUisCB4fh03zbmDswjVFde39vZzOuRoWbskIjx3E=;
	h=Date:To:From:Subject:From;
	b=U9GndY/cawZwI/buTEdyyHYJ3vn9/Yf2zK3veThZU2kDH6VgIEg54+xK9TOydQ6wm
	 cTjmJR6ADBxV3v1e8wjnSiCQVtNPlQGeNKykCkRgf/ehLPEa0FsNZb93E0Ex+EcPGy
	 PMEnPqsV+N3YkEoBNtGSz3qw4mokFTxx6431TlkU=
Date: Mon, 19 May 2025 17:19:36 -0700
To: mm-commits@vger.kernel.org,kbingham@kernel.org,jan.kiszka@siemens.com,hca@linux.ibm.com,gor@linux.ibm.com,agordeev@linux.ibm.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-symbols-determine-kaslr-offset-on-s390-during-early-boot.patch added to mm-nonmm-unstable branch
Message-Id: <20250520001937.3DF81C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/gdb/symbols: determine KASLR offset on s390 during early boot
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-symbols-determine-kaslr-offset-on-s390-during-early-boot.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-symbols-determine-kaslr-offset-on-s390-during-early-boot.patch

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
Subject: scripts/gdb/symbols: determine KASLR offset on s390 during early boot
Date: Thu, 15 May 2025 17:52:13 +0200

Using lx-symbols during s390 early boot fails with:

    Error occurred in Python: 'utf-8' codec can't decode byte 0xcb in position 0: invalid continuation byte

The reason is that s390 decompressor's startup_kernel() does not create
vmcoreinfo note, and sets vmcore_info to kernel's physical base.  This
confuses get_vmcore_s390().

Fix by handling this special case.  Extract vm_layout.kaslr_offset from
the kernel image in physical memory, which is placed there by the
decompressor using the __bootdata_preserved mechanism, and generate a
synthetic vmcoreinfo note from it.

Link: https://lkml.kernel.org/r/20250515155811.114392-4-iii@linux.ibm.com
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/symbols.py |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/scripts/gdb/linux/symbols.py~scripts-gdb-symbols-determine-kaslr-offset-on-s390-during-early-boot
+++ a/scripts/gdb/linux/symbols.py
@@ -54,6 +54,18 @@ def get_vmcore_s390():
         vmcore_info = 0x0e0c
         paddr_vmcoreinfo_note = gdb.parse_and_eval("*(unsigned long long *)" +
                                                    hex(vmcore_info))
+        if paddr_vmcoreinfo_note == 0 or paddr_vmcoreinfo_note & 1:
+            # In the early boot case, extract vm_layout.kaslr_offset from the
+            # vmlinux image in physical memory.
+            if paddr_vmcoreinfo_note == 0:
+                kaslr_offset_phys = 0
+            else:
+                kaslr_offset_phys = paddr_vmcoreinfo_note - 1
+            with utils.pagination_off():
+                gdb.execute("symbol-file {0} -o {1}".format(
+                    utils.get_vmlinux(), hex(kaslr_offset_phys)))
+            kaslr_offset = gdb.parse_and_eval("vm_layout.kaslr_offset")
+            return "KERNELOFFSET=" + hex(kaslr_offset)[2:]
         inferior = gdb.selected_inferior()
         elf_note = inferior.read_memory(paddr_vmcoreinfo_note, 12)
         n_namesz, n_descsz, n_type = struct.unpack(">III", elf_note)
_

Patches currently in -mm which might be from iii@linux.ibm.com are

scripts-gdb-symbols-factor-out-get_vmlinux.patch
scripts-gdb-symbols-factor-out-pagination_off.patch
scripts-gdb-symbols-determine-kaslr-offset-on-s390-during-early-boot.patch

