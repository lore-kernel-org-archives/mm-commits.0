From: akpm@linux-foundation.org
Subject: + mm-swapfilec-make-code-static.patch added to -mm tree
Date: Tue, 06 May 2008 11:36:48 -0700
Message-ID: <200805061836.m46Iamm8021243@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43833 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756015AbYEFShF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 14:37:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, kosaki.motohiro@jp.fujitsu.com


The patch titled
     mm/swapfile.c: make code static
has been added to the -mm tree.  Its filename is
     mm-swapfilec-make-code-static.patch

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
Subject: mm/swapfile.c: make code static
From: Adrian Bunk <bunk@kernel.org>

This patch makes the following needlessly global code static:
- swap_lock
- nr_swapfiles
- struct swap_list

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    3 ---
 mm/swapfile.c        |    6 +++---
 2 files changed, 3 insertions(+), 6 deletions(-)

diff -puN include/linux/swap.h~mm-swapfilec-make-code-static include/linux/swap.h
--- a/include/linux/swap.h~mm-swapfilec-make-code-static
+++ a/include/linux/swap.h
@@ -237,7 +237,6 @@ extern struct page *swapin_readahead(swp
 
 /* linux/mm/swapfile.c */
 extern long total_swap_pages;
-extern unsigned int nr_swapfiles;
 extern void si_swapinfo(struct sysinfo *);
 extern swp_entry_t get_swap_page(void);
 extern swp_entry_t get_swap_page_of_type(int);
@@ -254,8 +253,6 @@ extern int can_share_swap_page(struct pa
 extern int remove_exclusive_swap_page(struct page *);
 struct backing_dev_info;
 
-extern spinlock_t swap_lock;
-
 /* linux/mm/thrash.c */
 extern struct mm_struct * swap_token_mm;
 extern void grab_swap_token(void);
diff -puN mm/swapfile.c~mm-swapfilec-make-code-static mm/swapfile.c
--- a/mm/swapfile.c~mm-swapfilec-make-code-static
+++ a/mm/swapfile.c
@@ -34,8 +34,8 @@
 #include <asm/tlbflush.h>
 #include <linux/swapops.h>
 
-DEFINE_SPINLOCK(swap_lock);
-unsigned int nr_swapfiles;
+static DEFINE_SPINLOCK(swap_lock);
+static unsigned int nr_swapfiles;
 long total_swap_pages;
 static int swap_overflow;
 
@@ -44,7 +44,7 @@ static const char Unused_file[] = "Unuse
 static const char Bad_offset[] = "Bad swap offset entry ";
 static const char Unused_offset[] = "Unused swap offset entry ";
 
-struct swap_list_t swap_list = {-1, -1};
+static struct swap_list_t swap_list = {-1, -1};
 
 static struct swap_info_struct swap_info[MAX_SWAPFILES];
 
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

