From: akpm@linux-foundation.org
Subject: + bug-make-bug-always-stop-the-machine.patch added to -mm tree
Date: Mon, 10 Mar 2014 12:50:32 -0700
Message-ID: <531e1788.Dw5HD9YQ3Bilfx4w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40560 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661AbaCJTud (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Mar 2014 15:50:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, arnd@arndb.de, josh@joshtriplett.org

Subject: + bug-make-bug-always-stop-the-machine.patch added to -mm tree
To: josh@joshtriplett.org,arnd@arndb.de
From: akpm@linux-foundation.org
Date: Mon, 10 Mar 2014 12:50:32 -0700


The patch titled
     Subject: bug: Make BUG() always stop the machine
has been added to the -mm tree.  Its filename is
     bug-make-bug-always-stop-the-machine.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bug-make-bug-always-stop-the-machine.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bug-make-bug-always-stop-the-machine.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Josh Triplett <josh@joshtriplett.org>
Subject: bug: Make BUG() always stop the machine

When !CONFIG_BUG and !HAVE_ARCH_BUG, define the generic BUG() as an
infinite loop rather than a no-op.  This avoids undefined behavior if
execution ever actually reaches BUG(), and avoids warnings about code
after BUG() (such as on non-void functions calling BUG() and then not
returning).

bloat-o-meter results:

add/remove: 0/0 grow/shrink: 43/10 up/down: 235/-98 (137)
function                                     old     new   delta
umount_collect                               119     138     +19
notify_change                                306     324     +18
xstate_enable_boot_cpu                       252     269     +17
kunmap                                        54      70     +16
balloon_page_dequeue                         112     126     +14
mm_take_all_locks                            223     233     +10
list_lru_walk_node                           143     152      +9
vma_adjust                                  1059    1067      +8
pcpu_setup_first_chunk                      1130    1138      +8
mm_drop_all_locks                            143     151      +8
ns_capable                                    55      62      +7
anon_transport_class_unregister                8      15      +7
srcu_init_notifier_head                       35      41      +6
shrink_dcache_for_umount                     174     180      +6
kunmap_high                                   99     105      +6
end_page_writeback                            43      49      +6
do_exit                                     1339    1345      +6
__kfifo_dma_out_prepare_r                     86      92      +6
__kfifo_dma_in_prepare_r                      90      96      +6
fixup_user_fault                             120     125      +5
repair_env_string                             73      77      +4
read_cache_pages_invalidate_page              56      60      +4
isolate_lru_pages.isra                       142     146      +4
do_notify_parent_cldstop                     255     259      +4
cpu_init                                     370     374      +4
utimes_common                                270     272      +2
tasklet_hi_action                             91      93      +2
tasklet_action                                91      93      +2
set_pte_vaddr                                 46      48      +2
find_get_pages_tag                           202     204      +2
early_iounmap                                185     187      +2
__native_set_fixmap                           36      38      +2
__get_user_pages                             822     824      +2
__early_ioremap                              299     301      +2
yield_task_stop                                1       2      +1
tick_resume                                   37      38      +1
switched_to_stop                               1       2      +1
switched_to_idle                               1       2      +1
prio_changed_stop                              1       2      +1
prio_changed_idle                              1       2      +1
pm_qos_power_read                            111     112      +1
arch_cpu_idle_dead                             1       2      +1
__insert_vmap_area                           140     141      +1
sys_renameat                                 614     612      -2
mm_fault_error                               297     295      -2
SyS_renameat                                 614     612      -2
sys_linkat                                   416     413      -3
SyS_linkat                                   416     413      -3
chmod_common                                 129     122      -7
proc_cap_handler                             240     225     -15
__schedule                                   849     831     -18
sys_madvise                                 1077    1054     -23
SyS_madvise                                 1077    1054     -23

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/bug.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-generic/bug.h~bug-make-bug-always-stop-the-machine include/asm-generic/bug.h
--- a/include/asm-generic/bug.h~bug-make-bug-always-stop-the-machine
+++ a/include/asm-generic/bug.h
@@ -138,7 +138,7 @@ extern void warn_slowpath_null(const cha
 
 #else /* !CONFIG_BUG */
 #ifndef HAVE_ARCH_BUG
-#define BUG() do {} while (0)
+#define BUG() do {} while (1)
 #endif
 
 #ifndef HAVE_ARCH_BUG_ON
_

Patches currently in -mm which might be from josh@joshtriplett.org are

mm-compactionc-mark-function-as-static.patch
mm-memoryc-mark-functions-as-static.patch
mm-mmapc-mark-function-as-static.patch
mm-process_vm_accessc-mark-function-as-static.patch
mm-process_vm_accessc-mark-function-as-static-fix.patch
mm-page_cgroupc-mark-functions-as-static.patch
mm-nobootmemc-mark-function-as-static.patch
include-linux-mmh-remove-ifdef-condition.patch
include-linux-syscallsh-add-sys32_quotactl-prototype.patch
fs-kernel-permit-disabling-the-uselib-syscall.patch
fs-kernel-permit-disabling-the-uselib-syscall-v2.patch
submittingpatches-add-style-recommendation-to-use-imperative-descriptions.patch
submittingpatches-add-recommendation-for-mailing-list-references.patch
submittingpatches-document-the-use-of-git.patch
lglock-map-to-spinlock-when-config_smp.patch
lib-clz_ctzc-add-prototype-declarations-in-lib-clz_ctzc.patch
lib-decompress_inflatec-include-appropriate-header-file.patch
checkpatch-make-return-is-not-a-function-test-quieter.patch
fs-reiserfs-move-prototype-declaration-to-header-file.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
cris-make-etrax_arch_v10-select-tty-for-use-in-debugport.patch
ia64-select-config_tty-for-use-of-tty_write_message-in-unaligned.patch
ppc-make-ppc_book3s_64-select-irq_work.patch
s390-select-config_tty-for-use-of-tty-in-unconditional-keyboard-driver.patch
kconfig-make-allnoconfig-disable-options-behind-embedded-and-expert.patch
bug-when-config_bug-simplify-warn_on_once-and-family.patch
include-asm-generic-bugh-style-fix-s-while0-while-0.patch
bug-when-config_bug-make-warn-call-no_printk-to-check-format-and-args.patch
bug-make-bug-always-stop-the-machine.patch
x86-always-define-bug-and-have_arch_bug-even-with-config_bug.patch
linux-next.patch

