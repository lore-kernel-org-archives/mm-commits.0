From: akpm@linux-foundation.org
Subject: [folded-merged] fs-elf-drop-map_fixed-usage-from-elf_map.patch
 removed from -mm tree
Date: Wed, 07 Feb 2018 14:44:59 -0800
Message-ID: <5a7b816b.JCQe7vBYsrHRzT0y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38512 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752026AbeBGWpA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 17:45:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, abdhalee@linux.vnet.ibm.com, joel@jms.id.au, keescook@chromium.org, khalid.aziz@oracle.com, khandual@linux.vnet.ibm.com, mpe@ellerman.id.au, mm-commits@vger.kernel.org


The patch titled
     Subject: fs, elf: drop MAP_FIXED usage from elf_map
has been removed from the -mm tree.  Its filename was
     fs-elf-drop-map_fixed-usage-from-elf_map.patch

This patch was dropped because it was folded into mm-introduce-map_fixed_safe.patch

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: fs, elf: drop MAP_FIXED usage from elf_map

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

Address this issue by changing MAP_FIXED to the newly added
MAP_FIXED_NOREPLACE.  This will mean that mmap will fail if there is an
existing mapping clashing with the requested one without clobbering it.

Link: http://lkml.kernel.org/r/20171213092550.2774-3-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Khalid Aziz <khalid.aziz@oracle.com>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Cc: Joel Stanley <joel@jms.id.au>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/metag/kernel/process.c |    6 +++++-
 fs/binfmt_elf.c             |   12 ++++++++----
 2 files changed, 13 insertions(+), 5 deletions(-)

diff -puN arch/metag/kernel/process.c~fs-elf-drop-map_fixed-usage-from-elf_map arch/metag/kernel/process.c
--- a/arch/metag/kernel/process.c~fs-elf-drop-map_fixed-usage-from-elf_map
+++ a/arch/metag/kernel/process.c
@@ -399,7 +399,7 @@ unsigned long __metag_elf_map(struct fil
 	tcm_tag = tcm_lookup_tag(addr);
 
 	if (tcm_tag != TCM_INVALID_TAG)
-		type &= ~MAP_FIXED;
+		type &= ~(MAP_FIXED | MAP_FIXED_NOREPLACE);
 
 	/*
 	* total_size is the size of the ELF (interpreter) image.
@@ -417,6 +417,10 @@ unsigned long __metag_elf_map(struct fil
 	} else
 		map_addr = vm_mmap(filep, addr, size, prot, type, off);
 
+	if ((type & MAP_FIXED_NOREPLACE) && BAD_ADDR(map_addr))
+		pr_info("%d (%s): Uhuuh, elf segement at %p requested but the memory is mapped already\n",
+				task_pid_nr(current), tsk->comm, (void*)addr);
+
 	if (!BAD_ADDR(map_addr) && tcm_tag != TCM_INVALID_TAG) {
 		struct tcm_allocation *tcm;
 		unsigned long tcm_addr;
diff -puN fs/binfmt_elf.c~fs-elf-drop-map_fixed-usage-from-elf_map fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~fs-elf-drop-map_fixed-usage-from-elf_map
+++ a/fs/binfmt_elf.c
@@ -377,6 +377,10 @@ static unsigned long elf_map(struct file
 	} else
 		map_addr = vm_mmap(filep, addr, size, prot, type, off);
 
+	if ((type & MAP_FIXED_NOREPLACE) && BAD_ADDR(map_addr))
+		pr_info("%d (%s): Uhuuh, elf segement at %p requested but the memory is mapped already\n",
+				task_pid_nr(current), current->comm, (void*)addr);
+
 	return(map_addr);
 }
 
@@ -575,7 +579,7 @@ static unsigned long load_elf_interp(str
 				elf_prot |= PROT_EXEC;
 			vaddr = eppnt->p_vaddr;
 			if (interp_elf_ex->e_type == ET_EXEC || load_addr_set)
-				elf_type |= MAP_FIXED;
+				elf_type |= MAP_FIXED_NOREPLACE;
 			else if (no_base && interp_elf_ex->e_type == ET_DYN)
 				load_addr = -vaddr;
 
@@ -939,7 +943,7 @@ static int load_elf_binary(struct linux_
 		 * the ET_DYN load_addr calculations, proceed normally.
 		 */
 		if (loc->elf_ex.e_type == ET_EXEC || load_addr_set) {
-			elf_flags |= MAP_FIXED;
+			elf_flags |= MAP_FIXED_NOREPLACE;
 		} else if (loc->elf_ex.e_type == ET_DYN) {
 			/*
 			 * This logic is run once for the first LOAD Program
@@ -975,7 +979,7 @@ static int load_elf_binary(struct linux_
 				load_bias = ELF_ET_DYN_BASE;
 				if (current->flags & PF_RANDOMIZE)
 					load_bias += arch_mmap_rnd();
-				elf_flags |= MAP_FIXED;
+				elf_flags |= MAP_FIXED_NOREPLACE;
 			} else
 				load_bias = 0;
 
@@ -1234,7 +1238,7 @@ static int load_elf_library(struct file
 			(eppnt->p_filesz +
 			 ELF_PAGEOFFSET(eppnt->p_vaddr)),
 			PROT_READ | PROT_WRITE | PROT_EXEC,
-			MAP_FIXED | MAP_PRIVATE | MAP_DENYWRITE,
+			MAP_FIXED_NOREPLACE | MAP_PRIVATE | MAP_DENYWRITE,
 			(eppnt->p_offset -
 			 ELF_PAGEOFFSET(eppnt->p_vaddr)));
 	if (error != ELF_PAGESTART(eppnt->p_vaddr))
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-oom-docs-describe-the-cgroup-aware-oom-killer-fix-2.patch
mm-introduce-map_fixed_safe.patch
fs-elf-drop-map_fixed-usage-from-elf_map-fix-fix.patch
mm-numa-rework-do_pages_move.patch
mm-migrate-remove-reason-argument-from-new_page_t.patch
mm-migrate-remove-reason-argument-from-new_page_t-fix-3.patch
mm-unclutter-thp-migration.patch
net-netfilter-x_tablesc-remove-size-check.patch

