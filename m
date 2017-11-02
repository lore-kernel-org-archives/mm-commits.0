From: akpm@linux-foundation.org
Subject: + fs-elf-drop-map_fixed-usage-from-elf_map.patch added to -mm
 tree
Date: Thu, 02 Nov 2017 14:35:25 -0700
Message-ID: <59fb8f9d.2tku4dfwUaOnvrox%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38428 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964829AbdKBVf0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Nov 2017 17:35:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, bhe@redhat.com, james.hogan@mips.com, jkosina@suse.cz, keescook@chromium.org, mingo@redhat.com, oleg@redhat.com, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/binfmt_elf.c: drop MAP_FIXED usage from elf_map
has been added to the -mm tree.  Its filename is
     fs-elf-drop-map_fixed-usage-from-elf_map.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-elf-drop-map_fixed-usage-from-elf_map.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-elf-drop-map_fixed-usage-from-elf_map.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: fs/binfmt_elf.c: drop MAP_FIXED usage from elf_map

Both load_elf_interp and load_elf_binary rely on elf_map to map segments
on a controlled address and they use MAP_FIXED to enforce that.  This is
however dangerous thing prone to silent data corruption which can be even
exploitable.  Let's take CVE-2017-1000253 as an example.  At the time
(before eab09532d400 ("binfmt_elf: use ELF_ET_DYN_BASE only for PIE"))
ELF_ET_DYN_BASE was at TASK_SIZE / 3 * 2 which is not that far away from
the stack top on 32b (legacy) memory layout (only 1GB away).  Therefore we
could end up mapping over the existing stack with some luck.

