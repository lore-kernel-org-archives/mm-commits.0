From: akpm@linux-foundation.org
Subject: + pie-executable-randomization-checkpatch-fixes.patch added to -mm tree
Date: Tue, 23 Oct 2007 14:06:25 -0700
Message-ID: <200710232106.l9NL6PIa006416@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59325 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752525AbXJWVHm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Oct 2007 17:07:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, arjan@infradead.org, jakub@redhat.com, jkosina@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, mingo@elte.hu, roland@redhat.com, tglx@linutronix.de, tony.luck@intel.com


The patch titled
     pie-executable-randomization-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     pie-executable-randomization-checkpatch-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pie-executable-randomization-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#39: FILE: arch/ia64/ia32/binfmt_elf32.c:229:
+elf32_map (struct file *filep, unsigned long addr, struct elf_phdr *eppnt, int prot, int type, unsigned long unused)

WARNING: no space between function name and open parenthesis '('
#39: FILE: arch/ia64/ia32/binfmt_elf32.c:229:
+elf32_map (struct file *filep, unsigned long addr, struct elf_phdr *eppnt, int prot, int type, unsigned long unused)

WARNING: line over 80 characters
#67: FILE: arch/x86/kernel/sys_x86_64.c:80:
+			new_begin = randomize_range(*begin, *begin + 0x02000000, 0);

ERROR: use tabs not spaces
#110: FILE: arch/x86/kernel/sys_x86_64.c:185:
+ ^I        mm->cached_hole_size = 0;$

ERROR: use tabs not spaces
#111: FILE: arch/x86/kernel/sys_x86_64.c:186:
+ ^I^Imm->free_area_cache = mm->mmap_base;$

ERROR: use tabs not spaces
#112: FILE: arch/x86/kernel/sys_x86_64.c:187:
+ ^I}$

ERROR: use tabs not spaces
#141: FILE: arch/x86/kernel/sys_x86_64.c:216:
+ ^I^I/* remember the largest hole we saw so far */$

ERROR: use tabs not spaces
#142: FILE: arch/x86/kernel/sys_x86_64.c:217:
+ ^I^Iif (addr + mm->cached_hole_size < vma->vm_start)$

ERROR: use tabs not spaces
#143: FILE: arch/x86/kernel/sys_x86_64.c:218:
+ ^I^I        mm->cached_hole_size = vma->vm_start - addr;$

ERROR: use tabs not spaces
#157: FILE: arch/x86/kernel/sys_x86_64.c:232:
+  ^Imm->free_area_cache = TASK_UNMAPPED_BASE;$

ERROR: need a space before the open parenthesis '('
#291: FILE: arch/x86/mm/mmap_64.c:101:
+	} else if(mmap_is_legacy()) {

WARNING: braces {} are not necessary for single statement blocks
#302: FILE: arch/x86/mm/mmap_64.c:112:
+	if (current->flags & PF_RANDOMIZE) {
+		mm->mmap_base += ((long)rnd) << PAGE_SHIFT;
+	}

WARNING: line over 80 characters
#314: FILE: fs/binfmt_elf.c:48:
+static unsigned long elf_map (struct file *, unsigned long, struct elf_phdr *, int, int, unsigned long);

WARNING: no space between function name and open parenthesis '('
#314: FILE: fs/binfmt_elf.c:48:
+static unsigned long elf_map (struct file *, unsigned long, struct elf_phdr *, int, int, unsigned long);

WARNING: line over 80 characters
#429: FILE: fs/binfmt_elf.c:438:
+					   eppnt, elf_prot, elf_type, total_size);

ERROR: need space after that ',' (ctx:VxV)
#480: FILE: fs/binfmt_elf.c:939:
+				elf_prot, elf_flags,0);
 				                   ^

total: 9 errors, 7 warnings, 461 lines checked
Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jakub Jelinek <jakub@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/ia32/binfmt_elf32.c |    3 ++-
 arch/x86/kernel/sys_x86_64.c  |   14 +++++++-------
 arch/x86/mm/mmap_64.c         |    5 ++---
 fs/binfmt_elf.c               |    7 ++++---
 4 files changed, 15 insertions(+), 14 deletions(-)

diff -puN arch/ia64/ia32/binfmt_elf32.c~pie-executable-randomization-checkpatch-fixes arch/ia64/ia32/binfmt_elf32.c
--- a/arch/ia64/ia32/binfmt_elf32.c~pie-executable-randomization-checkpatch-fixes
+++ a/arch/ia64/ia32/binfmt_elf32.c
@@ -226,7 +226,8 @@ elf32_set_personality (void)
 }
 
 static unsigned long
