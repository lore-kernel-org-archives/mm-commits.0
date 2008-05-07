From: akpm@linux-foundation.org
Subject: - xtensa-remove-the-nonexisting-highmem-support.patch removed from -mm tree
Date: Tue, 06 May 2008 22:23:56 -0700
Message-ID: <200805070523.m475NuoA013234@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47546 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754721AbYEGFYQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2008 01:24:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, zankel@tensilica.com, mm-commits@vger.kernel.org


The patch titled
     xtensa: remove the nonexisting highmem support
has been removed from the -mm tree.  Its filename was
     xtensa-remove-the-nonexisting-highmem-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xtensa: remove the nonexisting highmem support
From: Adrian Bunk <bunk@kernel.org>

Trying to compile an xtensa kernel with CONFIG_HIGHMEM=y fails early and
hard:

<--  snip  -->

...
  CC      init/main.o
In file included from
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/pagemap.h:10,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/buffer_head.h:13,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/init/main.c:53:
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/highmem.h: In function 'clear_user_highpage':
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/highmem.h:68: error: implicit declaration of function 'kmap_atomic'
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/highmem.h:68: error: 'KM_USER0' undeclared (first use in this function)
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/highmem.h:68: error: (Each undeclared identifier is reported only once
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/highmem.h:68: error: for each function it appears in.)
...
make[2]: *** [init/main.o] Error 1

<--  snip  -->

This patch removes all traces of highmem support from the
xtensa port - highmem support was simply nonexisting.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Chris Zankel <zankel@tensilica.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/Kconfig          |    3 ---
 arch/xtensa/mm/init.c        |    8 --------
 include/asm-xtensa/highmem.h |   17 -----------------
 3 files changed, 28 deletions(-)

diff -puN arch/xtensa/Kconfig~xtensa-remove-the-nonexisting-highmem-support arch/xtensa/Kconfig
--- a/arch/xtensa/Kconfig~xtensa-remove-the-nonexisting-highmem-support
+++ a/arch/xtensa/Kconfig
@@ -119,9 +119,6 @@ config MATH_EMULATION
 	help
 	Can we use information of configuration file?
 
-config HIGHMEM
-	bool "High memory support"
-
 endmenu
 
 menu "Platform options"
diff -puN arch/xtensa/mm/init.c~xtensa-remove-the-nonexisting-highmem-support arch/xtensa/mm/init.c
--- a/arch/xtensa/mm/init.c~xtensa-remove-the-nonexisting-highmem-support
+++ a/arch/xtensa/mm/init.c
@@ -169,10 +169,6 @@ void __init paging_init(void)
 	for (i = 1; i < MAX_NR_ZONES; i++)
 		zones_size[i] = 0;
 
-#ifdef CONFIG_HIGHMEM
-	zones_size[ZONE_HIGHMEM] = max_pfn - max_low_pfn;
-#endif
-
 	/* Initialize the kernel's page tables. */
 
 	memset(swapper_pg_dir, 0, PAGE_SIZE);
@@ -222,10 +218,6 @@ void __init mem_init(void)
 	high_memory = (void *) __va(max_mapnr << PAGE_SHIFT);
 	highmemsize = 0;
 
-#ifdef CONFIG_HIGHMEM
-#error HIGHGMEM not implemented in init.c
-#endif
-
 	totalram_pages += free_all_bootmem();
 
 	reservedpages = ram = 0;
diff -puN include/asm-xtensa/highmem.h~xtensa-remove-the-nonexisting-highmem-support /dev/null
--- a/include/asm-xtensa/highmem.h
+++ /dev/null
@@ -1,17 +0,0 @@
-/*
- * include/asm-xtensa/highmem.h
- *
- * This file is subject to the terms and conditions of the GNU General
- * Public License.  See the file "COPYING" in the main directory of
- * this archive for more details.
- *
- * Copyright (C) 2003 - 2005 Tensilica Inc.
- */
-
-#ifndef _XTENSA_HIGHMEM_H
-#define _XTENSA_HIGHMEM_H
-
-extern void flush_cache_kmaps(void);
-
-#endif
-
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
uml-remove-unused-header.patch
linux-next.patch
proper-prototype-for-acpi_processor_tstate_has_changed.patch
git-avr32.patch
md-make-dm_dirty_log_initexit-static.patch
drm-make-drm_minors_cleanup-static.patch
git-input.patch
git-udf.patch
nfs-make-nfs4_drop_state_owner-static.patch
show_schedstat-fix-memleak.patch
if-0-ses_match_host.patch
git-sparc64.patch
git-watchdog.patch
git-xtensa.patch
mm-migratec-should-include-linux-syscallsh.patch
mm-vmstatc-proper-externs.patch
mm-hugetlbc-fix-duplicate-variable.patch
remove-include-asm-h8300-keyboardh.patch
pcmcia-kill-in_card_services.patch
remove-the-v850-port.patch
init-do_mountsc-should-include-linux-initrdh.patch
proper-spawn_ksoftirqd-prototype.patch
serial-8250_gscc-add-module_license.patch
mfd-sm501c-if-0-unused-functions.patch
xen-drivers-xen-balloonc-make-a-function-static.patch
video-sis-remove-compat-code.patch
minix-remove-no_truncate-code.patch
remove-is_tty.patch
proper-extern-for-mwave_s_mdd.patch
if-0-hpet_unregister.patch
unexport-proc_clear_tty.patch
move-proc_kmsg_operations-to-fs-proc-internalh.patch
proper-pidhashmap_init-prototypes.patch
unexport-uts_sem.patch
parport-sharec-proper-externs.patch
tpm_biosc-make-2-structs-static.patch
make-cgroup_seqfile_release-static.patch
make-kprobe_blacklist-static.patch
make-pnp_add_card_id-static.patch
make-struct-mpt_proc_root_dir-static.patch
make-parport_cs_release-static.patch
make-mm-sparsec-make-a-function-static.patch
mm-allocpercpuc-make-4-functions-static.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch
drivers-char-rtcc-make-2-functions-static.patch
make-init-do_mountsc-root_device_name-static.patch
reiser4.patch