The issue has been fixed since then (a87938b2e246 ("fs/binfmt_elf.c: fix
bug in loading of PIE binaries")), ELF_ET_DYN_BASE moved moved much
further from the stack (eab09532d400 and later by c715b72c1ba4 ("mm:
revert x86_64 and arm64 ELF_ET_DYN_BASE base changes")) and excessive
stack consumption early during execve fully stopped by da029c11e6b1
("exec: Limit arg stack to at most 75% of _STK_LIM").  So we should be
safe and any attack should be impractical.  On the other hand this is just
too subtle assumption so it can break quite easily and hard to spot.

I believe that the MAP_FIXED usage in load_elf_binary (et.  al) is still
fundamentally dangerous.  Moreover it shouldn't be even needed.  We are at
the early process stage and so there shouldn't be unrelated mappings
(except for stack and loader) existing so mmap for a given address should
succeed even without MAP_FIXED.  Something is terribly wrong if this is
not the case and we should rather fail than silently corrupt the
underlying mapping.

Address this issue by adding a helper elf_vm_mmap used by elf_map which
drops MAP_FIXED when asking for the mapping and check whether the returned
address really matches what the caller asked for and complain loudly if
this is not the case and fail.  Such a failure would be a kernel bug and
it should alarm us to look what has gone wrong.

Link: http://lkml.kernel.org/r/20171023082608.6167-1-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: James Hogan <james.hogan@mips.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/metag/kernel/process.c |   27 +++++++++++++++++++++++++--
 fs/binfmt_elf.c             |   29 ++++++++++++++++++++++++++---
 2 files changed, 51 insertions(+), 5 deletions(-)

diff -puN arch/metag/kernel/process.c~fs-elf-drop-map_fixed-usage-from-elf_map arch/metag/kernel/process.c
--- a/arch/metag/kernel/process.c~fs-elf-drop-map_fixed-usage-from-elf_map
+++ a/arch/metag/kernel/process.c
@@ -379,6 +379,29 @@ int dump_fpu(struct pt_regs *regs, elf_f
 
 #define BAD_ADDR(x) ((unsigned long)(x) >= TASK_SIZE)
 
+static unsigned long elf_vm_mmap(struct file *filep, unsigned long addr,
+		unsigned long size, int prot, int type, unsigned long off)
+{
+	unsigned long map_addr;
+
+	/*
+	 * If caller requests the mapping at a specific place, make sure we fail
+	 * rather than potentially clobber an existing mapping which can have
+	 * security consequences (e.g. smash over the stack area).
+	 */
+	map_addr = vm_mmap(filep, addr, size, prot, type & ~MAP_FIXED, off);
+	if (BAD_ADDR(map_addr))
+		return map_addr;
+
+	if ((type & MAP_FIXED) && map_addr != addr) {
+		pr_info("Uhuuh, elf segement at %p requested but the memory is mapped already\n",
+				(void*)addr);
+		return -EAGAIN;
+	}
+
+	return map_addr;
+}
+
 unsigned long __metag_elf_map(struct file *filep, unsigned long addr,
 			      struct elf_phdr *eppnt, int prot, int type,
 			      unsigned long total_size)
@@ -411,11 +434,11 @@ unsigned long __metag_elf_map(struct fil
 	*/
 	if (total_size) {
 		total_size = ELF_PAGEALIGN(total_size);
-		map_addr = vm_mmap(filep, addr, total_size, prot, type, off);
+		map_addr = elf_vm_mmap(filep, addr, total_size, prot, type, off);
 		if (!BAD_ADDR(map_addr))
 			vm_munmap(map_addr+size, total_size-size);
 	} else
-		map_addr = vm_mmap(filep, addr, size, prot, type, off);
+		map_addr = elf_vm_mmap(filep, addr, size, prot, type, off);
 
 	if (!BAD_ADDR(map_addr) && tcm_tag != TCM_INVALID_TAG) {
 		struct tcm_allocation *tcm;
diff -puN fs/binfmt_elf.c~fs-elf-drop-map_fixed-usage-from-elf_map fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~fs-elf-drop-map_fixed-usage-from-elf_map
+++ a/fs/binfmt_elf.c
@@ -341,6 +341,29 @@ create_elf_tables(struct linux_binprm *b
 
 #ifndef elf_map
 
+static unsigned long elf_vm_mmap(struct file *filep, unsigned long addr,
+		unsigned long size, int prot, int type, unsigned long off)
+{
+	unsigned long map_addr;
+
+	/*
+	 * If caller requests the mapping at a specific place, make sure we fail
+	 * rather than potentially clobber an existing mapping which can have
+	 * security consequences (e.g. smash over the stack area).
+	 */
+	map_addr = vm_mmap(filep, addr, size, prot, type & ~MAP_FIXED, off);
+	if (BAD_ADDR(map_addr))
+		return map_addr;
+
+	if ((type & MAP_FIXED) && map_addr != addr) {
+		pr_info("Uhuuh, elf segement at %p requested but the memory is mapped already\n",
+				(void*)addr);
+		return -EAGAIN;
+	}
+
+	return map_addr;
+}
+
 static unsigned long elf_map(struct file *filep, unsigned long addr,
 		struct elf_phdr *eppnt, int prot, int type,
 		unsigned long total_size)
@@ -366,11 +389,11 @@ static unsigned long elf_map(struct file
 	*/
 	if (total_size) {
 		total_size = ELF_PAGEALIGN(total_size);
-		map_addr = vm_mmap(filep, addr, total_size, prot, type, off);
+		map_addr = elf_vm_mmap(filep, addr, total_size, prot, type, off);
 		if (!BAD_ADDR(map_addr))
 			vm_munmap(map_addr+size, total_size-size);
 	} else
-		map_addr = vm_mmap(filep, addr, size, prot, type, off);
+		map_addr = elf_vm_mmap(filep, addr, size, prot, type, off);
 
 	return(map_addr);
 }
@@ -1218,7 +1241,7 @@ static int load_elf_library(struct file
 		eppnt++;
 
 	/* Now use mmap to map the library into memory. */
-	error = vm_mmap(file,
+	error = elf_vm_mmap(file,
 			ELF_PAGESTART(eppnt->p_vaddr),
 			(eppnt->p_filesz +
 			 ELF_PAGEOFFSET(eppnt->p_vaddr)),
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-memory_hotplug-do-not-back-off-draining-pcp-free-pages-from-kworker-context.patch
mm-drop-migrate-type-checks-from-has_unmovable_pages.patch
mm-distinguish-cma-and-movable-isolation-in-has_unmovable_pages.patch
mm-page_alloc-fail-has_unmovable_pages-when-seeing-reserved-pages.patch
mm-memory_hotplug-do-not-fail-offlining-too-early.patch
mm-memory_hotplug-remove-timeout-from-__offline_memory.patch
mm-hugetlb-drop-hugepages_treat_as_movable-sysctl.patch
mm-arch-remove-empty_bad_page.patch
fs-elf-drop-map_fixed-usage-from-elf_map.patch

