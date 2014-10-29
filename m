From: akpm@linux-foundation.org
Subject: + arch-x86-vdso-vmac-fix-build-with-older-gcc.patch added to -mm
 tree
Date: Wed, 29 Oct 2014 12:36:09 -0700
Message-ID: <545141a9.XcS17EWc3zmlsObk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49404 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbaJ2TgI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Oct 2014 15:36:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hpa@zytor.com, luto@amacapital.net, mingo@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/x86/vdso/vma.c: fix build with older gcc
has been added to the -mm tree.  Its filename is
     arch-x86-vdso-vmac-fix-build-with-older-gcc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-x86-vdso-vmac-fix-build-with-older-gcc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-x86-vdso-vmac-fix-build-with-older-gcc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: arch/x86/vdso/vma.c: fix build with older gcc

gcc-4.4.4:

arch/x86/vdso/vma.c: In function 'vgetcpu_cpu_init':
arch/x86/vdso/vma.c:247: error: unknown field 'limit0' specified in initializer
arch/x86/vdso/vma.c:247: warning: missing braces around initializer
arch/x86/vdso/vma.c:247: warning: (near initialization for '(anonymous).<anonymous>')
arch/x86/vdso/vma.c:248: error: unknown field 'limit' specified in initializer
arch/x86/vdso/vma.c:248: warning: excess elements in struct initializer
arch/x86/vdso/vma.c:248: warning: (near initialization for '(anonymous)')
arch/x86/vdso/vma.c:249: error: unknown field 'type' specified in initializer
arch/x86/vdso/vma.c:249: warning: excess elements in struct initializer
arch/x86/vdso/vma.c:249: warning: (near initialization for '(anonymous)')
arch/x86/vdso/vma.c:250: error: unknown field 'dpl' specified in initializer
arch/x86/vdso/vma.c:250: warning: excess elements in struct initializer
arch/x86/vdso/vma.c:250: warning: (near initialization for '(anonymous)')
arch/x86/vdso/vma.c:251: error: unknown field 's' specified in initializer
arch/x86/vdso/vma.c:251: warning: excess elements in struct initializer
arch/x86/vdso/vma.c:251: warning: (near initialization for '(anonymous)')
arch/x86/vdso/vma.c:252: error: unknown field 'p' specified in initializer
arch/x86/vdso/vma.c:252: warning: excess elements in struct initializer
arch/x86/vdso/vma.c:252: warning: (near initialization for '(anonymous)')
arch/x86/vdso/vma.c:253: error: unknown field 'd' specified in initializer
arch/x86/vdso/vma.c:253: warning: excess elements in struct initializer
arch/x86/vdso/vma.c:253: warning: (near initialization for '(anonymous)')

I couldn't find any way of tricking it into accepting an initializer
format :(

Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/vdso/vma.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff -puN arch/x86/vdso/vma.c~arch-x86-vdso-vmac-fix-build-with-older-gcc arch/x86/vdso/vma.c
--- a/arch/x86/vdso/vma.c~arch-x86-vdso-vmac-fix-build-with-older-gcc
+++ a/arch/x86/vdso/vma.c
@@ -230,7 +230,7 @@ __setup("vdso=", vdso_setup);
 static void vgetcpu_cpu_init(void *arg)
 {
 	int cpu = smp_processor_id();
-	struct desc_struct d;
+	struct desc_struct d = { };
 	unsigned long node = 0;
 #ifdef CONFIG_NUMA
 	node = cpu_to_node(cpu);
@@ -243,15 +243,13 @@ static void vgetcpu_cpu_init(void *arg)
 	 * quickly in user space in vgetcpu. (12 bits for the CPU
 	 * and 8 bits for the node)
 	 */
-	d = (struct desc_struct) {
-		.limit0 = cpu | ((node & 0xf) << 12),
-		.limit = node >> 4,
-		.type = 5,		/* RO data, expand down, accessed */
-		.dpl = 3,		/* Visible to user code */
-		.s = 1,			/* Not a system segment */
-		.p = 1,			/* Present */
-		.d = 1,			/* 32-bit */
-	};
+	d.limit0 = cpu | ((node & 0xf) << 12);
+	d.limit = node >> 4;
+	d.type = 5;		/* RO data, expand down, accessed */
+	d.dpl = 3;		/* Visible to user code */
+	d.s = 1;		/* Not a system segment */
+	d.p = 1;		/* Present */
+	d.d = 1;		/* 32-bit */
 
 	write_gdt_entry(get_cpu_gdt_table(cpu), GDT_ENTRY_PER_CPU, &d, DESCTYPE_S);
 }
diff -puN arch/x86/include/asm/desc_defs.h~arch-x86-vdso-vmac-fix-build-with-older-gcc arch/x86/include/asm/desc_defs.h
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
rtc-pm8xxx-rework-to-support-pm8941-rtc-checkpatch-fixes.patch
rtc-pm8xxx-rework-to-support-pm8941-rtc-fix.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkpatch-fixes.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
mm.patch
mm-memcontrol-lockless-page-counters-fix.patch
mm-memcontrol-lockless-page-counters-fix-fix.patch
kernel-res_counter-remove-the-unused-api-fix.patch
mm-compaction-simplify-deferred-compaction-fix.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag-fix.patch
mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move-fix.patch
lib-show_mem-this-patch-adds-cma-reserved-infromation-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
fs-proc-use-a-rb-tree-for-the-directory-entries-fix.patch
fs-binfmt_miscc-use-gfp_kernel-instead-of-gfp_user.patch
init-allow-config_init_fallback=n-to-disable-defaults-if-init=-fails-checkpatch-fixes.patch
rtc-omap-add-support-for-pmic_power_en-v3-fix.patch
sysctl-terminate-strings-also-on-r-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix-fix.patch
ipc-msg-increase-msgmni-remove-scaling-checkpatch-fixes.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
arch-x86-vdso-vmac-fix-build-with-older-gcc.patch
mm-cma-make-kmemleak-ignore-cma-regions.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
debugging-keep-track-of-page-owners.patch
debugging-keep-track-of-page-owners-fix.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

