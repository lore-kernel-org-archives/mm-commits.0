From: akpm@linux-foundation.org
Subject: + xtensa-remove-the-nonexisting-highmem-support.patch added to -mm tree
Date: Tue, 06 May 2008 11:37:29 -0700
Message-ID: <200805061837.m46IbUTx021314@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764361AbYEFShs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 14:37:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, zankel@tensilica.com


The patch titled
     xtensa: remove the nonexisting highmem support
has been added to the -mm tree.  Its filename is
     xtensa-remove-the-nonexisting-highmem-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
linux-next.patch
md-make-dm_dirty_log_initexit-static.patch
drm-make-drm_minors_cleanup-static.patch
git-udf.patch
nfs-make-nfs4_drop_state_owner-static.patch
show_schedstat-fix-memleak.patch
if-0-ses_match_host.patch
git-watchdog.patch
xen-drivers-xen-balloonc-make-a-function-static.patch
reiser4.patch
remove-is_tty.patch
make-cgroup_seqfile_release-static.patch
make-kprobe_blacklist-static.patch
make-pnp_add_card_id-static.patch
mfd-sm501c-if-0-unused-functions.patch
pcmcia-kill-in_card_services.patch
video-sis-remove-compat-code.patch
make-struct-mpt_proc_root_dir-static.patch
make-parport_cs_release-static.patch
parport-sharec-proper-externs.patch
remove-include-asm-h8300-keyboardh.patch
proper-spawn_ksoftirqd-prototype.patch
proper-pidhashmap_init-prototypes.patch
mm-migratec-should-include-linux-syscallsh.patch
make-mm-sparsec-make-a-function-static.patch
mm-allocpercpuc-make-4-functions-static.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch
minix-remove-no_truncate-code.patch
remove-the-v850-port.patch
mm-vmstatc-proper-externs.patch
mm-hugetlbc-fix-duplicate-variable.patch
drivers-char-rtcc-make-2-functions-static.patch
make-init-do_mountsc-root_device_name-static.patch
init-do_mountsc-should-include-linux-initrdh.patch
proper-prototype-for-acpi_processor_tstate_has_changed.patch
if-0-hpet_unregister.patch
tpm_biosc-make-2-structs-static.patch
proper-extern-for-mwave_s_mdd.patch
xtensa-remove-the-nonexisting-highmem-support.patch
serial-8250_gscc-add-module_license.patch
move-proc_kmsg_operations-to-fs-proc-internalh.patch
unexport-proc_clear_tty.patch
unexport-uts_sem.patch

