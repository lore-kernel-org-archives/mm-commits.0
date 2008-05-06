From: akpm@linux-foundation.org
Subject: + make-mm-memoryc-print_bad_pte-static.patch added to -mm tree
Date: Tue, 06 May 2008 11:36:46 -0700
Message-ID: <200805061836.m46IakLR021239@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36167 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756370AbYEFShA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 14:37:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, kosaki.motohiro@jp.fujitsu.com


The patch titled
     make mm/memory.c:print_bad_pte() static
has been added to the -mm tree.  Its filename is
     make-mm-memoryc-print_bad_pte-static.patch

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
Subject: make mm/memory.c:print_bad_pte() static
From: Adrian Bunk <bunk@kernel.org>

This patch makes the needlessly global print_bad_pte() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 -
 mm/memory.c        |    3 ++-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/mm.h~make-mm-memoryc-print_bad_pte-static include/linux/mm.h
--- a/include/linux/mm.h~make-mm-memoryc-print_bad_pte-static
+++ a/include/linux/mm.h
@@ -807,7 +807,6 @@ extern int access_process_vm(struct task
 
 int get_user_pages(struct task_struct *tsk, struct mm_struct *mm, unsigned long start,
 		int len, int write, int force, struct page **pages, struct vm_area_struct **vmas);
-void print_bad_pte(struct vm_area_struct *, pte_t, unsigned long);
 
 extern int try_to_release_page(struct page * page, gfp_t gfp_mask);
 extern void do_invalidatepage(struct page *page, unsigned long offset);
diff -puN mm/memory.c~make-mm-memoryc-print_bad_pte-static mm/memory.c
--- a/mm/memory.c~make-mm-memoryc-print_bad_pte-static
+++ a/mm/memory.c
@@ -364,7 +364,8 @@ static inline void add_mm_rss(struct mm_
  *
  * The calling function must still handle the error.
  */
-void print_bad_pte(struct vm_area_struct *vma, pte_t pte, unsigned long vaddr)
+static void print_bad_pte(struct vm_area_struct *vma, pte_t pte,
+			  unsigned long vaddr)
 {
 	printk(KERN_ERR "Bad pte = %08llx, process = %s, "
 			"vm_flags = %lx, vaddr = %lx\n",
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