-elf32_map (struct file *filep, unsigned long addr, struct elf_phdr *eppnt, int prot, int type, unsigned long unused)
+elf32_map(struct file *filep, unsigned long addr, struct elf_phdr *eppnt,
+		int prot, int type, unsigned long unused)
 {
 	unsigned long pgoff = (eppnt->p_vaddr) & ~IA32_PAGE_MASK;
 
diff -puN arch/x86/kernel/sys_x86_64.c~pie-executable-randomization-checkpatch-fixes arch/x86/kernel/sys_x86_64.c
--- a/arch/x86/kernel/sys_x86_64.c~pie-executable-randomization-checkpatch-fixes
+++ a/arch/x86/kernel/sys_x86_64.c
@@ -182,9 +182,9 @@ arch_get_unmapped_area_topdown(struct fi
 
 	/* check if free_area_cache is useful for us */
 	if (len <= mm->cached_hole_size) {
- 	        mm->cached_hole_size = 0;
- 		mm->free_area_cache = mm->mmap_base;
- 	}
+		mm->cached_hole_size = 0;
+		mm->free_area_cache = mm->mmap_base;
+	}
 
 	/* either no address requested or can't fit in requested address hole */
 	addr = mm->free_area_cache;
@@ -213,9 +213,9 @@ arch_get_unmapped_area_topdown(struct fi
 			/* remember the address as a hint for next time */
 			return (mm->free_area_cache = addr);
 
- 		/* remember the largest hole we saw so far */
- 		if (addr + mm->cached_hole_size < vma->vm_start)
- 		        mm->cached_hole_size = vma->vm_start - addr;
+		/* remember the largest hole we saw so far */
+		if (addr + mm->cached_hole_size < vma->vm_start)
+			mm->cached_hole_size = vma->vm_start - addr;
 
 		/* try just below the current vma->vm_start */
 		addr = vma->vm_start-len;
@@ -229,7 +229,7 @@ bottomup:
 	 * allocations.
 	 */
 	mm->cached_hole_size = ~0UL;
-  	mm->free_area_cache = TASK_UNMAPPED_BASE;
+	mm->free_area_cache = TASK_UNMAPPED_BASE;
 	addr = arch_get_unmapped_area(filp, addr0, len, pgoff, flags);
 	/*
 	 * Restore the topdown base:
diff -puN arch/x86/mm/mmap_64.c~pie-executable-randomization-checkpatch-fixes arch/x86/mm/mmap_64.c
--- a/arch/x86/mm/mmap_64.c~pie-executable-randomization-checkpatch-fixes
+++ a/arch/x86/mm/mmap_64.c
@@ -98,7 +98,7 @@ void arch_pick_mmap_layout(struct mm_str
 		/* ia32_pick_mmap_layout has its own. */
 		return ia32_pick_mmap_layout(mm);
 #endif
-	} else if(mmap_is_legacy()) {
+	} else if (mmap_is_legacy()) {
 		mm->mmap_base = TASK_UNMAPPED_BASE;
 		mm->get_unmapped_area = arch_get_unmapped_area;
 		mm->unmap_area = arch_unmap_area;
@@ -109,7 +109,6 @@ void arch_pick_mmap_layout(struct mm_str
 		if (current->flags & PF_RANDOMIZE)
 			rnd = -rnd;
 	}
-	if (current->flags & PF_RANDOMIZE) {
+	if (current->flags & PF_RANDOMIZE)
 		mm->mmap_base += ((long)rnd) << PAGE_SHIFT;
-	}
 }
diff -puN fs/binfmt_elf.c~pie-executable-randomization-checkpatch-fixes fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~pie-executable-randomization-checkpatch-fixes
+++ a/fs/binfmt_elf.c
@@ -45,7 +45,8 @@
 
 static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs);
 static int load_elf_library(struct file *);
-static unsigned long elf_map (struct file *, unsigned long, struct elf_phdr *, int, int, unsigned long);
+static unsigned long elf_map(struct file *, unsigned long, struct elf_phdr *,
+				int, int, unsigned long);
 
 /*
  * If we don't support core dumping, then supply a NULL so we
@@ -435,7 +436,7 @@ static unsigned long load_elf_interp(str
 				load_addr = -vaddr;
 
 			map_addr = elf_map(interpreter, load_addr + vaddr,
-					   eppnt, elf_prot, elf_type, total_size);
+					eppnt, elf_prot, elf_type, total_size);
 			total_size = 0;
 			if (!*interp_map_addr)
 				*interp_map_addr = map_addr;
@@ -936,7 +937,7 @@ static int load_elf_binary(struct linux_
 		}
 
 		error = elf_map(bprm->file, load_bias + vaddr, elf_ppnt,
-				elf_prot, elf_flags,0);
+				elf_prot, elf_flags, 0);
 		if (BAD_ADDR(error)) {
 			send_sig(SIGKILL, current, 0);
 			retval = IS_ERR((void *)error) ?
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
acpi-add-reboot-mechanism.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
ia64-slim-down-__clear_bit_unlock-checkpatch-fixes.patch
first-stab-at-elantech-touchpad-driver-for-26226-testers.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
ide-arm-hack.patch
nf_ct_alloc_hashtable-use-__gfp_nowarn.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd-fixup.patch
fix-build-breakage-if-sysfs-fix.patch
git-scsi-misc.patch
git-unionfs.patch
git-watchdog-fixup.patch
documentation-watchdog-src-watchdog-simplec-improve-this-code-checkpatch-fixes.patch
git-wireless.patch
git-wireless-fixup.patch
jiffies_round-jiffies_round_relative-conversion-rt2x00-checkpatch-fixes.patch
git-x86.patch
oprofile-op_model_athalonc-support-for-amd-family10h-barcelona-performance-counters-checkpatch-fixes.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
pm-qos-infrastructure-and-interface.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers.patch
deprecate-smbfs-in-favour-of-cifs.patch
procfs-detect-duplicate-names.patch
kernel-printkc-concerns-about-the-console-handover.patch
fix-versus-precedence-in-various-places-checkpatch-fixes.patch
pie-executable-randomization.patch
pie-executable-randomization-checkpatch-fixes.patch
sync_sb_inodes-propagate-errors.patch
peterz-vs-ext4-mballoc-core.patch
64-bit-i_version-afs-fixes.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
ftd_sio-clean-ups-and-updates-for-new-termios-work-checkpatch-fixes.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
w1-build-fix.patch
